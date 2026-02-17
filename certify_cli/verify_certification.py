"""Verify a stored certification: registry lookup, hash checks, Merkle structure, proof bundle."""

import json
import sys
from collections import Counter
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Optional

from .foundry import cast_keccak, strip_0x


@dataclass
class CheckResult:
    """Result of a single verification check."""

    status: str  # "pass", "fail", "skip"
    detail: str = ""
    computed_hash: Optional[str] = None  # when a hash was computed, carry it forward


@dataclass
class VerifyCertificationResult:
    """Aggregate result of all local verification checks."""

    found: bool
    cert_entry: dict[str, Any] = field(default_factory=dict)
    checks: dict[str, CheckResult] = field(default_factory=dict)
    taxonomy_summary: Optional[str] = None
    network_match: str = ""  # "exact", "fuzzy", or "" (not found)

    @property
    def all_passed(self) -> bool:
        """True when every check passed or was legitimately skipped.

        Requires at least one check to have actively passed — a result
        where *every* check was skipped is not considered a pass.
        """
        return (
            self.found
            and all(c.status in ("pass", "skip") for c in self.checks.values())
            and any(c.status == "pass" for c in self.checks.values())
        )

    def to_json(self) -> dict[str, Any]:
        """Serialize to a JSON-friendly dict."""
        result: dict[str, Any] = {"found": self.found}
        if self.found:
            result.update(
                {
                    "content_hash": self.cert_entry.get("content_hash", ""),
                    "tx_hash": self.cert_entry.get("tx_hash", ""),
                    "verified": self.cert_entry.get("verified", 0),
                    "total": self.cert_entry.get("total", 0),
                    "network": self.cert_entry.get("network", ""),
                    "network_match": self.network_match,
                    "verus_version": self.cert_entry.get("verus_version", ""),
                    "results_hash": self.cert_entry.get("results_hash", ""),
                    "specs_hash": self.cert_entry.get("specs_hash", ""),
                    "proofs_hash": self.cert_entry.get("proofs_hash", ""),
                    "results_file": self.cert_entry.get("results_file", ""),
                    "specs_file": self.cert_entry.get("specs_file", ""),
                    "proof_bundle": self.cert_entry.get("proof_bundle", ""),
                    "checks": {
                        name: {"status": c.status, "detail": c.detail}
                        for name, c in self.checks.items()
                    },
                }
            )
            if self.taxonomy_summary:
                result["taxonomy_summary"] = self.taxonomy_summary
        return result

    def print_human(self, file: Any = None) -> None:
        """Print a human-readable summary."""
        out = file or sys.stderr
        if not self.found:
            print("Certification not found in registry.", file=out)
            return

        entry = self.cert_entry
        print("", file=out)
        print(
            "═" * 65,
            file=out,
        )
        print(
            "  CERTIFICATION FOUND IN REGISTRY",
            file=out,
        )
        print(
            "═" * 65,
            file=out,
        )
        print(f"  Content Hash:  {entry.get('content_hash', '')}", file=out)
        print(f"  TX Hash:       {entry.get('tx_hash', '')}", file=out)
        print(
            f"  Verified:      {entry.get('verified', '?')} / {entry.get('total', '?')}",
            file=out,
        )
        print(f"  Network:       {entry.get('network', '')}", file=out)
        print(f"  Verus Version: {entry.get('verus_version', '')}", file=out)
        print("", file=out)

        for name, check in self.checks.items():
            label = name.replace("_", " ").title()
            if check.status == "pass":
                icon = "✅"
            elif check.status == "fail":
                icon = "❌"
            else:
                icon = "⏭️"
            detail = f"  ({check.detail})" if check.detail else ""
            print(f"  {icon} {label}{detail}", file=out)

        if self.taxonomy_summary:
            print(f"  Taxonomy: {self.taxonomy_summary}", file=out)
        print("", file=out)


# ---------------------------------------------------------------------------
# Individual verification steps
# ---------------------------------------------------------------------------


def lookup_certification(
    cert_id: str,
    commit: str,
    network: str,
    base_dir: Path,
) -> tuple[Optional[dict[str, Any]], str]:
    """Find a certification entry in history.json matching commit and network.

    Returns:
        A tuple of (cert_entry, network_match) where network_match is
        ``"exact"`` when both commit and network matched, ``"fuzzy"``
        when only the commit matched (older certifications without a
        network field), or ``""`` when no match was found at all.
    """
    history_file = base_dir / cert_id / "history.json"
    if not history_file.exists():
        return None, ""

    history = json.loads(history_file.read_text())
    certifications = history.get("certifications", [])

    # Try matching commit + network first
    for cert in certifications:
        if cert.get("commit_sha") == commit and cert.get("network") == network:
            return cert, "exact"

    # Fall back to matching just by commit (older certifications)
    for cert in certifications:
        if cert.get("commit_sha") == commit:
            actual_network = cert.get("network", "<unset>")
            print(
                f"WARNING: No exact network match for commit {commit}; "
                f"falling back to certification with network={actual_network} "
                f"(requested {network})",
                file=sys.stderr,
            )
            return cert, "fuzzy"

    return None, ""


def verify_stored_results_hash(
    cert_dir: Path,
    cert_entry: dict[str, Any],
) -> CheckResult:
    """Verify that the stored results file hashes to the recorded results_hash."""
    results_file = cert_entry.get("results_file")
    expected_hash = cert_entry.get("results_hash")

    if not results_file or not expected_hash:
        return CheckResult(status="skip", detail="no results file or hash recorded")

    full_path = cert_dir / results_file
    if not full_path.exists():
        return CheckResult(
            status="fail", detail=f"results file missing: {results_file}"
        )

    computed_hash = cast_keccak(full_path.read_bytes())
    if computed_hash == expected_hash:
        return CheckResult(
            status="pass",
            detail=f"hash matches: {computed_hash}",
            computed_hash=computed_hash,
        )
    return CheckResult(
        status="fail",
        detail=f"expected {expected_hash}, got {computed_hash}",
        computed_hash=computed_hash,
    )


def verify_merkle_structure(
    cert_dir: Path,
    cert_entry: dict[str, Any],
    precomputed_results_hash: Optional[str] = None,
) -> CheckResult:
    """Verify that Merkle leaves reconstruct the on-chain content_hash.

    Args:
        cert_dir: Directory containing certification artifacts.
        cert_entry: The certification record from history.json.
        precomputed_results_hash: If the results file was already hashed
            (e.g. by ``verify_stored_results_hash``), pass it here to
            avoid hashing the same file twice.
    """
    results_hash = cert_entry.get("results_hash")
    specs_hash = cert_entry.get("specs_hash")
    expected_content_hash = cert_entry.get("content_hash")

    if not results_hash or not specs_hash:
        return CheckResult(status="skip", detail="no Merkle leaf hashes recorded")

    # Verify that individual file hashes match recorded leaf hashes
    results_file = cert_entry.get("results_file")
    specs_file = cert_entry.get("specs_file")

    if results_file:
        full_results = cert_dir / results_file
        if full_results.exists():
            computed = precomputed_results_hash or cast_keccak(
                full_results.read_bytes()
            )
            if computed != results_hash:
                return CheckResult(
                    status="fail",
                    detail=f"results file hash mismatch: expected {results_hash}, got {computed}",
                )

    if specs_file:
        full_specs = cert_dir / specs_file
        if full_specs.exists():
            computed = cast_keccak(full_specs.read_bytes())
            if computed != specs_hash:
                return CheckResult(
                    status="fail",
                    detail=f"specs file hash mismatch: expected {specs_hash}, got {computed}",
                )

    # Reconstruct Merkle root
    combined = bytes.fromhex(strip_0x(results_hash)) + bytes.fromhex(
        strip_0x(specs_hash)
    )
    proofs_hash = cert_entry.get("proofs_hash")
    if proofs_hash:
        combined += bytes.fromhex(strip_0x(proofs_hash))

    computed_root = cast_keccak(combined)
    if computed_root == expected_content_hash:
        leaves = "3-leaf" if proofs_hash else "2-leaf"
        return CheckResult(
            status="pass",
            detail=f"Merkle root matches content_hash ({leaves})",
        )
    return CheckResult(
        status="fail",
        detail=f"Merkle root mismatch: expected {expected_content_hash}, got {computed_root}",
    )


def verify_proof_bundle(
    cert_dir: Path,
    cert_entry: dict[str, Any],
) -> CheckResult:
    """Check that all files referenced in proofs.json are present."""
    proof_bundle = cert_entry.get("proof_bundle")
    if not proof_bundle:
        return CheckResult(status="skip", detail="no proof bundle recorded")

    bundle_dir = cert_dir / proof_bundle
    proofs_json_path = bundle_dir / "proofs.json"
    if not proofs_json_path.exists():
        return CheckResult(
            status="fail", detail=f"proofs.json not found at {proofs_json_path}"
        )

    proofs = json.loads(proofs_json_path.read_text())
    total_funcs = len(proofs)

    missing_formulas = 0
    missing_proofs = 0
    has_formula = 0
    has_proof = 0

    for entry in proofs.values():
        formula_file = (entry.get("z3_formula") or {}).get("file")
        proof_file = (entry.get("z3_proof") or {}).get("file")

        if formula_file:
            if (bundle_dir / formula_file).exists():
                has_formula += 1
            else:
                missing_formulas += 1

        if proof_file:
            if (bundle_dir / proof_file).exists():
                has_proof += 1
            else:
                missing_proofs += 1

    if missing_formulas > 0 or missing_proofs > 0:
        parts = []
        if missing_formulas:
            parts.append(f"{missing_formulas} formula files missing")
        if missing_proofs:
            parts.append(f"{missing_proofs} proof files missing")
        return CheckResult(status="fail", detail="; ".join(parts))

    return CheckResult(
        status="pass",
        detail=f"{total_funcs} functions, {has_formula} formulas, {has_proof} proofs",
    )


def extract_taxonomy(
    cert_dir: Path,
    cert_entry: dict[str, Any],
) -> Optional[str]:
    """Extract taxonomy summary from stored specs file."""
    specs_file = cert_entry.get("specs_file")
    if not specs_file:
        return None

    full_specs = cert_dir / specs_file
    if not full_specs.exists():
        return None

    specs = json.loads(full_specs.read_text())
    if not isinstance(specs, list):
        return None

    counter: Counter[str] = Counter()
    for item in specs:
        labels = item.get("spec-labels") or []
        counter.update(labels)

    if not counter:
        return None

    return ", ".join(f"{count} {label}" for label, count in counter.most_common())


# ---------------------------------------------------------------------------
# Orchestrator
# ---------------------------------------------------------------------------


def verify_certification(
    cert_id: str,
    commit: str,
    network: str,
    base_dir: Path,
) -> VerifyCertificationResult:
    """Run all local verification checks for a stored certification."""
    if ".." in cert_id or "/" in cert_id or "\\" in cert_id:
        raise ValueError(f"Invalid cert_id (path traversal attempt): {cert_id!r}")

    cert_entry, network_match = lookup_certification(cert_id, commit, network, base_dir)

    if cert_entry is None:
        return VerifyCertificationResult(found=False)

    cert_dir = base_dir / cert_id

    stored = verify_stored_results_hash(cert_dir, cert_entry)
    merkle = verify_merkle_structure(
        cert_dir, cert_entry, precomputed_results_hash=stored.computed_hash
    )
    proofs = verify_proof_bundle(cert_dir, cert_entry)
    taxonomy = extract_taxonomy(cert_dir, cert_entry)

    return VerifyCertificationResult(
        found=True,
        cert_entry=cert_entry,
        checks={
            "stored_results": stored,
            "merkle_structure": merkle,
            "proof_bundle": proofs,
        },
        taxonomy_summary=taxonomy,
        network_match=network_match,
    )

"""Z3 proof certificate pipeline.

Extracts per-function SMT queries from Verus log output, generates Z3 proof
artifacts, and assembles the proofs.json dictionary that maps each verified
function to its Verus spec, Z3 formula, and Z3 proof.

This moves toward a Rocq-like proof certificate model where the evidence
(Z3 proof) is inspectable alongside the statement (Verus spec).
"""

import hashlib
import json
import re
import shutil
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Optional


# ---------------------------------------------------------------------------
# SMT file parsing and function-name extraction
# ---------------------------------------------------------------------------

# Verus marks the function being verified with this comment in the .smt2 file
_FUNCTION_DEF_RE = re.compile(r"^;;\s*Function-Def\s+(.+)$")

# The spinoff .smt2 filename pattern produced by Verus with -V spinoff-all
# e.g. "roottest_true!baz._01.smt2" or
#      "logimpl_vlib!logimpl_v.impl&%0.untrusted_append._01.smt2"
_SPINOFF_SUFFIX = re.compile(r"\._\d+\.smt2$")


def extract_function_def(smt2_path: Path) -> Optional[str]:
    """Extract the ;; Function-Def name from an .smt2 file.

    In spinoff mode, each .smt2 file has exactly one Function-Def line
    (the function being verified).  We return the *last* Function-Def
    found, which is the one actually being checked (earlier ones are
    dependency specs).
    """
    last_def = None
    with open(smt2_path, encoding="utf-8", errors="replace") as f:
        for line in f:
            m = _FUNCTION_DEF_RE.match(line.rstrip())
            if m:
                last_def = m.group(1)
    return last_def


def list_spinoff_smt2_files(log_dir: Path) -> list[Path]:
    """List per-function spinoff .smt2 files (excluding module-level files)."""
    return sorted(p for p in log_dir.glob("*.smt2") if _SPINOFF_SUFFIX.search(p.name))


def list_all_smt2_files(log_dir: Path) -> list[Path]:
    """List all .smt2 files in the log directory."""
    return sorted(log_dir.glob("*.smt2"))


# ---------------------------------------------------------------------------
# Function-name normalisation for matching
# ---------------------------------------------------------------------------


def normalise_verus_name(verus_name: str) -> str:
    """Normalise a Verus fully-qualified name for matching.

    Verus names look like "lib::logimpl_v::UntrustedLogImpl::untrusted_append".
    We want to extract just the bare function name for fuzzy matching.
    """
    parts = verus_name.split("::")
    return parts[-1] if parts else verus_name


def normalise_probe_name(probe_key: str) -> str:
    """Normalise a probe-verus code-name key for matching.

    probe-verus keys look like:
    "probe:pmemlog/0.1.0/logimpl_v/&mut/...#untrusted_append()"
    We extract the final function name (after last # and before ()).
    """
    # Strip trailing ()
    name = probe_key.rstrip(")").rstrip("(")
    # Get part after last #
    if "#" in name:
        name = name.rsplit("#", 1)[-1]
    # Get part after last /
    if "/" in name:
        name = name.rsplit("/", 1)[-1]
    return name


def extract_module_from_verus_name(verus_name: str) -> Optional[str]:
    """Extract the module component from a Verus name.

    "lib::logimpl_v::UntrustedLogImpl::untrusted_append" -> "logimpl_v"
    """
    parts = verus_name.split("::")
    # Skip "lib" prefix if present
    if len(parts) >= 2 and parts[0] == "lib":
        return parts[1]
    if len(parts) >= 2:
        return parts[0]
    return None


def extract_module_from_probe_key(probe_key: str) -> Optional[str]:
    """Extract the module from a probe-verus key.

    "probe:pmemlog/0.1.0/logimpl_v/..." -> "logimpl_v"
    """
    # Format: probe:crate/version/module/...
    stripped = probe_key
    if stripped.startswith("probe:"):
        stripped = stripped[6:]
    parts = stripped.split("/")
    if len(parts) >= 3:
        return parts[2]
    return None


def build_function_mapping(
    smt2_files: list[Path],
    results: dict,
    specs: Optional[dict] = None,
) -> dict[str, dict]:
    """Map .smt2 files to function IDs in results.json/specs.json.

    Returns a dict keyed by probe-verus function ID, with values containing
    the matched .smt2 file path and the Verus internal function name.
    """
    # Build index: (module, func_name) -> smt2_file, verus_name
    smt2_index: dict[tuple[str, str], tuple[Path, str]] = {}
    func_name_index: dict[str, list[tuple[Path, str]]] = {}

    for smt2_file in smt2_files:
        verus_name = extract_function_def(smt2_file)
        if not verus_name:
            continue

        func_name = normalise_verus_name(verus_name)
        module = extract_module_from_verus_name(verus_name)

        key = (module, func_name) if module else (None, func_name)
        smt2_index[key] = (smt2_file, verus_name)

        if func_name not in func_name_index:
            func_name_index[func_name] = []
        func_name_index[func_name].append((smt2_file, verus_name))

    # Match each results.json entry to its .smt2 file
    mapping: dict[str, dict] = {}
    for probe_key in results:
        func_name = normalise_probe_name(probe_key)
        module = extract_module_from_probe_key(probe_key)

        matched = None

        # Try exact (module, func) match
        if (module, func_name) in smt2_index:
            matched = smt2_index[(module, func_name)]

        # Fallback: match by func_name only (if unique)
        if not matched and func_name in func_name_index:
            candidates = func_name_index[func_name]
            if len(candidates) == 1:
                matched = candidates[0]
            elif module:
                # Try module substring match
                for smt2_file, verus_name in candidates:
                    if module in str(verus_name):
                        matched = (smt2_file, verus_name)
                        break

        if matched:
            smt2_file, verus_name = matched
            mapping[probe_key] = {
                "smt2_file": str(smt2_file),
                "verus_function_name": verus_name,
            }

    return mapping


# ---------------------------------------------------------------------------
# Z3 proof generation
# ---------------------------------------------------------------------------


@dataclass
class Z3ProofResult:
    """Result of running Z3 with proof production on a single query."""

    success: bool
    smt2_file: str
    proof_file: Optional[str] = None
    proof_size_bytes: int = 0
    query_size_bytes: int = 0
    time_ms: int = 0
    error: Optional[str] = None
    z3_result: str = ""  # "unsat", "sat", "unknown", or "error"


def generate_z3_proof(
    smt2_path: Path,
    proof_output_path: Path,
    z3_binary: str = "z3",
    timeout_seconds: int = 300,
) -> Z3ProofResult:
    """Run Z3 on an .smt2 file with proof production enabled.

    Uses the legacy proof mode (set-option :proof true) with (get-proof)
    injected after (check-sat), as this is compatible with Z3's default
    core which Verus tunes for.

    The sat.euf=true proof log mode crashes on complex Verus queries,
    so we use the legacy approach instead.
    """
    import time

    query_size = smt2_path.stat().st_size

    # Create a modified .smt2 file with proof production enabled
    temp_smt2 = proof_output_path.with_suffix(".tmp.smt2")
    try:
        _prepare_proof_query(smt2_path, temp_smt2)
    except Exception as e:
        return Z3ProofResult(
            success=False,
            smt2_file=str(smt2_path),
            query_size_bytes=query_size,
            error=f"Failed to prepare query: {e}",
            z3_result="error",
        )

    start = time.monotonic()
    try:
        result = subprocess.run(
            [z3_binary, str(temp_smt2)],
            capture_output=True,
            timeout=timeout_seconds,
        )
        elapsed_ms = int((time.monotonic() - start) * 1000)

        stdout = result.stdout.decode("utf-8", errors="replace")
        stderr = result.stderr.decode("utf-8", errors="replace")

        # Check for unsat + proof in output
        if "unsat" in stdout:
            # Extract proof (everything between ((proof and the final )))
            proof_output_path.parent.mkdir(parents=True, exist_ok=True)
            proof_output_path.write_text(stdout, encoding="utf-8")
            proof_size = proof_output_path.stat().st_size

            return Z3ProofResult(
                success=True,
                smt2_file=str(smt2_path),
                proof_file=str(proof_output_path),
                proof_size_bytes=proof_size,
                query_size_bytes=query_size,
                time_ms=elapsed_ms,
                z3_result="unsat",
            )
        elif "sat" in stdout:
            return Z3ProofResult(
                success=False,
                smt2_file=str(smt2_path),
                query_size_bytes=query_size,
                time_ms=elapsed_ms,
                error="Z3 returned sat (expected unsat for verified function)",
                z3_result="sat",
            )
        else:
            return Z3ProofResult(
                success=False,
                smt2_file=str(smt2_path),
                query_size_bytes=query_size,
                time_ms=elapsed_ms,
                error=f"Unexpected Z3 output: {stderr[:500]}",
                z3_result="unknown",
            )

    except subprocess.TimeoutExpired:
        elapsed_ms = int((time.monotonic() - start) * 1000)
        return Z3ProofResult(
            success=False,
            smt2_file=str(smt2_path),
            query_size_bytes=query_size,
            time_ms=elapsed_ms,
            error=f"Z3 timed out after {timeout_seconds}s",
            z3_result="timeout",
        )
    except Exception as e:
        return Z3ProofResult(
            success=False,
            smt2_file=str(smt2_path),
            query_size_bytes=query_size,
            error=str(e),
            z3_result="error",
        )
    finally:
        if temp_smt2.exists():
            temp_smt2.unlink()


def _prepare_proof_query(smt2_input: Path, smt2_output: Path) -> None:
    """Prepare an .smt2 file for proof production.

    Injects (set-option :proof true) at the top and (get-proof) after
    each (check-sat).
    """
    lines = smt2_input.read_text(encoding="utf-8", errors="replace").splitlines()
    out_lines = ["(set-option :proof true)"]

    for line in lines:
        out_lines.append(line)
        stripped = line.strip()
        if stripped == "(check-sat)":
            out_lines.append("(get-proof)")

    smt2_output.write_text("\n".join(out_lines) + "\n", encoding="utf-8")


def generate_all_proofs(
    smt2_files: list[Path],
    proof_dir: Path,
    z3_binary: str = "z3",
    timeout_seconds: int = 300,
) -> list[Z3ProofResult]:
    """Generate Z3 proofs for all .smt2 files."""
    proof_dir.mkdir(parents=True, exist_ok=True)
    results = []

    for smt2_file in smt2_files:
        proof_name = smt2_file.stem + ".proof"
        proof_path = proof_dir / proof_name
        result = generate_z3_proof(smt2_file, proof_path, z3_binary, timeout_seconds)
        results.append(result)

    return results


# ---------------------------------------------------------------------------
# Proofs.json assembly
# ---------------------------------------------------------------------------


def file_hash(path: Path) -> str:
    """Compute SHA-256 hash of a file's contents."""
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return "0x" + h.hexdigest()


def build_proofs_json(
    smt_log_dir: Path,
    output_dir: Path,
    results_path: Path,
    specs_path: Optional[Path] = None,
    z3_binary: str = "z3",
    timeout_seconds: int = 300,
    generate_proofs: bool = True,
) -> dict:
    """Build the proofs.json dictionary and archive all artifacts.

    Creates a self-contained output directory:
        output_dir/
            proofs.json
            smt_queries/   -- per-function .smt2 files (the Z3 formulas)
            z3_proofs/     -- per-function .proof files (the Z3 proofs)

    The "file" fields in proofs.json are relative paths within this
    directory, so the JSON + artifacts form a portable, self-contained
    proof bundle.

    For each verified function, produces:
    {
        "verus_spec": { ... },
        "z3_formula": { "file": "smt_queries/func.smt2", "hash": "0x..." },
        "z3_proof": { "file": "z3_proofs/func.proof", "hash": "0x...", ... },
        "verification_result": "unsat"
    }
    """
    # Load results and specs
    results = json.loads(results_path.read_text())
    specs = (
        json.loads(specs_path.read_text())
        if specs_path and specs_path.exists()
        else None
    )

    # Find per-function .smt2 files
    smt2_files = list_spinoff_smt2_files(smt_log_dir)
    if not smt2_files:
        smt2_files = list_all_smt2_files(smt_log_dir)

    # Build function mapping
    mapping = build_function_mapping(smt2_files, results, specs)

    # Prepare output subdirectories
    queries_dir = output_dir / "smt_queries"
    proofs_dir = output_dir / "z3_proofs"
    queries_dir.mkdir(parents=True, exist_ok=True)
    proofs_dir.mkdir(parents=True, exist_ok=True)

    # Copy matched .smt2 files into the output bundle
    for match_info in mapping.values():
        src = Path(match_info["smt2_file"])
        if src.exists():
            shutil.copy2(src, queries_dir / src.name)

    # Generate Z3 proofs (output directly into the bundle)
    proof_results: dict[str, Z3ProofResult] = {}
    if generate_proofs:
        mapped_smt2_files = [Path(v["smt2_file"]) for v in mapping.values()]
        all_proof_results = generate_all_proofs(
            mapped_smt2_files, proofs_dir, z3_binary, timeout_seconds
        )
        for pr in all_proof_results:
            proof_results[pr.smt2_file] = pr

    # Assemble the proofs dictionary
    proofs: dict[str, dict] = {}
    for probe_key, match_info in mapping.items():
        smt2_file = Path(match_info["smt2_file"])
        entry: dict = {}

        # Verus spec (from specs.json if available)
        if specs and probe_key in specs:
            spec_data = specs[probe_key]
            entry["verus_spec"] = {
                "mode": spec_data.get("mode", "unknown"),
            }
            if spec_data.get("requires_text"):
                entry["verus_spec"]["requires_text"] = spec_data["requires_text"]
            if spec_data.get("ensures_text"):
                entry["verus_spec"]["ensures_text"] = spec_data["ensures_text"]
        else:
            entry["verus_spec"] = None

        # Z3 formula -- path relative to output_dir
        bundled_smt2 = queries_dir / smt2_file.name
        if bundled_smt2.exists():
            entry["z3_formula"] = {
                "file": f"smt_queries/{smt2_file.name}",
                "hash": file_hash(bundled_smt2),
                "size_bytes": bundled_smt2.stat().st_size,
            }
        else:
            entry["z3_formula"] = None

        # Z3 proof -- path relative to output_dir
        smt2_key = str(smt2_file)
        if smt2_key in proof_results:
            pr = proof_results[smt2_key]
            if pr.success and pr.proof_file:
                proof_path = Path(pr.proof_file)
                entry["z3_proof"] = {
                    "file": f"z3_proofs/{proof_path.name}",
                    "hash": file_hash(proof_path),
                    "size_bytes": pr.proof_size_bytes,
                    "time_ms": pr.time_ms,
                    "format": "z3-legacy-proof",
                }
            else:
                entry["z3_proof"] = {
                    "error": pr.error,
                    "time_ms": pr.time_ms,
                    "z3_result": pr.z3_result,
                }
        else:
            entry["z3_proof"] = None

        # Verification result from results.json
        if probe_key in results:
            entry["verification_result"] = (
                "unsat" if results[probe_key].get("verified") else "failed"
            )
        else:
            entry["verification_result"] = "unknown"

        entry["verus_function_name"] = match_info.get("verus_function_name")
        proofs[probe_key] = entry

    return proofs


def write_proofs_json(proofs: dict, output_dir: Path) -> Path:
    """Write proofs.json into the output directory.

    Returns the path to the written proofs.json file.
    """
    output_dir.mkdir(parents=True, exist_ok=True)
    output_path = output_dir / "proofs.json"
    output_path.write_text(
        json.dumps(proofs, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    return output_path


# ---------------------------------------------------------------------------
# Summary statistics
# ---------------------------------------------------------------------------


@dataclass
class ProofsSummary:
    """Summary of the proofs.json contents."""

    total_functions: int = 0
    matched_smt2: int = 0
    proofs_generated: int = 0
    proofs_failed: int = 0
    total_query_size: int = 0
    total_proof_size: int = 0

    def print_report(self) -> None:
        """Print a human-readable summary."""
        print("Proof Certificate Summary:")
        print(f"  Total functions in results: {self.total_functions}")
        print(f"  Functions matched to .smt2: {self.matched_smt2}")
        print(f"  Z3 proofs generated:        {self.proofs_generated}")
        print(f"  Z3 proofs failed:           {self.proofs_failed}")
        if self.total_query_size > 0:
            ratio = self.total_proof_size / self.total_query_size
            print(f"  Total query size:           {self.total_query_size:,} bytes")
            print(f"  Total proof size:           {self.total_proof_size:,} bytes")
            print(f"  Proof/query ratio:          {ratio:.1f}x")


def summarise_proofs(proofs: dict, results: dict) -> ProofsSummary:
    """Compute summary statistics from a proofs dictionary."""
    summary = ProofsSummary(total_functions=len(results))

    for _key, entry in proofs.items():
        if entry.get("z3_formula"):
            summary.matched_smt2 += 1
            summary.total_query_size += entry["z3_formula"].get("size_bytes", 0)

        z3_proof = entry.get("z3_proof")
        if z3_proof:
            if "error" not in z3_proof and z3_proof.get("file"):
                summary.proofs_generated += 1
                summary.total_proof_size += z3_proof.get("size_bytes", 0)
            elif "error" in z3_proof:
                summary.proofs_failed += 1

    return summary

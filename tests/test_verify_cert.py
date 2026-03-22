"""P8: Registry consistency, P9: proof bundle completeness, and path traversal security.

Tests the verify_certification pipeline: lookup, hash checks, proof bundle,
and the all_passed aggregation logic.
"""

import hashlib
import json

import pytest

from certify_cli.verify_certification import (
    CheckResult,
    VerifyCertificationResult,
    lookup_certification,
    verify_certification,
    verify_proof_bundle,
)


class TestLookupCertification:
    """Test certification lookup in history.json."""

    def test_exact_match(self, tmp_registry):
        reg = tmp_registry
        entry, match = lookup_certification(
            reg["cert_id"], reg["commit"], "sepolia", reg["base_dir"]
        )
        assert entry is not None
        assert match == "exact"
        assert entry["content_hash"] == reg["content_hash"]

    def test_fuzzy_match_wrong_network(self, tmp_registry):
        reg = tmp_registry
        entry, match = lookup_certification(
            reg["cert_id"], reg["commit"], "mainnet", reg["base_dir"]
        )
        assert entry is not None
        assert match == "fuzzy"

    def test_not_found_wrong_commit(self, tmp_registry):
        reg = tmp_registry
        entry, match = lookup_certification(
            reg["cert_id"], "nonexistent_commit", "sepolia", reg["base_dir"]
        )
        assert entry is None
        assert match == ""

    def test_missing_history_file(self, tmp_path):
        cert_dir = tmp_path / "no-history"
        cert_dir.mkdir()
        entry, match = lookup_certification("no-history", "abc", "sepolia", tmp_path)
        assert entry is None
        assert match == ""


class TestPathTraversal:
    """Security: cert_id must not allow directory traversal."""

    @pytest.mark.parametrize(
        "bad_id",
        [
            "../../../etc/passwd",
            "foo/bar",
            "foo\\bar",
        ],
    )
    def test_path_traversal_rejected(self, tmp_path, bad_id):
        with pytest.raises(ValueError, match="path traversal"):
            verify_certification(
                cert_id=bad_id,
                commit="abc",
                network="sepolia",
                base_dir=tmp_path,
            )


class TestProofBundleCompleteness:
    """P9: Every file referenced in proofs.json must exist."""

    def test_all_files_present(self, tmp_path):
        cert_dir = tmp_path / "cert"
        bundle = cert_dir / "proofs" / "2026-01-01"
        (bundle / "smt_queries").mkdir(parents=True)
        (bundle / "z3_proofs").mkdir(parents=True)

        (bundle / "smt_queries" / "func.smt2").write_text("(check-sat)")
        (bundle / "z3_proofs" / "func.proof").write_text("(proof ...)")

        proofs_index = {
            "fn_a": {
                "z3_formula": {"file": "smt_queries/func.smt2"},
                "z3_proof": {"file": "z3_proofs/func.proof"},
            }
        }
        (bundle / "proofs.json").write_text(json.dumps(proofs_index))

        entry = {"proof_bundle": "proofs/2026-01-01"}
        result = verify_proof_bundle(cert_dir, entry)
        assert result.status == "pass"

    def test_missing_formula_file(self, tmp_path):
        cert_dir = tmp_path / "cert"
        bundle = cert_dir / "proofs" / "2026-01-01"
        bundle.mkdir(parents=True)

        proofs_index = {
            "fn_a": {
                "z3_formula": {"file": "smt_queries/missing.smt2"},
                "z3_proof": None,
            }
        }
        (bundle / "proofs.json").write_text(json.dumps(proofs_index))

        entry = {"proof_bundle": "proofs/2026-01-01"}
        result = verify_proof_bundle(cert_dir, entry)
        assert result.status == "fail"
        assert "formula files missing" in result.detail

    def test_missing_proof_file(self, tmp_path):
        cert_dir = tmp_path / "cert"
        bundle = cert_dir / "proofs" / "2026-01-01"
        (bundle / "smt_queries").mkdir(parents=True)

        (bundle / "smt_queries" / "func.smt2").write_text("(check-sat)")

        proofs_index = {
            "fn_a": {
                "z3_formula": {"file": "smt_queries/func.smt2"},
                "z3_proof": {"file": "z3_proofs/missing.proof"},
            }
        }
        (bundle / "proofs.json").write_text(json.dumps(proofs_index))

        entry = {"proof_bundle": "proofs/2026-01-01"}
        result = verify_proof_bundle(cert_dir, entry)
        assert result.status == "fail"
        assert "proof files missing" in result.detail

    def test_no_proof_bundle_skips(self):
        result = verify_proof_bundle(None, {})  # type: ignore[arg-type]
        assert result.status == "skip"

    def test_tampered_formula_hash_detected(self, tmp_path):
        """P9: SHA-256 hash mismatch on formula file is caught."""
        cert_dir = tmp_path / "cert"
        bundle = cert_dir / "proofs" / "2026-01-01"
        (bundle / "smt_queries").mkdir(parents=True)

        (bundle / "smt_queries" / "func.smt2").write_text("(check-sat)")

        proofs_index = {
            "fn_a": {
                "z3_formula": {
                    "file": "smt_queries/func.smt2",
                    "hash": "0x" + "ab" * 32,
                },
                "z3_proof": None,
            }
        }
        (bundle / "proofs.json").write_text(json.dumps(proofs_index))

        entry = {"proof_bundle": "proofs/2026-01-01"}
        result = verify_proof_bundle(cert_dir, entry)
        assert result.status == "fail"
        assert "hash mismatch" in result.detail.lower()

    def test_correct_hashes_pass(self, tmp_path):
        """P9: Correct SHA-256 hashes pass verification."""
        cert_dir = tmp_path / "cert"
        bundle = cert_dir / "proofs" / "2026-01-01"
        (bundle / "smt_queries").mkdir(parents=True)
        (bundle / "z3_proofs").mkdir(parents=True)

        formula_content = b"(check-sat)"
        proof_content = b"(proof ...)"
        (bundle / "smt_queries" / "func.smt2").write_bytes(formula_content)
        (bundle / "z3_proofs" / "func.proof").write_bytes(proof_content)

        formula_hash = "0x" + hashlib.sha256(formula_content).hexdigest()
        proof_hash = "0x" + hashlib.sha256(proof_content).hexdigest()

        proofs_index = {
            "fn_a": {
                "z3_formula": {
                    "file": "smt_queries/func.smt2",
                    "hash": formula_hash,
                },
                "z3_proof": {
                    "file": "z3_proofs/func.proof",
                    "hash": proof_hash,
                },
            }
        }
        (bundle / "proofs.json").write_text(json.dumps(proofs_index))

        entry = {"proof_bundle": "proofs/2026-01-01"}
        result = verify_proof_bundle(cert_dir, entry)
        assert result.status == "pass"


class TestAllPassedLogic:
    """The all_passed property requires at least one active pass."""

    def test_all_pass(self):
        r = VerifyCertificationResult(
            found=True,
            checks={"a": CheckResult(status="pass"), "b": CheckResult(status="pass")},
        )
        assert r.all_passed is True

    def test_one_fail(self):
        r = VerifyCertificationResult(
            found=True,
            checks={"a": CheckResult(status="pass"), "b": CheckResult(status="fail")},
        )
        assert r.all_passed is False

    def test_all_skip_is_not_pass(self):
        r = VerifyCertificationResult(
            found=True,
            checks={"a": CheckResult(status="skip"), "b": CheckResult(status="skip")},
        )
        assert r.all_passed is False

    def test_not_found_is_not_pass(self):
        r = VerifyCertificationResult(found=False)
        assert r.all_passed is False

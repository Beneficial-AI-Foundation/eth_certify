"""P3: Merkle integrity and P10: hash determinism tests.

Tests the core correctness invariant: content_hash is a deterministic
Merkle root over certification artifacts with fixed leaf order.
"""

from certify_cli.foundry import compute_merkle_content_hash, strip_0x
from certify_cli.verify_certification import verify_merkle_structure


class TestMerkleComputation:
    """Test compute_merkle_content_hash (P3)."""

    def test_two_leaf_merkle_root(self, tmp_path, mock_keccak, keccak_fn):
        results = tmp_path / "results.json"
        specs = tmp_path / "specs.json"
        results.write_bytes(b'{"verified": 5}')
        specs.write_bytes(b'{"fn_a": {}}')

        content_hash, results_hash, specs_hash, proofs_hash = (
            compute_merkle_content_hash(str(results), str(specs))
        )

        assert proofs_hash is None
        expected_rh = keccak_fn(b'{"verified": 5}')
        expected_sh = keccak_fn(b'{"fn_a": {}}')
        assert results_hash == expected_rh
        assert specs_hash == expected_sh

        combined = bytes.fromhex(strip_0x(expected_rh)) + bytes.fromhex(
            strip_0x(expected_sh)
        )
        expected_root = keccak_fn(combined)
        assert content_hash == expected_root

    def test_three_leaf_merkle_root(self, tmp_path, mock_keccak, keccak_fn):
        results = tmp_path / "results.json"
        specs = tmp_path / "specs.json"
        proofs = tmp_path / "proofs.json"
        results.write_bytes(b'{"verified": 5}')
        specs.write_bytes(b'{"fn_a": {}}')
        proofs.write_bytes(b'{"fn_a": {"z3_formula": {}}}')

        content_hash, results_hash, specs_hash, proofs_hash = (
            compute_merkle_content_hash(str(results), str(specs), str(proofs))
        )

        assert proofs_hash is not None
        expected_ph = keccak_fn(b'{"fn_a": {"z3_formula": {}}}')
        assert proofs_hash == expected_ph

        combined = (
            bytes.fromhex(strip_0x(results_hash))
            + bytes.fromhex(strip_0x(specs_hash))
            + bytes.fromhex(strip_0x(proofs_hash))
        )
        expected_root = keccak_fn(combined)
        assert content_hash == expected_root

    def test_leaf_order_matters(self, tmp_path, mock_keccak):
        """Swapping results and specs must produce a different root."""
        file_a = tmp_path / "a.json"
        file_b = tmp_path / "b.json"
        file_a.write_bytes(b"aaa")
        file_b.write_bytes(b"bbb")

        hash_ab, _, _, _ = compute_merkle_content_hash(str(file_a), str(file_b))
        hash_ba, _, _, _ = compute_merkle_content_hash(str(file_b), str(file_a))

        assert hash_ab != hash_ba

    def test_determinism(self, tmp_path, mock_keccak):
        """Same inputs produce the same Merkle root (P10)."""
        results = tmp_path / "results.json"
        specs = tmp_path / "specs.json"
        results.write_bytes(b"deterministic")
        specs.write_bytes(b"content")

        hash1, _, _, _ = compute_merkle_content_hash(str(results), str(specs))
        hash2, _, _, _ = compute_merkle_content_hash(str(results), str(specs))

        assert hash1 == hash2


class TestVerifyMerkleStructure:
    """Test verify_merkle_structure from verify_certification.py."""

    def test_correct_merkle_passes(self, tmp_registry, mock_keccak):
        reg = tmp_registry
        result = verify_merkle_structure(reg["cert_dir"], reg["history_entry"])
        assert result.status == "pass"
        assert "Merkle root matches" in result.detail

    def test_tampered_results_detected(self, tmp_registry, mock_keccak):
        reg = tmp_registry
        results_file = reg["cert_dir"] / "results" / "2026-03-22T12-00-00Z.json"
        results_file.write_bytes(b"TAMPERED CONTENT")

        result = verify_merkle_structure(reg["cert_dir"], reg["history_entry"])
        assert result.status == "fail"
        assert "results file hash mismatch" in result.detail

    def test_tampered_specs_detected(self, tmp_registry, mock_keccak):
        reg = tmp_registry
        specs_file = reg["cert_dir"] / "specs" / "2026-03-22T12-00-00Z.json"
        specs_file.write_bytes(b"TAMPERED SPECS")

        result = verify_merkle_structure(reg["cert_dir"], reg["history_entry"])
        assert result.status == "fail"
        assert "specs file hash mismatch" in result.detail

    def test_legacy_entry_skips(self, tmp_registry, mock_keccak):
        """When no Merkle leaf hashes are recorded, skip gracefully."""
        reg = tmp_registry
        legacy_entry = {
            "content_hash": "0xabc",
            "tx_hash": "0xdef",
        }
        result = verify_merkle_structure(reg["cert_dir"], legacy_entry)
        assert result.status == "skip"

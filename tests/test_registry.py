"""P8: Registry consistency tests.

Tests that update_registry creates correct file structures, maintains
history ordering, and handles optional Merkle fields properly.
"""

import json

import pytest

from certify_cli.registry import _get_badge_color, update_registry


class TestRegistryCreation:
    """update_registry creates all expected files."""

    def test_new_registry_creates_files(self, tmp_path):
        result = update_registry(
            cert_id="test-repo",
            repo_path="Owner/Repo",
            ref="main",
            network="sepolia",
            verified=5,
            total=5,
            tx_hash="0xabc",
            content_hash="0xdef",
            base_dir=tmp_path,
        )
        assert result.success
        cert_dir = tmp_path / "test-repo"
        assert (cert_dir / "badge.json").exists()
        assert (cert_dir / "badge.svg").exists()
        assert (cert_dir / "history.json").exists()
        assert (cert_dir / "README.md").exists()


class TestHistoryAppend:
    """History entries are prepended (newest first)."""

    def test_two_entries_newest_first(self, tmp_path):
        for i in range(2):
            update_registry(
                cert_id="test-repo",
                repo_path="Owner/Repo",
                ref=f"ref-{i}",
                network="sepolia",
                verified=i + 1,
                total=5,
                tx_hash=f"0xtx{i}",
                content_hash=f"0xhash{i}",
                base_dir=tmp_path,
            )

        history = json.loads((tmp_path / "test-repo" / "history.json").read_text())
        certs = history["certifications"]
        assert len(certs) == 2
        assert certs[0]["ref"] == "ref-1"
        assert certs[1]["ref"] == "ref-0"


class TestBadgeColor:
    """Badge color reflects verification percentage."""

    @pytest.mark.parametrize(
        "percent,expected",
        [
            (100, "brightgreen"),
            (90, "brightgreen"),
            (75, "green"),
            (50, "yellow"),
            (30, "orange"),
            (0, "orange"),
        ],
    )
    def test_color_thresholds(self, percent, expected):
        assert _get_badge_color(percent) == expected


class TestOptionalFields:
    """Merkle sub-hashes appear only when provided."""

    def test_merkle_fields_present_when_given(self, tmp_path):
        update_registry(
            cert_id="test-repo",
            repo_path="Owner/Repo",
            ref="main",
            network="sepolia",
            verified=5,
            total=5,
            tx_hash="0xabc",
            content_hash="0xdef",
            base_dir=tmp_path,
            results_hash="0xresults",
            specs_hash="0xspecs",
            proofs_hash="0xproofs",
            commit_sha="abc123",
        )

        history = json.loads((tmp_path / "test-repo" / "history.json").read_text())
        entry = history["certifications"][0]
        assert entry["results_hash"] == "0xresults"
        assert entry["specs_hash"] == "0xspecs"
        assert entry["proofs_hash"] == "0xproofs"
        assert entry["commit_sha"] == "abc123"

    def test_merkle_fields_absent_when_omitted(self, tmp_path):
        update_registry(
            cert_id="test-repo",
            repo_path="Owner/Repo",
            ref="main",
            network="sepolia",
            verified=5,
            total=5,
            tx_hash="0xabc",
            content_hash="0xdef",
            base_dir=tmp_path,
        )

        history = json.loads((tmp_path / "test-repo" / "history.json").read_text())
        entry = history["certifications"][0]
        assert "results_hash" not in entry
        assert "specs_hash" not in entry
        assert "proofs_hash" not in entry


class TestFileArchiving:
    """Results and proof bundles are archived correctly."""

    def test_results_file_archived(self, tmp_path):
        src_results = tmp_path / "src_results.json"
        src_results.write_text('{"verified": 5}')

        update_registry(
            cert_id="test-repo",
            repo_path="Owner/Repo",
            ref="main",
            network="sepolia",
            verified=5,
            total=5,
            tx_hash="0xabc",
            content_hash="0xdef",
            base_dir=tmp_path,
            results_file=str(src_results),
        )

        results_dir = tmp_path / "test-repo" / "results"
        assert results_dir.exists()
        assert (results_dir / "latest.json").exists()
        assert (results_dir / "latest.json").read_text() == '{"verified": 5}'

    def test_proof_bundle_archived(self, tmp_path):
        bundle_src = tmp_path / "proof-bundle"
        bundle_src.mkdir()
        (bundle_src / "proofs.json").write_text('{"fn": {}}')
        (bundle_src / "smt_queries").mkdir()
        (bundle_src / "smt_queries" / "fn.smt2").write_text("(check-sat)")

        update_registry(
            cert_id="test-repo",
            repo_path="Owner/Repo",
            ref="main",
            network="sepolia",
            verified=5,
            total=5,
            tx_hash="0xabc",
            content_hash="0xdef",
            base_dir=tmp_path,
            proof_bundle_dir=str(bundle_src),
        )

        proofs_dir = tmp_path / "test-repo" / "proofs"
        assert proofs_dir.exists()
        latest = proofs_dir / "latest"
        assert (latest / "proofs.json").exists()
        assert (latest / "smt_queries" / "fn.smt2").exists()

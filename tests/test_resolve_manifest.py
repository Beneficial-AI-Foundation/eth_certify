"""Tests for .github/scripts/resolve_manifest.py.

Validates project-prefix field discovery and metadata extraction from
probe-manifest JSON files.
"""

import importlib.util
import json
import sys
from pathlib import Path
from unittest.mock import MagicMock, patch

import pytest

# Load resolve_manifest.py as a module from the scripts directory
_SCRIPT_PATH = Path(__file__).parent.parent / ".github" / "scripts" / "resolve_manifest.py"
_spec = importlib.util.spec_from_file_location("resolve_manifest", _SCRIPT_PATH)
assert _spec and _spec.loader
_mod = importlib.util.module_from_spec(_spec)

# The script imports workflow_utils via a bare import (it runs from .github/scripts/)
# so we need to add that directory to sys.path temporarily.
_scripts_dir = str(_SCRIPT_PATH.parent)
if _scripts_dir not in sys.path:
    sys.path.insert(0, _scripts_dir)
_spec.loader.exec_module(_mod)  # type: ignore[union-attr]

_discover_prefixed_fields = _mod._discover_prefixed_fields


class TestDiscoverPrefixedFields:
    """The prefix discovery scanner extracts _repo, _resolved_commit, _branch."""

    def test_dalek_lite_prefix(self):
        manifest = {
            "dalek_lite_repo": "https://github.com/niccoloaspa/curve25519-dalek-lite",
            "dalek_lite_resolved_commit": "abc123def456",
            "dalek_lite_branch": "main",
            "other_field": "ignored",
        }
        result = _discover_prefixed_fields(manifest)
        assert result["repo_url"] == "https://github.com/niccoloaspa/curve25519-dalek-lite"
        assert result["commit_sha"] == "abc123def456"
        assert result["branch"] == "main"

    def test_first_match_wins(self):
        manifest = {
            "project_a_repo": "https://github.com/org/a",
            "project_b_repo": "https://github.com/org/b",
        }
        result = _discover_prefixed_fields(manifest)
        assert result["repo_url"] == "https://github.com/org/a"

    def test_skips_non_string_values(self):
        manifest = {
            "foo_repo": 42,
            "bar_repo": "",
            "baz_repo": "https://github.com/org/baz",
        }
        result = _discover_prefixed_fields(manifest)
        assert result["repo_url"] == "https://github.com/org/baz"

    def test_empty_manifest(self):
        assert _discover_prefixed_fields({}) == {}


class TestResolve:
    """The resolve() function downloads, parses, and extracts metadata."""

    def test_extracts_generic_fields(self, tmp_path: Path):
        manifest = {
            "project_repo": "https://github.com/org/proj",
            "project_resolved_commit": "deadbeef",
            "verified_functions_count": 42,
            "verify_summary_from_extract": {"total_functions": 50},
            "probe_verus_version": "0.2025.3.1",
            "verus_release_tag": "v0.2025.3.1",
            "cargo_package": "my-crate",
        }
        manifest_bytes = json.dumps(manifest).encode()

        mock_resp = MagicMock()
        mock_resp.read.return_value = manifest_bytes
        mock_resp.__enter__ = lambda s: s
        mock_resp.__exit__ = MagicMock(return_value=False)

        with patch("urllib.request.urlopen", return_value=mock_resp):
            with patch("urllib.request.Request") as mock_req:
                outputs = _mod.resolve("https://example.com/manifest.json", str(tmp_path))

        assert outputs["verified_count"] == "42"
        assert outputs["total_functions"] == "50"
        assert outputs["verus_version"] == "0.2025.3.1"
        assert outputs["verus_release_tag"] == "v0.2025.3.1"
        assert outputs["package_name"] == "my-crate"
        assert outputs["commit_sha"] == "deadbeef"
        assert outputs["repo_path"] == "org/proj"
        assert outputs["cert_id"] == "org-proj"

    def test_missing_optional_fields(self, tmp_path: Path):
        manifest = {
            "project_repo": "https://github.com/org/proj",
            "project_resolved_commit": "abc123",
        }
        manifest_bytes = json.dumps(manifest).encode()

        mock_resp = MagicMock()
        mock_resp.read.return_value = manifest_bytes
        mock_resp.__enter__ = lambda s: s
        mock_resp.__exit__ = MagicMock(return_value=False)

        with patch("urllib.request.urlopen", return_value=mock_resp):
            with patch("urllib.request.Request"):
                outputs = _mod.resolve("https://example.com/m.json", str(tmp_path))

        assert "verified_count" not in outputs
        assert "total_functions" not in outputs
        assert "verus_version" not in outputs
        assert outputs["commit_sha"] == "abc123"

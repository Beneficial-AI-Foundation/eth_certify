"""Tests for Lean certification support.

Covers:
- resolve_lean_extract.py script (atoms.json parsing, counting, lean version)
- lean_version field in registry, verify-certification, and summary scripts
"""

import json
import subprocess
import sys
from pathlib import Path

# Path to the scripts directory
SCRIPTS_DIR = Path(__file__).parent.parent / ".github" / "scripts"


# ---------------------------------------------------------------------------
# resolve_lean_extract.py
# ---------------------------------------------------------------------------


def _run_resolve(args: list[str], cwd: Path | None = None) -> dict[str, str]:
    """Run resolve_lean_extract.py and parse key=value output."""
    result = subprocess.run(
        [sys.executable, str(SCRIPTS_DIR / "resolve_lean_extract.py")] + args,
        capture_output=True,
        text=True,
        cwd=cwd,
    )
    if result.returncode != 0:
        raise RuntimeError(f"Script failed ({result.returncode}): {result.stderr}")
    outputs = {}
    for line in result.stdout.strip().splitlines():
        if "=" in line:
            k, _, v = line.partition("=")
            outputs[k] = v
    return outputs


def _make_atoms_json(tmp_path: Path, atoms: dict, envelope: bool = True) -> Path:
    """Create an atoms.json file in tmp_path."""
    if envelope:
        data = {
            "tool": {"version": "0.2.0", "name": "probe-lean", "command": "extract"},
            "timestamp": "2026-03-25T09:33:03Z",
            "source": {
                "repo": "https://github.com/test/repo.git",
                "package": "TestPkg",
                "language": "lean",
                "commit": "abc123",
            },
            "schema-version": "2.0",
            "schema": "probe-lean/extract",
            "data": atoms,
        }
    else:
        data = atoms
    path = tmp_path / "atoms.json"
    path.write_text(json.dumps(data))
    return path


class TestResolveLeanExtract:
    """resolve_lean_extract.py parses atoms.json correctly."""

    def test_counts_verified_and_sorry(self, tmp_path):
        atoms = {
            "probe:verified_fn": {
                "verification-status": "verified",
                "is-in-package": True,
                "is-relevant": True,
                "kind": "theorem",
            },
            "probe:sorry_fn": {
                "verification-status": "has-sorry",
                "is-in-package": True,
                "is-relevant": True,
                "kind": "def",
            },
            "probe:also_verified": {
                "verification-status": "verified",
                "is-in-package": True,
                "is-relevant": True,
                "kind": "def",
            },
        }
        atoms_path = _make_atoms_json(tmp_path, atoms)
        outputs = _run_resolve(["--atoms-file", str(atoms_path)])

        assert outputs["verified_count"] == "2"
        assert outputs["total_functions"] == "3"
        assert outputs["sorry_count"] == "1"

    def test_excludes_non_package_atoms(self, tmp_path):
        atoms = {
            "probe:in_pkg": {
                "verification-status": "verified",
                "is-in-package": True,
                "is-relevant": True,
                "kind": "theorem",
            },
            "probe:dep_atom": {
                "verification-status": "verified",
                "is-in-package": False,
                "is-relevant": True,
                "kind": "theorem",
            },
        }
        atoms_path = _make_atoms_json(tmp_path, atoms)
        outputs = _run_resolve(["--atoms-file", str(atoms_path)])

        assert outputs["verified_count"] == "1"
        assert outputs["total_functions"] == "1"

    def test_excludes_non_relevant_atoms(self, tmp_path):
        atoms = {
            "probe:relevant": {
                "verification-status": "verified",
                "is-in-package": True,
                "is-relevant": True,
                "kind": "theorem",
            },
            "probe:irrelevant": {
                "verification-status": "verified",
                "is-in-package": True,
                "is-relevant": False,
                "kind": "instance",
            },
        }
        atoms_path = _make_atoms_json(tmp_path, atoms)
        outputs = _run_resolve(["--atoms-file", str(atoms_path)])

        assert outputs["verified_count"] == "1"
        assert outputs["total_functions"] == "1"

    def test_results_file_is_absolute(self, tmp_path):
        atoms_path = _make_atoms_json(tmp_path, {})
        outputs = _run_resolve(["--atoms-file", str(atoms_path)])

        assert outputs["results_file"].startswith("/")
        assert outputs["results_file"] == str(atoms_path.resolve())

    def test_lean_version_from_toolchain_file(self, tmp_path):
        atoms_path = _make_atoms_json(tmp_path, {})
        toolchain = tmp_path / "lean-toolchain"
        toolchain.write_text("leanprover/lean4:v4.28.0-rc1\n")

        outputs = _run_resolve([
            "--atoms-file", str(atoms_path),
            "--lean-toolchain-file", str(toolchain),
        ])

        assert outputs["lean_version"] == "v4.28.0-rc1"

    def test_lean_version_toolchain_without_colon(self, tmp_path):
        atoms_path = _make_atoms_json(tmp_path, {})
        toolchain = tmp_path / "lean-toolchain"
        toolchain.write_text("v4.28.0\n")

        outputs = _run_resolve([
            "--atoms-file", str(atoms_path),
            "--lean-toolchain-file", str(toolchain),
        ])

        assert outputs["lean_version"] == "v4.28.0"

    def test_functions_file_output(self, tmp_path):
        atoms_path = _make_atoms_json(tmp_path, {})
        funcs_path = tmp_path / "functions.json"
        funcs_path.write_text("{}")

        outputs = _run_resolve([
            "--atoms-file", str(atoms_path),
            "--functions-file", str(funcs_path),
        ])

        assert outputs["functions_file"] == str(funcs_path.resolve())

    def test_functions_file_empty_when_missing(self, tmp_path):
        atoms_path = _make_atoms_json(tmp_path, {})

        outputs = _run_resolve(["--atoms-file", str(atoms_path)])

        assert outputs["functions_file"] == ""

    def test_empty_atoms(self, tmp_path):
        atoms_path = _make_atoms_json(tmp_path, {})
        outputs = _run_resolve(["--atoms-file", str(atoms_path)])

        assert outputs["verified_count"] == "0"
        assert outputs["total_functions"] == "0"
        assert outputs["sorry_count"] == "0"


# ---------------------------------------------------------------------------
# Registry lean_version support
# ---------------------------------------------------------------------------


class TestRegistryLeanVersion:
    """lean_version is correctly stored and retrieved from the registry."""

    def test_lean_version_in_history(self, tmp_path):
        from certify_cli.registry import update_registry

        update_registry(
            cert_id="test-lean",
            repo_path="Owner/Repo",
            ref="main",
            network="sepolia",
            verified=10,
            total=15,
            tx_hash="0xabc",
            content_hash="0xdef",
            base_dir=tmp_path,
            lean_version="v4.28.0-rc1",
        )

        history = json.loads((tmp_path / "test-lean" / "history.json").read_text())
        entry = history["certifications"][0]
        assert entry["lean_version"] == "v4.28.0-rc1"
        assert "verus_version" not in entry

    def test_lean_version_absent_when_omitted(self, tmp_path):
        from certify_cli.registry import update_registry

        update_registry(
            cert_id="test-verus",
            repo_path="Owner/Repo",
            ref="main",
            network="sepolia",
            verified=5,
            total=5,
            tx_hash="0xabc",
            content_hash="0xdef",
            base_dir=tmp_path,
            verus_version="v0.2025.2.24",
        )

        history = json.loads((tmp_path / "test-verus" / "history.json").read_text())
        entry = history["certifications"][0]
        assert entry["verus_version"] == "v0.2025.2.24"
        assert "lean_version" not in entry

    def test_readme_shows_lean_toolchain(self, tmp_path):
        from certify_cli.registry import update_registry

        update_registry(
            cert_id="test-lean",
            repo_path="Owner/Repo",
            ref="main",
            network="sepolia",
            verified=10,
            total=15,
            tx_hash="0xabc",
            content_hash="0xdef",
            base_dir=tmp_path,
            lean_version="v4.28.0-rc1",
        )

        readme = (tmp_path / "test-lean" / "README.md").read_text()
        assert "**Lean**: v4.28.0-rc1" in readme
        assert "Verus" not in readme


# ---------------------------------------------------------------------------
# verify_certification lean_version support
# ---------------------------------------------------------------------------


class TestVerifyCertificationLeanVersion:
    """verify_certification exposes lean_version in JSON and human output."""

    def test_to_json_includes_lean_version(self, tmp_path, mock_keccak, keccak_fn):
        cert_id = "test-lean"
        cert_dir = tmp_path / cert_id
        cert_dir.mkdir()

        results_content = b'{"verified": 10}'
        results_hash = keccak_fn(results_content)

        results_dir = cert_dir / "results"
        results_dir.mkdir()
        results_file = results_dir / "latest.json"
        results_file.write_bytes(results_content)

        commit = "abc123"
        history = {
            "certifications": [{
                "timestamp": "2026-03-25T12:00:00Z",
                "ref": "main",
                "network": "sepolia",
                "tx_hash": "0xdeadbeef",
                "content_hash": results_hash,
                "etherscan_url": "https://sepolia.etherscan.io/tx/0xdeadbeef",
                "verified": 10,
                "total": 15,
                "commit_sha": commit,
                "lean_version": "v4.28.0-rc1",
                "results_hash": results_hash,
                "results_file": "results/latest.json",
            }],
        }
        (cert_dir / "history.json").write_text(json.dumps(history))

        from certify_cli.verify_certification import verify_certification

        result = verify_certification(
            cert_id=cert_id,
            commit=commit,
            network="sepolia",
            base_dir=tmp_path,
        )

        assert result.found
        json_out = result.to_json()
        assert json_out["lean_version"] == "v4.28.0-rc1"
        assert json_out["verus_version"] == ""

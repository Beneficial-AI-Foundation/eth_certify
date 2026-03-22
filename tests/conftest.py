"""Shared fixtures for certify_cli tests.

The main challenge: many functions shell out to `cast keccak` (Foundry CLI).
Tests must not depend on Foundry being installed. We patch cast_keccak with
a pure-Python keccak256 via web3 (already a project dependency).
"""

import json
from pathlib import Path
from typing import Any
from unittest.mock import patch

import pytest
from web3 import Web3


def _py_keccak(data: str | bytes) -> str:
    """Pure-Python keccak256 matching cast_keccak's interface."""
    if isinstance(data, str):
        data = data.encode()
    return "0x" + Web3.keccak(data).hex()


@pytest.fixture()
def keccak_fn():
    """Bare keccak function for computing expected values in tests."""
    return _py_keccak


@pytest.fixture()
def mock_keccak():
    """Patch cast_keccak and run_cast so no subprocess calls escape.

    cast_keccak is replaced with a pure-Python Web3.keccak.
    run_cast raises RuntimeError if called (catches accidental subprocess use).
    """

    def _run_cast_guard(args: list[str]) -> str:
        raise RuntimeError(
            f"run_cast called during test with args={args}. "
            "Add a mock or use a pure-Python alternative."
        )

    with (
        patch("certify_cli.foundry.cast_keccak", side_effect=_py_keccak),
        patch("certify_cli.verify_certification.cast_keccak", side_effect=_py_keccak),
        patch("certify_cli.verify.cast_keccak", side_effect=_py_keccak),
        patch("certify_cli.foundry.run_cast", side_effect=_run_cast_guard),
    ):
        yield


@pytest.fixture()
def tmp_registry(tmp_path: Path, keccak_fn) -> dict[str, Any]:
    """Create a realistic temp registry with history.json and archived files.

    Returns a dict with keys: base_dir, cert_id, cert_dir, results_content,
    specs_content, results_hash, specs_hash, content_hash, commit, history_entry.
    """
    cert_id = "test-org-test-repo"
    cert_dir = tmp_path / cert_id
    cert_dir.mkdir()

    results_content = b'{"verified": 5, "total": 5}'
    specs_content = b'{"fn_a": {"ensures_text": "x > 0"}}'

    results_hash = keccak_fn(results_content)
    specs_hash = keccak_fn(specs_content)

    combined = bytes.fromhex(results_hash[2:]) + bytes.fromhex(specs_hash[2:])
    content_hash = keccak_fn(combined)

    results_dir = cert_dir / "results"
    results_dir.mkdir()
    results_file = results_dir / "2026-03-22T12-00-00Z.json"
    results_file.write_bytes(results_content)

    specs_dir = cert_dir / "specs"
    specs_dir.mkdir()
    specs_file = specs_dir / "2026-03-22T12-00-00Z.json"
    specs_file.write_bytes(specs_content)

    commit = "abc123def456"
    history_entry = {
        "timestamp": "2026-03-22T12:00:00Z",
        "ref": "main",
        "network": "sepolia",
        "tx_hash": "0xdeadbeef",
        "content_hash": content_hash,
        "etherscan_url": "https://sepolia.etherscan.io/tx/0xdeadbeef",
        "verified": 5,
        "total": 5,
        "commit_sha": commit,
        "results_hash": results_hash,
        "specs_hash": specs_hash,
        "results_file": "results/2026-03-22T12-00-00Z.json",
        "specs_file": "specs/2026-03-22T12-00-00Z.json",
    }

    history = {"certifications": [history_entry]}
    (cert_dir / "history.json").write_text(json.dumps(history, indent=2))

    return {
        "base_dir": tmp_path,
        "cert_id": cert_id,
        "cert_dir": cert_dir,
        "results_content": results_content,
        "specs_content": specs_content,
        "results_hash": results_hash,
        "specs_hash": specs_hash,
        "content_hash": content_hash,
        "commit": commit,
        "history_entry": history_entry,
    }

"""P4: Commit binding (zero-padding), P7: Key confidentiality (static check),
and identifier override tests.

P4 partial: unit-tests the commit hash zero-padding logic that converts
a hex SHA-1 to a bytes32 value for on-chain storage.

P7: static analysis test that verifies no run_forge() call site passes
private keys via CLI arguments.
"""

import ast
import inspect
from pathlib import Path
from unittest.mock import MagicMock, patch


class TestCommitHashZeroPadding:
    """P4: commit hash is correctly zero-padded to bytes32."""

    @staticmethod
    def _pad_commit(commit_hash: str | None) -> str:
        """Reproduce the zero-padding logic from deploy.py::certify_content."""
        if not commit_hash:
            return "0x" + "0" * 64
        raw = commit_hash.replace("0x", "").strip('"').strip("'")
        return "0x" + raw.ljust(64, "0")

    def test_full_sha1_padded(self):
        sha = "abc123def456789012345678901234abcdef1234"
        result = self._pad_commit(sha)
        assert result == "0x" + sha + "0" * 24
        assert len(result) == 66  # 0x + 64 hex chars

    def test_short_sha_padded(self):
        result = self._pad_commit("abc123")
        assert result == "0x" + "abc123" + "0" * 58
        assert len(result) == 66

    def test_with_0x_prefix(self):
        result = self._pad_commit("0xabc123")
        assert result == "0x" + "abc123" + "0" * 58

    def test_none_produces_zero_hash(self):
        result = self._pad_commit(None)
        assert result == "0x" + "0" * 64

    def test_empty_string_produces_zero_hash(self):
        result = self._pad_commit("")
        assert result == "0x" + "0" * 64

    def test_quoted_sha_stripped(self):
        result = self._pad_commit('"abc123"')
        assert result == "0x" + "abc123" + "0" * 58

    def test_result_always_66_chars(self):
        for sha in ["a", "ab" * 20, "0xdeadbeef", None, ""]:
            result = self._pad_commit(sha)
            assert len(result) == 66, f"Failed for input {sha!r}: got {len(result)}"


class TestKeyConfidentiality:
    """P7: Private keys must never appear as CLI arguments to forge."""

    def test_no_private_key_in_run_forge_calls(self):
        """Static check: scan deploy.py source for run_forge calls with --private-key."""
        import certify_cli.deploy as deploy_mod

        source = inspect.getsource(deploy_mod)
        tree = ast.parse(source)

        for node in ast.walk(tree):
            if isinstance(node, ast.Call):
                for arg in node.args:
                    if isinstance(arg, ast.Constant) and isinstance(arg.value, str):
                        assert "--private-key" not in arg.value, (
                            f"deploy.py contains '--private-key' as a string literal "
                            f"at line {arg.lineno}"
                        )
                for keyword in node.keywords:
                    if isinstance(keyword.value, ast.Constant) and isinstance(
                        keyword.value.value, str
                    ):
                        assert "--private-key" not in keyword.value.value, (
                            f"deploy.py contains '--private-key' in keyword arg "
                            f"at line {keyword.value.lineno}"
                        )

    def test_no_private_key_in_forge_arg_lists(self):
        """Scan all .py files in certify_cli/ for --private-key string literals."""
        cli_dir = Path(__file__).parent.parent / "certify_cli"
        for py_file in cli_dir.glob("*.py"):
            source = py_file.read_text()
            if "run_forge" not in source:
                continue

            tree = ast.parse(source)
            for node in ast.walk(tree):
                if isinstance(node, ast.Constant) and isinstance(node.value, str):
                    assert "--private-key" not in node.value, (
                        f"{py_file.name} contains '--private-key' string literal "
                        f"at line {node.lineno}"
                    )

    def test_forge_script_uses_env_var(self):
        """Verify Certify.s.sol reads private key from env, not constructor arg."""
        script_path = Path(__file__).parent.parent / "script" / "Certify.s.sol"
        source = script_path.read_text()
        assert 'vm.envUint("ETH_PRIVATE_KEY")' in source

        non_comment_lines = [
            line
            for line in source.splitlines()
            if not line.strip().startswith("//") and not line.strip().startswith("*")
        ]
        non_comment_source = "\n".join(non_comment_lines)
        assert "--private-key" not in non_comment_source


class TestIdentifierOverride:
    """The --identifier flag makes the on-chain identifier differ from --source."""

    @patch("certify_cli.deploy.run_forge")
    def test_identifier_used_as_on_chain_id(self, mock_forge: MagicMock):
        """When identifier is provided, it should appear in forge args instead of source."""
        from certify_cli.config import CertifyConfig, EnvConfig, Network
        from certify_cli.deploy import certify_content

        mock_forge.return_value = MagicMock(success=True)

        env = MagicMock(spec=EnvConfig)
        env.certify_address = "0x1234567890abcdef1234567890abcdef12345678"
        env.get_private_key.return_value = "0xdeadbeef"
        env.get_rpc_url.return_value = "http://localhost:8545"

        config = CertifyConfig(source="/tmp/local.json", description="test")

        with patch("certify_cli.deploy.compute_content_hash", return_value="0xhash"):
            with patch("certify_cli.deploy._extract_tx_hash_from_broadcast", return_value="0xtx"):
                result = certify_content(
                    env, config, Network.ANVIL,
                    identifier="https://example.com/manifest.json",
                )

        forge_args = mock_forge.call_args[0][0]
        assert "https://example.com/manifest.json" in forge_args
        assert "/tmp/local.json" not in forge_args
        assert result.url == "https://example.com/manifest.json"

    @patch("certify_cli.deploy.run_forge")
    def test_source_used_when_no_identifier(self, mock_forge: MagicMock):
        """When identifier is omitted, source should be the on-chain identifier."""
        from certify_cli.config import CertifyConfig, EnvConfig, Network
        from certify_cli.deploy import certify_content

        mock_forge.return_value = MagicMock(success=True)

        env = MagicMock(spec=EnvConfig)
        env.certify_address = "0x1234567890abcdef1234567890abcdef12345678"
        env.get_private_key.return_value = "0xdeadbeef"
        env.get_rpc_url.return_value = "http://localhost:8545"

        config = CertifyConfig(source="https://example.com/results.json", description="test")

        with patch("certify_cli.deploy.compute_content_hash", return_value="0xhash"):
            with patch("certify_cli.deploy._extract_tx_hash_from_broadcast", return_value="0xtx"):
                result = certify_content(env, config, Network.ANVIL)

        forge_args = mock_forge.call_args[0][0]
        assert "https://example.com/results.json" in forge_args
        assert result.url == "https://example.com/results.json"

"""Config parsing tests: env file syntax, priority, fallbacks.

Tests that configuration loading respects the documented priority
(env vars > file) and handles edge cases in .env file syntax.
"""

import pytest

from certify_cli.config import (
    CertifyConfig,
    EnvConfig,
    Network,
    _parse_env_file,
)


class TestEnvFileParsing:
    """Test _parse_env_file handles all .env syntax variations."""

    def test_standard_key_value(self, tmp_path):
        f = tmp_path / ".env"
        f.write_text("KEY=value\nOTHER=123\n")
        result = _parse_env_file(f)
        assert result == {"KEY": "value", "OTHER": "123"}

    def test_double_quoted_values(self, tmp_path):
        f = tmp_path / ".env"
        f.write_text('KEY="quoted value"\n')
        result = _parse_env_file(f)
        assert result["KEY"] == "quoted value"

    def test_single_quoted_values(self, tmp_path):
        f = tmp_path / ".env"
        f.write_text("KEY='single quoted'\n")
        result = _parse_env_file(f)
        assert result["KEY"] == "single quoted"

    def test_comments_skipped(self, tmp_path):
        f = tmp_path / ".env"
        f.write_text("# This is a comment\nKEY=value\n# Another comment\n")
        result = _parse_env_file(f)
        assert result == {"KEY": "value"}

    def test_empty_lines_skipped(self, tmp_path):
        f = tmp_path / ".env"
        f.write_text("\n\nKEY=value\n\n")
        result = _parse_env_file(f)
        assert result == {"KEY": "value"}

    def test_whitespace_around_equals(self, tmp_path):
        f = tmp_path / ".env"
        f.write_text(" KEY = value \n")
        result = _parse_env_file(f)
        assert "KEY" in result


class TestCertifyConfigLoading:
    """Test CertifyConfig.load with env var priority and legacy fallback."""

    def test_env_var_overrides_file(self, tmp_path, monkeypatch):
        conf = tmp_path / "certify.conf"
        conf.write_text(
            'CERTIFY_SOURCE="file_value"\nCERTIFY_DESCRIPTION="file_desc"\n'
        )
        monkeypatch.setenv("CERTIFY_SOURCE", "env_value")

        config = CertifyConfig.load(conf)
        assert config.source == "env_value"

    def test_legacy_certify_url_fallback(self, tmp_path, monkeypatch):
        monkeypatch.delenv("CERTIFY_SOURCE", raising=False)
        monkeypatch.delenv("CERTIFY_URL", raising=False)

        conf = tmp_path / "certify.conf"
        conf.write_text('CERTIFY_URL="https://legacy.example.com"\n')

        config = CertifyConfig.load(conf)
        assert config.source == "https://legacy.example.com"

    def test_missing_source_raises(self, tmp_path, monkeypatch):
        monkeypatch.delenv("CERTIFY_SOURCE", raising=False)
        monkeypatch.delenv("CERTIFY_URL", raising=False)

        conf = tmp_path / "certify.conf"
        conf.write_text("# empty\n")

        with pytest.raises(ValueError, match="CERTIFY_SOURCE must be set"):
            CertifyConfig.load(conf)


class TestSourceTypeDetection:
    """Test CertifyConfig source type properties."""

    def test_url_source(self):
        c = CertifyConfig(source="https://example.com/results.json", description="test")
        assert c.source_type == "URL"
        assert c.is_url is True
        assert c.is_github_artifact is False

    def test_github_artifact_source(self):
        c = CertifyConfig(
            source="github://owner/repo/artifacts/123", description="test"
        )
        assert c.source_type == "GitHub artifact"
        assert c.is_github_artifact is True

    def test_file_source(self):
        c = CertifyConfig(source="./local/path.json", description="test")
        assert c.source_type == "file"
        assert c.is_url is False


class TestEnvConfigKeyFallback:
    """Test network-specific key selection and fallback logic."""

    def _make_env(self, **kwargs) -> EnvConfig:
        defaults = {
            "mainnet_rpc_url": None,
            "sepolia_rpc_url": "https://sepolia.rpc",
            "mainnet_private_key": None,
            "sepolia_private_key": None,
            "private_key": None,
            "etherscan_api_key": None,
            "certify_address": None,
        }
        defaults.update(kwargs)
        return EnvConfig(**defaults)

    def test_mainnet_key_used_for_mainnet(self):
        env = self._make_env(mainnet_private_key="0xMAINNET")
        assert env.get_private_key(Network.MAINNET) == "0xMAINNET"

    def test_fallback_key_used_for_mainnet(self):
        env = self._make_env(private_key="0xFALLBACK")
        assert env.get_private_key(Network.MAINNET) == "0xFALLBACK"

    def test_no_key_raises_for_mainnet(self):
        env = self._make_env()
        with pytest.raises(ValueError, match="must be set"):
            env.get_private_key(Network.MAINNET)

    def test_sepolia_key_used(self):
        env = self._make_env(sepolia_private_key="0xSEPOLIA")
        assert env.get_private_key(Network.SEPOLIA) == "0xSEPOLIA"

    def test_any_key_used_for_local(self):
        env = self._make_env(sepolia_private_key="0xSEPOLIA")
        assert env.get_private_key(Network.LOCAL) == "0xSEPOLIA"

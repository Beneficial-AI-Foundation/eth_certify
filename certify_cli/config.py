"""Configuration dataclasses for the Certify CLI."""

from dataclasses import dataclass
from enum import Enum
from pathlib import Path
from typing import Optional
import os


class Network(Enum):
    """Supported blockchain networks."""
    SEPOLIA = "sepolia"
    ANVIL = "anvil"
    LOCAL = "local"

    @property
    def rpc_url(self) -> str:
        """Get the RPC URL for this network."""
        if self == Network.SEPOLIA:
            url = os.getenv("SEPOLIA_RPC_URL")
            if not url:
                raise ValueError("SEPOLIA_RPC_URL must be set (env var or .env file)")
            return url
        return "http://127.0.0.1:8545"


def _get_env(key: str, file_vars: dict[str, str], default: Optional[str] = None) -> Optional[str]:
    """Get a value from environment variable first, then file, then default."""
    return os.getenv(key) or file_vars.get(key) or default


@dataclass(frozen=True)
class EnvConfig:
    """Environment configuration from env vars or .env file.
    
    Priority: Environment variables > .env file
    This allows GitHub Actions secrets to override local .env values.
    """
    sepolia_rpc_url: Optional[str]
    private_key: str
    etherscan_api_key: Optional[str]
    certify_address: Optional[str]

    @classmethod
    def load(cls, env_path: Path = Path(".env")) -> "EnvConfig":
        """Load configuration from environment variables and optionally .env file.
        
        Environment variables take priority over .env file values.
        The .env file is optional (for CI/CD environments).
        """
        # Load .env file if it exists (optional)
        file_vars: dict[str, str] = {}
        if env_path.exists():
            file_vars = _parse_env_file(env_path)

        private_key = _get_env("PRIVATE_KEY", file_vars)
        if not private_key:
            raise ValueError(
                "PRIVATE_KEY must be set (via environment variable or .env file)"
            )

        return cls(
            sepolia_rpc_url=_get_env("SEPOLIA_RPC_URL", file_vars),
            private_key=private_key,
            etherscan_api_key=_get_env("ETHERSCAN_API_KEY", file_vars),
            certify_address=_get_env("CERTIFY_ADDRESS", file_vars),
        )


@dataclass(frozen=True)
class CertifyConfig:
    """Certification configuration from env vars or certify.conf file.
    
    Priority: Environment variables > certify.conf file
    """
    source: str  # URL, local file path, or GitHub artifact
    description: str

    @classmethod
    def load(cls, config_path: Path = Path("certify.conf")) -> "CertifyConfig":
        """Load configuration from environment variables and optionally certify.conf.
        
        Environment variables take priority over file values.
        """
        # Load config file if it exists (optional)
        file_vars: dict[str, str] = {}
        if config_path.exists():
            file_vars = _parse_env_file(config_path)

        # Support both CERTIFY_SOURCE (new) and CERTIFY_URL (legacy)
        source = _get_env("CERTIFY_SOURCE", file_vars) or _get_env("CERTIFY_URL", file_vars)
        if not source:
            raise ValueError(
                "CERTIFY_SOURCE must be set (via environment variable or certify.conf)"
            )

        return cls(
            source=source,
            description=_get_env("CERTIFY_DESCRIPTION", file_vars, "Content certification"),
        )

    @property
    def is_url(self) -> bool:
        """Check if the source is a URL."""
        return self.source.startswith(("http://", "https://"))

    @property
    def is_github_artifact(self) -> bool:
        """Check if the source is a GitHub artifact."""
        return self.source.startswith("github://")

    @property
    def source_type(self) -> str:
        """Get a human-readable source type."""
        if self.is_github_artifact:
            return "GitHub artifact"
        elif self.is_url:
            return "URL"
        return "file"


@dataclass(frozen=True)
class OnChainCertification:
    """Represents a certification record found on-chain."""
    content_hash: str
    certifier_address: str
    timestamp: Optional[int]
    block_number: int
    transaction_hash: str


def _parse_env_file(path: Path) -> dict[str, str]:
    """Parse a .env-style file into a dictionary."""
    result: dict[str, str] = {}
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if "=" in line:
                key, _, value = line.partition("=")
                # Remove quotes if present
                value = value.strip().strip('"').strip("'")
                result[key.strip()] = value
    return result


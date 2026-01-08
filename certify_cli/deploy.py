"""Deploy and certify commands."""

from dataclasses import dataclass

from .config import CertifyConfig, EnvConfig, Network
from .foundry import compute_content_hash, run_forge


@dataclass
class DeployResult:
    """Result of a deploy operation."""
    success: bool
    message: str


def deploy_contract(
    env: EnvConfig,
    network: Network,
) -> DeployResult:
    """Deploy the Certify contract to the specified network."""
    print(f"Deploying Certify contract to {network.value}...")

    args = [
        "script", "script/Certify.s.sol:DeployCertify",
        "--broadcast",
        "--rpc-url", network.rpc_url,
        "--private-key", env.private_key,
    ]

    # Add verification flags for Sepolia if API key is available
    if env.etherscan_api_key and network == Network.SEPOLIA:
        args.extend(["--verify", "--etherscan-api-key", env.etherscan_api_key])

    result = run_forge(args)

    if result.success:
        return DeployResult(
            success=True,
            message=(
                "✅ Deploy complete!\n"
                "👉 Copy the deployed address and add it to .env as CERTIFY_ADDRESS"
            ),
        )
    return DeployResult(
        success=False,
        message=f"❌ Deploy failed:\n{result.stderr}",
    )


@dataclass
class CertifyResult:
    """Result of a certify operation."""
    success: bool
    url: str
    content_hash: str
    contract_address: str
    message: str


def certify_content(
    env: EnvConfig,
    certify_config: CertifyConfig,
    network: Network,
) -> CertifyResult:
    """Certify content (from URL or file) on-chain."""
    if not env.certify_address:
        raise ValueError(
            "CERTIFY_ADDRESS must be set in .env. "
            f"Run deploy first, then add the address to .env"
        )

    source = certify_config.source
    print(f"Fetching content hash for {certify_config.source_type}: {source}...")

    content_hash = compute_content_hash(source)
    print(f"Content hash: {content_hash}")

    print("\nCertifying content...")

    args = [
        "script", "script/Certify.s.sol:CertifyWebsiteContent",
        "--sig", "run(address,string,bytes32,string)",
        env.certify_address,
        source,
        content_hash,
        certify_config.description,
        "--broadcast",
        "--rpc-url", network.rpc_url,
        "--private-key", env.private_key,
    ]

    result = run_forge(args)

    if result.success:
        return CertifyResult(
            success=True,
            url=source,
            content_hash=content_hash,
            contract_address=env.certify_address,
            message=(
                f"✅ Content certified!\n"
                f"   Source: {source}\n"
                f"   Content Hash: {content_hash}\n"
                f"   Contract: {env.certify_address}"
            ),
        )
    return CertifyResult(
        success=False,
        url=source,
        content_hash=content_hash,
        contract_address=env.certify_address,
        message=f"❌ Certification failed:\n{result.stderr}",
    )


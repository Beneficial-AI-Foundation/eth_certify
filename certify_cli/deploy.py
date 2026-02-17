"""Deploy and certify commands."""

from dataclasses import dataclass
from typing import Optional

from .config import CertifyConfig, EnvConfig, Network
from .foundry import (
    compute_content_hash,
    compute_merkle_content_hash,
    run_cast,
    run_forge,
)


@dataclass
class DeployResult:
    """Result of a deploy operation."""

    success: bool
    message: str


def deploy_contract(
    env: EnvConfig,
    network: Network,
    authorized_address: Optional[str] = None,
) -> DeployResult:
    """Deploy the Certify contract to the specified network.

    Args:
        env: Environment configuration (RPC, keys, etc.)
        network: Target network.
        authorized_address: The only address that may call certify().
                            Typically the BAIF Gnosis Safe address.
                            If omitted, defaults to the deployer's own address.
    """
    print(f"Deploying Certify contract to {network.value}...")

    private_key = env.get_private_key(network)
    rpc_url = env.get_rpc_url(network)

    # Determine the authorized certifier address
    if not authorized_address:
        # Default: deployer's own address (useful for local testing)
        from eth_account import Account

        authorized_address = Account.from_key(private_key).address
        print(
            f"No --authorized-address given; defaulting to deployer: {authorized_address}"
        )

    print(f"Authorized certifier: {authorized_address}")

    args = [
        "script",
        "script/Certify.s.sol:DeployCertify",
        "--sig",
        "run(address)",
        authorized_address,
        "--broadcast",
        "--rpc-url",
        rpc_url,
    ]

    # Pass private key via environment variable (not CLI arg) to avoid
    # leaking it in the process list (/proc/<pid>/cmdline).
    result = run_forge(args, env_extra={"ETH_PRIVATE_KEY": private_key})

    if not result.success:
        return DeployResult(
            success=False,
            message=f"❌ Deploy failed:\n{result.stderr}",
        )

    # Note: Etherscan verification is done manually after deployment
    # since we need the deployed address from the broadcast output.
    if env.etherscan_api_key and network in (Network.MAINNET, Network.SEPOLIA):
        print(
            f"Tip: verify on Etherscan with:\n"
            f"  forge verify-contract <ADDRESS> src/Certify.sol:Certify "
            f"--chain {network.value} --etherscan-api-key <KEY> "
            f"--constructor-args 0x{'0' * 24}{authorized_address[2:].lower()}"
        )

    return DeployResult(
        success=True,
        message=(
            "✅ Deploy complete!\n"
            "👉 Copy the deployed address and add it to .env as CERTIFY_ADDRESS"
        ),
    )


@dataclass
class CertifyResult:
    """Result of a certify operation."""

    success: bool
    url: str
    content_hash: str
    contract_address: str
    message: str
    results_hash: Optional[str] = None  # Set when Merkle hashing is used
    specs_hash: Optional[str] = None  # Set when Merkle hashing is used


def certify_content(
    env: EnvConfig,
    certify_config: CertifyConfig,
    network: Network,
    safe_address: Optional[str] = None,
    safe_execute: bool = False,
    commit_hash: Optional[str] = None,
) -> CertifyResult:
    """Certify content (from URL or file) on-chain.

    When specs_source is configured (via CERTIFY_SPECS_SOURCE or certify.conf),
    uses Merkle-style hashing:
      results_hash = keccak256(results.json)
      specs_hash   = keccak256(specs.json)
      content_hash = keccak256(results_hash || specs_hash)

    Otherwise falls back to simple hashing of the source file.

    If safe_address is provided without safe_execute, generates transaction
    data for Safe UI.

    If safe_address is provided with safe_execute=True, programmatically
    signs and executes the transaction via the Safe.
    """
    if not env.certify_address:
        raise ValueError(
            "CERTIFY_ADDRESS must be set in .env. "
            "Run deploy first, then add the address to .env"
        )

    source = certify_config.source
    results_hash: Optional[str] = None
    specs_hash: Optional[str] = None

    if certify_config.specs_source:
        # Merkle-style: hash results and specs independently, combine
        print("Computing Merkle content hash...")
        print(f"  Results: {source}")
        print(f"  Specs:   {certify_config.specs_source}")
        content_hash, results_hash, specs_hash, _proofs_hash = (
            compute_merkle_content_hash(
                results_source=source,
                specs_source=certify_config.specs_source,
            )
        )
        print(f"  Results hash: {results_hash}")
        print(f"  Specs hash:   {specs_hash}")
        print(f"  Content hash: {content_hash}  (Merkle root)")
    else:
        print(f"Fetching content hash for {certify_config.source_type}: {source}...")
        content_hash = compute_content_hash(source)
        print(f"Content hash: {content_hash}")

    # If Safe address provided, use Safe-based certification
    if safe_address:
        result = _certify_via_safe(
            env=env,
            certify_config=certify_config,
            network=network,
            safe_address=safe_address,
            content_hash=content_hash,
            execute=safe_execute,
            commit_hash=commit_hash or "",
        )
        result.results_hash = results_hash
        result.specs_hash = specs_hash
        return result

    print("\nCertifying content (direct forge-script path)...")
    if network not in (Network.ANVIL, Network.LOCAL):
        print("Warning: The contract enforces msg.sender == authorizedCertifier.")
        print("For mainnet/sepolia, use --safe ADDRESS --execute instead.")

    private_key = env.get_private_key(network)
    rpc_url = env.get_rpc_url(network)

    # Zero-padded commit hash for the forge script
    commit_bytes32 = "0x" + "0" * 64
    if commit_hash:
        raw = commit_hash.replace("0x", "")
        commit_bytes32 = "0x" + raw.ljust(64, "0")

    args = [
        "script",
        "script/Certify.s.sol:CertifyDirect",
        "--sig",
        "run(address,string,bytes32,bytes32,string)",
        env.certify_address,
        source,
        content_hash,
        commit_bytes32,
        certify_config.description,
        "--broadcast",
        "--rpc-url",
        rpc_url,
    ]

    # Pass private key via environment variable (not CLI arg) to avoid
    # leaking it in the process list (/proc/<pid>/cmdline).
    result = run_forge(args, env_extra={"ETH_PRIVATE_KEY": private_key})

    if result.success:
        # Extract transaction hash from broadcast file
        tx_hash = _extract_tx_hash_from_broadcast(network)
        tx_info = f"\n   Tx Hash: {tx_hash}" if tx_hash else ""

        merkle_info = ""
        if results_hash and specs_hash:
            merkle_info = (
                f"\n   Results Hash: {results_hash}\n   Specs Hash: {specs_hash}"
            )

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
                f"{merkle_info}"
                f"{tx_info}"
            ),
            results_hash=results_hash,
            specs_hash=specs_hash,
        )
    return CertifyResult(
        success=False,
        url=source,
        content_hash=content_hash,
        contract_address=env.certify_address,
        message=f"❌ Certification failed:\n{result.stderr}",
    )


def _extract_tx_hash_from_broadcast(network: Network) -> Optional[str]:
    """Extract transaction hash from Foundry broadcast file."""
    import json
    from pathlib import Path

    chain_ids = {
        Network.MAINNET: 1,
        Network.SEPOLIA: 11155111,
        Network.ANVIL: 31337,
        Network.LOCAL: 31337,
    }

    chain_id = chain_ids.get(network)
    if not chain_id:
        return None

    broadcast_file = Path(f"broadcast/Certify.s.sol/{chain_id}/run-latest.json")
    if not broadcast_file.exists():
        return None

    try:
        with open(broadcast_file) as f:
            data = json.load(f)

        # Get the first transaction hash
        transactions = data.get("transactions", [])
        if transactions:
            return transactions[0].get("hash")
    except (json.JSONDecodeError, KeyError, IndexError):
        pass

    return None


def _certify_via_safe(
    env: EnvConfig,
    certify_config: CertifyConfig,
    network: Network,
    safe_address: str,
    content_hash: str,
    execute: bool = False,
    commit_hash: str = "",
) -> CertifyResult:
    """Certify via Gnosis Safe.

    If execute=True, programmatically sign and execute the transaction.
    Otherwise, generate transaction data for manual submission via Safe UI.
    """
    source = certify_config.source
    description = certify_config.description
    contract_address = env.certify_address

    if not contract_address:
        return CertifyResult(
            success=False,
            url=source,
            content_hash=content_hash,
            contract_address="",
            message="❌ CERTIFY_ADDRESS not set. Deploy the contract first or set the address.",
        )

    if execute:
        # Programmatic execution via Safe SDK
        return _execute_safe_certification(
            env=env,
            network=network,
            safe_address=safe_address,
            contract_address=contract_address,
            source=source,
            content_hash=content_hash,
            commit_hash=commit_hash,
            description=description,
        )

    # Generate transaction data for manual submission
    commit_hash_padded = commit_hash.ljust(66, "0") if commit_hash else "0x" + "0" * 64
    if not commit_hash_padded.startswith("0x"):
        commit_hash_padded = "0x" + commit_hash_padded.ljust(64, "0")

    calldata = run_cast(
        [
            "calldata",
            "certify(string,bytes32,bytes32,string)",
            source,
            content_hash,
            commit_hash_padded,
            description,
        ]
    )

    # Determine the network name for Safe URL
    network_slug = "eth" if network == Network.MAINNET else "sep"

    # Build Safe Transaction Builder URL
    safe_url = (
        f"https://app.safe.global/transactions/tx-builder?"
        f"safe={network_slug}:{safe_address}"
    )

    message = f"""
Transaction data generated for Safe.

Contract:     {contract_address}
Function:     certify(string,bytes32,bytes32,string)

Parameters:
  identifier:  {source}
  contentHash: {content_hash}
  commitHash:  {commit_hash_padded}
  description: {description}

Calldata:
{calldata}

Instructions:
1. Open your Safe: {safe_url}
2. Click "New Transaction" > "Transaction Builder"
3. Enter contract address: {contract_address}
4. Paste this ABI:
   [{{"inputs":[{{"internalType":"string","name":"identifier","type":"string"}},{{"internalType":"bytes32","name":"contentHash","type":"bytes32"}},{{"internalType":"bytes32","name":"commitHash","type":"bytes32"}},{{"internalType":"string","name":"description","type":"string"}}],"name":"certify","outputs":[],"stateMutability":"nonpayable","type":"function"}}]
5. Select function: certify
6. Fill in parameters and execute.

TIP: Add --execute to run programmatically:
  certify --network {network.value} --safe {safe_address} --execute

"""

    return CertifyResult(
        success=True,
        url=source,
        content_hash=content_hash,
        contract_address=contract_address,
        message=message,
    )


def _execute_safe_certification(
    env: EnvConfig,
    network: Network,
    safe_address: str,
    contract_address: str,
    source: str,
    content_hash: str,
    commit_hash: str,
    description: str,
) -> CertifyResult:
    """Execute certification through Safe programmatically."""
    from .safe import encode_certify_call, execute_safe_transaction

    print(f"\nExecuting certification via Safe {safe_address}...")

    # Get the private key for signing
    private_key = env.get_private_key(network)
    rpc_url = env.get_rpc_url(network)

    # Encode the function call
    calldata = encode_certify_call(
        identifier=source,
        content_hash=content_hash,
        commit_hash=commit_hash,
        description=description,
    )

    # Execute via Safe
    result = execute_safe_transaction(
        safe_address=safe_address,
        contract_address=contract_address,
        calldata=calldata,
        private_key=private_key,
        rpc_url=rpc_url,
        network=network,
    )

    if result.success:
        return CertifyResult(
            success=True,
            url=source,
            content_hash=content_hash,
            contract_address=contract_address,
            message=(
                f"✅ Content certified via Safe!\n"
                f"   Source: {source}\n"
                f"   Content Hash: {content_hash}\n"
                f"   Contract: {contract_address}\n"
                f"   Safe: {safe_address}\n"
                f"   {result.message}"
            ),
        )
    return CertifyResult(
        success=False,
        url=source,
        content_hash=content_hash,
        contract_address=contract_address,
        message=result.message,
    )

"""Gnosis Safe integration for programmatic transaction execution."""

from dataclasses import dataclass
from typing import Optional

from typing import cast

from eth_account import Account
from eth_account.signers.local import LocalAccount
from eth_typing import URI, ChecksumAddress
from web3 import Web3

from safe_eth.eth import EthereumClient
from safe_eth.eth.ethereum_network import EthereumNetwork
from safe_eth.safe import Safe
from safe_eth.safe.api import TransactionServiceApi

from .config import Network


# Map our Network enum to safe-eth-py's EthereumNetwork enum
ETHEREUM_NETWORKS = {
    Network.MAINNET: EthereumNetwork.MAINNET,
    Network.SEPOLIA: EthereumNetwork.SEPOLIA,
}


@dataclass
class SafeExecutionResult:
    """Result of a Safe transaction execution."""

    success: bool
    tx_hash: Optional[str]
    message: str


def execute_safe_transaction(
    safe_address: str,
    contract_address: str,
    calldata: bytes,
    private_key: str,
    rpc_url: str,
    network: Network,
) -> SafeExecutionResult:
    """Execute a transaction through a Gnosis Safe.

    This function:
    1. Creates a Safe transaction
    2. Signs it with the owner's private key
    3. Submits to the Safe Transaction Service
    4. Executes the transaction on-chain (for 1-of-N Safes)

    Args:
        safe_address: The Gnosis Safe address
        contract_address: The target contract to call
        calldata: The encoded function call data
        private_key: Private key of a Safe owner
        rpc_url: RPC URL for the network
        network: The network (mainnet/sepolia)

    Returns:
        SafeExecutionResult with transaction hash if successful
    """
    if network not in ETHEREUM_NETWORKS:
        return SafeExecutionResult(
            success=False,
            tx_hash=None,
            message=f"❌ Safe execution not supported for {network.value}. Use mainnet or sepolia.",
        )

    try:
        # Initialize clients with proper types
        ethereum_client = EthereumClient(cast(URI, rpc_url))
        safe_checksum: ChecksumAddress = Web3.to_checksum_address(safe_address)

        # Detect Safe version and instantiate appropriate subclass
        safe_version = Safe.detect_version(safe_checksum, ethereum_client)
        if not safe_version:
            return SafeExecutionResult(
                success=False,
                tx_hash=None,
                message=f"❌ Could not detect Safe version for {safe_address}",
            )
        safe = Safe.from_version(safe_version, safe_checksum, ethereum_client)

        # Get the signer account
        account: LocalAccount = Account.from_key(private_key)

        # Check if account is an owner
        owners = safe.retrieve_owners()
        if account.address not in owners:
            return SafeExecutionResult(
                success=False,
                tx_hash=None,
                message=f"❌ Account {account.address} is not an owner of Safe {safe_address}",
            )

        # Get Safe info
        safe_info = safe.retrieve_all_info()

        # Build the Safe transaction
        contract_checksum: ChecksumAddress = Web3.to_checksum_address(contract_address)
        safe_tx = safe.build_multisig_tx(
            to=contract_checksum,
            value=0,
            data=calldata,
            safe_nonce=safe_info.nonce,
        )

        # Sign the transaction
        safe_tx.sign(private_key)

        # Initialize Transaction Service API
        eth_network = ETHEREUM_NETWORKS[network]
        tx_service = TransactionServiceApi(
            network=eth_network,
            ethereum_client=ethereum_client,
        )

        # Check if we have enough signatures to execute (threshold)
        threshold = safe_info.threshold

        if threshold == 1:
            # We can execute directly on-chain
            print("Safe threshold is 1. Executing transaction directly...")

            tx_hash, _ = safe_tx.execute(
                tx_sender_private_key=private_key,
            )

            return SafeExecutionResult(
                success=True,
                tx_hash=tx_hash.hex() if tx_hash else None,
                message=f"✅ Transaction executed!\n   Tx Hash: {tx_hash.hex() if tx_hash else 'N/A'}",
            )
        else:
            # Need to propose and wait for more signatures
            print(f"Safe threshold is {threshold}. Proposing transaction...")

            # Post to transaction service
            tx_service.post_transaction(safe_tx)

            return SafeExecutionResult(
                success=True,
                tx_hash=None,
                message=(
                    f"✅ Transaction proposed to Safe!\n"
                    f"   Safe requires {threshold} signatures.\n"
                    f"   Other owners need to sign at: https://app.safe.global/transactions/queue?safe={safe_address}"
                ),
            )

    except Exception as e:
        return SafeExecutionResult(
            success=False,
            tx_hash=None,
            message=f"❌ Safe transaction failed: {e}",
        )


def encode_certify_website_call(
    url: str,
    content_hash: str,
    description: str,
) -> bytes:
    """Encode the certifyWebsite function call.

    Returns the calldata bytes for calling:
    certifyWebsite(string url, bytes32 contentHash, string description)
    """
    # Function signature: certifyWebsite(string,bytes32,string)

    # Create Web3 instance (doesn't need a provider for encoding)
    w3 = Web3()

    # Encode the function call
    # The content_hash should already be a hex string starting with 0x
    content_hash_bytes = (
        bytes.fromhex(content_hash[2:])
        if content_hash.startswith("0x")
        else bytes.fromhex(content_hash)
    )

    # Build the contract interface
    contract_abi = [
        {
            "inputs": [
                {"internalType": "string", "name": "url", "type": "string"},
                {"internalType": "bytes32", "name": "contentHash", "type": "bytes32"},
                {"internalType": "string", "name": "description", "type": "string"},
            ],
            "name": "certifyWebsite",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function",
        }
    ]

    # Create contract instance (address doesn't matter for encoding)
    contract = w3.eth.contract(
        address=Web3.to_checksum_address("0x0000000000000000000000000000000000000000"),
        abi=contract_abi,
    )

    # Encode the function call
    calldata = contract.encode_abi(
        "certifyWebsite",
        args=[url, content_hash_bytes, description],
    )

    return bytes.fromhex(calldata[2:])  # Remove 0x prefix and convert to bytes

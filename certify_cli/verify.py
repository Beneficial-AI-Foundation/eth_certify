"""Verification of on-chain certifications."""

import re
from dataclasses import dataclass
from datetime import datetime
from typing import Optional

from .config import CertifyConfig, OnChainCertification
from .foundry import (
    cast_block_number,
    cast_keccak,
    cast_logs,
    cast_to_dec,
    compute_content_hash,
)


# Certified event signature (v2 contract)
# Certified(bytes32 indexed identifierHash, bytes32 indexed contentHash,
#           address indexed sender, string identifier, bytes32 commitHash,
#           string description, uint8 schemaVersion, uint256 timestamp)
EVENT_SIGNATURE = "0x"  # Placeholder — computed below

def _compute_event_signature() -> str:
    """Compute keccak256 of the Certified event signature."""
    from .foundry import cast_keccak
    sig = "Certified(bytes32,bytes32,address,string,bytes32,string,uint8,uint256)"
    return cast_keccak(sig.encode())

# Lazy initialization to avoid calling cast at import time
_EVENT_SIG_CACHE: str | None = None

def _get_event_signature() -> str:
    global _EVENT_SIG_CACHE, EVENT_SIGNATURE
    if _EVENT_SIG_CACHE is None:
        _EVENT_SIG_CACHE = _compute_event_signature()
        EVENT_SIGNATURE = _EVENT_SIG_CACHE
    return _EVENT_SIG_CACHE

# Default values
DEFAULT_RPC_URL = "https://ethereum-sepolia-rpc.publicnode.com"
DEFAULT_CONTRACT_ADDRESS = "0x125721f8a45bbABC60aDbaaF102a94d9cae59238"
DEFAULT_BLOCK_LOOKBACK = 50000


@dataclass
class VerifyResult:
    """Result of a verification operation."""

    verified: bool
    url: str
    on_chain_hash: Optional[str]
    current_hash: Optional[str]
    certification: Optional[OnChainCertification]
    message: str


@dataclass
class VerifyHashResult:
    """Result of a content hash verification."""

    verified: bool
    content_hash: str
    certification: Optional[OnChainCertification]
    message: str


def verify_content(
    certify_config: CertifyConfig,
    rpc_url: Optional[str] = None,
    contract_address: Optional[str] = None,
) -> VerifyResult:
    """Verify current content against its on-chain certification."""
    source = certify_config.source
    source_type = certify_config.source_type
    rpc = rpc_url or DEFAULT_RPC_URL
    contract = contract_address or DEFAULT_CONTRACT_ADDRESS

    _print_header()
    print(f"Contract: {contract}")
    print(f"Source:   {source}")
    print(f"Type:     {source_type}")
    print(f"RPC:      {rpc}")
    print()

    # Compute source hash (used as the key for lookup)
    source_hash = cast_keccak(source)
    print(f"Source Hash: {source_hash}")
    print()

    # Query on-chain certification
    print("Fetching on-chain certifications...")
    certification = _fetch_certification(rpc, contract, source_hash)

    if not certification:
        return VerifyResult(
            verified=False,
            url=source,
            on_chain_hash=None,
            current_hash=None,
            certification=None,
            message=(
                f"❌ No certification found for this {source_type.lower()} in recent blocks\n"
                "   Try expanding the block range or check if the content was certified"
            ),
        )

    _print_certification(certification)

    # Fetch and hash current content
    print("═" * 67)
    print("                     CURRENT CONTENT CHECK")
    print("═" * 67)
    print(f"Reading {source} ...")

    current_hash = compute_content_hash(source)
    print(f"Current Hash: {current_hash}")
    print()

    # Compare hashes
    print("═" * 67)
    print("                       VERIFICATION RESULT")
    print("═" * 67)

    if current_hash == certification.content_hash:
        return VerifyResult(
            verified=True,
            url=source,
            on_chain_hash=certification.content_hash,
            current_hash=current_hash,
            certification=certification,
            message=(
                "\n  ✅ VERIFIED - Content matches on-chain certification!\n\n"
                "  The content has not changed since it was certified.\n"
            ),
        )

    return VerifyResult(
        verified=False,
        url=source,
        on_chain_hash=certification.content_hash,
        current_hash=current_hash,
        certification=certification,
        message=(
            "\n  ❌ MISMATCH - Content has changed since certification!\n\n"
            f"  Certified: {certification.content_hash}\n"
            f"  Current:   {current_hash}\n\n"
            "  The content has been modified since the last certification.\n"
            "  Consider re-certifying with: uv run certify-cli certify\n"
        ),
    )


def _print_header() -> None:
    """Print the verification header."""
    print("╔" + "═" * 66 + "╗")
    print("║                 CERTIFICATION VERIFIER                           ║")
    print("╚" + "═" * 66 + "╝")
    print()


def _print_certification(cert: OnChainCertification) -> None:
    """Print certification details."""
    print()
    print("═" * 67)
    print("                     ON-CHAIN CERTIFICATION")
    print("═" * 67)
    print(f"Content Hash: {cert.content_hash}")
    print(f"Certifier:    {cert.certifier_address}")

    if cert.timestamp and cert.timestamp > 0:
        try:
            dt = datetime.fromtimestamp(cert.timestamp)
            print(f"Timestamp:    {dt.strftime('%Y-%m-%d %H:%M:%S')}")
        except (ValueError, OSError):
            print(f"Timestamp:    {cert.timestamp}")

    print(f"Block:        {cert.block_number}")
    print(f"Transaction:  https://sepolia.etherscan.io/tx/{cert.transaction_hash}")
    print()


def _fetch_certification(
    rpc_url: str,
    contract_address: str,
    url_hash: str,
) -> Optional[OnChainCertification]:
    """Fetch the most recent certification for a URL from the blockchain."""
    current_block = cast_block_number(rpc_url)
    from_block = current_block - DEFAULT_BLOCK_LOOKBACK

    logs = cast_logs(rpc_url, contract_address, _get_event_signature(), url_hash, from_block)

    if not logs:
        return None

    return _parse_logs(logs)


def _parse_logs(logs: str) -> Optional[OnChainCertification]:
    """Parse cast logs output to extract certification data.

    Event layout (v2):
        topic[0] = event signature hash
        topic[1] = identifierHash (bytes32, indexed)
        topic[2] = contentHash   (bytes32, indexed)
        topic[3] = sender        (address, indexed, padded to 32 bytes)
        data     = ABI-encoded (string identifier, bytes32 commitHash,
                   string description, uint8 schemaVersion, uint256 timestamp)
    """
    # Extract topics
    topics_section = re.search(r"topics:\s*\[(.*?)\]", logs, re.DOTALL | re.IGNORECASE)
    if not topics_section:
        topics_section = re.search(
            r"topics:\s*\n((?:\s+0x[a-f0-9]{64}\s*\n)+)", logs, re.IGNORECASE
        )

    if not topics_section:
        return None

    topics = re.findall(r"0x[a-f0-9]{64}", topics_section.group(1), re.IGNORECASE)

    if len(topics) < 4:
        return None

    content_hash = topics[2]
    certifier_padded = topics[3]
    certifier_address = "0x" + certifier_padded[-40:]

    # Extract block number
    block_match = re.search(r"blockNumber:\s*(\d+)", logs)
    block_number = int(block_match.group(1)) if block_match else 0

    # Extract transaction hash
    tx_match = re.search(r"transactionHash:\s*(0x[a-f0-9]+)", logs, re.IGNORECASE)
    tx_hash = tx_match.group(1) if tx_match else ""

    # Extract timestamp from the ABI-encoded data.
    # The data contains dynamic types (two strings) interleaved with static types.
    # The last 32-byte word is always `timestamp` (uint256).
    timestamp: Optional[int] = None
    data_match = re.search(r"data:\s*(0x[a-f0-9]+)", logs, re.IGNORECASE)
    if data_match:
        data_hex = data_match.group(1)[2:]  # strip 0x
        if len(data_hex) >= 64:
            timestamp_hex = data_hex[-64:]  # last 32-byte word = timestamp
            try:
                timestamp = int(timestamp_hex, 16)
            except ValueError:
                pass

    return OnChainCertification(
        content_hash=content_hash,
        certifier_address=certifier_address,
        timestamp=timestamp,
        block_number=block_number,
        transaction_hash=tx_hash,
    )


def verify_by_content_hash(
    content_hash: str,
    rpc_url: Optional[str] = None,
    contract_address: Optional[str] = None,
    network: str = "sepolia",
    from_block: Optional[int] = None,
) -> VerifyHashResult:
    """Verify that a content hash exists on-chain.

    This searches for certification events by content hash (topic2),
    which is useful for independent verification when you don't know
    the original source path that was used during certification.

    Args:
        content_hash: The keccak256 hash of the content to verify
        rpc_url: RPC endpoint URL (defaults to public node for network)
        contract_address: Certify contract address
        network: Network name for Etherscan links (mainnet/sepolia)
        from_block: Starting block for search (default: current - 50000)
    """
    rpc = rpc_url or DEFAULT_RPC_URL
    contract = contract_address or DEFAULT_CONTRACT_ADDRESS

    # Normalize hash format
    if not content_hash.startswith("0x"):
        content_hash = "0x" + content_hash

    _print_header()
    print(f"Contract:     {contract}")
    print(f"Content Hash: {content_hash}")
    print(f"RPC:          {rpc}")
    print()

    # Query on-chain certification by content hash (topic2)
    print("Searching for certification by content hash...")
    certification = _fetch_certification_by_content_hash(
        rpc, contract, content_hash, from_block
    )

    if not certification:
        return VerifyHashResult(
            verified=False,
            content_hash=content_hash,
            certification=None,
            message=(
                f"❌ No certification found with content hash: {content_hash}\n\n"
                "   Possible reasons:\n"
                "   - The content was never certified\n"
                "   - The certification is older than the search window (50000 blocks)\n"
                "   - Wrong network (try mainnet vs sepolia)\n"
                "   - RPC rate limit exceeded (try --from-block with a paid RPC)\n"
                "\n"
                "   Note: Public RPCs limit queries to 50000 blocks (~7 days on Sepolia).\n"
                "   For older certifications, use a paid RPC (Alchemy, Infura) with\n"
                "   --rpc-url and --from-block options.\n"
            ),
        )

    _print_certification_for_network(certification, network)

    return VerifyHashResult(
        verified=True,
        content_hash=content_hash,
        certification=certification,
        message=(
            "\n  ✅ VERIFIED - Content hash found on-chain!\n\n"
            f"  Certifier:   {certification.certifier_address}\n"
            f"  Block:       {certification.block_number}\n"
            f"  Transaction: {certification.transaction_hash}\n"
        ),
    )


def _fetch_certification_by_content_hash(
    rpc_url: str,
    contract_address: str,
    content_hash: str,
    from_block: Optional[int] = None,
) -> Optional[OnChainCertification]:
    """Fetch certification by content hash (searches topic2)."""
    if from_block is None:
        current_block = cast_block_number(rpc_url)
        from_block = current_block - DEFAULT_BLOCK_LOOKBACK
        if from_block < 0:
            from_block = 0

    # Query with empty topic1 ("") to match any identifier hash, filter by content hash
    logs = cast_logs(
        rpc_url,
        contract_address,
        _get_event_signature(),
        "",  # Match any identifierHash
        from_block,
        content_hash,  # Filter by contentHash
    )

    if not logs:
        return None

    return _parse_logs(logs)


def _print_certification_for_network(cert: OnChainCertification, network: str) -> None:
    """Print certification details with network-specific Etherscan link."""
    print()
    print("═" * 67)
    print("                     ON-CHAIN CERTIFICATION")
    print("═" * 67)
    print(f"Content Hash: {cert.content_hash}")
    print(f"Certifier:    {cert.certifier_address}")

    if cert.timestamp and cert.timestamp > 0:
        try:
            dt = datetime.fromtimestamp(cert.timestamp)
            print(f"Timestamp:    {dt.strftime('%Y-%m-%d %H:%M:%S')}")
        except (ValueError, OSError):
            print(f"Timestamp:    {cert.timestamp}")

    print(f"Block:        {cert.block_number}")

    if network == "mainnet":
        print(f"Transaction:  https://etherscan.io/tx/{cert.transaction_hash}")
    else:
        print(f"Transaction:  https://sepolia.etherscan.io/tx/{cert.transaction_hash}")
    print()

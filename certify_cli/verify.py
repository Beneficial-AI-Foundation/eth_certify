"""Website verification against on-chain certifications."""

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


# WebsiteCertified event signature
EVENT_SIGNATURE = "0xe902b6df7966d5f61a8031b28d5925fb223a483f4f9782928884cf243abec003"

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

    logs = cast_logs(rpc_url, contract_address, EVENT_SIGNATURE, url_hash, from_block)

    if not logs:
        return None

    return _parse_logs(logs)


def _parse_logs(logs: str) -> Optional[OnChainCertification]:
    """Parse cast logs output to extract certification data."""
    # Extract all topic hashes from the logs
    # Topics appear as 0x followed by 64 hex chars, typically in a topics: [...] block
    # Find the topics section and extract all 64-char hex values from it
    topics_section = re.search(r"topics:\s*\[(.*?)\]", logs, re.DOTALL | re.IGNORECASE)
    if not topics_section:
        # Fallback: try plain format without brackets
        topics_section = re.search(r"topics:\s*\n((?:\s+0x[a-f0-9]{64}\s*\n)+)", logs, re.IGNORECASE)
    
    if not topics_section:
        return None
    
    # Extract all 64-char hex values from the topics section
    topics = re.findall(r"0x[a-f0-9]{64}", topics_section.group(1), re.IGNORECASE)

    if len(topics) < 4:
        return None

    # topics[0] = event signature
    # topics[1] = urlHash (indexed)
    # topics[2] = contentHash (indexed)
    # topics[3] = sender (indexed, padded to 32 bytes)
    content_hash = topics[2]
    certifier_padded = topics[3]
    certifier_address = "0x" + certifier_padded[-40:]

    # Extract block number
    block_match = re.search(r"blockNumber:\s*(\d+)", logs)
    block_number = int(block_match.group(1)) if block_match else 0

    # Extract transaction hash
    tx_match = re.search(r"transactionHash:\s*(0x[a-f0-9]+)", logs, re.IGNORECASE)
    tx_hash = tx_match.group(1) if tx_match else ""

    # Extract timestamp from data field
    # Timestamp is the 3rd 32-byte word in data (offset 128-192 chars after 0x)
    timestamp: Optional[int] = None
    data_match = re.search(r"data:\s*(0x[a-f0-9]+)", logs, re.IGNORECASE)
    if data_match:
        data = data_match.group(1)
        if len(data) >= 194:  # 0x + 192 hex chars (3 * 64)
            timestamp_hex = data[130:194]  # chars 130-194 (3rd word)
            try:
                timestamp = cast_to_dec("0x" + timestamp_hex)
            except Exception:
                pass

    return OnChainCertification(
        content_hash=content_hash,
        certifier_address=certifier_address,
        timestamp=timestamp,
        block_number=block_number,
        transaction_hash=tx_hash,
    )


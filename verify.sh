#!/bin/bash
set -e

# Default values
RPC_URL="${SEPOLIA_RPC_URL:-https://ethereum-sepolia-rpc.publicnode.com}"
CONTRACT_ADDRESS="${CERTIFY_ADDRESS:-0x125721f8a45bbABC60aDbaaF102a94d9cae59238}"
URL="${1:-https://beneficial-ai-foundation.github.io/dalek-lite/}"

# Load .env if present
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs) 2>/dev/null || true
    CONTRACT_ADDRESS="${CERTIFY_ADDRESS:-$CONTRACT_ADDRESS}"
fi

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║              WEBSITE CERTIFICATION VERIFIER                      ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""
echo "Contract: $CONTRACT_ADDRESS"
echo "URL:      $URL"
echo "RPC:      $RPC_URL"
echo ""

# Compute URL hash to search for
URL_HASH=$(cast keccak "$URL")
echo "URL Hash: $URL_HASH"
echo ""

# Get current block and query recent blocks
echo "Fetching on-chain certifications..."
CURRENT_BLOCK=$(cast block-number --rpc-url "$RPC_URL")
FROM_BLOCK=$((CURRENT_BLOCK - 50000))

# WebsiteCertified event signature
EVENT_SIG="0xe902b6df7966d5f61a8031b28d5925fb223a483f4f9782928884cf243abec003"

# Query logs for this URL
LOGS=$(cast logs \
    --rpc-url "$RPC_URL" \
    --from-block $FROM_BLOCK \
    --address "$CONTRACT_ADDRESS" \
    "$EVENT_SIG" \
    "$URL_HASH" 2>/dev/null || echo "")

if [ -z "$LOGS" ]; then
    echo "❌ No certification found for this URL in recent blocks"
    echo "   Try expanding the block range or check if the URL was certified"
    exit 1
fi

# Extract topics from the event
# topics[0] = event signature
# topics[1] = urlHash (indexed)
# topics[2] = contentHash (indexed) 
# topics[3] = sender (indexed)
CONTENT_HASH=$(echo "$LOGS" | grep -A10 "topics:" | grep -E "^\s+0x[a-f0-9]{64}$" | sed -n '3p' | tr -d '[:space:]')
CERTIFIER=$(echo "$LOGS" | grep -A10 "topics:" | grep -E "^\s+0x[a-f0-9]{64}$" | sed -n '4p' | tr -d '[:space:]')
BLOCK_NUM=$(echo "$LOGS" | grep "blockNumber:" | tail -1 | awk '{print $2}')
TX_HASH=$(echo "$LOGS" | grep "transactionHash:" | tail -1 | awk '{print $2}')

# Extract timestamp from data field
DATA=$(echo "$LOGS" | grep "data:" | tail -1 | awk '{print $2}')
# Timestamp is the 3rd 32-byte word in data (offset 128-192 chars, or 64-96 bytes)
TIMESTAMP_HEX=$(echo "$DATA" | cut -c131-194)
TIMESTAMP=$(cast to-dec "0x$TIMESTAMP_HEX" 2>/dev/null || echo "unknown")

echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "                     ON-CHAIN CERTIFICATION"
echo "═══════════════════════════════════════════════════════════════════"
echo "Content Hash: $CONTENT_HASH"
# Extract actual address from padded topic (last 40 chars + 0x prefix)
CERTIFIER_ADDR="0x${CERTIFIER: -40}"
echo "Certifier:    $CERTIFIER_ADDR"
if [ "$TIMESTAMP" != "unknown" ] && [ "$TIMESTAMP" -gt 0 ] 2>/dev/null; then
    echo "Timestamp:    $(date -d @$TIMESTAMP 2>/dev/null || date -r $TIMESTAMP 2>/dev/null || echo $TIMESTAMP)"
fi
echo "Block:        $BLOCK_NUM"
echo "Transaction:  https://sepolia.etherscan.io/tx/$TX_HASH"
echo ""

# Fetch current website content and compute hash
echo "═══════════════════════════════════════════════════════════════════"
echo "                     LIVE WEBSITE CHECK"
echo "═══════════════════════════════════════════════════════════════════"
echo "Fetching $URL ..."
FRESH_HASH=$(curl -s "$URL" | cast keccak)
echo "Current Hash: $FRESH_HASH"
echo ""

# Compare
echo "═══════════════════════════════════════════════════════════════════"
echo "                       VERIFICATION RESULT"
echo "═══════════════════════════════════════════════════════════════════"
if [ "$FRESH_HASH" = "$CONTENT_HASH" ]; then
    echo ""
    echo "  ✅ VERIFIED - Content matches on-chain certification!"
    echo ""
    echo "  The website content has not changed since it was certified."
    echo ""
    exit 0
else
    echo ""
    echo "  ❌ MISMATCH - Content has changed since certification!"
    echo ""
    echo "  Certified: $CONTENT_HASH"
    echo "  Current:   $FRESH_HASH"
    echo ""
    echo "  The website has been updated since the last certification."
    echo "  Consider re-certifying with: ./deploy.sh sepolia certify"
    echo ""
    exit 1
fi


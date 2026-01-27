#!/bin/bash
# Update certification badge JSON for shields.io endpoint badge
#
# Usage: ./update-badge.sh <verified_count> <total_count> <output_file> [etherscan_url]
#
# Example:
#   ./update-badge.sh 42 50 docs/certification-badge.json "https://etherscan.io/tx/0x..."

set -e

VERIFIED=${1:?Usage: update-badge.sh <verified> <total> <output_file> [etherscan_url]}
TOTAL=${2:?Usage: update-badge.sh <verified> <total> <output_file> [etherscan_url]}
OUTPUT_FILE=${3:?Usage: update-badge.sh <verified> <total> <output_file> [etherscan_url]}
ETHERSCAN_URL=${4:-""}

# Determine color based on verification percentage
PERCENT=$((VERIFIED * 100 / TOTAL))
if [ "$PERCENT" -ge 90 ]; then
  COLOR="brightgreen"
elif [ "$PERCENT" -ge 70 ]; then
  COLOR="green"
elif [ "$PERCENT" -ge 50 ]; then
  COLOR="yellow"
else
  COLOR="orange"
fi

# Create badge JSON
mkdir -p "$(dirname "$OUTPUT_FILE")"

cat > "$OUTPUT_FILE" << EOF
{
  "schemaVersion": 1,
  "label": "BAIF Certified",
  "message": "${VERIFIED}/${TOTAL} verified",
  "color": "${COLOR}",
  "namedLogo": "ethereum",
  "logoColor": "white"
}
EOF

echo "Badge updated: ${VERIFIED}/${TOTAL} verified (${PERCENT}%) - ${COLOR}"
echo "Output: $OUTPUT_FILE"

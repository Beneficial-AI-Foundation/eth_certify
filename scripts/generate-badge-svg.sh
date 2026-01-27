#!/bin/bash
# Generate a custom SVG badge for BAIF certification

VERIFIED="${1:-0}"
TOTAL="${2:-0}"
OUTPUT_FILE="${3:-badge.svg}"

# Calculate percentage and color
if [ "$TOTAL" -gt 0 ]; then
  PERCENT=$((VERIFIED * 100 / TOTAL))
else
  PERCENT=0
fi

if [ "$PERCENT" -eq 100 ]; then
  BG_COLOR="#2ea44f"  # GitHub green
elif [ "$PERCENT" -ge 50 ]; then
  BG_COLOR="#dbab09"  # Yellow
else
  BG_COLOR="#cb2431"  # Red
fi

# Calculate widths
LABEL_WIDTH=95
MESSAGE_WIDTH=85
TOTAL_WIDTH=$((LABEL_WIDTH + MESSAGE_WIDTH))

# Checkmark for 100%
if [ "$PERCENT" -eq 100 ]; then
  CHECKMARK='<g transform="translate(162, 8)"><circle cx="5" cy="5" r="5" fill="#fff" fill-opacity="0.3"/><path d="M2 5l2 2 4-4" stroke="#fff" stroke-width="1.5" fill="none"/></g>'
else
  CHECKMARK=""
fi

cat > "$OUTPUT_FILE" << EOF
<svg xmlns="http://www.w3.org/2000/svg" width="${TOTAL_WIDTH}" height="28" role="img" aria-label="BAIF Certified: ${VERIFIED}/${TOTAL} verified">
  <title>BAIF Certified: ${VERIFIED}/${TOTAL} verified</title>
  <defs>
    <linearGradient id="bg" x2="0" y2="100%">
      <stop offset="0" stop-color="#555" stop-opacity=".1"/>
      <stop offset="1" stop-opacity=".1"/>
    </linearGradient>
    <clipPath id="r">
      <rect width="${TOTAL_WIDTH}" height="28" rx="6" fill="#fff"/>
    </clipPath>
  </defs>
  <g clip-path="url(#r)">
    <rect width="${LABEL_WIDTH}" height="28" fill="#333"/>
    <rect x="${LABEL_WIDTH}" width="${MESSAGE_WIDTH}" height="28" fill="${BG_COLOR}"/>
    <rect width="${TOTAL_WIDTH}" height="28" fill="url(#bg)"/>
  </g>
  <g fill="#fff" text-anchor="middle" font-family="Verdana,Geneva,DejaVu Sans,sans-serif" font-size="11" font-weight="bold">
    <g transform="translate(8, 5) scale(0.043)">
      <path fill="#fff" fill-opacity="0.9" d="M127.961 0l-2.795 9.5v275.668l2.795 2.79 127.962-75.638z"/>
      <path fill="#fff" fill-opacity="0.7" d="M127.962 0L0 212.32l127.962 75.639V154.158z"/>
      <path fill="#fff" fill-opacity="0.9" d="M127.961 312.187l-1.575 1.92v98.199l1.575 4.601L256 236.587z"/>
      <path fill="#fff" fill-opacity="0.7" d="M127.962 416.905v-104.72L0 236.585z"/>
    </g>
    <text x="55" y="18" fill="#fff">BAIF Certified</text>
    <text x="137" y="18" fill="#fff">${VERIFIED}/${TOTAL} verified</text>
  </g>
  ${CHECKMARK}
</svg>
EOF

echo "Generated badge: $OUTPUT_FILE"

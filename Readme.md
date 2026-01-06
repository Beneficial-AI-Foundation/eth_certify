# Certify

On-chain certification of content hashes using Ethereum. Prove that website content existed at a specific point in time.

## Features

- **Hash Certification** - Certify any keccak256 hash on-chain
- **Website Certification** - Certify website URLs with their content hash
- **Verification Progress** - Track formal verification progress for projects like [Dalek-Lite](https://beneficial-ai-foundation.github.io/dalek-lite/)
- **Verification Script** - Verify that current website content matches on-chain certification

## Deployed Contract

| Network | Address | Explorer |
|---------|---------|----------|
| Sepolia | `0x125721f8a45bbABC60aDbaaF102a94d9cae59238` | [View on Etherscan](https://sepolia.etherscan.io/address/0x125721f8a45bbABC60aDbaaF102a94d9cae59238) |

## Quick Start

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
- A wallet with Sepolia ETH ([get some here](https://cloud.google.com/application/web3/faucet/ethereum/sepolia))

### Setup

```bash
# Clone the repo
git clone <repo-url>
cd certify

# Install dependencies
forge install

# Create your .env file
cp .env.example .env
# Edit .env with your private key
```

### Deploy Your Own Contract

```bash
./deploy.sh sepolia deploy
```

Copy the deployed address and add it to `.env` as `CERTIFY_ADDRESS`.

### Certify a Website

```bash
./deploy.sh sepolia certify
```

This will:
1. Fetch the current HTML content from https://beneficial-ai-foundation.github.io/dalek-lite/
2. Compute its keccak256 hash
3. Store the certification on-chain with timestamp

### Verify a Certification

```bash
./verify.sh
```

This compares the current website content hash with the on-chain certified hash.

Example output:
```
╔══════════════════════════════════════════════════════════════════╗
║              WEBSITE CERTIFICATION VERIFIER                      ║
╚══════════════════════════════════════════════════════════════════╝

Contract: 0x125721f8a45bbABC60aDbaaF102a94d9cae59238
URL:      https://beneficial-ai-foundation.github.io/dalek-lite/

═══════════════════════════════════════════════════════════════════
                     VERIFICATION RESULT
═══════════════════════════════════════════════════════════════════

  ✅ VERIFIED - Content matches on-chain certification!
```

## Contract API

### Events

```solidity
event Certified(bytes32 indexed hash, address indexed sender, uint256 timestamp);

event WebsiteCertified(
    bytes32 indexed urlHash,
    bytes32 indexed contentHash,
    address indexed sender,
    string url,
    string description,
    uint256 timestamp
);

event VerificationProgressCertified(
    bytes32 indexed projectHash,
    address indexed sender,
    string projectUrl,
    string gitCommit,
    uint256 totalFunctions,
    uint256 functionsWithSpecs,
    uint256 fullyVerified,
    uint256 timestamp
);
```

### Functions

| Function | Description |
|----------|-------------|
| `certify(bytes32 hash)` | Certify a single hash |
| `certifyBatch(bytes32[] hashes)` | Certify multiple hashes in one tx |
| `certifyWebsite(string url, bytes32 contentHash, string description)` | Certify a website with content hash |
| `certifyVerificationProgress(...)` | Certify formal verification metrics |
| `hashUrl(string url)` | Compute keccak256 of a URL |
| `hashContent(bytes content)` | Compute keccak256 of content |

## Manual Usage

### Certify a simple hash

```bash
# Hash some content
HASH=$(echo -n "hello world" | cast keccak)

# Certify it
cast send $CERTIFY_ADDRESS \
  "certify(bytes32)" \
  $HASH \
  --rpc-url https://ethereum-sepolia-rpc.publicnode.com \
  --private-key $PRIVATE_KEY
```

### Certify a website manually

```bash
# Get content hash
CONTENT_HASH=$(curl -s "https://example.com" | cast keccak)

# Certify
cast send $CERTIFY_ADDRESS \
  "certifyWebsite(string,bytes32,string)" \
  "https://example.com" \
  $CONTENT_HASH \
  "My website certification" \
  --rpc-url https://ethereum-sepolia-rpc.publicnode.com \
  --private-key $PRIVATE_KEY
```

### Query certification events

```bash
cast logs \
  --rpc-url https://ethereum-sepolia-rpc.publicnode.com \
  --from-block $(($(cast block-number --rpc-url https://ethereum-sepolia-rpc.publicnode.com) - 10000)) \
  --address 0x125721f8a45bbABC60aDbaaF102a94d9cae59238
```

## How Verification Works

1. **Certification**: The website HTML is fetched and hashed with keccak256. The hash is stored on-chain with the URL, timestamp, and certifier address.

2. **Verification**: Anyone can later:
   - Fetch the current website content
   - Compute its keccak256 hash
   - Compare with the on-chain hash
   - If they match → content is unchanged since certification

3. **Trust Model**: The certification proves:
   - The content existed at the certified timestamp
   - It was certified by a specific Ethereum address
   - The content hash is immutably recorded on-chain

## Development

```bash
# Build
forge build

# Test
forge test -vvv

# Format
forge fmt
```

## License

MIT

---

Generated by Claude Opus 4.5
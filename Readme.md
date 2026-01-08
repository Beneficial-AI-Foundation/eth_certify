# Certify

On-chain certification of content hashes using Ethereum. Prove that website content existed at a specific point in time.

## Features

- **Hash Certification** - Certify any keccak256 hash on-chain
- **Website Certification** - Certify website URLs with their content hash
- **Verification Progress** - Track formal verification progress for projects like [Dalek-Lite](https://beneficial-ai-foundation.github.io/dalek-lite/)
- **Verification Script** - Verify that current website content matches on-chain certification
- **Team Support** - Use Gnosis Safe for team certifications from a single address

## Deployed Contract

| Network | Address | Explorer |
|---------|---------|----------|
| Sepolia | `0x125721f8a45bbABC60aDbaaF102a94d9cae59238` | [View on Etherscan](https://sepolia.etherscan.io/address/0x125721f8a45bbABC60aDbaaF102a94d9cae59238) |

## Quick Start

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
- [uv](https://docs.astral.sh/uv/getting-started/installation/) installed
- A wallet with Sepolia ETH ([get some here](https://cloud.google.com/application/web3/faucet/ethereum/sepolia))

### Setup

```bash
# Clone the repo
git clone <repo-url>
cd certify

# Install Foundry dependencies
forge install

# Install Python dependencies
uv sync

# Create your .env file
cp .env.example .env
# Edit .env with your private key and RPC URL
```

### Configuration

Edit `certify.conf` to set the content source and description:

```bash
# Content Certification Configuration
# Source can be a URL or local file path
CERTIFY_SOURCE="https://beneficial-ai-foundation.github.io/dalek-lite/"
CERTIFY_DESCRIPTION="Dalek-Lite Verification Progress - Formally verifying curve25519-dalek with Verus"
```

You can also certify local files:

```bash
CERTIFY_SOURCE="./data/config.json"
CERTIFY_DESCRIPTION="Configuration file v1.2.0"
```

Or GitHub workflow artifacts:

```bash
# Single-file artifact
CERTIFY_SOURCE="github://owner/repo/artifacts/123456789"

# Multi-file artifact (specify which file)
CERTIFY_SOURCE="github://owner/repo/artifacts/123456789/results.json"
CERTIFY_DESCRIPTION="CI verification results"
```

For GitHub artifacts, set the `GITHUB_TOKEN` environment variable (required for private repos):

```bash
export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"
```

### Deploy Your Own Contract

```bash
uv run certify-cli deploy --network sepolia
```

Copy the deployed address and add it to `.env` as `CERTIFY_ADDRESS`.

### Certify Content

```bash
uv run certify-cli certify --network sepolia
```

This will:
1. Fetch content from the source in `certify.conf` (URL or local file)
2. Compute its keccak256 hash
3. Store the certification on-chain with timestamp

### Verify a Certification

```bash
uv run certify-cli verify
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

## CLI Reference

```bash
# Deploy contract
uv run certify-cli deploy --network sepolia
uv run certify-cli deploy --network anvil

# Certify website (reads URL from certify.conf)
uv run certify-cli certify --network sepolia

# Verify certification
uv run certify-cli verify
uv run certify-cli verify --rpc-url https://custom-rpc.com
uv run certify-cli verify --contract 0x...

# Show help
uv run certify-cli --help
uv run certify-cli deploy --help
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

## GitHub Actions Integration

The CLI can be used in GitHub Actions workflows. Environment variables take priority over config files, making it easy to use with GitHub secrets.

### Required Secrets

| Secret | Description |
|--------|-------------|
| `PRIVATE_KEY` | Ethereum private key for signing transactions |
| `SEPOLIA_RPC_URL` | RPC endpoint (Infura, Alchemy, etc.) |
| `CERTIFY_ADDRESS` | Deployed Certify contract address |

### Optional Secrets

| Secret | Description |
|--------|-------------|
| `ETHERSCAN_API_KEY` | For contract verification on deploy |
| `GITHUB_TOKEN` | Auto-provided, for accessing artifacts |

### Example Workflow

```yaml
name: Certify Content

on:
  workflow_dispatch:
    inputs:
      source:
        description: 'URL or file to certify'
        required: true

jobs:
  certify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          repository: beneficial-ai-foundation/certify
          path: certify

      - uses: astral-sh/setup-uv@v4
      - uses: foundry-rs/foundry-toolchain@v1

      - name: Install and run
        working-directory: certify
        env:
          PRIVATE_KEY: ${{ secrets.PRIVATE_KEY }}
          SEPOLIA_RPC_URL: ${{ secrets.SEPOLIA_RPC_URL }}
          CERTIFY_ADDRESS: ${{ secrets.CERTIFY_ADDRESS }}
          CERTIFY_SOURCE: ${{ inputs.source }}
          CERTIFY_DESCRIPTION: "Certified via GitHub Actions"
        run: |
          uv sync
          uv run certify-cli certify --network sepolia
```

See `.github/workflows/certify.yml.example` for a complete example.

## Development

```bash
# Build Solidity contracts
forge build

# Test contracts
forge test -vvv

# Format Solidity
forge fmt

# Run Python linting
uv run ruff check certify_cli/

# Run type checking
uv run mypy certify_cli/
```

## Project Structure

```
certify/
├── certify_cli/           # Python CLI package
│   ├── __init__.py
│   ├── __main__.py        # CLI entry point
│   ├── config.py          # Configuration dataclasses
│   ├── deploy.py          # Deploy & certify commands
│   ├── foundry.py         # Forge/cast wrappers
│   └── verify.py          # Verification logic
├── script/                # Foundry deploy scripts
│   └── Certify.s.sol
├── src/                   # Solidity contracts
│   └── Certify.sol
├── test/                  # Contract tests
│   └── Certify.t.sol
├── .github/workflows/     # Example GitHub Actions
├── certify.conf           # Content source configuration
├── pyproject.toml         # Python project config
└── foundry.toml           # Foundry config
```

## Environment Variables

All configuration can be set via environment variables (for CI/CD) or config files (for local dev).

| Variable | File | Description |
|----------|------|-------------|
| `PRIVATE_KEY` | `.env` | Ethereum private key |
| `SEPOLIA_RPC_URL` | `.env` | Sepolia RPC endpoint |
| `CERTIFY_ADDRESS` | `.env` | Deployed contract address |
| `ETHERSCAN_API_KEY` | `.env` | Etherscan API key (optional) |
| `CERTIFY_SOURCE` | `certify.conf` | URL, file path, or `github://` artifact |
| `CERTIFY_DESCRIPTION` | `certify.conf` | Certification description |
| `GITHUB_TOKEN` | (env only) | For GitHub artifact access |

**Priority:** Environment variables override config file values.

## License

MIT

---

_Generated by Claude Opus 4.5_

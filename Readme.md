# Certify

On-chain certification of content hashes using Ethereum. Prove that content existed at a specific point in time.

## Deployed Contracts

| Network | Address | Explorer |
|---------|---------|----------|
| **Mainnet** | `0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c` | [Etherscan](https://etherscan.io/address/0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c) |
| Sepolia | `0x125721f8a45bbABC60aDbaaF102a94d9cae59238` | [Etherscan](https://sepolia.etherscan.io/address/0x125721f8a45bbABC60aDbaaF102a94d9cae59238) |

## Quick Start

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [uv](https://docs.astral.sh/uv/getting-started/installation/)
- Wallet with ETH (testnet or mainnet)

### Setup

```bash
git clone <repo-url> && cd certify
forge install
uv sync
cp .env.example .env  # Edit with your keys
```

### Certify Content

```bash
# Edit certify.conf with your URL/file
uv run python3 -m certify_cli certify --network sepolia
```

### Verify a Certification

```bash
uv run python3 -m certify_cli verify
```

## CLI Commands

```bash
# Deploy contract
uv run python3 -m certify_cli deploy --network mainnet

# Certify (EOA)
uv run python3 -m certify_cli certify --network mainnet

# Certify via Gnosis Safe
uv run python3 -m certify_cli certify --network mainnet --safe 0x... --execute

# Verify
uv run python3 -m certify_cli verify --rpc-url https://... --contract 0x...
```

## Configuration

**`.env`** — Secrets (private keys, RPC URLs)
```bash
MAINNET_RPC_URL="https://ethereum-rpc.publicnode.com"
MAINNET_PRIVATE_KEY="0x..."
SEPOLIA_RPC_URL="https://ethereum-sepolia-rpc.publicnode.com"
SEPOLIA_PRIVATE_KEY="0x..."
CERTIFY_ADDRESS="0x..."
```

**`certify.conf`** — What to certify
```bash
CERTIFY_SOURCE="https://example.com"
CERTIFY_DESCRIPTION="My certification"
```

## Documentation

| Topic | Document |
|-------|----------|
| Trust model & address roles | [doc/trust_model.md](doc/trust_model.md) |
| Mainnet deployment guide | [doc/mainnet_deployment.md](doc/mainnet_deployment.md) |
| Gnosis Safe integration | [doc/safe_integration.md](doc/safe_integration.md) |

## Contract API

```solidity
// Certify content
certifyWebsite(string url, bytes32 contentHash, string description)

// Query
hashUrl(string url) → bytes32
hashContent(bytes content) → bytes32
```

Events: `Certified`, `WebsiteCertified`, `VerificationProgressCertified`

## Development

```bash
forge build      # Build contracts
forge test -vvv  # Run tests
uv run ruff check certify_cli/  # Lint Python
```

## License

MIT

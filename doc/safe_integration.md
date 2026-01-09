# Gnosis Safe Integration

This document describes the changes made to support programmatic certification via Gnosis Safe, enabling automated certifications from GitHub Actions workflows.

## Overview

The CLI now supports certifying content through a Gnosis Safe wallet, allowing:
- **Team-based certifications** from a single Safe address
- **Programmatic execution** for CI/CD pipelines
- **Audit trail** of which team member initiated each certification

## New Dependencies

Added to `pyproject.toml`:

```toml
dependencies = [
    "httpx>=0.27.0",
    "safe-eth-py>=6.0.0",
    "web3>=6.0.0",
]
```

## New Files

### `certify_cli/safe.py`

New module for Gnosis Safe integration:

- **`execute_safe_transaction()`** - Executes a transaction through a Safe
  - Creates and signs a Safe transaction
  - For 1-of-N Safes (threshold=1), executes directly on-chain
  - For multi-sig Safes, proposes to the Safe Transaction Service

- **`encode_certify_website_call()`** - Encodes the `certifyWebsite` function call as bytes

## CLI Changes

### New Arguments

```bash
certify --safe ADDRESS       # Gnosis Safe address
certify --safe ADDRESS --execute  # Execute programmatically
```

### Behavior

| Command | Result |
|---------|--------|
| `certify --network mainnet` | Direct EOA certification |
| `certify --network mainnet --safe 0x...` | Generates transaction data for Safe UI |
| `certify --network mainnet --safe 0x... --execute` | Programmatic Safe execution |

## Usage Examples

### Generate Instructions for Safe UI

```bash
uv run python3 -m certify_cli certify \
  --network mainnet \
  --safe 0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e
```

Output includes:
- Transaction calldata
- Step-by-step instructions for the Safe Transaction Builder
- Direct link to Safe UI

### Programmatic Execution

```bash
uv run python3 -m certify_cli certify \
  --network mainnet \
  --safe 0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e \
  --execute
```

This:
1. Fetches content and computes hash
2. Encodes the `certifyWebsite` call
3. Creates a Safe transaction
4. Signs with the owner's private key (from `.env`)
5. Executes on-chain (for 1-of-N Safes)

## GitHub Actions Integration

### Required Secrets

| Secret | Description |
|--------|-------------|
| `MAINNET_RPC_URL` | Ethereum mainnet RPC endpoint |
| `MAINNET_PRIVATE_KEY` | Private key of a Safe owner |

### Example Workflow

```yaml
name: Certify Content

on:
  push:
    branches: [main]
    paths:
      - 'docs/**'  # Trigger when docs change

jobs:
  certify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install uv
        uses: astral-sh/setup-uv@v4
      
      - name: Install Foundry
        uses: foundry-rs/foundry-toolchain@v1
      
      - name: Certify content
        env:
          MAINNET_RPC_URL: ${{ secrets.MAINNET_RPC_URL }}
          MAINNET_PRIVATE_KEY: ${{ secrets.MAINNET_PRIVATE_KEY }}
          CERTIFY_ADDRESS: "0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c"
          CERTIFY_SOURCE: "https://beneficial-ai-foundation.github.io/dalek-lite/"
          CERTIFY_DESCRIPTION: "Dalek-Lite Verification Progress"
        run: |
          uv run python3 -m certify_cli certify \
            --network mainnet \
            --safe 0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e \
            --execute
```

## How It Works

### Transaction Flow

```
┌─────────────────────────────────────────────────────────────┐
│                     GitHub Actions                          │
├─────────────────────────────────────────────────────────────┤
│  1. Fetch content from URL                                  │
│  2. Compute keccak256 hash                                  │
│  3. Encode certifyWebsite(url, hash, description)           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    safe-eth-py SDK                          │
├─────────────────────────────────────────────────────────────┤
│  4. Build Safe transaction                                  │
│  5. Sign with owner's private key                           │
│  6. Execute on-chain (threshold=1)                          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Ethereum Mainnet                         │
├─────────────────────────────────────────────────────────────┤
│  7. Safe executes call to Certify contract                  │
│  8. WebsiteCertified event emitted                          │
│  9. Certification recorded on-chain                         │
└─────────────────────────────────────────────────────────────┘
```

### Security Model

- **Private key required**: The `MAINNET_PRIVATE_KEY` must belong to a Safe owner
- **Threshold=1**: For automated execution, the Safe must allow single-signer execution
- **GitHub Secrets**: Private keys are stored securely in GitHub Secrets, never in code

### Multi-Signature Safes

For Safes with threshold > 1:
- The CLI will **propose** the transaction to the Safe Transaction Service
- Other owners must sign via the Safe UI
- Transaction executes when threshold is met

## Deployed Addresses

| Component | Address | Network |
|-----------|---------|---------|
| Certify Contract | `0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c` | Mainnet |
| BAIF Safe | `0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e` | Mainnet |
| Safe Owner | `0xA8A1F614F4b86A7F7AA0F498C3a72aBbD51067d3` | Mainnet |

## Example Transaction

The first mainnet certification via Safe:

- **Transaction**: [0x09f0ee375bc3801b89f75e0663b1962d08d488e3d38f308e2d4488fbc9178ffc](https://etherscan.io/tx/0x09f0ee375bc3801b89f75e0663b1962d08d488e3d38f308e2d4488fbc9178ffc)
- **Block**: 24196278
- **URL**: `https://beneficial-ai-foundation.github.io/dalek-lite/`
- **Content Hash**: `0x545a9a795ee534ae61ecf4f72ad2202e823650931a0d1771d15f0b74c9103d06`


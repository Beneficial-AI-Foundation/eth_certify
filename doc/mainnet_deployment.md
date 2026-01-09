# Deploying Certify to Ethereum Mainnet

This document describes the steps to deploy the Certify contract to Ethereum mainnet using a Gnosis Safe for team certifications.

## Overview

| Component | Address |
|-----------|---------|
| Certify Contract | `0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c` |
| Safe Wallet | `0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e` |
| Deployer (Safe Owner) | `0xA8A1F614F4b86A7F7AA0F498C3a72aBbD51067d3` |

## Prerequisites

- **MetaMask wallet** with ETH for gas (~$1-5)
- **Gnosis Safe** created at [app.safe.global](https://app.safe.global/)
- **Foundry** installed (`curl -L https://foundry.paradigm.xyz | bash`)

## Step 1: Create a Gnosis Safe

1. Go to [app.safe.global](https://app.safe.global/)
2. Select **Ethereum Mainnet** as the network
3. Connect your MetaMask wallet
4. Create a new Safe with your wallet as an owner
5. Set threshold to **1-of-N** for immediate execution
6. Save the Safe address

## Step 2: Configure Environment

Create a `.env` file in the project root:

```bash
# RPC URLs
MAINNET_RPC_URL="https://ethereum-rpc.publicnode.com"
SEPOLIA_RPC_URL="https://ethereum-sepolia-rpc.publicnode.com"

# Network-specific private keys
MAINNET_PRIVATE_KEY="0x..."   # MetaMask wallet (Safe owner)
SEPOLIA_PRIVATE_KEY="0x..."   # Testnet wallet

# Etherscan API key (for contract verification)
ETHERSCAN_API_KEY="..."

# Contract address (set after deployment)
CERTIFY_ADDRESS="0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c"
```

### Exporting Private Key from MetaMask

1. Open the MetaMask browser extension
2. Click the three dots (⋮) → **Account details**
3. Click **Show private key**
4. Enter your password and copy the key
5. Add `0x` prefix when saving to `.env`

## Step 3: Deploy the Contract

```bash
uv run python3 -m certify_cli deploy --network mainnet
```

Output:
```
Deploying Certify contract to mainnet...
...
Contract Address: 0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c
...
ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
```

**Cost**: ~0.00003 ETH (~$0.10 at time of deployment)

## Step 4: Verify on Etherscan (Optional)

1. Get a free API key at [etherscan.io/myapikey](https://etherscan.io/myapikey)
2. Run:

```bash
forge verify-contract \
  0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c \
  src/Certify.sol:Certify \
  --chain mainnet \
  --etherscan-api-key "your-api-key"
```

This makes the contract source code publicly visible on Etherscan.

## Step 5: Certify Content via Safe

1. Go to your Safe at [app.safe.global](https://app.safe.global/)
2. Ensure you're on **Ethereum Mainnet**
3. Click **New Transaction** → **Transaction Builder**
4. Enter contract address: `0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c`
5. Enter the ABI or use custom data to call:
   - Function: `certifyWebsite(string,bytes32,string)`
   - URL: The content URL to certify
   - Content Hash: `curl -s "<url>" | cast keccak`
   - Description: Human-readable description
6. Sign and execute the transaction

## Trust Model

The deployment establishes a clear trust chain:

```
MetaMask EOA (0xA8A1...67d3)
    │
    ├── Owns → Safe (0x8EAb...ef0e)
    │
    └── Deployed → Certify Contract (0x4f2a...83c)
                        │
                        └── Receives certifications from Safe
```

Anyone can verify on-chain that:
- The Safe's owner deployed the contract
- All certifications come from the Safe address
- The Safe provides an audit trail of which team member initiated each certification

## Links

- **Contract on Etherscan**: [0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c](https://etherscan.io/address/0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c)
- **Safe on Etherscan**: [0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e](https://etherscan.io/address/0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e)
- **Deploy Transaction**: [0xe3887c5d...](https://etherscan.io/tx/0xe3887c5dfcf3baf830fad556ed177f540fa07574bdf65b0a02fc5093fad907f8)


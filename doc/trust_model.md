# Trust Model

This document explains the relationship between addresses in the Certify system and how trust is established on-chain.

## Addresses Overview

| Role | Address | Type |
|------|---------|------|
| Contract Deployer | `0xA8A1F614F4b86A7F7AA0F498C3a72aBbD51067d3` | EOA (MetaMask) |
| Certification Sender | `0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e` | Gnosis Safe |
| Certify Contract | `0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c` | Smart Contract |

## Trust Chain

```
┌─────────────────────────────────────────────────────────────────┐
│                    MetaMask EOA                                 │
│            0xA8A1F614F4b86A7F7AA0F498C3a72aBbD51067d3           │
└─────────────────────────────────────────────────────────────────┘
                              │
                ┌─────────────┴─────────────┐
                │                           │
                ▼                           ▼
┌───────────────────────────┐   ┌───────────────────────────┐
│      Deployed Contract    │   │      Owns Safe            │
│  (one-time action)        │   │  (ongoing relationship)   │
└───────────────────────────┘   └───────────────────────────┘
                │                           │
                ▼                           ▼
┌───────────────────────────┐   ┌───────────────────────────┐
│    Certify Contract       │   │    Gnosis Safe            │
│  0x4f2a70eC878E9Adae...   │   │  0x8EAb4dB55DCEfb6D...    │
└───────────────────────────┘   └───────────────────────────┘
                                            │
                                            ▼
                              ┌───────────────────────────┐
                              │   Certification Events    │
                              │   sender = Safe address   │
                              └───────────────────────────┘
```

## Why Two Addresses?

### Contract Deployer (EOA)

The EOA `0xA8A1...` deployed the Certify contract. This is visible on Etherscan as the "Contract Creator". 

- **Permanently recorded** as the deployer
- **No special privileges** in the contract (the contract has no owner)
- **One-time action** — deployment happened once

### Certification Sender (Safe)

The Safe `0x8EAb...` sends all certification transactions. This appears in event logs as the `sender`.

- **All certifications** show this address
- **Team audit trail** — Safe UI shows which team member initiated each certification
- **Key management** — Team members can be added/removed without changing the public address

## On-Chain Verification

Anyone can verify the trust chain on Etherscan:

### 1. Verify the EOA owns the Safe

```bash
# Query Safe owners
cast call 0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e \
  "getOwners()(address[])" \
  --rpc-url https://ethereum-rpc.publicnode.com
```

This returns `[0xA8A1F614F4b86A7F7AA0F498C3a72aBbD51067d3]` — the deployer is a Safe owner.

### 2. Verify the deployer deployed the contract

On Etherscan: [Contract Creator](https://etherscan.io/address/0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c) shows `0xA8A1...`

### 3. Verify certifications come from the Safe

In any `WebsiteCertified` event, `topic[3]` is the sender:
```
0x0000000000000000000000008eab4db55dcefb6d8bf76e1c6132d48d2048ef0e
```

Removing the padding: `0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e` — the Safe.

## Why This Matters

This design provides:

1. **Single Team Identity** — All certifications come from one address (the Safe)
2. **Verifiable Ownership** — The Safe's owner deployed the contract (provable on-chain)
3. **Flexible Team Management** — Add/remove team members via Safe without changing the public identity
4. **Audit Trail** — Safe UI records which team member initiated each certification
5. **No Single Point of Failure** — Multiple team members can certify (with threshold=1)

## Event Structure

When a certification is made, the `WebsiteCertified` event contains:

```
topics[0]: 0xe902b6df... (event signature)
topics[1]: urlHash (keccak256 of the URL)
topics[2]: contentHash (keccak256 of the content)
topics[3]: sender (Safe address, padded to 32 bytes)

data: url, description, timestamp (encoded)
```

The `sender` (topic 3) is always the Safe address for team certifications.

## Links

- [Certify Contract on Etherscan](https://etherscan.io/address/0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c)
- [Safe on Etherscan](https://etherscan.io/address/0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e)
- [Safe UI](https://app.safe.global/home?safe=eth:0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e)
- [Deploy Transaction](https://etherscan.io/tx/0xe3887c5dfcf3baf830fad556ed177f540fa07574bdf65b0a02fc5093fad907f8)


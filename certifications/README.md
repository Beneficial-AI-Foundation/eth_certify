# BAIF Certifications Registry

This directory contains certification records for Verus projects verified and certified by BAIF.

## Structure

```
certifications/
├── README.md                    # This file
├── owner-repo/                  # One directory per certified project
│   ├── badge.json              # shields.io endpoint badge data
│   ├── history.json            # Certification history
│   └── README.md               # Badge instructions for the project
└── another-owner-repo/
    └── ...
```

## How to Get Your Project Certified

1. **Contact BAIF** - Request certification for your Verus project
2. **BAIF runs verification** - We verify your code using [probe-verus](https://github.com/beneficial-ai-foundation/probe-verus)
3. **Certification recorded** - The verification hash is recorded on Ethereum
4. **Add badge** - Add the BAIF Certified badge to your README

## Badge Format

After certification, add this to your project's README:

```markdown
[![BAIF Certified](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/beneficial-ai-foundation/certify/main/certifications/YOUR-PROJECT-ID/badge.json)](https://github.com/beneficial-ai-foundation/certify/blob/main/certifications/YOUR-PROJECT-ID/history.json)
```

## Verifying Certifications

Each certification is recorded on the Ethereum blockchain. You can verify:

1. **On-chain**: Check the transaction hash on Etherscan
2. **Content hash**: Recompute the hash of the verification results
3. **History**: View `history.json` for all certifications of a project

## What Does "BAIF Certified" Mean?

A BAIF Certified badge indicates:

- ✅ The project was verified using [Verus](https://github.com/verus-lang/verus) formal verification
- ✅ Verification results were recorded on Ethereum by BAIF
- ✅ The certification is cryptographically verifiable

It does NOT mean:
- ❌ BAIF endorses or audits the project's functionality
- ❌ The project is bug-free or secure
- ❌ BAIF maintains or supports the project

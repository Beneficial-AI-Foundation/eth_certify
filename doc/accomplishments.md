# BAIF Certification System - Accomplishments

<div align="center">

```
 ____    _    ___ _____    ____          _   _  __       
| __ )  / \  |_ _|  ___|  / ___|___ _ __| |_(_)/ _|_   _ 
|  _ \ / _ \  | || |_    | |   / _ \ '__| __| | |_| | | |
| |_) / ___ \ | ||  _|   | |__|  __/ |  | |_| |  _| |_| |
|____/_/   \_\___|_|      \____\___|_|   \__|_|_|  \__, |
                                                   |___/ 
```

**On-Chain Certification for Formally Verified Code**

![Ethereum](https://img.shields.io/badge/Ethereum-3C3C3D?style=flat&logo=ethereum&logoColor=white)
![Rust](https://img.shields.io/badge/Rust-000000?style=flat&logo=rust&logoColor=white)
![Verus](https://img.shields.io/badge/Verus-Formal_Verification-blue?style=flat)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat&logo=github-actions&logoColor=white)

</div>

---

This document summarizes the work completed to build a comprehensive on-chain certification system for formally verified Rust code using Verus.

## Overview

We've created a complete pipeline that:
1. **Verifies** Rust code using the Verus formal verification toolchain
2. **Certifies** verification results on Ethereum (mainnet or testnet)
3. **Displays** certification status via badges on project READMEs

---

## GitHub Actions Created

### 1. Verus Verify Action (`baif/probe-verus/action`)

**Location:** https://github.com/Beneficial-AI-Foundation/probe-verus

A reusable composite GitHub Action that runs Verus formal verification on Rust projects.

**Features:**
- Extracts Verus and Rust versions from `Cargo.toml` metadata
- Installs all required tooling (Rust, Verus, verus-analyzer, SCIP, probe-verus)
- Caches dependencies for faster subsequent runs
- Runs `probe-verus atomize` to extract verifiable functions
- Runs `probe-verus verify` to perform formal verification
- Handles both results.json formats (dictionary with verified boolean, and summary object)

**Outputs:**
- `results-file`: Path to verification results JSON
- `atoms-file`: Path to atoms JSON
- `verified-count`: Number of successfully verified functions
- `total-functions`: Total number of verifiable functions

**Usage:**
```yaml
- uses: Beneficial-AI-Foundation/probe-verus/action@v1
  with:
    project-path: '.'
    package: 'my-crate'
    output-dir: './output'
```

---

### 2. Certify Action (`baif/eth_certify/action`)

**Location:** This repository (`action/`)

A reusable composite GitHub Action that certifies content hashes on Ethereum.

**Features:**
- Hashes verification results using keccak256
- Submits certification transaction to Ethereum
- Supports both direct signing and Gnosis Safe multisig
- Works with mainnet and Sepolia testnet
- Automatic transaction execution for 1-of-N Safes

**Inputs:**
- `source`: File to certify (required)
- `description`: Description of the certification
- `network`: `mainnet` or `sepolia`
- `private-key`: Ethereum private key for signing
- `rpc-url`: Ethereum RPC endpoint
- `certify-address`: Deployed Certify contract address
- `safe-address`: Optional Gnosis Safe address
- `safe-execute`: Whether to execute Safe transaction programmatically

**Outputs:**
- `tx_hash`: Transaction hash of the certification
- `content_hash`: Keccak256 hash of the certified content

**Usage:**
```yaml
- uses: Beneficial-AI-Foundation/eth_certify/action@main
  with:
    source: './results.json'
    description: 'Verification results for my-project'
    network: mainnet
    private-key: ${{ secrets.PRIVATE_KEY }}
    rpc-url: ${{ secrets.RPC_URL }}
    certify-address: ${{ vars.CERTIFY_ADDRESS }}
    safe-address: ${{ vars.SAFE_ADDRESS }}
    safe-execute: 'true'
```

---

## Workflows Created

### 1. Certify External Project (`certify-external.yml`)

Allows BAIF to certify any external Verus project without requiring changes to that project's repository.

**Features:**
- Accepts repository URL, ref, and optional package name as inputs
- Clones the external repository
- Runs verification using the probe-verus action
- Certifies results on-chain using the certify action
- Creates/updates badge and history files in `certifications/` directory
- Supports both mainnet and Sepolia

**Trigger:** Manual dispatch with inputs

**Certification Artifacts:**
- `certifications/{project-id}/badge.json` - Shields.io compatible badge data
- `certifications/{project-id}/history.json` - Full certification history

---

### 2. Internal Project Certification (`verify-certify-badge.yml.example`)

Example workflow for projects that want to integrate certification into their own CI/CD.

**Features:**
- Runs on push to main branch (when Rust files change)
- Full verification and certification pipeline
- Updates certification badge automatically

---

### 3. Test Action Workflow (`test-action.yml`)

Tests the certify action in both local (`act`) and CI environments.

**Features:**
- Spins up local Anvil blockchain for testing
- Deploys test Certify contract
- Supports both `act` (local) and GitHub Actions (CI) modes

---

## Badge System

### Badge Examples

| Status | Badge | Description |
|--------|-------|-------------|
| 100% verified | ![BAIF Certified](https://img.shields.io/badge/BAIF_Certified-72%2F72_verified-brightgreen?style=flat&logo=ethereum&logoColor=white) | All functions formally verified |
| Partial verification | ![BAIF Certified](https://img.shields.io/badge/BAIF_Certified-45%2F72_verified-yellow?style=flat&logo=ethereum&logoColor=white) | 50-99% of functions verified |
| Low verification | ![BAIF Certified](https://img.shields.io/badge/BAIF_Certified-10%2F72_verified-red?style=flat&logo=ethereum&logoColor=white) | Less than 50% verified |

### Badge Display

Projects can display a BAIF Certified badge by adding this to their README:

```markdown
[![BAIF Certified](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/Beneficial-AI-Foundation/eth_certify/main/certifications/{project-id}/badge.json)](https://github.com/Beneficial-AI-Foundation/eth_certify/blob/main/certifications/{project-id}/history.json)
```

### Badge Colors
- 🟢 **Green** (`brightgreen`): 100% verified
- 🟡 **Yellow** (`yellow`): 50-99% verified  
- 🔴 **Red** (`red`): <50% verified

### Custom SVG vs Shields.io

We provide two badge options:

| Aspect | Custom SVG | Shields.io Endpoint |
|--------|-----------|---------------------|
| **How it works** | Pre-generated SVG file hosted in repo | External service fetches `badge.json` and renders on-the-fly |
| **URL** | `https://raw.githubusercontent.com/.../badge.svg` | `https://img.shields.io/endpoint?url=...badge.json` |
| **Speed** | ⚡ Instant (static file) | Slight delay (external API call) |
| **Dependencies** | None | Requires shields.io service |
| **Private repos** | ✅ Works (for repo members) | ❌ Cannot access private URLs |
| **Customization** | Full control over design | Limited to shields.io options |
| **Updates** | Requires regenerating SVG | Just update JSON file |

**Recommendation:**
- **Custom SVG** (default): Better performance, no external dependencies, works with private repos
- **Shields.io**: Convenient if you want dynamic styling options or don't want to regenerate SVGs

Both options are generated automatically by the certification workflow.

---

## Key Fixes & Improvements

### 1. Transaction Hash Extraction

Fixed regex to handle Gnosis Safe outputs that may or may not include the `0x` prefix:

```bash
TX_HASH=$(echo "$OUTPUT" | grep -Eo 'Tx Hash:[[:space:]]*(0x)?[a-fA-F0-9]{64}' | head -1 | sed -E 's/.*Tx Hash:[[:space:]]*(0x)?([a-fA-F0-9]{64})$/0x\\2/')
```

### 2. Results JSON Parsing

Fixed to handle both formats produced by `probe-verus verify`:

**Format 1** (with `-a atoms.json`): Dictionary keyed by function name
```json
{
  "function_name": { "verified": true, ... },
  ...
}
```

**Format 2** (without atoms): Object with summary
```json
{
  "summary": { "verified": 72, "total": 72, ... }
}
```

### 3. Cast Logs Parsing

Fixed `verify.py` to handle updated `cast logs` output format where topics appear in array format:

```
topics: [
    0x...
    0x...
]
```

### 4. Output Directory Creation

Added `mkdir -p` to ensure output directory exists before `probe-verus` writes files.

---

## Architecture

```
                    ╔═══════════════════════════════════════════╗
                    ║       🦀 External Verus Project           ║
                    ║    (e.g., pmemlog_with_callgraph)         ║
                    ╚═══════════════════════════════════════════╝
                                        │
                                        ▼
╭───────────────────────────────────────────────────────────────────────────╮
│  🔍 STEP 1: VERIFICATION                                                  │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │  probe-verus/action@v1                                              │  │
│  │  ├── Install Verus toolchain                                        │  │
│  │  ├── Run probe-verus atomize → atoms.json                           │  │
│  │  └── Run probe-verus verify  → results.json                         │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
│                                                                           │
│  📤 Outputs: results.json, verified_count=72, total_functions=72         │
╰───────────────────────────────────────────────────────────────────────────╯
                                        │
                                        ▼
╭───────────────────────────────────────────────────────────────────────────╮
│  ⛓️  STEP 2: ON-CHAIN CERTIFICATION                                       │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │  eth_certify/action@main                                             │  │
│  │  ├── Compute keccak256(results.json)                                │  │
│  │  ├── Submit to Certify.sol contract                                 │  │
│  │  └── Via Gnosis Safe multisig (optional)                            │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
│                                                                           │
│  📤 Outputs: tx_hash=0x..., content_hash=0x...                           │
╰───────────────────────────────────────────────────────────────────────────╯
                                        │
                          ┌─────────────┴─────────────┐
                          ▼                           ▼
              ┌───────────────────────┐   ┌───────────────────────┐
              │   📁 badge.json       │   │   📁 history.json     │
              │   (shields.io data)   │   │   (all certifications)│
              └───────────────────────┘   └───────────────────────┘
                          │                           │
                          └─────────────┬─────────────┘
                                        ▼
                    ╔═══════════════════════════════════════════╗
                    ║              🏷️  README Badge              ║
                    ║  ┌─────────────────────────────────────┐  ║
                    ║  │ BAIF Certified | 72/72 verified | ✓ │  ║
                    ║  └─────────────────────────────────────┘  ║
                    ╚═══════════════════════════════════════════╝
```

### Flow Summary

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Rust Code   │───▶│    Verus     │───▶│   Ethereum   │───▶│    Badge     │
│  + Proofs    │    │  Verifier    │    │  Blockchain  │    │   Display    │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
     Source           Formal Proof       Immutable Record     Public Trust
```

---

## Repository Structure

```
eth_certify/
├── action/
│   ├── action.yml          # Certify GitHub Action
│   └── README.md           # Action documentation
├── certifications/
│   ├── README.md           # Registry overview
│   └── {project-id}/       # Per-project certification data
│       ├── badge.json
│       └── history.json
├── certify_cli/            # Python CLI for certification
│   ├── __main__.py
│   ├── config.py
│   ├── deploy.py
│   ├── foundry.py
│   ├── safe.py
│   └── verify.py
├── doc/
│   ├── accomplishments.md  # This file
│   ├── badge.md            # Badge documentation
│   └── ...
├── scripts/
│   └── update-badge.sh     # Badge generation script
├── src/
│   └── Certify.sol         # Solidity contract
└── .github/workflows/
    ├── certify-external.yml           # Certify external projects
    ├── test-action.yml                # Test workflow
    └── verify-certify-badge.yml.example
```

---

## Certified Projects

| Project | Badge | Status | Blockchain |
|---------|-------|--------|------------|
| [pmemlog_with_callgraph](https://github.com/Beneficial-AI-Foundation/pmemlog_with_callgraph) | ![BAIF Certified](https://img.shields.io/badge/BAIF_Certified-72%2F72_verified-brightgreen?style=flat&logo=ethereum&logoColor=white) | 100% verified | [Etherscan](https://etherscan.io) |

---

## Next Steps

Potential future enhancements:
- [ ] Automatic re-certification on upstream changes
- [ ] Certification verification API/website
- [ ] Support for other formal verification tools (beyond Verus)
- [ ] Certification revocation mechanism
- [ ] Multi-chain support (L2s for lower gas costs)

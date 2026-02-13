# BAIF Certification System - Overview

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

> **⚠️ Proof of Concept (PoC)**
> 
> This system is a proof of concept demonstrating the feasibility of on-chain certification for formally verified code. It is functional but intended primarily for exploration and validation of the approach. 

---

This document provides a technical overview of the on-chain certification system for formally verified Rust code using Verus.

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
- `verus-version`: Verus version used for verification
- `rust-version`: Rust toolchain version used

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
- `certifications/{project-id}/badge.svg` - Custom SVG badge
- `certifications/{project-id}/history.json` - Full certification history with toolchain info
- `certifications/{project-id}/results/` - Stored verification results
  - `{timestamp}.json` - Timestamped results for each certification
  - `latest.json` - Most recent verification results
- `certifications/{project-id}/specs/` - Stored specification manifests
  - `{timestamp}.json` - Timestamped specs for each certification
  - `latest.json` - Most recent specification manifest

---

### 2. Internal Project Certification (`verify-certify-badge.yml.example`)

Example workflow for projects that want to integrate certification into their own CI/CD.

**Features:**
- Runs on push to main branch (when Rust files change)
- Full verification and certification pipeline
- Updates certification badge automatically

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
- 🔴 **Red** (`red`): <50% verified (it makes little sense to certify red projects)

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

## Certification Data

### history.json Structure

Each certification is recorded in `history.json` with full traceability:

```json
{
  "certifications": [
    {
      "timestamp": "2026-01-27T09:49:01Z",
      "ref": "main",
      "network": "sepolia",
      "tx_hash": "0x...",
      "content_hash": "0x...",
      "etherscan_url": "https://sepolia.etherscan.io/tx/0x...",
      "verified": 70,
      "total": 70,
      "verus_version": "0.2026.01.10.531beb1",
      "rust_version": "1.92.0",
      "results_file": "results/2026-01-27T09-49-01Z.json",
      "results_hash": "0x...",
      "specs_hash": "0x...",
      "specs_file": "specs/2026-01-27T09-49-01Z.json"
    }
  ]
}
```

**Fields:**
- `timestamp`: ISO 8601 timestamp of certification
- `ref`: Git ref (branch/tag/commit) that was certified
- `network`: Ethereum network (`mainnet` or `sepolia`)
- `tx_hash`: Transaction hash of the on-chain certification
- `content_hash`: Keccak256 hash certified on-chain (Merkle root when specs are present)
- `etherscan_url`: Link to transaction on Etherscan
- `verified`/`total`: Verification statistics
- `verus_version`: Verus toolchain version used
- `rust_version`: Rust compiler version used
- `results_file`: Path to stored verification results
- `results_hash`: keccak256 of results.json (Merkle leaf)
- `specs_hash`: keccak256 of specs.json (Merkle leaf)
- `specs_file`: Path to stored specification manifest

**Merkle hashing:** When specs are available, the on-chain `content_hash` is a
Merkle root: `keccak256(results_hash || specs_hash)`. Both leaf hashes are stored
in `history.json` so each artifact can be verified independently. When specs are
not available (older certifications), `content_hash` is simply `keccak256(results.json)`.

### Results & Specs Storage

Full verification results and specification manifests are stored for each certification:
- `results/{timestamp}.json` - Immutable verification results per certification
- `results/latest.json` - Most recent verification results
- `specs/{timestamp}.json` - Immutable specification manifest per certification
- `specs/latest.json` - Most recent specification manifest

The specification manifest (produced by `probe-verus specify`) contains the
pre/postconditions for each verified function, making the "theorem statements"
inspectable without reading source code.

This enables:
- Full reproducibility of verification
- Historical comparison of results across versions
- Audit trail of what was verified
- Independent review of what properties were proven (via specs)
- Tracking spec stability across re-certifications (same `specs_hash` = unchanged specs)

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
│  🔍 STEP 1: VERIFICATION + SPEC EXTRACTION                                │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │  probe-verus/action@v1                                              │  │
│  │  ├── Install Verus toolchain                                        │  │
│  │  ├── Run probe-verus atomize → atoms.json                           │  │
│  │  └── Run probe-verus verify  → results.json                         │  │
│  │                                                                     │  │
│  │  probe-verus specify (post-action step)                             │  │
│  │  └── Extract specs from source + atoms.json → specs.json            │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
│                                                                           │
│  📤 Outputs: results.json, specs.json, verified_count, total_functions   │
╰───────────────────────────────────────────────────────────────────────────╯
                                        │
                                        ▼
╭───────────────────────────────────────────────────────────────────────────╮
│  ⛓️  STEP 2: ON-CHAIN CERTIFICATION (Merkle hashing)                      │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │  certify_cli certify                                                │  │
│  │  ├── results_hash = keccak256(results.json)                         │  │
│  │  ├── specs_hash   = keccak256(specs.json)                           │  │
│  │  ├── content_hash = keccak256(results_hash || specs_hash)           │  │
│  │  ├── Submit content_hash to Certify.sol contract                    │  │
│  │  └── Via Gnosis Safe multisig (optional)                            │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
│                                                                           │
│  📤 Outputs: tx_hash, content_hash, results_hash, specs_hash             │
╰───────────────────────────────────────────────────────────────────────────╯
                                        │
                    ┌───────────┬───────┼───────┬───────────┐
                    ▼           ▼       ▼       ▼           ▼
          ┌──────────────┐ ┌────────┐ ┌────────┐ ┌──────────────┐
          │ 📁 badge.svg │ │📁 hist │ │📁 res/ │ │  📁 specs/   │
          │ 📁 badge.json│ │  .json │ │ latest │ │  latest.json │
          └──────────────┘ └────────┘ └────────┘ └──────────────┘
                          │             │             │
                          └─────────────┼─────────────┘
                                        ▼
                    ╔═══════════════════════════════════════════╗
                    ║              🏷️  README Badge             ║
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
│       ├── badge.json      # Shields.io compatible data
│       ├── badge.svg       # Custom SVG badge
│       ├── history.json    # Certification history (incl. Merkle hashes)
│       ├── README.md       # Project-specific instructions
│       ├── results/        # Stored verification results
│       │   ├── {timestamp}.json
│       │   └── latest.json
│       └── specs/          # Stored specification manifests
│           ├── {timestamp}.json
│           └── latest.json
├── certify_cli/            # Python CLI for certification
│   ├── __main__.py
│   ├── config.py           # Supports CERTIFY_SPECS_SOURCE for Merkle hashing
│   ├── deploy.py           # Merkle-style hashing when specs are present
│   ├── foundry.py          # compute_merkle_content_hash()
│   ├── registry.py         # Badge, history, results & specs archiving
│   ├── safe.py
│   └── verify.py
├── doc/
│   ├── overview.md                    # This file
│   └── ...
├── src/
│   └── Certify.sol         # Solidity contract
└── .github/workflows/
    ├── certify-external.yml           # Certify external projects (with spec extraction)
    ├── verify.yml                     # Verify certifications (with Merkle check)
    ├── ci.yml                         # Linting & tests
    └── verify-certify-badge.yml.example
```

---

## Certified Projects

| Project | Badge | Status | Blockchain |
|---------|-------|--------|------------|
| [pmemlog_with_callgraph](https://github.com/Beneficial-AI-Foundation/pmemlog_with_callgraph) | ![BAIF Certified](https://img.shields.io/badge/BAIF_Certified-72%2F72_verified-brightgreen?style=flat&logo=ethereum&logoColor=white) | 100% verified | [Etherscan](https://etherscan.io) |

---

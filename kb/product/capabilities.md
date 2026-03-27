---
title: Capabilities
last-updated: 2026-03-26
status: draft
---

# Capabilities

What the certify system can do today. This is a factual inventory of implemented functionality. For the product charter and design principles, see [spec.md](spec.md). For future directions, see [future.md](future.md).

## CLI interface

The `certify-cli` Python package exposes seven commands:

| Command | Purpose |
|---------|---------|
| `deploy` | Deploy the Certify contract to a network |
| `certify` | Hash content and record certification on-chain (direct or via Safe) |
| `verify` | Check a content hash against on-chain certification for a given identifier |
| `verify-hash` | Direct on-chain lookup of a content hash |
| `verify-certification` | Full local verification (registry + hashes + Merkle + proof bundle) |
| `update-registry` | Archive artifacts and update badges/history in the certification registry |
| `generate-proofs` | Generate Z3 proof bundles from Verus SMT logs |

## On-chain certification

A single Solidity contract (`src/Certify.sol`) deployed on Ethereum records certifications as `Certified` events. Each event contains 8 fields (identifier, content hash, commit hash, description, schema version, timestamp, sender, identifier hash). The contract is stateless — all data lives in event logs.

- **Access control**: only the `AUTHORIZED_CERTIFIER` address can call `certify()` (P1)
- **Schema**: version 2 (`uint8 public constant`)
- **Gnosis Safe**: mainnet certifications go through a BAIF multisig via `safe.py`

Deployed contracts:

| Network | Contract | Authorized Certifier |
|---------|----------|---------------------|
| Mainnet | `0x7774c8804a462bB7d5D33f2ad4fcc4A6FC67d399` | `0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e` (BAIF Safe) |
| Sepolia | `0x7a1bdfE0F2F9B4110301371Fa26BB3a4719b2A9F` | `0x9d12f95B0340efeB967060823cB9a4A55C9ebb36` (EOA, testing) |

## Merkle-style content hashing

Certification artifacts are hashed into a single on-chain content hash using a Merkle-style scheme:

- **1-leaf mode**: `content_hash = keccak256(results_file)` — verification results only (probe-lean without Aeneas)
- **2-leaf mode**: `content_hash = keccak256(results_hash || specs_hash)` — verification results + spec manifest (probe-verus, or probe-lean + probe-aeneas)
- **3-leaf mode**: `content_hash = keccak256(results_hash || specs_hash || proofs_hash)` — adds proof bundle (probe-verus with Z3 proofs)

Leaf order is fixed (results, specs, proofs). One transaction, one gas cost regardless of artifact count. Each sub-hash is stored in `history.json` for independent verification.

See [ADR-002](../decisions/002-merkle-hashing.md) for design rationale, [schema.md](../engineering/schema.md) for format details.

## Spec manifests

Verification tools produce structured spec manifests that are hashed as the second Merkle leaf:

- **Verus**: `probe-verus extract` produces `specs.json` listing every verified specification (pre/postconditions)
- **Lean/Aeneas**: `probe-aeneas listfuns` produces `functions.json` mapping Rust functions to Lean translations with verification status

These manifests are archived in the certification registry alongside verification results and are inspectable by anyone without running the verification tool or reading source code.

## Spec taxonomy

Verified properties are classified by category using `probe-verus extract --taxonomy-config`. Categories include functional correctness, memory safety, data invariants, crash safety, and liveness. The taxonomy is included in the spec manifest and surfaced in certification summaries.

A certification that says "72 verified: 45 functional correctness, 20 safety, 7 crash consistency" is qualitatively different from "72 verified."

## Z3 proof bundles

The `generate-proofs` CLI command produces per-function proof artifacts from Verus SMT logs:

```
proof-bundle/
├── proofs.json          # Per-function index: spec text, formula path, proof path, hashes
├── smt_queries/         # .smt2 files (Z3 formulas in standard SMT-LIB2)
└── z3_proofs/           # .proof files (Z3 proof terms)
```

Proof generation uses the SMT-LIB standard proof mode (`set-option :proof true` + `get-proof`), which works with Z3's default solver core that Verus tunes for. The proof bundle is hashed as the third Merkle leaf.

Current coverage (see [proof coverage report](../reports/proof-coverage-report.md) for details):

| Project | Verified | In proof bundle | Proofs generated | Proof errors |
|---------|------:|------:|------:|------:|
| pmemlog | 72 | 66 | 66 (100%) | 0 |
| curve25519-dalek | 1157 | 1130 | 1110 (98.2%) | 20 |

Functions absent from proof bundles are trusted axioms, mocks, or spec functions that Verus verifies by assumption — no SMT query is emitted for them. The 20 dalek proof errors are complex cryptographic lemmas where Z3 returns "unknown" with proof production enabled.

## Verification pipeline

Three CLI commands for independent verification:

- **`verify`** — Check if a content hash exists on-chain for a given identifier, fetch and display the `Certified` event
- **`verify-hash`** — Direct on-chain lookup of a content hash
- **`verify-certification`** — Full local verification pipeline:
  1. Registry lookup (find certification entry by commit, identifier, or content hash)
  2. Hash checks (recompute keccak256 of each archived artifact)
  3. Merkle structure verification (recompute content hash from sub-hashes, compare to on-chain)
  4. Proof bundle integrity (P9: all referenced `.smt2` and `.proof` files exist with correct SHA-256 hashes)

## Registry management

Per-project directories under `certifications/` store all certification artifacts:

- `badge.json` — Shields.io-compatible badge data (color based on verification percentage)
- `history.json` — Chronological certification records with Merkle sub-hashes, file paths, tool versions
- `results/` — Timestamped verification result snapshots
- `specs/` — Timestamped spec manifest snapshots
- `proofs/` — Proof bundles (proofs.json + smt_queries/ + z3_proofs/)

The `update-registry` CLI command handles archiving, timestamping, and `latest` symlink management.

## CI/CD automation

Six certification/verification workflows, two per verification tool:

| Workflow | Tool | Merkle | Purpose |
|----------|------|--------|---------|
| `certify-verus.yml` | probe-verus | 2 or 3-leaf | Certify Verus projects (with optional Z3 proofs) |
| `verify-verus.yml` | probe-verus | 2 or 3-leaf | Verify Verus certifications |
| `certify-lean.yml` | probe-lean | 1-leaf | Certify generic Lean projects |
| `verify-lean.yml` | probe-lean | 1-leaf | Verify Lean certifications |
| `certify-aeneas.yml` | probe-lean + probe-aeneas | 2-leaf | Certify Aeneas-translated Lean projects |
| `verify-aeneas.yml` | probe-lean + probe-aeneas | 2-leaf | Verify Aeneas certifications |

Additionally:
- **`ci.yml`** — Lint Python + build/test Solidity
- **`test.yml`** — Python pytest suite + Foundry tests on every push

All business logic lives in `certify_cli`; workflow scripts handle only JSON-to-`GITHUB_OUTPUT` bridging and summary formatting.

## Certified projects

### Verus projects (with Z3 proof bundles)

#### pmemlog (persistent memory log)

- **Repository**: `beneficial-ai-foundation/pmemlog`
- **Latest certification**: 2026-03-23, 72/72 verified
- **Proof bundle**: 66 proofs generated (100% success for matched functions)
- **Certifications**: 13 on Sepolia across multiple commits
- **Spec taxonomy**: crash safety, functional correctness, data invariants

#### curve25519-dalek (elliptic curve cryptography, Verus)

- **Repository**: `beneficial-ai-foundation/dalek-lite`
- **Latest certification**: 2026-03-22, 1157/1208 verified
- **Proof bundle**: 1110 proofs generated (98.2% success for matched functions)
- **Certifications**: 4 on Sepolia
- **Spec taxonomy**: functional correctness (field arithmetic, scalar operations, point operations), memory safety

### Lean/Aeneas projects

#### curve25519-dalek-lean-verify (Aeneas translation of curve25519-dalek)

- **Repository**: `beneficial-ai-foundation/curve25519-dalek-lean-verify`
- **Tool**: probe-lean + probe-aeneas (2-leaf Merkle)
- **Latest certification**: 2026-03-26, 1459/1542 atoms verified (83 unverified), Lean v4.28.0-rc1
- **Functions mapping**: 586 functions (457 visible), 163 verified via Aeneas
- **Certifications**: 1 on Sepolia
- **Network**: Sepolia

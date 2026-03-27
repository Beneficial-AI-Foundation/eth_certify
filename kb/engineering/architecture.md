---
title: Architecture
last-updated: 2026-03-26
status: draft
---

# Architecture

The certify system has four layers, each with a distinct responsibility.

## Layers

### 1. Contract Layer (`src/Certify.sol`)

A single Solidity contract deployed on Ethereum. Responsibilities:
- Enforce [access control](glossary.md#authorized-certifier) via the `onlyAuthorized` modifier
- Emit `Certified` events with the full [event schema](schema.md#certified-event)
- Provide pure hash helper functions (`hashIdentifier`, `hashContent`)

The contract is stateless — it stores no mappings or arrays. All data is in event logs. The `AUTHORIZED_CERTIFIER` address is `immutable` (set once at deploy, never changed — see [ADR-001](../decisions/001-immutable-certifier.md)).

### 2. CLI Layer (`certify_cli/`)

A Python package (`certify-cli`) that orchestrates the certification pipeline. Responsibilities:
- **Deploy** the contract via Foundry (`deploy.py`)
- **Certify** content: fetch source, compute [content hash](glossary.md#content-hash) (including [Merkle hashing](glossary.md#merkle-root) for multi-artifact mode), submit transaction or generate Safe data (`deploy.py`, `envelope.py`)
- **Verify** certifications against on-chain events (`verify.py`, `verify_certification.py`)
- **Generate proof bundles** from Verus SMT logs (`proofs.py`)
- **Manage the registry** — update badges, history, archive artifacts (`registry.py`)
- **Gnosis Safe integration** — propose and execute multisig transactions (`safe.py`)

The CLI calls Foundry (`forge`) as a subprocess for all on-chain operations. Private keys are passed via environment variables, never CLI arguments (see [P7](properties.md#p7-key-confidentiality)).

### 3. Workflow Layer (`.github/workflows/`, `.github/scripts/`)

GitHub Actions workflows that automate certification for external projects. Three verification tools are supported, each with a certify + verify workflow pair:

**Verus workflows** (probe-verus):
- `certify-verus.yml` — Certify Verus projects with `probe-verus/action-extract@v5` (2 or 3-leaf Merkle)
- `verify-verus.yml` — Verify Verus certifications

**Lean workflows** (probe-lean):
- `certify-lean.yml` — Certify generic Lean projects via `probe-lean extract` (1-leaf Merkle)
- `verify-lean.yml` — Verify Lean certifications

**Aeneas workflows** (probe-lean + probe-aeneas):
- `certify-aeneas.yml` — Certify Aeneas-translated Lean projects (2-leaf Merkle: atoms.json + functions.json)
- `verify-aeneas.yml` — Verify Aeneas certifications

**Manifest anchoring**:
- `anchor-manifest.yml` — Anchor a probe-manifest JSON on-chain (1-leaf Merkle: keccak256 of the manifest file)

**Infrastructure**:
- `ci.yml` — Lint Python + build/test Solidity
- `test.yml` — Python pytest suite + Foundry tests

Helper scripts in `.github/scripts/` handle only logic not in `certify_cli`:
- `workflow_utils.py` — JSON-to-`GITHUB_OUTPUT` bridge, repo URL parsing
- `resolve_extract.py` — Parse probe-verus extract output format
- `resolve_lean_extract.py` — Parse probe-lean atoms.json: count verified/unverified atoms, extract Lean version
- `resolve_manifest.py` — Download probe-manifest JSON from URL, parse project-prefixed metadata fields
- `certify_summary.py` / `verify_summary.py` — `GITHUB_STEP_SUMMARY` markdown (supports both Verus and Lean version display)

All business logic (hashing, verification, registry, proofs) stays in `certify_cli`.
Workflows invoke it via `uv run python -m certify_cli <command> --json`.

### 4. Registry Layer (`certifications/`)

On-disk storage of certification artifacts, one directory per certified project. Structure:
- `badge.json` — Shields.io endpoint for README badges
- `history.json` — Chronological records with [Merkle sub-hashes](schema.md#historyjson)
- `README.md` — Human-readable summary
- `results/` — Timestamped verification result snapshots
- `specs/` — Timestamped spec manifest snapshots
- `proofs/` — [Proof bundles](glossary.md#proof-bundle) (proofs.json + smt_queries/ + z3_proofs/)

## Data flow

```
Target project (external repo)
        │
        ▼
  CI Workflow runs verification
        │
        ├── Verus path:  results.json + specs.json [+ proof-bundle/]  (2 or 3-leaf)
        ├── Lean path:   atoms.json                                   (1-leaf)
        ├── Aeneas path: atoms.json + functions.json                  (2-leaf)
        │
        └── CLI computes Merkle root ──▶ certify() tx ──▶ Certified event (on-chain)
                                                │
                                                ▼
                                         CLI updates registry
                                                │
                                   ┌────────────┼────────────┐
                                   ▼            ▼            ▼
                             badge.json   history.json   artifacts/
```

## Key design constraints

- The CLI never bypasses Foundry for on-chain operations — `forge script` is the only path to transaction submission
- URL fetching validates against SSRF before any HTTP request ([P6](properties.md#p6-ssrf-prevention))
- The contract is the sole authority for certification validity; the registry is a convenience layer
- Registry files are committed to the certify repo itself (not a separate registry repo)

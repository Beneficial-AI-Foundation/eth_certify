---
title: Schema
last-updated: 2026-03-26
status: draft
---

# Schema

On-chain event schema, Merkle leaf structure, and registry file formats.

## Certified Event

The sole on-chain data structure. Emitted by `Certify.certify()`.

```solidity
event Certified(
    bytes32 indexed identifierHash,
    bytes32 indexed contentHash,
    address indexed sender,
    string identifier,
    bytes32 commitHash,
    string description,
    uint8 schemaVersion,
    uint256 timestamp
);
```

### Indexed fields (topics)
- `identifierHash` — `keccak256(bytes(identifier))`, for filtering by project
- `contentHash` — the [Merkle root](glossary.md#merkle-root) or single-source hash, for verification lookups
- `sender` — `msg.sender` (always the [authorized certifier](glossary.md#authorized-certifier))

### Data fields
- `identifier` — raw project identifier string (e.g., `"beneficial-ai-foundation/pmemlog"`)
- `commitHash` — git commit SHA as bytes32 (20-byte SHA-1, right-padded with zeros)
- `description` — human-readable summary (e.g., `"72/72 verified"`)
- `schemaVersion` — `uint8`, currently `2`
- `timestamp` — `block.timestamp` at certification time

## Merkle Leaf Structure

The [content hash](glossary.md#content-hash) in multi-artifact mode is a Merkle root over artifact hashes:

```
results.json ──▶ results_hash = keccak256(results.json bytes) ─┐
specs.json   ──▶ specs_hash   = keccak256(specs.json bytes)    ├──▶ content_hash = keccak256(all leaves concatenated)
proofs.json  ──▶ proofs_hash  = keccak256(proofs.json bytes)   ─┘
```

### 1-leaf mode (results only)
`content_hash = keccak256(results_file_bytes)`

Used for probe-lean certifications without Aeneas. The content hash equals the results hash; `history.json` stores `results_hash = content_hash` with no `specs_hash`.

### 2-leaf mode (results + specs)
`content_hash = keccak256(results_hash || specs_hash)`

Used for probe-verus (results + spec manifest) and probe-aeneas (atoms + functions mapping).

### 3-leaf mode (results + specs + proofs)
`content_hash = keccak256(results_hash || specs_hash || proofs_hash)`

Used for probe-verus certifications with Z3 proof bundles.

Leaf order is always: results, specs, proofs. The mode is determined by which `--specs-source` and `--proof-bundle-dir` flags are provided to the CLI.

### Known limitation (C5)
There is no domain separation tag or leaf-count prefix. The 1-leaf, 2-leaf, and 3-leaf modes are distinguishable only by context (which sub-hashes exist in `history.json`).

## Registry Files

### history.json

Object with a `certifications` key containing an array of certification records, one per certification event. Ordered reverse-chronologically (newest first).

```json
{
  "certifications": [
    {
      "timestamp": "2026-02-15T12:00:00Z",
      "ref": "main",
      "commit_sha": "abc123...",
      "network": "mainnet",
      "verified": 72,
      "total": 72,
      "tx_hash": "0x...",
      "content_hash": "0x...",
      "results_hash": "0x...",
      "specs_hash": "0x...",
      "proofs_hash": "0x...",
      "results_file": "results/2026-02-15T120000Z.json",
      "specs_file": "specs/2026-02-15T120000Z.json",
      "proof_bundle": "proofs/2026-02-15T120000Z",
      "verus_version": "0.2025.2.15",
      "rust_version": "nightly-2025-02-25"
    }
  ]
}
```

Fields `results_hash`, `specs_hash`, `proofs_hash`, `results_file`, `specs_file`, `proof_bundle`, `verus_version`, `rust_version`, `lean_version`, and `commit_sha` are optional (absent in legacy entries). `lean_version` is present for probe-lean/probe-aeneas certifications; `verus_version` and `rust_version` for probe-verus certifications.

### badge.json

Shields.io endpoint format:

```json
{
  "schemaVersion": 1,
  "label": "BAIF Certified",
  "message": "72/72 verified",
  "color": "brightgreen"
}
```

Color is determined by the verification percentage: `brightgreen` (>=90%), `green` (>=70%), `yellow` (>=50%), `orange` (<50%).

### proofs.json

Per-function proof index within a [proof bundle](glossary.md#proof-bundle):

```json
{
  "module::function_name": {
    "verus_spec": {
      "kind": "proof",
      "requires_text": "requires ...",
      "ensures_text": "ensures ..."
    },
    "z3_formula": {
      "file": "smt_queries/module__function_name.smt2",
      "hash": "0xabc123...",
      "size_bytes": 12345
    },
    "z3_proof": {
      "file": "z3_proofs/module__function_name.proof",
      "hash": "0xdef456...",
      "size_bytes": 67890,
      "time_ms": 1500,
      "format": "z3-legacy-proof"
    },
    "verification_result": "unsat",
    "verus_function_name": "lib::module::function_name"
  }
}
```

`verus_spec` is `null` when no spec was found for the function. `z3_formula` and `z3_proof` are `null` when the corresponding artifact was not generated. When proof generation fails, `z3_proof` contains `error`, `time_ms`, and `z3_result` instead of `file`/`hash`.

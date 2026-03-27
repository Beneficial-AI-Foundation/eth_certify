---
title: "ADR-002: Merkle-Style Hashing"
last-updated: 2026-03-22
status: accepted
---

# ADR-002: Merkle-Style Hashing

## Context

A certification may include multiple artifacts: verification results, spec manifests, and proof bundles. Each needs to be independently verifiable, but we want a single on-chain transaction (one gas cost).

## Options considered

### A. Separate transactions per artifact
- One `certify()` call per artifact (results, specs, proofs)
- Simple and explicit
- 2-3x gas cost; coordination complexity (which tx goes first? what if one fails?)

### B. Concatenate all artifacts into one blob
- Hash everything as one file
- Cannot verify individual artifacts without the full blob

### C. Merkle-style hashing (chosen)
- Hash each artifact independently, then hash the concatenated hashes
- `content_hash = keccak256(results_hash || specs_hash [|| proofs_hash])`
- One transaction, individual artifact verifiability

## Decision

Option C. The Merkle root is stored on-chain; individual leaf hashes are stored in `history.json` off-chain. This enables:
- Independent verification of any single artifact against its leaf hash
- Verification that the leaves combine to the on-chain root
- Backward compatibility: 2-leaf mode (results + specs) works when proofs are absent

## Known limitation

The current implementation is `keccak256(h1 || h2 [|| h3])` with no domain separation tag or leaf-count prefix. This is noted as [C5](../engineering/properties.md#known-bugs-and-edge-cases). The practical risk is low because the leaf count is deterministic (2 or 3 based on whether proofs are present), but a proper tagged Merkle tree would be more robust.

## Consequences

- Single gas cost regardless of artifact count
- Spec stability tracking: `specs_hash` stays constant across re-certifications when specs are unchanged
- Opens the door to two-signature certification (domain expert signs specs, BAIF signs results) without contract changes
- Slightly more complex verification logic than a flat hash

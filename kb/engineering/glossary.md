---
title: Glossary
last-updated: 2026-03-26
status: draft
---

# Glossary

Precise definitions of domain terms used across the certify system. Use these exact terms in code, documentation, and KB files.

## Attestation

A declaration by a party that something is true. BAIF attesting that Verus verification passed is attestation. Contrast with [certification](#certification).

## Authorized Certifier

The single Ethereum address permitted to call `certify()` on the [Certify contract](#certify-contract). Set at deploy time as an `immutable` state variable. Typically the [BAIF Safe](#baif-safe). See [ADR-001](../decisions/001-immutable-certifier.md).

## BAIF Safe

The Gnosis Safe multisig wallet operated by the Beneficial AI Foundation. Used as the [authorized certifier](#authorized-certifier) on mainnet. Requires multiple signers to approve certification transactions.

## Badge

A Shields.io-compatible JSON endpoint (`badge.json`) in the [registry](#registry) that displays verification status in project READMEs. Shows verified/total counts and links to the certification record.

## Certification

The act of recording a [content hash](#content-hash) on-chain via the [Certify contract](#certify-contract). Currently closer to [attestation](#attestation) than true third-party certification — acknowledged in the project's documentation and roadmap.

## Certify Contract

The Solidity smart contract (`src/Certify.sol`) deployed on Ethereum. Emits [Certified events](#certified-event) when the [authorized certifier](#authorized-certifier) calls `certify()`. Stateless — all data lives in event logs.

## Certified Event

The Solidity event emitted by every successful `certify()` call. Contains 8 fields — see [schema.md](schema.md#certified-event) for the full definition.

## Content Hash

The keccak256 hash recorded on-chain as the `contentHash` field of a [Certified event](#certified-event). In single-source mode, this is `keccak256(source_content)`. In multi-artifact mode, this is the [Merkle root](#merkle-root).

## Content Source

The input to a certification: a URL, local file path, or GitHub artifact reference. Configured in `certify.conf` as `CERTIFY_SOURCE`. URLs are validated against [SSRF](properties.md#p6-ssrf-prevention) before fetching.

## Identifier

A string that names what is being certified (e.g., `"beneficial-ai-foundation/pmemlog"`). Stored as a non-indexed field in the [Certified event](#certified-event). Its keccak256 hash is stored as an indexed topic for efficient filtering.

## Merkle Root

The content hash computed by hashing artifact hashes together. Three modes:
- **1-leaf**: `content_hash = keccak256(results_file)` — probe-lean only
- **2-leaf**: `keccak256(results_hash || specs_hash)` — probe-verus or probe-aeneas
- **3-leaf**: `keccak256(results_hash || specs_hash || proofs_hash)` — probe-verus with Z3 proofs

Enables a single on-chain transaction to cover multiple artifacts while allowing independent verification of each. See [ADR-002](../decisions/002-merkle-hashing.md).

## probe-aeneas

An external CLI tool that analyzes Aeneas-translated Lean projects. Produces `functions.json` mapping Rust functions to their Lean translations with verification status. Used alongside [probe-lean](#probe-lean) for 2-leaf Merkle certifications.

- `probe-aeneas listfuns --lean-project <path>` — generate functions.json, enriched with verification data from probe-lean atoms

The `functions.json` output contains per-function entries with `lean_name`, `rust_name`, `verified`, `specified`, `fully_verified`, and visibility flags.

## probe-lean

An external CLI tool that analyzes Lean 4 projects. Produces `atoms.json` listing every declaration with verification status, dependencies, and metadata.

- `probe-lean extract <project_path>` — unified pipeline: atomize declarations, detect sorries via build output, produce atoms.json

Key atom fields: `verification-status` (`verified`, `unverified`, `failed`), `is-in-package`, `is-relevant`, `kind`. Note: probe-lean maps sorry-containing declarations to `"unverified"` status, not a separate `"has-sorry"` status.

Output is wrapped in a Schema 2.0 metadata envelope with `lean-version` in the `source` field.

## probe-verus

An external CLI tool that analyzes Verus projects. Produces the artifacts consumed by the certify pipeline:
- `probe-verus extract` — unified pipeline (atomize + specify + run-verus) that produces results.json, specs.json, and the combined extract.json in a single invocation. This is the recommended command and the one used by all active certification workflows.
- `probe-verus atomize` — generates call graph atoms from SCIP indexes (run internally by `extract`)
- `probe-verus specify` — extracts [spec manifests](#spec-manifest) from source + atoms (run internally by `extract`)
- `probe-verus run-verus` — runs Verus verification and produces results.json (run internally by `extract`)

Since v2.0.0, all probe-verus JSON outputs are wrapped in a [Schema 2.0 metadata envelope](../certify_cli/envelope.py) (`{"tool": {...}, "source": {...}, "timestamp": "...", "data": <payload>}`).

## Proof Bundle

A directory containing Z3 proof artifacts for a certification:
- `proofs.json` — per-function index with spec text, formula paths, proof paths, and SHA-256 hashes
- `smt_queries/` — `.smt2` files (Z3 formulas in SMT-LIB2 format)
- `z3_proofs/` — `.proof` files (Z3 proof terms)

Generated by `certify-cli generate-proofs`. The hash of `proofs.json` is the third [Merkle](#merkle-root) leaf.

## Ralph Loop

The iterate-and-validate cycle for converging on correctness: implement → audit → fix → audit → fix → ... → validate. Each iteration uses [KB auditors](#kb-auditors) as the feedback signal. Named for the insight that single agent runs are probabilistic but rapid iteration drives quality exponentially.

## Registry

The `certifications/` directory in the certify repo. Contains one subdirectory per certified project with [badges](#badge), history, and archived artifacts. See [architecture.md](architecture.md#4-registry-layer-certifications) and [schema.md](schema.md#registry-files).

## Spec Manifest

A structured JSON file produced by the specify stage of `probe-verus extract` (or standalone `probe-verus specify`) listing every verified specification (pre/postconditions) in a project. Hashed as the second [Merkle](#merkle-root) leaf. Makes verified properties inspectable without running Verus.

## KB Auditors

The auditor skills in `.claude/skills/` that check the KB and code for consistency, ambiguity, and test coverage. Three auditors: ambiguity, code quality, test quality. Their outputs go to `kb/reports/`.

---
title: Testing Strategy
last-updated: 2026-03-26
status: draft
---

# Testing Strategy

How the certify system is tested. What each test defends, what is intentionally not tested, and the mock strategy for external dependencies.

## Design principles

1. **Test behavior, not implementation** — tests assert on what the system does (blocks SSRF, computes correct Merkle roots, rejects path traversal), not on internal function signatures or exact output strings.
2. **Every test defends a KB property or known bug** — each test file maps to specific properties from [properties.md](properties.md).
3. **No fragile coupling** — tests mock external tools (`cast`, `forge`, DNS, HTTP) at the narrowest boundary. When the implementation changes but behavior stays the same, tests stay green.

## Test suites

### Solidity (`test/Certify.t.sol`)

7 tests run via `forge test`. Covers the contract layer:

| Test | Property |
|------|----------|
| `testAuthorizedCanCertify` | [P1](properties.md#p1-access-control) |
| `testUnauthorizedReverts` | [P1](properties.md#p1-access-control) |
| `testEventFieldsAreCorrect` | [P2](properties.md#p2-event-completeness) |
| `testSchemaVersion` | [P5](properties.md#p5-schema-versioning) |
| `testAuthorizedCertifierIsSet` | [P1](properties.md#p1-access-control) |
| `testHashIdentifier` | Pure helper correctness |
| `testHashContent` | Pure helper correctness |

### Python (`tests/`)

118 tests run via `uv run pytest tests/ -v`. Covers the CLI layer:

| File | Properties | What it defends |
|------|-----------|-----------------|
| `test_ssrf.py` | [P6](properties.md#p6-ssrf-prevention) | Scheme blocking, private/loopback/link-local/reserved IP blocking, DNS failure, cloud metadata endpoint, fetch_content integration |
| `test_merkle.py` | [P3](properties.md#p3-merkle-integrity), [P10](properties.md#p10-hash-determinism) | 2-leaf and 3-leaf Merkle roots, leaf order is fixed, determinism, verify_merkle_structure pass/fail/tamper-detection/skip |
| `test_verify_cert.py` | [P8](properties.md#p8-registry-consistency), [P9](properties.md#p9-proof-bundle-completeness) | Certification lookup (exact/fuzzy/missing), path traversal security, proof bundle completeness (file existence + SHA-256 hash integrity), all_passed aggregation |
| `test_proofs_pipeline.py` | [P9](properties.md#p9-proof-bundle-completeness), C2 | Function-def extraction, Verus/probe name normalization, module extraction, function mapping (C2 regression), proof query preparation |
| `test_envelope.py` | — | Schema 2.0 envelope detection and unwrapping, bare data passthrough |
| `test_config.py` | — | Env file parsing, env var priority, legacy CERTIFY_URL fallback, source type detection, network key fallback |
| `test_registry.py` | [P8](properties.md#p8-registry-consistency) | Registry creation, history append ordering, badge color, optional Merkle fields, file and proof-bundle archiving |
| `test_deploy_helpers.py` | [P4](properties.md#p4-commit-binding), [P7](properties.md#p7-key-confidentiality) | Commit hash zero-padding (7 cases), key confidentiality static analysis (AST scan of deploy.py, string scan of all CLI files, Solidity script check) |
| `test_lean_support.py` | [P8](properties.md#p8-registry-consistency) | probe-lean atoms.json parsing (verified/unverified counts, package/relevance filtering, absolute paths, Lean version extraction), registry lean_version support (history.json storage, README toolchain display), verify-certification lean_version in JSON output |

## Mock strategy

The CLI shells out to Foundry (`cast keccak`, `forge script`, etc.). Tests must not depend on Foundry being installed.

- **`cast_keccak`** — patched with a pure-Python implementation using `Web3.keccak()` (already a project dependency). The `mock_keccak` fixture in `tests/conftest.py` handles this. Functions that call `cast_keccak` transitively get the mock automatically.
- **`run_cast`** — guarded: raises `RuntimeError` if called during tests, catching accidental subprocess use.
- **DNS resolution** — `socket.getaddrinfo` is patched in SSRF tests to return controlled IP addresses, avoiding real network calls.
- **Filesystem** — pytest's `tmp_path` fixture provides isolated directories. The `tmp_registry` fixture creates a realistic registry with `history.json` and archived files.

## Coverage by property

| Property | Solidity | Python | Gap |
|----------|----------|--------|-----|
| P1 (Access control) | Full | — | — |
| P2 (Event completeness) | Full | — | — |
| P3 (Merkle integrity) | — | Full | — |
| P4 (Commit binding) | — | Partial | Zero-padding logic tested; end-to-end requires live chain |
| P5 (Schema versioning) | Full | — | — |
| P6 (SSRF prevention) | — | Full | — |
| P7 (Key confidentiality) | — | Full | Static analysis: AST scan + string scan + Solidity check |
| P8 (Registry consistency) | — | Partial | No on-chain cross-check |
| P9 (Proof bundle completeness) | — | Full | File existence + SHA-256 hash integrity |
| P10 (Hash determinism) | — | Full | — |
| P11 (Append-only) | Implicit | — | — |

## What is intentionally not tested

- **`run_forge` / `run_cast` subprocess wrappers** — thin wrappers around `subprocess.run`; testing them would just test that subprocess works. The behavior they enable (deploy, certify on-chain) requires a running blockchain.
- **`safe.py` Gnosis Safe integration** — requires a live Safe contract on a testnet. Integration test territory.
- **`verify.py::_parse_logs` regex parsing** — parses `cast logs` output which has an unstable format across Foundry versions. Testing it locks in a specific format that may change.
- **SVG badge generation** — cosmetic output, not a correctness invariant.
- **Print formatting** (`print_human`, headers) — UI, not behavior.

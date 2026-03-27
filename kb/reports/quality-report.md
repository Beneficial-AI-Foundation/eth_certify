---
auditor: code-quality-auditor
date: 2026-03-22
status: 0 critical, 1 warnings, 1 info
---

## Critical

(none — all critical issues resolved)

- ~~[C1] history.json format contradicts schema.md~~ — **Fixed**: schema.md updated to match implementation (P8).

## Warnings

### [W1] Known bugs C3-C6 still present
- **Location**: kb/engineering/properties.md, lines 116-119
- **Issue**: Four documented defects remain unresolved:
  - **C3**: Verify workflow compares aggregate counts, not per-function results.
  - **C4**: Verify workflow does not pin the Verus version.
  - **C5**: Merkle tree uses no domain separation tag or leaf-count prefix.
  - **C6**: Proof generation pipeline does not verify Z3 binary integrity.
- **Recommendation**: Documented and accepted risks. C3 and C5 are highest priority for future work.

## Property Verification Summary

| Property | Status | Notes |
|----------|--------|-------|
| P1 (Access control) | **Pass** | `onlyAuthorized` modifier, `_checkAuthorized()`, `UnauthorizedCertifier` error |
| P2 (Event completeness) | **Pass** | All 8 fields emitted correctly |
| P3 (Merkle integrity) | **Pass** | 2-leaf and 3-leaf modes with fixed leaf order |
| P4 (Commit binding) | **Pass** | CLI → forge script → on-chain. Zero-padded to bytes32 |
| P5 (Schema versioning) | **Pass** | `SCHEMA_VERSION = 2` as `uint8 public constant` |
| P6 (SSRF prevention) | **Pass** | Scheme, DNS, IP checks. `follow_redirects=False` for user URLs |
| P7 (Key confidentiality) | **Pass** | `env_extra` pattern for all `run_forge()` calls. `vm.envUint` in Solidity |
| P8 (Registry consistency) | **Pass** | Schema.md now matches implementation |
| P9 (Proof bundle completeness) | **Pass** | File existence + SHA-256 hash integrity checks |
| P10 (Hash determinism) | **Pass** | No randomness, fixed leaf order |
| P11 (Append-only) | **Pass** | No state-mutating functions beyond `certify()` |

## Info

### [I1] `verify.py` hardcodes Sepolia Etherscan URL
- **Location**: certify_cli/verify.py, line 183
- **Issue**: `_print_certification` always prints Sepolia Etherscan link. Low priority — `verify` command targets one network at a time.
- **Recommendation**: Make network-aware if mainnet verification is added.

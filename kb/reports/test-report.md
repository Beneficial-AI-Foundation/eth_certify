---
auditor: test-quality-auditor
date: 2026-03-22
status: 0 critical, 0 warnings, 2 info
---

## Coverage Summary

| Property | Tests | Coverage | Notes |
|----------|-------|----------|-------|
| P1 (Access control) | test/Certify.t.sol: 3 tests | Full | |
| P2 (Event completeness) | test/Certify.t.sol: testEventFieldsAreCorrect | Full | All 8 fields decoded |
| P3 (Merkle integrity) | tests/test_merkle.py: 8 tests | Full | 2-leaf, 3-leaf, order, tamper |
| P4 (Commit binding) | tests/test_deploy_helpers.py: 7 tests | Partial | Zero-padding logic covered. End-to-end requires live chain |
| P5 (Schema versioning) | test/Certify.t.sol: testSchemaVersion | Full | |
| P6 (SSRF prevention) | tests/test_ssrf.py: 10 tests | Full | Scheme, IP, DNS, integration |
| P7 (Key confidentiality) | tests/test_deploy_helpers.py: 3 tests | Full | AST scan of deploy.py, grep of all CLI files, Solidity script check |
| P8 (Registry consistency) | tests/test_registry.py + tests/test_verify_cert.py | Partial | Missing on-chain event cross-check |
| P9 (Proof bundle completeness) | tests/test_verify_cert.py + tests/test_proofs_pipeline.py | Full | File existence, SHA-256 hash, C2 regression |
| P10 (Hash determinism) | tests/test_merkle.py: test_determinism | Full | |
| P11 (Append-only) | (implicit) | Implicit | No revoke function exists |

**Total: 7 Solidity tests + 105 Python tests = 112 tests**

## Warnings

(none — previous warnings resolved)

- ~~[W1] P4 (Commit binding) no test coverage~~ — **Fixed**: 7 commit hash zero-padding tests added in `tests/test_deploy_helpers.py`.
- ~~[W2] P7 (Key confidentiality) no test coverage~~ — **Fixed**: 3 static analysis tests added: AST scan of `deploy.py`, string scan of all `certify_cli/*.py` files, and Solidity script verification.

## Info

### [I1] P11 (Append-only) could have an explicit test
- **Location**: test/Certify.t.sol
- **Issue**: P11 is only implicitly tested. An explicit function selector test would catch accidental addition of state-mutating functions.
- **Recommendation**: Low priority.

### [I2] P8 on-chain cross-check not unit-testable
- **Issue**: The P8 property requires verifying `content_hash` exists on-chain via `cast logs`. This requires a running blockchain and is not unit-testable. The off-chain consistency checks (hash recomputation, Merkle structure) are fully tested.
- **Recommendation**: Accepted gap. Integration testing territory.

---
title: Properties and Invariants
last-updated: 2026-03-26
status: draft
---

# Properties and Invariants

Correctness constraints that the certify implementation must preserve. Every change must be checked against these properties. If you cannot satisfy a property, stop and ask — do not silently weaken it.

## P1. Access control

Only the [authorized certifier](glossary.md#authorized-certifier) can call `certify()`. Enforced by the `onlyAuthorized` modifier on `Certify.sol`. Any other caller MUST trigger a revert with `UnauthorizedCertifier(caller, expected)`.

**Validation**: Call `certify()` from an unauthorized address → revert. Call from `AUTHORIZED_CERTIFIER` → success.

## P2. Event completeness

Every successful `certify()` call MUST emit exactly one `Certified` event with all 8 fields:
- `identifierHash` (indexed) — `keccak256(bytes(identifier))`
- `contentHash` (indexed)
- `sender` (indexed) — `msg.sender`
- `identifier` — the raw project identifier string
- `commitHash` — git commit SHA as bytes32
- `description` — free-form string
- `schemaVersion` — `SCHEMA_VERSION` constant
- `timestamp` — `block.timestamp`

No field may be omitted. The event is the sole on-chain record.

**Validation**: Record logs during `certify()`, decode all fields, verify each matches the input.

## P3. Merkle integrity

The [content hash](glossary.md#content-hash) is computed as a [Merkle root](glossary.md#merkle-root) over certification artifacts:

- **1-leaf mode**: `content_hash = keccak256(results_file_bytes)` (probe-lean without Aeneas)
- **2-leaf mode**: `content_hash = keccak256(results_hash || specs_hash)` (probe-verus, probe-aeneas)
- **3-leaf mode**: `content_hash = keccak256(results_hash || specs_hash || proofs_hash)` (probe-verus with Z3 proofs)

Where each leaf is `keccak256(file_contents)`. Leaf order is fixed: results, specs, proofs. The mode is determined by which `--specs-source` and `--proof-bundle-dir` flags are provided. For 1-leaf certifications, `results_hash` equals `content_hash` in `history.json`.

**Validation**: Recompute each leaf hash from archived files, concatenate in order, keccak256 the result, compare to `content_hash` in `history.json` and on-chain.

## P4. Commit binding

Every certification records the git commit SHA as `commitHash` (bytes32, 20-byte SHA-1 zero-padded). The CLI passes this via `--commit-sha`. Workflows extract it from `${{ github.sha }}` or the target project's HEAD.

**Validation**: The `commitHash` in the `Certified` event matches the commit that was actually verified.

## P5. Schema versioning

`SCHEMA_VERSION` is a `uint8 public constant` on the contract, emitted in every `Certified` event. Current value: `2`. This enables future event schema changes without breaking historical log parsing.

**Validation**: `certify.SCHEMA_VERSION() == 2`. Every `Certified` event's `schemaVersion` field equals the contract constant.

## P6. SSRF prevention

When the [content source](glossary.md#content-source) is a URL, it MUST be validated before fetching:
1. Only `http` and `https` schemes are allowed
2. The hostname is resolved via DNS; all resulting IP addresses are checked against `is_private`, `is_loopback`, `is_link_local`, and `is_reserved`
3. If DNS resolution fails, the request is rejected
4. Redirect following is disabled

This is implemented in `_validate_url()` in `certify_cli/foundry.py`.

**Validation**: Attempt to fetch `http://169.254.169.254/`, `file:///etc/passwd`, `http://localhost/` — all must be rejected.

## P7. Key confidentiality

Private keys are passed to Foundry via environment variables (`ETH_PRIVATE_KEY`), never as CLI arguments. CLI arguments are visible in `/proc/<pid>/cmdline`; environment variables are only readable by the process owner.

This is implemented in `run_forge()` via `env_extra` and in `script/Certify.s.sol` via `vm.envUint("ETH_PRIVATE_KEY")`.

**Validation**: Inspect all `run_forge()` call sites — no `--private-key` in the argument list.

## P8. Registry consistency

Every entry in [history.json](schema.md#historyjson) MUST have a corresponding on-chain `Certified` event with matching `content_hash` and `commit_hash`. The `tx_hash` field in the history entry links to the specific transaction.

Merkle sub-hashes (`results_hash`, `specs_hash`, `proofs_hash`) in the history entry MUST match the keccak256 of the corresponding archived files.

**Validation**: For each history entry, verify `content_hash` exists on-chain, and each sub-hash matches its archived file.

## P9. Proof bundle completeness

Every file referenced in [proofs.json](schema.md#proofsjson) MUST exist on disk:
- `z3_formula.file` paths point to existing `.smt2` files in `smt_queries/`
- `z3_proof.file` paths point to existing `.proof` files in `z3_proofs/`
- SHA-256 hashes (`z3_formula.hash`, `z3_proof.hash`) match the actual file contents

**Validation**: Walk all entries in `proofs.json`, check file existence and hash correctness.

## P10. Hash determinism

The same input file content MUST produce the same keccak256 hash. The Merkle root is deterministic given fixed leaf order (results, specs, proofs). No randomness, no timestamp-dependent ordering in hash computation.

**Validation**: Hash the same file twice → identical result. Compute Merkle root from the same leaves → identical result.

## P11. Append-only

No revocation mechanism exists on the contract. Certifications are permanent once emitted as events. Newer certifications for the same [identifier](glossary.md#identifier) supersede older ones by convention, not by on-chain state mutation.

This is an intentional design choice — see [ADR-003](../decisions/003-no-revocation.md).

**Validation**: The contract has no `revoke()`, `delete()`, or state-modifying functions other than `certify()`.

---

## Known bugs and edge cases

These are documented defects that should be fixed, not acceptable behavior:

- **C1**: ~~The `certify_cli/` package has zero automated tests.~~ **Partially resolved.** A pytest suite (`tests/`, 118 tests) now covers P3 (Merkle), P6 (SSRF), P8 (registry), P9 (proof bundle), P10 (determinism), config parsing, envelope handling, and Lean/Aeneas integration (atoms.json parsing, lean_version tracking, registry support). Not yet covered by Python tests: P4 (commit binding end-to-end), P7 (key confidentiality static check). On-chain integration tests (deploy, certify, verify via RPC) are not unit-testable.
- **C2**: Name-matching heuristics in `proofs.py` use substring matching to map Verus functions to SMT queries. False matches and silent misses are possible.
- **C3**: The `verify` workflow compares `verified` and `total` counts, not per-function results. A function could fail while another passes, and verification "succeeds" because the count is unchanged.
- **C4**: The verify workflow does not install the same Verus version that was used for the original certification. Version drift could cause false negatives.
- **C5**: The Merkle tree uses `keccak256(h1 [|| h2 [|| h3]])` with no domain separation tag or leaf-count prefix. Theoretical 1-leaf vs 2-leaf vs 3-leaf ambiguity.
- **C6**: The proof generation pipeline does not verify Z3 binary integrity. A supply-chain attack on the Verus distribution could substitute a modified Z3.

---
title: Future Directions
last-updated: 2026-03-24
status: draft
---

# Future Directions

Ideas and research directions that are not yet implemented. For what the system can do today, see [capabilities.md](capabilities.md). For an honest assessment of current limitations, see the [system review](../reports/system-review.md).

---

## Spec quality and visibility

### Spec quality metrics

Automated metrics to flag trivial specifications. "72/72 verified, 68 with non-trivial postconditions, 4 trivial" is more informative than bare counts.

- Postcondition density (functions with empty or `ensures true`)
- Spec-to-code ratio (specification lines vs implementation lines)
- Spec complexity (quantifiers, arithmetic constraints, inductive properties)
- Public API coverage (proportion of `pub` functions with non-trivial specs)

**Feasibility**: automatable via syntactic analysis of the spec manifest.

### Spec display in badge/registry UI

Surface spec manifests in a human-readable format alongside certification badges. Currently specs are archived as JSON but not rendered for casual inspection.

**Feasibility**: low effort; rendering layer on top of existing JSON archives.

### Spec diff tracking

When a project is re-certified at a new commit, produce a spec-level diff: which specifications were added, modified, removed, or unchanged. Archive diffs in `history.json` alongside existing certification metadata.

**Feasibility**: straightforward comparison of two spec manifests keyed by function name.

---

## Trust and accountability

### Informal-to-formal mapping

A structured document that makes the claim of correspondence between informal requirements (design docs, RFCs) and formal specifications explicit and auditable. Includes the informal source, formal spec references, author, and reviewer.

Does not prove correctness of the mapping, but creates accountability and enables review — the "theorem significance review" analog.

**Feasibility**: document format is straightforward; the hard part is authoring meaningful mappings.

### Two-signature certification

Separate "the specs are meaningful" from "the specs are verified" with two independent signatures:

- **Spec attestation**: domain expert signs the spec manifest, claiming the properties capture the intended behavior
- **Verification attestation**: BAIF signs the verification results, claiming Verus accepted the specs

This mirrors the proof certificate structure: theorem statement judged by humans, proof checked by machine.

**Feasibility**: requires contract changes or a wrapper contract; the Merkle scheme already separates the hashes.

---

## Proof artifacts

### Z3 `sat.euf` proof logs

Z3 4.12.0+ offers a newer proof-log mode via `sat.euf=true` with self-validation, proof trimming, and a different inference format. We currently use the SMT-LIB standard proof mode because Verus tunes queries for Z3's default core, and `sat.euf` crashes on complex Verus-scale queries ([Z3#5336](https://github.com/Z3Prover/z3/issues/5336)).

If the `sat.euf` core stabilizes, switching would give built-in proof checking — a meaningful step toward independently verifiable proofs.

**Related**: Gap 3 in [proof coverage report](../reports/proof-coverage-report.md). **Feasibility**: blocked on Z3 upstream stability.

### Independent proof checking

Several research approaches toward proofs checkable by a small trusted kernel:

| Approach | Status | What it gives |
|----------|--------|---------------|
| Z3 proof term checkers | No mature checker for Verus-scale queries | Retrospective verification of archived `.proof` files |
| Verus-to-Lean/Rocq translation | Research project | True proof objects checkable by a ~5K-line kernel |
| Pi2 ZK-SNARKs of verification | Requires K framework semantics for Rust/Verus | Constant-size, constant-time verification |

**Feasibility**: all are active research areas; archiving proof terms now enables retrospective verification when tools mature.

### SMT proof certificates (emerging standard)

The SC2/SMTLIB working group is developing a standardized format for SMT proof artifacts. Adoption would make our proof bundles portable across solvers and checkers.

**Feasibility**: depends on standardization timeline.

---

## Pipeline improvements

### Trusted axiom marking in proofs.json

Add explicit status fields (e.g., `"status": "trusted-axiom"`) to `proofs.json` for functions that Verus verifies by assumption and for which no SMT query is emitted. Currently these functions are simply absent from the proof bundle, which is correct but unclear.

**Origin**: recommended action in [proof coverage report](../reports/proof-coverage-report.md). **Feasibility**: low effort, `proofs.py` change.

### Verus function count tracking

Record the raw Verus compiler function counts (total functions, verified functions) in `history.json` alongside the existing `verified`/`total` fields from `probe-verus extract`. This enables precise measurement of Gap 1 (functions lost in the atomize stage of `probe-verus extract`).

**Origin**: recommended action in [proof coverage report](../reports/proof-coverage-report.md). **Feasibility**: low effort, workflow + registry change.

---

## External adoption

### Self-service contract deployment

Currently, only the BAIF-deployed Certify contract exists, and it gates `certify()` to the BAIF Gnosis Safe via the `onlyAuthorized` modifier. An external organization that wants to run its own certification pipeline would need to deploy its own contract with its own `AUTHORIZED_CERTIFIER` address.

This is technically straightforward (`certify-cli deploy` already supports it), but there is no documentation, tooling, or guidance for the self-service path. Before offering a reusable GitHub Action or integration library for external adopters, the prerequisites are:

- Documentation for deploying and configuring a self-owned Certify contract
- Guidance on key management (Safe setup, signer rotation)
- A clear separation between BAIF-issued certifications and third-party ones (different contract addresses, distinct badge provenance)

**Feasibility**: low technical effort, moderate documentation effort. Deferred until there is concrete external demand.

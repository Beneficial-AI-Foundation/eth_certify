---
title: Product Specification
last-updated: 2026-03-26
status: draft
---

# Product Specification

The product charter: what certify is, who it's for, and the principles it follows. For the concrete implementation inventory, see [capabilities.md](capabilities.md).

## What certify does

Certify anchors verification results for formally verified code on Ethereum. A single on-chain transaction records a tamper-evident hash of what was verified, binding it to a specific git commit, project identifier, and human-readable description.

The system supports multiple verification tools (Verus, Lean/Aeneas) and four tiers of certification artifacts:

1. **Results only** — verification pass/fail counts (legacy, pre-Schema 2)
2. **Results, single hash** — one verification artifact hashed directly (1-leaf; used by probe-lean)
3. **Results + specs** — verification results plus a structured spec manifest, Merkle-hashed into a single content hash (2-leaf; used by probe-verus and probe-aeneas)
4. **Results + specs + proofs** — adds Z3 proof bundles (SMT formulas + proof terms) as a third Merkle leaf (3-leaf; used by probe-verus with Z3 proof generation)

## Who uses it

### Certifiers (BAIF)
- Run verification pipelines on target projects
- Record results on-chain via the CLI or CI workflows
- Operate through a Gnosis Safe multisig for mainnet certifications

### Consumers (developers, auditors, the public)
- Read certification badges in project READMEs
- Verify certifications independently via the CLI
- Inspect spec manifests to judge whether verified properties are meaningful
- Inspect proof bundles for evidence of what Z3 solved

### CI/CD systems
- Trigger certification workflows on new commits to certified projects

## Design principles

1. **Single transaction** — One gas cost per certification, regardless of artifact count (Merkle hashing combines leaves)
2. **Independent verifiability** — Anyone can recompute hashes from archived artifacts and check against on-chain events
3. **Authorization gating** — Only the designated certifier (BAIF Safe) can create certifications on the contract
4. **Append-only** — No revocation; newer certifications supersede older ones for the same project
5. **Spec visibility** — Spec manifests make verified properties inspectable without running Verus or reading source code

## Where the system stands

The system is progressing from attestation toward certification. For an honest assessment of limitations, see the [system review](../reports/system-review.md).

| Level | What it implies | Status |
|-------|----------------|--------|
| **L0: Mechanical** | Verus accepts the specs | Implemented |
| **L0.5: Inspectable** | Specs are published and hashed alongside results | Implemented (Merkle hashing) |
| **L0.75: Evidenced** | Z3 formulas + proof terms archived per function | Implemented (proof bundles) |
| **L1: Refinement** | Formal specs correctly refine informal requirements | Not yet |
| **L2: Completeness** | Specs cover all security-relevant properties | Not yet |
| **L3: Review** | Independent expert validated the refinement | Not yet |

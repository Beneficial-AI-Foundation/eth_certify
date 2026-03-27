---
title: System Review
last-updated: 2026-03-24
status: living
---

# System Review

An honest assessment of the certify system's limitations, design trade-offs, and security posture. This is a living document — update statuses as issues are addressed.

For technical bugs and edge cases, see [properties.md](../engineering/properties.md) (C1-C6). This document covers conceptual limitations, design trade-offs, and security forensics that are not captured by the property/invariant framework.

---

## Status summary

| # | Issue | Category | Status |
|---|-------|----------|--------|
| L1 | "Certification" misnomer | Conceptual | Acknowledged |
| L2 | Vacuous specification problem | Conceptual | Partially addressed (taxonomy) |
| L3 | Z3 proofs are self-attestation | Conceptual | Acknowledged |
| L4 | No formal spec-to-intent link | Conceptual | Open |
| T1 | Survivorship bias in verified counts | Trade-off | Open |
| T2 | Blockchain alternatives exist | Trade-off | Acknowledged |
| T3 | Deterrence assumptions unexamined | Trade-off | Open |
| T4 | No separation of duties | Trade-off | Open |
| T5 | history.json is the practical source of truth | Trade-off | Open |
| S1 | No KMS-backed signing | Security | Open |
| S2 | DNS rebinding not fully mitigated | Security | Open |
| S3 | No Z3 binary integrity check | Security | Open |
| S4 | No Gnosis Safe on Sepolia | Security | Open |

---

## Fundamental limitations

### L1. "Certification" misnomer

The project calls itself "certification" while providing "attestation." These are categorically different:

- **Certification** implies an independent third party validated a claim against a standard, with accountability.
- **Attestation** means a party declares something to be true.

The system is BAIF attesting that BAIF ran Verus and Verus said "pass." The blockchain records that BAIF made this claim. This is notarized self-attestation, not certification.

**Status:** Acknowledged. The terminology is intentionally aspirational — the system is progressing from pure attestation toward certification (see the progression table in [spec.md](../product/spec.md)).

### L2. Vacuous specification problem

The system can produce a green "72/72 verified" badge for code where every function has `ensures true`. The taxonomy classification (functional-correctness, safety, etc.) is heuristic, not semantic. A vacuous postcondition classified as "functional-correctness" by a loose rule is still vacuous.

The headline metric (verified/total) conflates "has a specification" with "has a meaningful specification."

**Status:** Partially addressed. Spec taxonomy provides some signal. Spec quality metrics (trivial-spec detection, postcondition density) are identified as the next step — see [future.md](../product/future.md).

### L3. Z3 proofs are self-attestation by the same oracle

The Z3 proof pipeline re-invokes the same Z3 binary with `(set-option :proof true)` on the same formula. If Z3 has a soundness bug, both the original result and the proof term would be wrong. There is no independent checker (unlike Rocq's ~5K-line kernel).

**Status:** Acknowledged. The Z3 proofs are honestly described as "not yet independently checkable" but archived for future verification as proof-checking tools mature. See [future.md](../product/future.md) (independent proof checking).

### L4. No formal link between specifications and intent

The system proves that code satisfies specs. It does not prove that specs capture what users need. No part of the pipeline addresses this gap.

**Status:** Open. Two-signature certification (domain expert attests specs, BAIF attests verification) is proposed but not implemented — see [future.md](../product/future.md).

---

## Design trade-offs

### T1. Survivorship bias in "72/72 verified"

The metric counts only functions with Verus annotations. If a codebase has 200 functions but only 72 are annotated, the badge reads "72/72" — appearing to show complete coverage. The "total" in verified/total is the number of annotated functions, not the total function count.

**Status:** Open. Could be addressed by including total codebase function count alongside the verified count.

### T2. Blockchain alternatives exist

Signed Git tags, Certificate Transparency logs, and RFC 3161 timestamping could achieve similar properties (immutability, timestamping, public auditability) without gas fees.

**Status:** Acknowledged. The blockchain choice provides value in public discoverability and composability with the Ethereum ecosystem (Safe multisig, Etherscan verification), but is not strictly necessary for the core guarantee.

### T3. Deterrence assumptions

The "anyone could re-verify" argument assumes someone will actually do so, have the right tools, and care about the result. If nobody re-verifies, the deterrent is hollow.

**Status:** Open. The verify workflow lowers the barrier (single `workflow_dispatch` click), but independent re-verification by third parties has not been demonstrated.

### T4. No separation of duties

BAIF selects projects, runs verification, extracts specs, generates proofs, computes hashes, signs the transaction, maintains the registry, and hosts the badge. No separation of duties.

**Status:** Open. Two-signature certification is proposed but not implemented — see [future.md](../product/future.md). The Gnosis Safe provides some internal accountability (audit trail of which key signed), but the trust boundary is still "trust BAIF."

### T5. history.json is the practical source of truth

Despite the emphasis on blockchain immutability, the practical verification workflow reads `history.json` from a Git repository. If this file is tampered with, the blockchain event still exists but is harder to find without the index.

**Status:** Open. The `verify-hash` CLI command allows querying the blockchain directly, but discoverability still depends on the Git repository index.

---

## Security posture

### Resolved issues

Three security vulnerabilities were identified and fixed in the v2 contract (2026-02-17):

| Issue | Fix | KB reference |
|-------|-----|-------------|
| No contract access control — anyone could emit fake certifications | `AUTHORIZED_CERTIFIER` immutable + `onlyAuthorized` modifier | [P1](../engineering/properties.md) |
| Private key leaked via CLI args (`/proc/<pid>/cmdline`) | Environment variables via `env_extra` + `vm.envUint()` | [P7](../engineering/properties.md) |
| SSRF in `fetch_content` — CI runner could hit internal services | `_validate_url()` blocks private/loopback/reserved IPs, no redirects | [P6](../engineering/properties.md) |

### Contract redesign (v1 to v2)

| Aspect | v1 | v2 |
|--------|----|----|
| Functions | `certifyWebsite`, `certifyBatch`, `certifyVerificationProgress` | Single `certify()` |
| Access control | None | `AUTHORIZED_CERTIFIER` immutable |
| Event name | `WebsiteCertified` | `Certified` |
| Event fields | url, contentHash, sender, description, timestamp | identifier, contentHash, commitHash, description, schemaVersion, timestamp, sender, identifierHash |
| Git commit | Not recorded on-chain | `commitHash` (bytes32) |
| Schema version | Not present | `SCHEMA_VERSION = 2` (uint8) |
| Error handling | Silent failure | Custom error `UnauthorizedCertifier(caller, expected)` |

### Open security considerations

**S1. No KMS-backed signing.** Private keys are passed as environment variables, which is better than CLI args but still involves plaintext key handling. A KMS-backed signer (AWS KMS, GCP Cloud KMS, HashiCorp Vault) would eliminate plaintext keys entirely. Not yet implemented.

**S2. DNS rebinding not fully mitigated.** The SSRF validation (P6) resolves DNS and checks IPs, but a sophisticated DNS rebinding attack could bypass this by resolving to a public IP during validation and a private IP during the actual request. Full mitigation requires connecting to the resolved IP directly.

**S3. No Z3 binary integrity check.** The workflow uses whichever Z3 binary ships with Verus, with no integrity check. A supply-chain attack on the Verus distribution could substitute a modified Z3. Could be addressed by pinning Z3 binary hashes in the workflow. See also [C6](../engineering/properties.md).

**S4. No Gnosis Safe on Sepolia.** The Sepolia contract uses an EOA as the authorized certifier (sufficient for testing). A Safe should be set up on Sepolia if Safe-path integration testing is needed.

---

## Credit

The system is unusually honest about its limitations. The progression from pure attestation to spec-inspectable attestation with Z3 proof archival is genuine and valuable. The v2 contract hardening addresses the most actionable security issues. The roadmap correctly identifies the remaining gaps (spec quality, independent proof checking, separation of duties).

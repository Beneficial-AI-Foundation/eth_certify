---
title: "ADR-003: No Revocation"
last-updated: 2026-03-22
status: accepted
---

# ADR-003: No Revocation

## Context

What happens if a certification is later found to be incorrect? Should there be a mechanism to revoke it?

## Options considered

### A. On-chain revocation
- Add a `revoke(bytes32 contentHash)` function
- Emits a `Revoked` event; consumers must check for revocations
- Adds complexity to the contract and verification logic
- Requires maintaining a revocation set (storage costs)

### B. Off-chain revocation
- Mark certifications as revoked in `history.json` only
- On-chain event remains but off-chain metadata flags it
- Consumers who only check on-chain miss the revocation

### C. No revocation (chosen)
- Certifications are permanent once emitted as events
- Ethereum events are append-only by nature
- Newer certifications for the same identifier supersede older ones by convention

## Decision

Option C. Certifications are tied to specific commits and content hashes. A new certification at a different commit effectively supersedes the old one. There is no need to "un-say" a previous certification — it was true at the time it was made (BAIF did run Verus, and Verus did say "pass" at that commit).

If a certification is found to be flawed (e.g., vacuous specs, Z3 bug), the appropriate response is:
1. Document the issue
2. Fix the specs or verification pipeline
3. Re-certify at the corrected commit

## Consequences

- Simpler contract (no revocation state, no admin functions)
- Historical certifications remain queryable even if superseded
- Consumers should check the most recent certification for a given identifier, not just any
- No mechanism to retract a certification that was technically valid but misleading (e.g., "72/72 verified" where specs are vacuous)

---
title: "ADR-001: Immutable Authorized Certifier"
last-updated: 2026-03-22
status: accepted
---

# ADR-001: Immutable Authorized Certifier

## Context

The Certify contract needs access control — only BAIF should be able to create certifications. The question is whether the authorized address should be changeable after deployment.

## Options considered

### A. Mutable owner (OpenZeppelin Ownable)
- `transferOwnership()` allows changing the authorized address
- Standard pattern, well-audited
- Risk: owner key compromise allows silently transferring control

### B. Immutable address (chosen)
- `AUTHORIZED_CERTIFIER` is set once in the constructor, stored as `immutable`
- Cannot be changed after deployment — to switch certifiers, redeploy the contract
- Simpler contract, smaller attack surface, lower gas

### C. Role-based (OpenZeppelin AccessControl)
- Multiple roles with fine-grained permissions
- Overkill for a single-function contract

## Decision

Option B: immutable address. The contract has exactly one function (`certify()`), so a single immutable gatekeeper is sufficient. If the authorized address needs to change (e.g., new Safe deployment), redeploy the contract. The old contract's events remain valid and queryable.

## Consequences

- Changing the certifier requires a new contract deployment and updating all workflows/configs to the new address
- Historical certifications on the old contract remain valid
- The contract is simpler to audit (no ownership transfer logic, no admin functions)
- Gas savings: `immutable` is cheaper than storage reads

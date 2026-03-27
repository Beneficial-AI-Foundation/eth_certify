---
title: Engineering
last-updated: 2026-03-22
status: draft
---

# Engineering

How the certify system is built. Architecture, schema, invariants, terminology.

## Files

- **[architecture.md](architecture.md)** — Four layers: Contract, CLI, Workflows, Registry. Data flow between them.
- **[schema.md](schema.md)** — On-chain event schema, Merkle leaf structure, registry file formats
- **[properties.md](properties.md)** — Invariants and correctness constraints that all implementations must preserve
- **[glossary.md](glossary.md)** — Precise definitions of domain terms used across the system
- **[testing.md](testing.md)** — Test strategy: what each test defends, coverage by property, mock strategy, intentional gaps

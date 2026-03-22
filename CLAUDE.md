# CLAUDE.md — certify

## Project Overview

On-chain certification of formally verified code. A Solidity contract (`Certify.sol`) records Merkle-hashed verification results on Ethereum, gated by an authorized certifier (BAIF Gnosis Safe). A Python CLI (`certify-cli`) handles deployment, certification, verification, proof bundle generation, and registry management.

## Build and Test

```bash
# Solidity (Foundry)
forge build
forge test -vvv

# Python CLI (uv)
uv sync
uv run ruff check certify_cli/
uv run mypy certify_cli/
uv run pytest tests/ -v
```

## Knowledge Base

- The `kb/` directory is the **source of truth** for the certify system. It defines what the system should be. The code is an implementation of that definition.
- Read `kb/index.md` before starting any task to orient yourself.
- If your implementation contradicts `kb/engineering/schema.md`, `kb/engineering/architecture.md`, or `kb/engineering/properties.md`, your implementation is wrong. Fix the code, not the KB.
- KB specification files (engineering/, product/, decisions/) are only updated when the human explicitly refines the intent — never to accommodate implementation shortcuts.
- When creating new features that EXTEND the spec without contradicting it, add a corresponding KB entry and run the kb-update skill.
- After significant changes, run the kb-update skill to verify KB consistency.

## Working With the Knowledge Base

- Before implementing any task, read `kb/index.md` and load the relevant KB files.
- The KB is the specification. Your code must conform to it.
- Use `kb/engineering/properties.md` as your correctness checklist — every change must preserve listed invariants. If you cannot satisfy a property, stop and ask — do not silently drop or weaken it.
- Use `kb/engineering/glossary.md` for terminology — use the exact terms defined there.
- When the task is ambiguous, check `kb/product/spec.md` and `kb/engineering/architecture.md` before asking the user. The answer is often already documented.
- If you find a contradiction between your implementation and the KB, the implementation is wrong. Fix the code to match the spec.
- Reference KB files in commit messages when a change is driven by a KB property or design decision.

## Development Loop (Ralph Loop)

For every implementation task:
1. Implement the change
2. Run all relevant auditor skills (`/ambiguity-auditor`, `/code-quality-auditor`, `/test-quality-auditor`)
3. Read the audit reports in `kb/reports/`
4. Fix every issue found
5. Repeat steps 2-4 until all auditors pass clean
6. Run the validation suite (`forge test && uv run pytest tests/ -v && uv run ruff check certify_cli/`) before considering the task done

Never skip the audit step. Never mark a task complete with unresolved audit findings.

### When to run the full loop

Run it when touching:
- Smart contract logic (`src/Certify.sol`)
- Merkle hashing or content hash computation (`envelope.py`)
- Certification or verification flow (`deploy.py`, `verify.py`, `verify_certification.py`)
- Proof bundle generation (`proofs.py`)
- Registry management (`registry.py`)
- Anything that could violate a property in `kb/engineering/properties.md`

For trivial changes (typo fixes, comment updates, dependency bumps), the full loop is overkill — just run `forge test`, `uv run pytest tests/ -v`, and `uv run ruff check certify_cli/`.

### Chaining in a single prompt

The user may ask you to run the full loop in one shot:
```
Implement [feature]. Then run the Ralph Loop: run all three auditor
skills, fix every issue, repeat until clean, then run the tests.
```
When asked this way, loop autonomously through implement → audit → fix cycles until convergence.

### After spec changes

When the user deliberately changes a design decision or adds a capability, run `/kb-update` to sync the KB. The kb-update skill checks whether code changes contradict the KB and adds entries for new concepts.

## Key Properties

The following invariants (from `kb/engineering/properties.md`) are most commonly relevant:
- **P1**: Only `AUTHORIZED_CERTIFIER` can call `certify()`
- **P3**: Merkle integrity — `content_hash = keccak256(results_hash || specs_hash [|| proofs_hash])`
- **P6**: SSRF prevention — URL validation blocks private/loopback/reserved IPs
- **P7**: Key confidentiality — private keys via env vars, never CLI args
- **P8**: Registry consistency — `history.json` matches on-chain events
- **P9**: Proof bundle completeness — all referenced files exist with correct hashes

## Project Structure

```
src/
  Certify.sol           # On-chain certification contract (Solidity)
test/
  Certify.t.sol         # Foundry tests for the contract
script/
  Certify.s.sol         # Foundry deployment script
certify_cli/
  __main__.py           # CLI entry point (deploy, certify, verify, generate-proofs, etc.)
  config.py             # Configuration loading (.env, certify.conf)
  deploy.py             # Contract deployment and certification transactions
  verify.py             # On-chain verification (content hash lookup)
  verify_certification.py  # Local registry + hash + Merkle structure verification
  envelope.py           # Merkle-style hashing (content hash computation)
  proofs.py             # Z3 proof bundle generation
  registry.py           # Certification registry management (badges, history)
  safe.py               # Gnosis Safe transaction integration
  foundry.py            # Forge subprocess wrapper + URL fetching + SSRF validation
action/
  action.yml            # Reusable GitHub Action for certification
certifications/         # On-disk certification registry (per-project folders)
kb/                     # Knowledge base (source of truth)
doc/                    # Design documents, reviews, proposals (reference, not normative)
.claude/skills/         # Auditor skills for the Ralph Loop
```

## Commit Message Style

Conventional commits. Reference KB files when applicable:
```
fix: validate URL scheme before DNS resolution (P6)
feat: add proof bundle hash to Merkle tree (P3, ADR-002)
```

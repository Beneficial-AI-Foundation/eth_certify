---
auditor: ambiguity-auditor
date: 2026-03-22
status: 0 critical, 0 warnings, 2 info
---

## Critical

(none — all critical issues resolved)

- ~~[C1] history.json field name mismatch~~ — **Fixed**: schema.md updated to use `"timestamp"` matching the code and existing files.
- ~~[C2] history.json bare array vs wrapper object~~ — **Fixed**: schema.md updated to show `{"certifications": [...]}` wrapper.

## Warnings

(none — all warnings resolved)

- ~~[W1] `probe-verus` not in glossary~~ — **Fixed**: glossary entry added.
- ~~[W2] `test.yml` not in architecture.md~~ — **Fixed**: added to workflow list.

## Info

### [I1] Testing.md test count should be verified periodically
- **Location**: kb/engineering/testing.md, line 35
- **Issue**: States "95 tests". After adding 10 new tests, the actual count is now 105. The testing.md count is stale.
- **Recommendation**: Update testing.md to reflect 105 tests, or remove the exact count.

### [I2] Schema.md badge.json example omits fields present in code
- **Location**: kb/engineering/schema.md, lines 94-103
- **Issue**: The `badge.json` example omits `"namedLogo"` and `"logoColor"` fields that `registry.py::_create_badge_json` includes. Cosmetic, not correctness-critical.
- **Recommendation**: Optionally update example for completeness.

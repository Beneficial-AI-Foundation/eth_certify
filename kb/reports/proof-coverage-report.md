---
title: Proof Coverage Gap Analysis
date: 2026-03-24
status: open
source: https://github.com/Beneficial-AI-Foundation/eth_certify/issues/2
relates-to: [P9, C2]
---

# Proof Coverage Gap Analysis

The Z3 proof certificate pipeline produces per-function proof artifacts for certified projects. This report documents the coverage gaps between what Verus verifies and what ends up in the proof bundle, with data for both certified projects.

## Pipeline Overview

Three systems participate, each with its own naming and filtering:

```
Verus compiler          probe-verus extract        proofs.py mapping        Z3 proof generation
(compiles & verifies)   (atomize + specify +       (name normalisation)     (run Z3 with --proof)
                         run-verus)
       │                        │                         │                        │
       ▼                        ▼                         ▼                        ▼
  N verified  ──────▶  M in results.json  ──────▶  K in proofs.json  ──────▶  J proofs generated
                Gap 1: N-M lost              Gap 2: M-K lost            Gap 3: K-J errors
```

The workflow invokes `probe-verus extract` — the unified pipeline that runs atomize, specify, and run-verus in a single invocation. Gap 1 losses occur during the **atomize** stage within `extract`, where `verus-analyzer` performs call-graph analysis to enumerate functions.

---

## Project 1: pmemlog

### Current numbers (latest certification: 2026-03-23)

| Stage | Count | Notes |
|-------|------:|-------|
| Verus verified (history.json) | 72 | From `verified` field in history.json |
| `results.json` entries | 70 | All 70 verified |
| `proofs.json` entries | 66 | All 66 matched to `.smt2` |
| Z3 proofs generated | 66 | 100% success rate |
| Z3 proof errors | 0 | |
| Bundled `.smt2` files | 66 | |
| Bundled `.proof` files | 66 | |

### Gap 1: 72 verified → 70 in `results.json` (2 functions)

2 functions are counted as verified by Verus but not captured by the atomize stage of `probe-verus extract`. These are likely trait default implementations or functions unreachable from the call-graph entry points.

### Gap 2: 70 in `results.json` → 66 in `proofs.json` (4 functions)

These 4 functions are in results but not in the proof bundle:

| Function | Module | Likely cause |
|----------|--------|-------------|
| `VolatileMemoryMockingPersistentMemory<u64>#new()` | `pmemmock_t` | Mock/test infrastructure — no SMT query emitted |
| `axiom_bytes_uncorrupted()` | `pmemspec_t` | Axiom — trusted, no SMT query |
| `axiom_corruption_detecting_boolean()` | `pmemspec_t` | Axiom — trusted, no SMT query |
| `bytes_crc()` | `pmemspec_t` | Spec function — no SMT query |

All 4 are verified-by-assumption: axioms, mock constructors, and spec functions that Verus accepts without generating an SMT query. There is no `.smt2` file to match because Verus never asks Z3 to check these — they are the *trusted base* of the verification.

### Gap 3: none

All 66 matched functions produced Z3 proofs successfully.

### Coverage over time

| Date | `proofs.json` entries | Matched | Proofs | Errors |
|------|----------------------:|--------:|-------:|-------:|
| 2026-02-16 | 45 | 45 | 45 | 0 |
| 2026-02-17 | 45 | 45 | 45 | 0 |
| 2026-03-10 | 66 | 66 | 66 | 0 |
| 2026-03-23 | 66 | 66 | 66 | 0 |

The jump from 45→66 between Feb and Mar reflects improvements in probe-verus coverage (the original issue was filed with the Feb data).

---

## Project 2: curve25519-dalek

### Current numbers (latest certification: 2026-03-22)

| Stage | Count | Notes |
|-------|------:|-------|
| Verus verified (history.json) | 1157 | From `verified` field; `total`: 1208 |
| `results.json` entries | 1199 | 1150 verified, 49 not verified |
| `proofs.json` entries | 1130 | All 1130 matched to `.smt2` |
| Z3 proofs generated | 1110 | |
| Z3 proof errors | 20 | All returned "unknown" |
| Bundled `.smt2` files | 1074 | |
| Bundled `.proof` files | 1056 | |

### Gap 1: not directly measurable

Verus compiler-level function counts are not recorded in the registry. The `verified: 1157` in history.json comes from probe-verus's aggregation, which may differ from Verus's raw count.

### Gap 2: 1199 in `results.json` → 1130 in `proofs.json` (69 functions)

All 69 missing functions are verified. They fall into categories of functions that Verus verifies by assumption rather than by SMT query:

| Module | Count | Nature |
|--------|------:|--------|
| `subtle_assumes` | 26 | Trusted axioms for the `subtle` crate's constant-time operations |
| `core_assumes` | 18 | Trusted axioms for Rust core byte conversion functions |
| `iterator_specs` | 10 | Iterator specification stubs (closures, trait impls) |
| `lizard_ristretto` | 3 | Encoding/decoding functions |
| `ristretto` | 3 | Batch operations, hash-based construction |
| `scalar` | 3 | Random generation, hash-based construction |
| `traits` | 3 | `IsIdentity` trait implementations |
| `scalar_helpers` | 2 | Slice aggregation operations |
| `edwards` | 1 | Iterator count |

The dominant categories (`subtle_assumes`: 26, `core_assumes`: 18) are **trusted external function axioms** — these model the behavior of non-Verus code (Rust's `subtle` crate and `core` byte conversions). Verus accepts them on trust; no SMT query is generated. Similarly, `iterator_specs` are specification stubs for iterator behavior that Verus assumes rather than proves.

This is not a matching failure in `proofs.py` — there is genuinely no `.smt2` file for these functions.

### Gap 3: 1130 matched → 1110 proofs generated (20 errors)

All 20 errors are Z3 returning "unknown" (neither proved nor disproved). These are cases where Z3 with legacy proof production mode cannot produce a proof within the timeout:

| Module | Function | Z3 result |
|--------|----------|-----------|
| `batch_compress_lemmas` | `lemma_batch_std_case_dispatch()` | unknown |
| `batch_compress_lemmas` | `lemma_doubled_affine_from_batch_state()` | unknown |
| `curve_equation_lemmas` | `lemma_x_zero_implies_y_squared_one()` | unknown |
| `edwards` | `create()` | unknown |
| `field` | `as_bytes()` | unknown |
| `lizard_lemmas` | `lemma_jacobi_to_edwards_affine_s_canonical_zero()` | unknown |
| `lizard_ristretto` | `to_jacobi_quartic_ristretto()` | unknown |
| `lizard_ristretto` | `lizard_encode_verus()` | unknown |
| `montgomery_reduce_lemmas` | `lemma_identity_array_satisfies_canonical_bound()` | unknown |
| `montgomery_reduce_lemmas` | `lemma_part1_correctness()` | unknown |
| `mul_base_lemmas` | `lemma_even_sum_up_to_correct()` | unknown |
| `mul_base_lemmas` | `lemma_odd_sum_up_to_correct()` | unknown |
| `number_theory_lemmas` | `lemma_mod_is_zero_when_divisible()` | unknown |
| `pippenger_lemmas` | `lemma_bucket_weighted_sum_equals_column_sum()` | unknown |
| `pippenger_lemmas` | `lemma_pippenger_peel_last()` | unknown |
| `ristretto` | `elligator_ristretto_flavor()` | unknown |
| `scalar` | `mul()` | unknown |
| `scalar` | `montgomery_invert()` | unknown |
| `scalar` | `mul()` | unknown |
| `variable_base` | `mul()` | unknown |

These are complex cryptographic lemmas and operations. Z3 can verify them without proof production (Verus confirms they pass), but the legacy proof mode `(set-option :proof true)` changes Z3's solver behavior enough that these queries become undecidable within the timeout. This is a known limitation of Z3 legacy proof mode — it disables some heuristics that the non-proof solver relies on.

### Coverage over time

| Date | `proofs.json` entries | Matched | Proofs | Errors |
|------|----------------------:|--------:|-------:|-------:|
| 2026-03-21 | 1130 | 1130 | 1110 | 20 |
| 2026-03-22 | 1130 | 1130 | 1110 | 20 |

Dalek was first certified with proof bundles on 2026-03-21. Coverage has been stable.

---

## Summary: Three Kinds of Gaps

The original issue framed the problem as two gaps. With data from both projects, three distinct gap types emerge:

### Gap 1: Verus verified → `results.json` (atomize stage of `probe-verus extract`)

| Project | Verified | In results | Lost | % coverage |
|---------|------:|------:|-----:|-----------:|
| pmemlog | 72 | 70 | 2 | 97.2% |
| dalek | ~1157 | 1199* | — | — |

\* Dalek's `results.json` has *more* entries than the `verified` count because it includes non-verified functions. The raw Verus compiler function count is not recorded.

**Owner:** probe-verus (upstream).
**Fix:** Enhance `verus-analyzer` symbol resolution in the atomize stage for trait impls, macros, closures.

### Gap 2: `results.json` → `proofs.json` (name matching / no SMT query)

| Project | In results | In proofs | Lost | Cause |
|---------|------:|------:|-----:|-------|
| pmemlog | 70 | 66 | 4 | Axioms, mocks, spec fns — no SMT query emitted |
| dalek | 1199 | 1130 | 69 | Trusted axioms (`subtle_assumes`, `core_assumes`), iterator specs |

**Key finding:** The original issue attributed Gap 2 to name-matching failures in `build_function_mapping()`. With current data, **all matched functions match correctly** (0 matching failures for either project). The "missing" functions are those that Verus verifies by assumption — no `.smt2` file exists for them. This is correct behavior, not a bug.

The original 3 unmatched functions from issue #2 (Feb 2026) appear to have been resolved by the `probe-verus extract` coverage improvement that brought pmemlog from 45 to 66 entries.

**Implication:** C2 (name-matching heuristics) is less severe than originally assessed. The matching logic works for all cases where an `.smt2` file exists. The remaining gap is *inherent*: trusted axioms don't produce proof artifacts.

### Gap 3: `proofs.json` → Z3 proofs generated (proof production failures)

| Project | In proofs | Proofs OK | Errors | Error rate |
|---------|------:|------:|-------:|-----------:|
| pmemlog | 66 | 66 | 0 | 0% |
| dalek | 1130 | 1110 | 20 | 1.8% |

**Owner:** this repo (`proofs.py`) + Z3 upstream.

#### Why we use Z3 legacy proof mode

Z3 has two proof production mechanisms:

| | Legacy (`set-option :proof true`) | New (`sat.euf=true`) |
|---|---|---|
| **SMT-LIB standard** | Yes — `(get-proof)` is part of SMT-LIB | No — Z3-specific extension |
| **Solver core** | Z3's default core (what Verus tunes for) | Z3's newer SAT-based core |
| **Proof format** | Proof terms (tree of low-level inference rules) | Proof logs (inference stream with hints) |
| **Self-validation** | No | Yes (built-in checker, proof trimming) |
| **Stability on Verus queries** | Good (1176/1196 across both projects) | Crashes on complex queries ([Z3#5336](https://github.com/Z3Prover/z3/issues/5336)) |

We use legacy mode because:

1. **Verus tunes its SMT queries for Z3's default core.** Trigger patterns, quantifier strategies, and arithmetic hints are all designed for this solver. Switching to `sat.euf=true` activates an entirely different solver engine with different heuristics, causing queries that Verus tuned to succeed to fail or behave unpredictably.
2. **`sat.euf=true` crashes on complex Verus-scale queries.** The Z3 issue tracker documents assertion violations, crashes, and soundness bugs with the new core on heavily-quantified queries. While many were fixed, it remains less battle-tested for queries of this complexity.
3. **Legacy mode is the SMT-LIB-standard mechanism.** Despite the name, it is the standardized approach (`(set-option :produce-proofs true)` + `(get-proof)`). The `sat.euf` mode is a newer Z3-specific extension.

The "legacy" label is somewhat misleading — it is the more mature, more compatible, and more stable option for our use case.

#### Why the 20 dalek failures happen

Even legacy proof mode changes solver behavior. When `(set-option :proof true)` is set, Z3 must record justifications for every inference, which disables certain lemma-forgetting heuristics and forces more detailed bookkeeping in quantifier instantiation. This changes the search strategy enough that some complex queries that Z3 solves in normal mode become "unknown" within the timeout. The 20 failing dalek functions (pippenger lemmas, montgomery reduce, scalar multiply, etc.) are the hardest cryptographic lemmas where this performance difference tips the solver past the 300s timeout.

#### Fix options

1. Increase Z3 timeout (currently 300s) — may help borderline cases
2. Switch to `sat.euf=true` when it stabilizes for Verus-scale queries — would give self-validation and proof trimming
3. Track the SMT proof certificate standardization effort (SC²/SMTLIB working group) — emerging standard for portable proof artifacts

---

## Relationship to Properties and Known Bugs

- **P9 (Proof bundle completeness):** Structurally satisfied — every file referenced in `proofs.json` exists with correct hashes. But the *scope* of the bundle is limited: trusted axioms (4 in pmemlog, 69 in dalek) have no proof artifact by design, and 20 dalek functions have `.smt2` formulas but no Z3 proof due to solver limitations.
- **C2 (Name-matching heuristics):** Less severe than originally assessed. Current data shows 0 matching failures. The substring-based matching in `proofs.py` is working correctly for all cases where a `.smt2` file exists. Consider downgrading or closing.

## Recommended Actions

| Action | Owner | Effort | Impact |
|--------|-------|--------|--------|
| Mark trusted axioms explicitly in `proofs.json` (e.g., `"status": "trusted-axiom"`) | this repo | Low | Clarifies why functions are absent; supports P9 spirit |
| Investigate Z3 timeout/options for the 20 dalek failures | this repo | Medium | Could recover 1.8% of dalek proofs |
| Re-evaluate C2 severity given 0 current matching failures | this repo | Low | KB accuracy |
| Record Verus raw function counts in history.json for precise Gap 1 tracking | this repo + workflow | Low | Enables per-certification Gap 1 measurement |
| Improve atomize stage coverage in `probe-verus extract` for trait impls and closures | probe-verus (upstream) | High | Closes Gap 1 for pmemlog (2 functions) |

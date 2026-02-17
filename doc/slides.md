---
marp: true
theme: default
paginate: true
footer: "Beneficial AI Foundation — BAIF Certify"
---

<!-- _class: lead -->

# BAIF Certify

### On-Chain Certification for Formally Verified Code

Mathematically verify software correctness.
Record the proof on Ethereum — permanently, publicly, independently verifiable.

---

# The Problem

| Traditional Assurance | Formal Verification |
|---|---|
| Unit tests (finite cases) | Mathematical proof |
| Code review (human judgment) | All possible inputs |
| "Works on my machine" | Mechanically checked |

**But even formal verification has a gap:**

- Proofs live as local build artifacts
- No permanent, tamper-evident record
- No way for third parties to audit *when* or *what* was verified

---

# What BAIF Certify Does

```
  Source Code        Verification        Spec             Z3 Proof           On-Chain          Public
  + Specs            Engine              Extraction       Certificates       Certification     Badge
┌───────────┐   ┌─────────────┐   ┌────────────┐   ┌─────────────┐   ┌────────────┐   ┌───────────┐
│ Rust Code │──▶│   Verus     │──▶│  probe-    │──▶│  Z3 proof   │──▶│  Ethereum  │──▶│  Badge    │
│ + Verus   │   │   + Z3 SMT  │   │  verus     │   │  production │   │  Event Log │   │ + History │
│ Annots    │   │   Solver    │   │  specify   │   │  per func   │   │  (Merkle)  │   │ + Proofs  │
└───────────┘   └─────────────┘   └────────────┘   └─────────────┘   └────────────┘   └───────────┘
     Input            Proof         Spec Manifest     Proof Bundle        Record           Display
```

Five layers: **verify**, **extract specs**, **generate Z3 proofs**, **certify (Merkle)**, **display**.

---

# Layer 1: Formal Verification with Verus

**What Verus proves** — for ALL inputs satisfying preconditions:
- Postconditions hold
- Loop invariants maintained
- No array out-of-bounds, no integer overflow

**Output:** `results.json` — per-function verification status

---

# Layer 1: Verification Output

```json
{
  "PersistentMemoryLogHeader::spec_crc":  { "verified": true, "time_ms": 89 },
  "PersistentMemoryLogHeader::check_crc": { "verified": true, "time_ms": 142 },
  "UntrustedLogImpl::start":              { "verified": true, "time_ms": 203 },
  ...
  "summary": { "verified": 72, "total": 72, "errors": 0 }
}
```

This is the artifact we certify on-chain.

---

# Layer 1.5: Z3 Proof Certificate Generation

**New:** After verification, we extract per-function Z3 formulas and produce proof terms.

```
  Verus --log smt -V spinoff-all
  ──────────────────────────────
  93 .smt2 files (per-function SMT queries)
       │
       ▼
  certify_cli generate-proofs
  ───────────────────────────
  For each function:
    1. Map probe-verus function ID → .smt2 file
    2. Inject (set-option :proof true) + (get-proof)
    3. Run Z3 → produce .proof file
       │
       ▼
  proof-bundle/
    proofs.json           ← per-function index
    smt_queries/*.smt2    ← the Z3 formulas (standard SMT-LIB2)
    z3_proofs/*.proof     ← the Z3 proof terms
```

**Result:** 45 functions → 45 formulas + 45 proofs (pmemlog, ~5 seconds total)

---

# Layer 2: On-Chain Certification (Merkle Hashing)

The `Certify.sol` smart contract records a **content hash** on Ethereum.
The hash is a Merkle root of up to three leaves — results, specs, and (when available) Z3 proofs:

```
  results.json ──▶ results_hash = keccak256(results.json)   ─┐
                                                             │
  specs.json   ──▶ specs_hash   = keccak256(specs.json)     ─┼──▶ content_hash = keccak256(r || s [|| p])
                                                             │           │
  proofs.json  ──▶ proofs_hash  = keccak256(proofs.json)    ─┘           ▼
    (optional)                                                     on-chain event
```

```solidity
function certify(
    string calldata identifier,   // project id, e.g. "owner/repo"
    bytes32 contentHash,          // Merkle root: keccak256(results_hash || specs_hash [|| proofs_hash])
    bytes32 commitHash,           // git commit SHA as bytes32
    string calldata description   // "pmemlog: 72/72 verified"
) external onlyAuthorized {
    emit Certified(
        keccak256(bytes(identifier)),  // indexed for lookup
        contentHash,                   // Merkle root
        msg.sender,                    // BAIF Safe address
        identifier, commitHash, description,
        SCHEMA_VERSION, block.timestamp
    );
}
```

**Stateless** — emits events only, no storage, no upgrades.
**Access controlled** — only `AUTHORIZED_CERTIFIER` (BAIF Safe) can call.
One transaction, one gas cost. All leaf hashes stored in `history.json`.

---

# Layer 2: What Gets Recorded

```
  results.json ──▶ results_hash  ─┐
                                  │
  specs.json   ──▶ specs_hash    ─┼──▶ content_hash ──▶  Ethereum Event
                                  │    (Merkle root)    ┌─────────────────────┐
  proofs.json  ──▶ proofs_hash   ─┘                     │ contentHash = 0x…   │
  (+ smt_queries/  (optional)                           │ sender      = 0x8EA…│
   + z3_proofs/)                                        │ block       = 24196…│
                                                        │ timestamp   = 1737… │
                                                        └─────────────────────┘
```

**Anyone can verify (Merkle path):**
1. Fetch `results.json`, `specs.json`, and `proofs.json` from our repo
2. Compute `keccak256` of each → compare with recorded hashes in `history.json`
3. Compute `keccak256(results_hash || specs_hash [|| proofs_hash])` → compare with on-chain `contentHash`
4. Match → all files are authentic, none have been tampered with
5. Read `specs.json` to judge: are these the properties that matter?
6. Inspect `proofs.json` → open the `.smt2` and `.proof` files to examine the Z3 evidence

---

# Layer 3: Trust Model

```
┌──────────────────────────────────────────────────────┐
│  GNOSIS SAFE (Multisig Wallet)                       │
│  0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e          │
│  • Team identity    • Key rotation    • Audit trail  │
└───────────────────────────┬──────────────────────────┘
                            │ signs & executes
                            ▼
┌──────────────────────────────────────────────────────┐
│  CERTIFY CONTRACT                                    │
│  0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c          │
│  • No owner   • No admin   • Events only             │
└───────────────────────────┬──────────────────────────┘
                            │ emits event
                            ▼
┌──────────────────────────────────────────────────────┐
│  ETHEREUM EVENT LOG                                  │
│  Immutable • Append-only • Queryable forever         │
└──────────────────────────────────────────────────────┘
```

---

<!-- _class: lead -->

# GitHub Workflows

Automating the certification and verification pipeline

---

# Workflow Overview

Two main workflows:

| Workflow | Trigger | Purpose |
|---|---|---|
| Certification workflow | Manual dispatch | Verify + certify any Verus project |
| Verification workflow | Manual dispatch | Independently verify a certification |

---

# Certification Workflow

**`certify-external.yml`** — triggered manually with a repo URL, ref, and network.

```
┌────────────┐ ┌─────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐
│ Clone repo │ │ probe-verus │ │ probe-verus│ │ generate-  │ │ certify_cli│ │ update-    │
│ at ref     │▶│ verify      │▶│ specify    │▶│ proofs     │▶│ certify    │▶│ registry   │
│            │ │ +SMT logs   │ │            │ │ (Z3 proof) │ │ (Merkle)   │ │            │
│ target/    │ │ results.json│ │ specs.json │ │proof-bundle│ │ --safe     │ │badge + hist│
└────────────┘ └─────────────┘ └────────────┘ └────────────┘ └────────────┘ └────────────┘
                                                                   │
                                                                   ▼
                                                            Ethereum Event
                                                            tx: 0x09f0ee…
```

| Step | What happens | Tool |
|---|---|---|
| **Verify** | Install Verus, run `probe-verus verify` with SMT logging → `results.json` + `.smt2` files | `probe-verus/action@v1` |
| **Specify** | Extract specs from source → `specs.json` | `probe-verus specify` |
| **Proofs** | Map functions to `.smt2`, run Z3 with proof production → proof bundle | `certify_cli generate-proofs` |
| **Certify** | Merkle hash (results + specs + proofs) → sign via Gnosis Safe → submit to Ethereum | `certify_cli certify` |
| **Registry** | Generate badge, append to `history.json`, archive results + specs + proof bundle | `certify_cli update-registry` |
| **Commit** | Push updated certification files to this repo | `git commit && push` |

Single GitHub Actions job — no human intervention after dispatch.

---

# Verification Workflow

**`verify.yml`** — triggered manually with a repo URL, commit SHA, and network.

```
┌──────────────────────────────────────────┐ ┌────────────┐ ┌────────────┐
│ certify_cli verify-certification         │ │ On-chain   │ │ Fresh Verus│
│                                          │ │ event      │ │ re-run     │
│  Registry lookup + hash check + Merkle   │▶│ query      │▶│ & compare  │
│  structure + proof bundle + taxonomy     │ │ eth_getLogs│ │ probe-verus│
│  (single Python command, JSON output)    │ │            │ │            │
└──────────────────────────────────────────┘ └────────────┘ └────────────┘
```

The `verify-certification` command performs all local checks in one call:

| Check | What it verifies | Catches |
|---|---|---|
| **Registry lookup** | Find certification by commit SHA + network | Missing certifications |
| **Stored hashes** | `keccak256(stored file)` = recorded hash? (results, specs) | Tampered artifacts |
| **Merkle structure** | `keccak256(results_hash \|\| specs_hash [\|\| proofs_hash])` = on-chain `contentHash`? | Inconsistent Merkle tree |
| **Proof bundle** | All `.smt2` and `.proof` files referenced in `proofs.json` exist? | Missing/corrupt proof artifacts |
| **Taxonomy** | Extract spec-label summary from stored specs | N/A (informational) |

Followed by workflow-level steps:

| Step | What it checks | Catches |
|---|---|---|
| **On-chain check** | Query Ethereum for the certification event | Fake/deleted certifications |
| **Fresh re-verification** | Re-run Verus, compare verified/total counts | Non-reproducible results |

**Outcome:** Passed (all match), Partial (authentic but counts differ), or Failed.

---


# Badge System

Badges update automatically after each certification:

| Coverage | Badge | Color |
|---|---|---|
| 100% | `BAIF Certified — 72/72 verified` | Green |
| 50-99% | `BAIF Certified — 45/72 verified` | Yellow |

**Integration:**
```markdown
[![BAIF Certified](https://raw.githubusercontent.com/.../badge.svg)](
  https://github.com/.../certifications/project-id/history.json)
```

Badge links to `history.json` — the full audit trail with toolchain versions,
commit hashes, transaction hashes, and Etherscan links.

---

# Security Properties

| Threat | Mitigation |
|---|---|
| Fake certification | Contract enforces `AUTHORIZED_CERTIFIER` (immutable); only BAIF Safe can call `certify()` |
| Tampered results | keccak256 hash on-chain; any change produces different hash |
| Deleted certification | Ethereum events are append-only; always queryable |
| Backdated certification | Block timestamp from consensus; infeasible to forge |
| Key compromise | Gnosis Safe enables key rotation; keys passed via env vars (not CLI args) |
| SSRF via content source | URL validation blocks private/loopback IPs; only http/https; no redirects |
| Contract vulnerability | Minimal contract — events only, no state, single function, on-chain access control |

---

# Deployed Infrastructure

| Component | Network | Address |
|---|---|---|
| Certify Contract (v2) | Mainnet | `0x7774c8804a462bB7d5D33f2ad4fcc4A6FC67d399` |
| Certify Contract (v2) | Sepolia | `0x7a1bdfE0F2F9B4110301371Fa26BB3a4719b2A9F` |
| BAIF Safe | Mainnet | `0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e` |

All contract source code is verified on Etherscan. The v2 contract enforces
on-chain access control: only the `AUTHORIZED_CERTIFIER` (BAIF Safe) can
call `certify()`.

---

# What "Certified" Means (and Doesn't)

**What a BAIF certification proves:**
- Verus accepted the formal specs — machine-checked mathematical proof
- The result is cryptographically bound to a Merkle root of results + specs + Z3 proofs
- The hash is immutably recorded on Ethereum with a timestamp
- The actual specs (pre/postconditions) are published and independently inspectable
- The Z3 formulas and proof terms are archived and verifiable

**What it does NOT prove:**
- That the specs capture what users actually care about
- That specifications are complete (they may miss properties)
- That external dependencies are correct

**The honest statement:**
> We have built the **infrastructure** for certification and made both the "theorem
> statements" and their "evidence" first-class, inspectable artifacts. The Z3 proof
> bundle brings us significantly closer to a true proof certificate model.

---

<!-- _class: lead -->

# Why Not Docker Images for Reproducibility?

---

# The Docker Reproducibility Argument

The idea: ship a Docker image per project so anyone can reproduce verification locally.

```
  Project repo  ──▶  Docker image  ──▶  Run locally  ──▶  "Same result"
                     (Verus + deps +
                      pinned source)
```

Sounds easy. But it introduces a set of problems heavier
than the one it solves.

---

# Problem 1: We Become a Project Registry

Docker images require us to **store** each project's source code and dependencies.

But projects are not static artifacts. They are living codebases:
- Patches, security fixes, feature branches
- Dependency updates, toolchain upgrades
- Multiple verified versions over time

Storing a snapshot is easy. Tracking a living project is not.

We would need to:
- Mirror repositories (or fork them)
- Monitor upstream changes
- Decide which versions to keep, which to retire

This becomes a project registry, not a certification service.

---

# Problem 2: Scope Creep Kills Focus

BAIF's core mission: **certify formally verified code on-chain.**

| Task | Core mission? |
|---|---|
| Running Verus, recording results on Ethereum | Yes |
| Maintaining Docker images for N projects | No |
| Tracking upstream repos for updates | No |
| Rebuilding images when Verus/Rust versions change | No |
| Debugging Docker build failures for other people's code | No |
| Hosting and distributing multi-GB images | No |

Every hour spent maintaining Docker infrastructure is an hour
**not** spent improving verification tooling, spec quality, or the certification protocol.

---

# The Verification Workflow Already Solves This

Our `verify.yml` workflow provides **stronger** reproducibility guarantees
than a Docker image — without any of the maintenance burden:

```
  verify.yml
  ┌─────────────────────────────────────────────────────┐
  │  1. Clone the exact commit from the project's repo  │
  │  2. Install Verus (version from Cargo.toml)         │
  │  3. Run fresh verification                          │
  │  4. Compare results with on-chain certification     │
  └─────────────────────────────────────────────────────┘
```

**The project owner hosts their own code.** We just point at it.

---

# Verification Workflow vs Docker: Comparison

| Property | Docker Image | Verification Workflow |
|---|---|---|
| Source of truth | Our copy (stale risk) | Upstream repo (always current) |
| Storage burden | Us (GB per project) | Project owner (zero for us) |
| Toolchain pinning | Baked into image | Derived from `Cargo.toml` |
| Tracks new versions | Manual rebuild needed | Just run on new commit |
| Maintenance cost | High (N images x M versions) | Near zero |
| Trust model | "Trust our image" | "Trust the math, verify yourself" |
| Who hosts the code | We do | They do |

---

# The Key Insight

We don't need to **store** projects. We need to **point at** them.

```
  Certification record:
  ┌─────────────────────────────────────────────────┐
  │  repo:       github.com/owner/project           │
  │  commit:     a1b2c3d4...                        │
  │  content_hash: 0x545a9a...  (on Ethereum)       │
  │  verus_version: 0.2026.01.10                    │
  │  rust_version: 1.92.0                           │
  └─────────────────────────────────────────────────┘
```

This should suffice in order to reproduce the verification:
- **Commit SHA** pins the exact source code (hosted by the project)
- **Verus/Rust versions** pin the exact toolchain
- **Content hash** pins the expected result (anchored on-chain)

No Docker image required. No BAIF-hosted copy of the code.

---

# What If the Upstream Repo Disappears?

Docker images don't solve this either — they just move the problem:
- we cannot show that the code we copied is the one having been deleted

**What we already have:**
- `results/{timestamp}.json` archived in our repo
- Content hash on Ethereum (permanent)
- `history.json` with full provenance

**If we ever need source archival**, the right answer is:
- Git submodules or archival snapshots (lightweight)
- Not multi-GB Docker images with OS layers, compilers, and package managers

The certification **record** is permanent. The ability to **re-run** depends on
the project staying available — which is the project owner's responsibility.

---

# Summary: Stay Lean

```
  ┌─────────────────────────────────────┐
  │  BAIF's job:                        │
  │  1. Verify (run Verus)              │
  │  2. Certify (record on Ethereum)    │
  │  3. Enable re-verification          │
  │                                     │
  │  NOT BAIF's job:                    │
  │  4. Host other people's code        │
  │  5. Maintain Docker images          │
  │  6. Track project lifecycles        │
  └─────────────────────────────────────┘
```

The verification workflow gives anyone the ability to independently reproduce
the result — using the project's own repo, the recorded toolchain versions,
and a single `workflow_dispatch` click.

**Docker images add maintenance burden. The verify workflow adds a button.**

---

<!-- _class: lead -->

# Certification vs Attestation

What proof systems actually provide — and what we don't

---

# Proof Certificates in Rocq/Lean

In type-theoretic proof assistants, **proofs are programs**:

```
  Theorem: A → B → A
  Proof term: λ (a : A) (b : B) => a    -- has type A → B → A
```

The proof term **is** the certificate. Verification = type-checking.

```
┌─────────────────────────────────────────────────────────────────┐
│  Full Proof Assistant (tactics, automation, metaprogramming)    │
│  ───────────────────────────────────────────────────────────    │
│  You DON'T need to trust this layer                             │
└────────────────────────────┬────────────────────────────────────┘
                             │ produces proof terms
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  Kernel (~5,000 lines)                                          │
│  • Type inference, definitional equality                        │
│  ───────────────────────────────────────────────────────────    │
│  This is ALL you need to trust                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

# What `coqchk` Returning 0 Means

When Rocq's independent checker accepts a proof:

| Logic Concept | Type Theory Equivalent |
|---------------|------------------------|
| Proposition P | Type P |
| Proof of P | Term `t` where `t : P` |
| P is provable | Type P is inhabited |

**"This term has type P"** = **"This is a valid proof of P"**

The proof term is **self-certifying**. Anyone with a ~5K line type-checker can verify it.
No trust in the original prover. No need to re-run the proof search.

---

# What BAIF Provides (Honestly)

| Aspect | Rocq/Lean Proof Certificate | BAIF Certification |
|--------|----------------------------|-------------------|
| What is it? | The proof term itself | Merkle hash of results + specs + Z3 proofs |
| Statement visible? | Yes — theorem type | Yes — `specs.json` manifest |
| Evidence available? | Yes — proof term | Yes — `.smt2` formulas + `.proof` files |
| Evidence checkable? | Yes — type-check ~5K lines | Partially — re-run Z3 on `.smt2` to verify |
| Trust assumption | Type system is sound | Z3 is correct |
| Portable? | Yes — term can be checked anywhere | Yes — `.smt2` files are standard SMT-LIB2 |

We now extract Z3's proof terms via `(set-option :proof true)` + `(get-proof)`.
These are not as compact as Rocq proof terms, but they are **inspectable evidence**
archived alongside the theorem statements.

**Our position:** significantly closer to certification — both the *statements* (specs)
and the *evidence* (Z3 formulas + proofs) are independently inspectable artifacts.

---

# From Attestation Toward Certification

The terminology spectrum:

| Term | What It Implies | Where We Are |
|------|-----------------|--------------|
| **Pure attestation** | "Trust us, it passed" | ~~No longer here~~ |
| **Attestation + specs** | Claim by trusted party, with inspectable theorem statements | ~~Previous milestone~~ |
| **Attestation + specs + Z3 proofs** | Theorem statements + verifier evidence archived and hashable | **Here now** |
| **Full certificate** | Self-verifying proof object (constant-time check) | Not yet (needs ZK compression) |

**Current state:**
> "BAIF certifies that Verus accepted *these specific properties* (published in `specs.json`)
> for commit X at time T. The Z3 formulas and proof terms are archived in the proof bundle
> and hashed into the on-chain Merkle root."

What remains for full self-certifying proofs:
- Independent Z3 proof checker (replay `.smt2` + `.proof` without full Z3)
- ZK compression of Z3 proofs for constant-time on-chain verification (Pi-Squared vision)
- Spec quality metrics and review processes (see `doc/toward_certification.md`)

---

# Specs and Proofs Are Now in the Certificate

We now record:
- ✓ Commit hash (what code)
- ✓ Content hash — Merkle root of results + specs + proofs (what was proven)
- ✓ Toolchain versions (how verified)
- ✓ **The specification manifest** (the "theorem statements")
- ✓ **Z3 formulas** (the SMT-LIB2 queries encoding each function's spec)
- ✓ **Z3 proof terms** (the evidence that each formula is unsatisfiable)

The proof bundle (produced by `certify_cli generate-proofs`) contains:
- `proofs.json` — per-function index with spec, formula file, and proof file
- `smt_queries/*.smt2` — the exact Z3 queries (standard SMT-LIB2 format)
- `z3_proofs/*.proof` — the Z3 proof terms (produced via legacy proof mode)

A verifier can now:
> "Read the specs. Inspect the Z3 formulas. Replay the proofs. Judge for yourself."

**Remaining gap:** Independent proof checker (replay without full Z3),
ZK compression for constant-time verification, and spec quality metrics.

---

<!-- _class: lead -->

# The Trust Gap

Capability to verify vs. verification actually happening

---

# Two Kinds of Assurance (as Shaowei summarised it)

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  REPRODUCIBILITY                  VERIFIED EXECUTION            │
│  ────────────────                 ──────────────────            │
│                                                                 │
│  "You COULD verify               "Verification ACTUALLY         │
│   if you wanted to"               happened"                     │
│                                                                 │
│  Dockerfile + inputs              Multiple parties ran it       │
│  published openly                 and agreed on results         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**The trust gap:** If BAIF publishes a Github workflow but nobody runs it,
could BAIF lie and never get caught?

---

# Deterrence vs Prevention

| Approach | Mechanism | Trust Model |
|----------|-----------|-------------|
| **Deterrence** | Anyone *could* check; threat of being caught | Reproducibility |
| **Prevention** | Multiple parties *actually* check; consensus | Decentralized compute |

**Deterrence is how most trust systems work:**
- Auditors don't check every transaction — the *threat* of audit keeps people honest
- Open source isn't read by everyone — the *possibility* of scrutiny matters
- BAIF won't lie because anyone *could* re-run Verus and catch us

**You don't need everyone to verify. You need the credible threat that someone might.**

---

# Why Deterrence could be Sufficient for BAIF

```
  If BAIF lies:
  ┌─────────────────────────────────────────────────────────────┐
  │  1. Someone re-runs Verus on the commit                     │
  │  2. Results don't match what BAIF claimed                   │
  │  3. BAIF's entire certification system becomes worthless    │
  │  4. Reputation destruction (our only asset)                 │
  └─────────────────────────────────────────────────────────────┘
```

**The GitHub verification workflow is readable. The inputs are committed. Anyone can re-run.**

The cost of lying (reputation destruction) exceeds the benefit.
Decentralized compute would be solving a problem we don't have.

---

# When Would Decentralized Compute Matter?

Stronger guarantees might be needed if:

- Verification is so expensive (days/weeks) that nobody will realistically re-run
- Stakes are high enough that deterrence isn't sufficient
- You need *proactive* assurance, not just *reactive* capability
- BAIF's reputation isn't sufficient collateral

For formal verification of open-source code:
**Reproducibility + reputation + threat of being caught should be enough.**

---

<!-- _class: lead -->

# The Pi-Squared Vision

Grigore Rosu's Pi² project aims to make **any computation** produce checkable proofs:

```
┌─────────────────────────────────────────────────────────────────┐
│  1. Define language semantics in K framework (matching logic)   │
│  2. Program execution → mathematical proof (via K)              │
│  3. Proof → ZK-SNARK (succinct, constant-time verification)     │
│  4. Anyone verifies the ZK proof (~200 line checker)            │
└─────────────────────────────────────────────────────────────────┘
```

"ZK Proofs of (mathematical) Proofs" = π²

---

# Pi-Squared vs Rocq: Proof Certificate Costs

Rocq already has proof certificates — Pi-Squared's advance is making verification **cheap**.

| | Rocq (`coqchk`) | Pi-Squared |
|---|---|---|
| **Proof artifact** | Proof term (can be multi-GB) | ZK-SNARK (constant size) |
| **Verification cost** | O(proof size) — must traverse the entire term | O(1) — constant-time ZK verification |
| **Verifier complexity** | ~5K line type-checker | ~200 line SNARK checker |
| **Trust base** | Type theory is sound | ZK cryptography is sound |

**The key insight:** Rocq already separates proving from checking,
but checking still scales linearly with proof size.
Pi-Squared adds a cryptographic compression layer on top:
the ZK proof *of* the proof is constant-size and constant-time to verify,
regardless of the complexity of the underlying mathematical proof.


<!-- _class: lead -->

# Backup Slides

Detailed workflow steps

---

# Certification — Step 1: Verify (with SMT Logging)

Uses the `probe-verus/action@v1` reusable action with extra Verus flags:

```yaml
- name: Run Verus verification (with SMT logging)
  uses: beneficial-ai-foundation/probe-verus/action@v1
  with:
    project-path: target/${{ inputs.project_path }}
    package: ${{ inputs.package }}
    output-dir: ./output
    verus-args: '--log smt --log-dir ./verus-smt-logs -V spinoff-all'
```

**What it does:**
- Installs the Verus toolchain (version from `Cargo.toml`)
- Runs `probe-verus atomize` → function inventory
- Runs `probe-verus verify` → `results.json`
- `--log smt -V spinoff-all` → per-function `.smt2` files in `verus-smt-logs/`

**Outputs:** `verified-count`, `total-functions`, `verus-version`, `rust-version`, `smt-log-dir`

---

# Certification — Step 1.5: Generate Z3 Proof Certificates

```yaml
- name: Generate Z3 proof certificates
  run: |
    Z3_BIN="$HOME/.cargo/bin/verus-x86-linux/z3"
    uv run python3 -m certify_cli generate-proofs \
      --smt-log-dir $SMT_LOG_DIR \
      --results-file $RESULTS_FILE \
      --specs-file $SPECS_FILE \
      --output-dir ./output/proof-bundle \
      --z3-binary $Z3_BIN --timeout 300
```

**What it does:**
- Maps each probe-verus function ID to its per-function `.smt2` file
- Copies matched `.smt2` files into `smt_queries/` (the Z3 formulas)
- Injects `(set-option :proof true)` and `(get-proof)` into each query
- Runs Z3 (bundled with Verus) to produce `.proof` files
- Assembles `proofs.json` index with relative paths to all artifacts

**Output:** Self-contained `proof-bundle/` directory

---

# Certification — Step 2: Certify On-Chain

```yaml
- name: Certify on ${{ inputs.network }}
  env:
    MAINNET_RPC_URL: ${{ secrets.MAINNET_RPC_URL }}
    MAINNET_PRIVATE_KEY: ${{ secrets.MAINNET_PRIVATE_KEY }}
    CERTIFY_ADDRESS: ${{ vars.MAINNET_CERTIFIER_ADDRESS }}
  run: |
    CMD="uv run python3 -m certify_cli certify --network $NETWORK"
    CMD="$CMD --safe \"$SAFE_ADDR\" --execute"
    eval $CMD
```

**What it does:**
- Computes `keccak256(results.json)`
- Builds a Gnosis Safe transaction (for mainnet)
- Signs with the private key from GitHub Secrets
- Submits to Ethereum

**Outputs:** `tx_hash`, `content_hash`, `etherscan_url`

---

# Certification — Step 3: Update Registry

```yaml
- name: Update certification registry
  run: |
    uv run python3 -m certify_cli update-registry \
      --cert-id "$CERT_ID" --repo "$REPO" --ref "$REF" \
      --network "$NETWORK" --verified "$VERIFIED" --total "$TOTAL" \
      --tx-hash "$TX_HASH" --content-hash "$CONTENT_HASH" \
      --commit-sha "$SHA" --verus-version "$VERUS_VERSION"
```

**Creates/updates** under `certifications/{project-id}/`:

| File | Purpose |
|---|---|
| `badge.json` | Shields.io dynamic endpoint |
| `badge.svg` | Pre-rendered SVG badge |
| `history.json` | Full certification audit trail |
| `results/{timestamp}.json` | Archived verification results |
| `specs/{timestamp}.json` | Archived specification manifest |
| `proofs/{timestamp}/` | Archived proof bundle (proofs.json + smt_queries/ + z3_proofs/) |

Then commits and pushes to the repository.

---

# Verification — Step 1: Local Verification (Python)

```yaml
- name: Verify stored certification
  run: |
    OUTPUT=$(uv run python -m certify_cli verify-certification \
      --cert-id "$CERT_ID" --commit "$COMMIT_ID" \
      --network "$NETWORK" --json)
```

A single Python command performs all local checks:
1. **Registry lookup** — finds certification by commit + network in `history.json`
2. **Stored hash check** — `keccak256(results.json)` matches recorded `results_hash`
3. **Merkle structure** — reconstructs `content_hash` from leaf hashes
4. **Proof bundle integrity** — all `.smt2` and `.proof` files referenced in `proofs.json` exist
5. **Taxonomy extraction** — summarizes spec-labels from stored specs

Outputs structured JSON with pass/fail/skip status for each check.

---

# Verification — Step 2: On-Chain Check

```yaml
- name: Verify on-chain certification
  run: |
    uv run python -m certify_cli verify-hash \
      "$EXPECTED_HASH" --network "$NETWORK"
```

Queries the Ethereum event log for a `WebsiteCertified` event
matching the expected content hash.

**Confirms:**
- The certification transaction exists on-chain
- The content hash was recorded by the BAIF Safe
- The block timestamp is authentic

---

# Verification — Step 4: Fresh Re-Verification

```yaml
- name: Run fresh Verus verification
  uses: beneficial-ai-foundation/probe-verus/action@v1
  with:
    project-path: target/${{ inputs.project_path }}
```

```yaml
- name: Compare verification results
  run: |
    if [ "$CERTIFIED_VERIFIED" = "$FRESH_VERIFIED" ] &&
       [ "$CERTIFIED_TOTAL" = "$FRESH_TOTAL" ]; then
      echo "Fresh verification matches certified results"
    fi
```

**Note:** Exact hash may differ (non-deterministic timestamps/ordering),
but the semantic result (verified/total counts) should match.

---

# Verification — Outcome Matrix

| Stored Hash | On-Chain | Fresh Run | Verdict |
|---|---|---|---|
| Match | Found | Match | **Passed** — certification is authentic and reproducible |
| Match | Found | Differ | **Partial** — authentic but Verus version may differ |
| Mismatch | — | — | **Failed** — results may have been tampered with |
| — | Not found | — | **Failed** — certification not on blockchain |

---

# The Reusable Action

**`action/action.yml`** — lets any BAIF repository certify content in their own workflows:

```yaml
- uses: Beneficial-AI-Foundation/eth_certify/action@main
  with:
    source: ./output/results.json
    description: "My project: 72/72 verified"
    network: mainnet
    rpc-url: ${{ secrets.MAINNET_RPC_URL }}
    private-key: ${{ secrets.PRIVATE_KEY }}
    certify-address: ${{ vars.CERTIFY_ADDRESS }}
    safe-address: ${{ vars.SAFE_ADDRESS }}
```

**Outputs:** `tx-hash`, `content-hash`, `etherscan-url`

---
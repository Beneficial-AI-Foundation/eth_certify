# BAIF Certify: Visual Summary

<div align="center">

## On-Chain "Certification" for Formally Verified Code

A system that mathematically verifies software correctness and creates immutable, publicly auditable certification records.

</div>

---

## The Problem

<div align="center">

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║   TRADITIONAL ASSURANCE              vs.          FORMAL VERIFICATION            ║
║   ─────────────────────                           ──────────────────             ║
║                                                                                  ║
║   • Unit tests (finite cases)                     • Mathematical proof           ║
║   • Code review (human judgment)                  • All possible inputs          ║
║   • "Works on my machine"                         • Mechanically checked         ║
║                                                                                  ║
║   ❌ Can miss edge cases                          ✅ Covers entire state space   ║
║   ❌ Subjective assessment                        ✅ Objective, reproducible     ║
║   ❌ No permanent record                          ✅ Immutable audit trail       ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
```

</div>

---

## System Architecture

<div align="center">

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              BAIF CERTIFY PIPELINE                                  │
└─────────────────────────────────────────────────────────────────────────────────────┘

  ┌──────────────────┐   ┌──────────────────┐   ┌──────────────────┐   ┌──────────────────┐
  │   SOURCE CODE    │   │   VERIFICATION   │   │  Z3 PROOF        │   │   CERTIFICATION  │
  │   + SPECS        │──▶│   ENGINE         │──▶│  EXTRACTION      │──▶│   LAYER          │
  │                  │   │                  │   │                  │   │                  │
  │  Rust + Verus    │   │  probe-verus     │   │  certify_cli     │   │  Ethereum        │
  │  annotations     │   │  + Verus + Z3    │   │  generate-proofs │   │  smart contract  │
  └──────────────────┘   └──────────────────┘   └──────────────────┘   └──────────────────┘
          │                       │                       │                       │
          ▼                       ▼                       ▼                       ▼
  ┌──────────────────┐   ┌──────────────────┐   ┌──────────────────┐   ┌──────────────────┐
  │  • Pre/post      │   │  • SMT solving   │   │  • Per-function  │   │  • Merkle hash   │
  │    conditions    │   │  • Type checking │   │    Z3 formulas   │   │    of results +  │
  │  • Invariants    │   │  • Proof search  │   │    (.smt2)       │   │    specs + proofs│
  │  • Ghost code    │   │  • 72/72 verified│   │  • Z3 proof terms│   │  • Timestamped   │
  └──────────────────┘   │  • Spec manifest │   │    (.proof)      │   │    event log     │
                         │  • SMT logs      │   │  • proofs.json   │   └──────────────────┘
                         └──────────────────┘   └──────────────────┘           │
                                                                               ▼
                                                                       ┌──────────────────┐
                                                                       │  PUBLIC BADGE    │
                                                                       │  + HISTORY       │
                                                                       │  + SPECS         │
                                                                       │  + PROOF BUNDLE  │
                                                                       │                  │
                                                                       │  JSON endpoint   │
                                                                       │  SVG artifact    │
                                                                       └──────────────────┘
```

</div>

---

## Component Deep Dive

### 1. Formal Verification Layer

**Tool:** [Verus](https://github.com/verus-lang/verus) — a verification framework for Rust

Verus extends Rust with specification constructs that are checked at compile time:

```rust
// Example: Verus-annotated Rust function
#[verifier::spec]
fn sorted(v: &Vec<i32>) -> bool {
    forall|i: int, j: int| 0 <= i < j < v.len() ==> v[i] <= v[j]
}

#[verifier::proof]
fn binary_search(v: &Vec<i32>, key: i32) -> Option<usize>
    requires sorted(v),                          // Precondition
    ensures match result {                       // Postcondition
        Some(i) => v[i as int] == key,
        None => forall|i: int| 0 <= i < v.len() ==> v[i] != key,
    }
{
    // Implementation verified against spec
}
```

**What Verus proves:**
- Function contracts (requires/ensures) hold for ALL inputs
- Loop invariants are maintained
- Array bounds are never violated
- Integer overflow cannot occur
- Memory safety beyond Rust's guarantees

**Output:** `results.json` containing per-function verification status

```json
{
  "binary_search": { "verified": true, "time_ms": 142 },
  "insert_sorted": { "verified": true, "time_ms": 89 },
  ...
  "summary": { "verified": 72, "total": 72 }
}
```

---

### 2. Certification Layer

**Contract:** `Certify.sol` deployed on Ethereum

We certify the verification results, the specification manifest, and (when available)
the Z3 proof index by hashing all artifacts into a Merkle root and recording that
root on-chain:

```solidity
function certify(
    string calldata identifier,  // project id, e.g. "owner/repo"
    bytes32 contentHash,         // Merkle root: keccak256(results_hash || specs_hash [|| proofs_hash])
    bytes32 commitHash,          // git commit SHA as bytes32
    string calldata description  // e.g., "pmemlog verification: 72/72"
) external onlyAuthorized {      // only AUTHORIZED_CERTIFIER (BAIF Safe) can call
    emit Certified(
        keccak256(bytes(identifier)),  // Indexed for lookup
        contentHash,                   // Merkle root of results + specs + proofs
        msg.sender,                    // BAIF Safe address
        identifier, commitHash,
        description,
        SCHEMA_VERSION,
        block.timestamp
    );
}
```

**Concrete example — Merkle-style hashing:**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                                                                 │
│   INPUT 1: results.json (what Verus reported)                                   │
│   ┌───────────────────────────────────────────────────────────────────────────┐ │
│   │ {                                                                         │ │
│   │   "probe:pmemlog/.../spec_crc()": {"verified": true, "status": "success"},│ │
│   │   "probe:pmemlog/.../check_crc()": {"verified": true, "status": "success"}│ │
│   │ }                                                                         │ │
│   └───────────────────────────────────────────┬───────────────────────────────┘ │
│                                               ▼                                 │
│                                   results_hash = keccak256(results.json)        │
│                                                                                 │
│   INPUT 2: specs.json (what was proven — the "theorem statements")              │
│   ┌───────────────────────────────────────────────────────────────────────────┐ │
│   │ {                                                                         │ │
│   │   "probe:pmemlog/.../check_crc()": {                                      │ │
│   │     "has_requires": true, "has_ensures": true,                            │ │
│   │     "requires_text": "self.bytes_valid()",                                │ │
│   │     "ensures_text": "result == (self.crc == spec_crc(self))"              │ │
│   │   }                                                                       │ │
│   │ }                                                                         │ │
│   └───────────────────────────────────────────┬───────────────────────────────┘ │
│                                               ▼                                 │
│                                   specs_hash = keccak256(specs.json)            │
│                                                                                 │
│   INPUT 3: proofs.json (the evidence — Z3 formulas + proofs)    [when avail.]  │
│   ┌───────────────────────────────────────────────────────────────────────────┐ │
│   │ {                                                                         │ │
│   │   "functions": {                                                          │ │
│   │     "probe:pmemlog/.../check_crc()": {                                    │ │
│   │       "z3_formula": { "file": "smt_queries/check_crc.smt2", ... },        │ │
│   │       "z3_proof":   { "file": "z3_proofs/check_crc.proof", ... }          │ │
│   │     }                                                                     │ │
│   │   }                                                                       │ │
│   │ }                                                                         │ │
│   └───────────────────────────────────────────┬───────────────────────────────┘ │
│                                               ▼                                 │
│                                   proofs_hash = keccak256(proofs.json)          │
│                                                                                 │
│   MERKLE ROOT (3-leaf when proofs present, 2-leaf otherwise):                   │
│   ┌───────────────────────────────────────────────────────────────────────────┐ │
│   │  content_hash = keccak256(results_hash || specs_hash [|| proofs_hash])    │ │
│   └───────────────────────────────────────────┬───────────────────────────────┘ │
│                                               ▼                                 │
│   ON-CHAIN: Certified event                                                     │
│   ┌───────────────────────────────────────────────────────────────────────────┐ │
│   │  topics[2] = content_hash (Merkle root)                                   │ │
│   │  sender    = 0x8EAb4dB55DCEfb6D8bF76e1C6132d48D...  (BAIF Safe)           │ │
│   └───────────────────────────────────────────────────────────────────────────┘ │
│                                                                                 │
│   Anyone can:                                                                   │
│   1. Fetch results.json, specs.json, and proofs.json from our repo              │
│   2. Compute keccak256 of each file                                             │
│   3. Verify each hash matches the recorded leaf hashes in history.json          │
│   4. Verify Merkle root == on-chain content_hash                                │
│   5. Read specs.json to judge: are these the properties that matter?            │
│   6. Inspect Z3 formulas/proofs for verification evidence                       │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

> The v2 contract uses a single `certify()` function with on-chain access control
> (`AUTHORIZED_CERTIFIER` immutable). It also records the git commit hash and a
> schema version in the event for future-proofing.

**Why blockchain (specifically Ethereum)?**

| Property | How Ethereum Provides It |
|----------|-------------------------|
| **Immutability** | Proof-of-stake consensus; ~1M validators must agree |
| **Availability** | Thousands of full nodes; public RPC endpoints |
| **Timestamping** | Block timestamps with economic finality |
| **Permissionless verification** | Anyone can query events via `eth_getLogs` |
| **Censorship resistance** | No single party can delete records |

---

### 3. Trust Model

<div align="center">

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           TRUST CHAIN                                       │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│  GNOSIS SAFE (Multisig Wallet)                                              │
│  Address: 0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e                        │
│                                                                             │
│  • Team identity (all certs from single address)                            │
│  • Configurable threshold (1-of-N for automation, M-of-N for governance)    │
│  • On-chain audit trail of which key signed                                 │
└───────────────────────────────────┬─────────────────────────────────────────┘
                                    │ signs & executes
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  CERTIFY CONTRACT                                                           │
│  Address: 0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c                        │
│                                                                             │
│  • No owner, no admin functions (cannot be upgraded or paused)              │
│  • Stateless: only emits events, stores nothing                             │
│  • Verification: source code verified on Etherscan                          │
└───────────────────────────────────┬─────────────────────────────────────────┘
                                    │ emits event
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  ETHEREUM EVENT LOG                                                         │
│                                                                             │
│  topics[0]: Certified event signature                                       │
│  topics[1]: keccak256(identifier)                                           │
│  topics[2]: contentHash                                                     │
│  topics[3]: sender (Safe address)                                           │
│  data: identifier, commitHash, description, schemaVersion, timestamp        │
│                                                                             │
│  Queryable forever via eth_getLogs                                          │
└─────────────────────────────────────────────────────────────────────────────┘
```

</div>

**Independent verification path:**

```bash
# 1. Query certification events
cast logs --address 0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c \
          --from-block 24196278 \
          --rpc-url https://ethereum-rpc.publicnode.com

# 2. Extract contentHash from event
# topics[2] = 0x545a9a795ee534ae61ecf4f72ad2202e823650931a0d1771d15f0b74c9103d06

# 3. Recompute hash from stored results
cat certifications/project-id/results/latest.json | cast keccak

# 4. Compare: if hashes match, results are authentic
```

---

### 4. Data Flow (CI/CD Integration)

<div align="center">

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                          GITHUB ACTIONS WORKFLOW                                    │
└─────────────────────────────────────────────────────────────────────────────────────┘

  ┌───────────────────────────────────────────────────────────────────────────────────┐
  │ TRIGGER: push to main, manual dispatch, or scheduled                              │
  └───────────────────────────────────────────────────────────────────────────────────┘
                                         │
                                         ▼
  ┌───────────────────────────────────────────────────────────────────────────────────┐
  │ STEP 1: probe-verus/action@v1 + spec extraction + SMT logging                     │
  │ ────────────────────────────────────────────────────────────                       │
  │ • Clone target repository                                                         │
  │ • Install Verus toolchain (version from Cargo.toml)                               │
  │ • Run: probe-verus atomize → atoms.json (function inventory)                      │
  │ • Run: probe-verus verify  → results.json + per-function .smt2 files              │
  │   (with --log smt --log-dir ./verus-smt-logs -V spinoff-all)                      │
  │ • Run: probe-verus specify → specs.json (specification manifest)                  │
  │                                                                                   │
  │ Outputs: results.json, specs.json, smt-log-dir, verified_count, total_functions   │
  └───────────────────────────────────────────────────────────────────────────────────┘
                                         │
                                         ▼
  ┌───────────────────────────────────────────────────────────────────────────────────┐
  │ STEP 1.5: certify_cli generate-proofs (Z3 proof certificate generation)            │
  │ ────────────────────────────────────────────────────────────                       │
  │ • Map .smt2 files to verified functions (name normalisation + fuzzy matching)      │
  │ • For each matched function: inject (set-option :proof true) + run Z3             │
  │ • Collect Z3 proof terms → .proof files                                           │
  │ • Build proofs.json (per-function: spec text, Z3 formula file, Z3 proof file)     │
  │                                                                                   │
  │ Outputs: proof-bundle-dir/ (proofs.json, smt_queries/, z3_proofs/)                │
  └───────────────────────────────────────────────────────────────────────────────────┘
                                         │
                                         ▼
  ┌───────────────────────────────────────────────────────────────────────────────────┐
  │ STEP 2: certify_cli certify (Merkle hashing)                                      │
  │ ──────────────────────────────────────────────                                    │
  │ • Compute: results_hash = keccak256(results.json)                                 │
  │ • Compute: specs_hash   = keccak256(specs.json)                                   │
  │ • Compute: proofs_hash  = keccak256(proofs.json)   [when proof bundle present]    │
  │ • Compute: content_hash = keccak256(results_hash || specs_hash [|| proofs_hash])  │
  │ • Build Safe transaction (if using multisig)                                      │
  │ • Sign with PRIVATE_KEY from GitHub Secrets                                       │
  │ • Submit content_hash to Ethereum (mainnet or Sepolia)                            │
  │                                                                                   │
  │ Outputs: tx_hash, content_hash, results_hash, specs_hash, proofs_hash             │
  └───────────────────────────────────────────────────────────────────────────────────┘
                                         │
                                         ▼
  ┌───────────────────────────────────────────────────────────────────────────────────┐
  │ STEP 3: Update Artifacts                                                          │
  │ ────────────────────────                                                          │
  │ • certifications/{project}/badge.json   → Shields.io endpoint                     │
  │ • certifications/{project}/badge.svg    → Static SVG asset                        │
  │ • certifications/{project}/history.json → Append record (incl. Merkle hashes)     │
  │ • certifications/{project}/results/{timestamp}.json → Archive results             │
  │ • certifications/{project}/specs/{timestamp}.json   → Archive specs               │
  │ • certifications/{project}/proofs/{timestamp}/      → Archive proof bundle        │
  │   (proofs.json + smt_queries/ + z3_proofs/)                                       │
  │                                                                                   │
  │ Commit and push to repository                                                     │
  └───────────────────────────────────────────────────────────────────────────────────┘
```

</div>

---

## Certification Record Structure

**`history.json`** — Full audit trail with toolchain provenance and Merkle hashes:

```json
{
  "certifications": [
    {
      "timestamp": "2026-01-27T09:49:01Z",
      "ref": "main",
      "commit_sha": "a1b2c3d4e5f6...",
      "network": "mainnet",
      "tx_hash": "0x09f0ee375bc3801b89f75e0663b1962d08d488e3...",
      "content_hash": "0x... (Merkle root)",
      "etherscan_url": "https://etherscan.io/tx/0x09f0ee...",
      "verified": 72,
      "total": 72,
      "verus_version": "0.2026.01.10.531beb1",
      "rust_version": "1.92.0",
      "results_file": "results/2026-01-27T09-49-01Z.json",
      "results_hash": "0x... (keccak256 of results.json)",
      "specs_hash": "0x... (keccak256 of specs.json)",
      "specs_file": "specs/2026-01-27T09-49-01Z.json",
      "proof_bundle": "proofs/2026-01-27T09-49-01Z",
      "proofs_hash": "0x... (keccak256 of proofs.json)"
    }
  ]
}
```

**Key properties:**
- **Reproducibility:** Exact toolchain versions recorded
- **Traceability:** Git ref and commit hash linked
- **Verifiability:** Merkle root can be recomputed from individual file hashes;
  each file hash can be recomputed from the archived files
- **Spec inspectability:** Anyone can read `specs.json` to judge whether the
  proven properties are meaningful — without running Verus or reading source code
- **Evidence inspectability:** Anyone can examine the Z3 formulas (`.smt2` files)
  and proof terms (`.proof` files) for each verified function
- **Spec stability:** Unchanged specs produce the same `specs_hash` across
  re-certifications, making spec evolution visible

---

## Security Properties

<div align="center">

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│                         SECURITY ANALYSIS                                        │
└──────────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────┬─────────────────────────────────────────────────┐
│  THREAT                        │  MITIGATION                                     │
├────────────────────────────────┼─────────────────────────────────────────────────┤
│  Fake certification            │  Contract enforces AUTHORIZED_CERTIFIER         │
│  (unauthorized party)          │  (immutable); only BAIF Safe can call certify() │
├────────────────────────────────┼─────────────────────────────────────────────────┤
│  Tampered results              │  keccak256 hash committed on-chain;             │
│  (modified after cert)         │  any change produces different hash             │
├────────────────────────────────┼─────────────────────────────────────────────────┤
│  Deleted certification         │  Ethereum events are append-only;               │
│  (cover up bad result)         │  historical events always queryable             │
├────────────────────────────────┼─────────────────────────────────────────────────┤
│  Backdated certification       │  Block timestamp from consensus;                │
│  (false timeline)              │  economically infeasible to forge               │
├────────────────────────────────┼─────────────────────────────────────────────────┤
│  Key compromise                │  Gnosis Safe enables key rotation               │
│  (stolen private key)          │  without changing public identity;              │
│                                │  keys passed via env vars (not CLI args)        │
├────────────────────────────────┼─────────────────────────────────────────────────┤
│  SSRF via content source       │  URL validation blocks private/loopback IPs;    │
│  (malicious URL in CI)         │  only http/https; no automatic redirects        │
├────────────────────────────────┼─────────────────────────────────────────────────┤
│  Contract vulnerability        │  Minimal contract (events only);                │
│                                │  no state, no admin, no upgrades;               │
│                                │  single function, on-chain access control       │
└────────────────────────────────┴─────────────────────────────────────────────────┘
```

</div>

---

## Verification Semantics

**What "72/72 verified" actually means:**

<div align="center">

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                                                                 │
│  For each function f with specification S:                                      │
│                                                                                 │
│    Verus proves:  ∀ inputs x satisfying requires(x):                            │
│                     ensures(f(x)) holds ∧ f terminates                          │
│                                                                                 │
│  This is NOT:                                                                   │
│    • Testing (checked finite samples)                                           │
│    • Static analysis (heuristic warnings)                                       │
│    • Fuzzing (random input generation)                                          │
│                                                                                 │
│  This IS:                                                                       │
│    • Machine-checked mathematical proof                                         │
│    • Sound with respect to Verus's axioms and Rust's semantics                  │
│    • Complete for the specified properties (not "all correctness")              │
│                                                                                 │
│  Additionally, Z3 proof terms are now archived for each verified function:      │
│    • .smt2 files show the exact formulas Z3 solved                              │
│    • .proof files contain Z3's proof terms (legacy proof format)                │
│    • As proof checkers mature, these become independently checkable              │
│                                                                                 │
│  Caveats:                                                                       │
│    • Specifications themselves could be wrong (spec vs. intent)                 │
│    • Assumes Verus/Z3 implementation is correct (trusted computing base)        │
│    • Does not verify external dependencies or FFI                               │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

</div>

---

## Badge System

| Coverage | Badge | Color Logic |
|----------|-------|-------------|
| 100% | ![100%](https://img.shields.io/badge/BAIF_Certified-72%2F72_verified-brightgreen?logo=ethereum&logoColor=white) | `brightgreen` if verified == total |
| 50-99% | ![partial](https://img.shields.io/badge/BAIF_Certified-45%2F72_verified-yellow?logo=ethereum&logoColor=white) | `yellow` if ratio ≥ 0.5 |
| <50% | ![low](https://img.shields.io/badge/BAIF_Certified-10%2F72_verified-red?logo=ethereum&logoColor=white) | `red` if ratio < 0.5 |

**Integration options:**

```markdown
<!-- Dynamic (via Shields.io endpoint) -->
[![BAIF Certified](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/org/repo/main/certifications/project/badge.json)](link-to-history)

<!-- Static (pre-generated SVG) -->
![BAIF Certified](https://raw.githubusercontent.com/org/repo/main/certifications/project/badge.svg)
```

---

## Deployed Infrastructure

| Component | Network | Address |
|-----------|---------|---------|
| Certify Contract | Mainnet | [`0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c`](https://etherscan.io/address/0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c) |
| Certify Contract | Sepolia | [`0x125721f8a45bbABC60aDbaaF102a94d9cae59238`](https://sepolia.etherscan.io/address/0x125721f8a45bbABC60aDbaaF102a94d9cae59238) |
| BAIF Safe | Mainnet | [`0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e`](https://etherscan.io/address/0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e) |

---

## Summary

<div align="center">

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                     │
│                           BAIF "CERTIFY" IN ONE DIAGRAM                             │
│                                                                                     │
│   ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐        │
│   │           │  │           │  │  Z3 Proof │  │           │  │           │        │
│   │ Rust Code │─▶│   Verus   │─▶│ Extraction│─▶│ Ethereum  │─▶│   Badge   │        │
│   │ + Specs   │  │ Verifier  │  │           │  │ Mainnet   │  │  + JSON   │        │
│   │           │  │           │  │           │  │           │  │           │        │
│   └───────────┘  └───────────┘  └───────────┘  └───────────┘  └───────────┘        │
│                                                                                     │
│       Input          Proof        Evidence          Record          Display         │
│                                                                                     │
│   ─────────────────────────────────────────────────────────────────────────────     │
│                                                                                     │
│   What we have:                                                                     │
│   ✓ Mathematically verified (SMT-backed proofs)                                     │
│   ✓ Cryptographically bound (keccak256 Merkle root)                                 │
│   ✓ Immutably recorded (Ethereum event logs)                                        │
│   ✓ Independently verifiable (public RPC, open source)                              │
│   ✓ CI/CD integrated (GitHub Actions workflows)                                     │
│   ✓ Specs inspectable (spec manifests in the certificate)                           │
│   ✓ Evidence archived (Z3 formulas + proof terms per function)                      │
│                                                                                     │
│   ─────────────────────────────────────────────────────────────────────────────     │
│                                                                                     │
│   What we're building toward:                                                       │
│   ◐ Independent proof checking (Z3 proof checkers maturing)                         │
│   ✗ A fully meaningful definition of "certify"                                      │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

</div>

---

## Moving From Attestation Toward Certification

<div align="center">

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                     │
│    CURRENT STATE: "Certify" = "Verus ran successfully"                              │
│                             + "here are the specs"                                  │
│                             + "here are the Z3 formulas and proof terms"            │
│                                                                                     │
│    We now include both the specification manifest (the "theorem statements")        │
│    and the Z3 proof evidence as first-class certified artifacts, making both        │
│    the claim and the evidence inspectable by anyone.                                │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

</div>

**The gap we're closing:**

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                     │
│   WHAT THE PROJECT             ???              WHAT VERUS                          │
│   IS SUPPOSED TO DO      ─────────────▶         ACTUALLY CHECKS                     │
│   (informal spec)           narrowing           (formal spec)                       │
│                             the gap                                                 │
│   "This library ensures                         requires(x > 0)                     │
│    memory safety for                            ensures(result.is_ok())             │
│    concurrent access"                           invariant(len <= cap)               │
│                                                                                     │
│   ─────────────────────────────────────────────────────────────────────────────     │
│                                                                                     │
│   BEFORE: "72/72 verified" — no way to know what those specs actually say           │
│   THEN:   specs.json included — reviewers can read and judge the specs              │
│   NOW:    Z3 proofs included — reviewers can also inspect the evidence              │
│                                                                                     │
│   The certification proves "these specific properties hold." The evidence           │
│   (Z3 formulas and proof terms) is now archived and will become independently       │
│   checkable as proof-checking tools mature.                                         │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

**What meaningful certification would require:**

| Level | What It Proves | Status |
|-------|---------------|--------|
| **L0: Mechanical** | Verus accepts the specs | ✓ We do this |
| **L0.5: Inspectable** | Specs are published and hashed alongside results | ✓ Implemented (Merkle hashing) |
| **L0.75: Evidenced** | Z3 formulas + proof terms archived per function | ✓ Implemented (proof bundles) |
| **L1: Refinement** | Formal specs correctly refine informal requirements | ✗ Open problem |
| **L2: Completeness** | Specs cover all security-relevant properties | ✗ Open problem |
| **L3: Review** | Independent expert validated the refinement | ✗ Open problem |

**The honest statement:**

> A BAIF certification now proves that *specific, inspectable properties were verified by Verus*,
> with Z3 formulas and proof terms archived as evidence, all cryptographically bound to the
> on-chain record.
> 
> It does **not** yet prove those specs capture what users actually care about — but the specs
> and proof evidence are now visible for anyone to judge. The Z3 proofs are not yet independently
> checkable by a small trusted kernel (as in Rocq/Lean), but they are archived and will become
> verifiable as proof-checking tools mature.

**Directions we're exploring (see `doc/toward_certification.md`):**

- Spec quality metrics (trivial spec detection, postcondition density)
- Spec taxonomy (classifying properties by type: safety, correctness, crash consistency)
- Spec diff tracking between re-certifications
- Informal-to-formal mapping documents (linking specs to design docs)
- Two-signature certification (domain expert attests specs, BAIF attests verification)

---

<div align="center">

*Built by the [Beneficial AI Foundation](https://github.com/Beneficial-AI-Foundation)*

**Transforming software assurance from reputation-based to evidence-based.**

*(The specs and Z3 proofs are now part of the evidence. What remains: ensuring the specs are the right ones, and independent proof checking.)*

</div>

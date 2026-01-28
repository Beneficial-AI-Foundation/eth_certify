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

  ┌──────────────────┐      ┌──────────────────┐      ┌──────────────────┐
  │   SOURCE CODE    │      │   VERIFICATION   │      │   CERTIFICATION  │
  │   + SPECS        │─────▶│   ENGINE         │─────▶│   LAYER          │
  │                  │      │                  │      │                  │
  │  Rust + Verus    │      │  probe-verus     │      │  Ethereum        │
  │  annotations     │      │  + Verus         │      │  smart contract  │
  └──────────────────┘      └──────────────────┘      └──────────────────┘
          │                         │                         │
          ▼                         ▼                         ▼
  ┌──────────────────┐      ┌──────────────────┐      ┌──────────────────┐
  │  • Pre/post      │      │  • SMT solving   │      │  • keccak256     │
  │    conditions    │      │  • Type checking │      │    content hash  │
  │  • Invariants    │      │  • Proof search  │      │  • Timestamped   │
  │  • Ghost code    │      │  • 72/72 verified│      │    event log     │
  └──────────────────┘      └──────────────────┘      └──────────────────┘
                                                              │
                                                              ▼
                                                      ┌──────────────────┐
                                                      │  PUBLIC BADGE    │
                                                      │  + HISTORY       │
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

We certify the verification results JSON by hashing it and recording that hash on-chain:

```solidity
function certifyWebsite(   // * name is historical; we're certifying JSON, not a website
    string calldata url,         // identifier (e.g., project URL or file reference)
    bytes32 contentHash,         // keccak256(results.json) — the key artifact
    string calldata description  // e.g., "pmemlog verification: 72/72"
) external {
    emit WebsiteCertified(
        keccak256(bytes(url)),   // Indexed for lookup
        contentHash,             // The fingerprint of results.json
        msg.sender,              // BAIF Safe address
        url,
        description,
        block.timestamp
    );
}
```

**Concrete example — what gets certified:**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                                                                 │
│   INPUT: results.json from Verus                                                │
│   ┌───────────────────────────────────────────────────────────────────────────┐ │
│   │ {                                                                         │ │
│   │   "PersistentMemoryLogHeader::spec_crc": {"verified": true, "time": 89},  │ │
│   │   "PersistentMemoryLogHeader::check_crc": {"verified": true, "time": 142},│ │
│   │   "UntrustedLogImpl::start": {"verified": true, "time": 203},             │ │
│   │   ...                                                                     │ │
│   │   "summary": {"verified": 72, "total": 72, "errors": 0}                   │ │
│   │ }                                                                         │ │
│   └───────────────────────────────────────────────────────────────────────────┘ │
│                              │                                                  │
│                              ▼                                                  │
│                      keccak256(json_bytes)                                      │
│                              │                                                  │
│                              ▼                                                  │
│   OUTPUT: contentHash                                                           │
│   0x545a9a795ee534ae61ecf4f72ad2202e823650931a0d1771d15f0b74c9103d06            │
│                              │                                                  │
│                              ▼                                                  │
│   ON-CHAIN: WebsiteCertified event                                              │
│   ┌───────────────────────────────────────────────────────────────────────────┐ │
│   │  topics[2] = 0x545a9a795ee534ae61ecf4f72ad2202e...  (the hash)            │ │
│   │  sender    = 0x8EAb4dB55DCEfb6D8bF76e1C6132d48D...  (BAIF Safe)           │ │
│   │  block     = 24196278                                                     │ │
│   │  timestamp = 1737970141 (2026-01-27T09:49:01Z)                            │ │
│   └───────────────────────────────────────────────────────────────────────────┘ │
│                                                                                 │
│   Anyone can:                                                                   │
│   1. Fetch results.json from our repo                                           │
│   2. Compute keccak256(file_contents)                                           │
│   3. Query Ethereum for events with that hash                                   │
│   4. Verify: hashes match → file is authentic, timestamp is when certified      │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

> \* The function is named `certifyWebsite` for historical reasons. A more accurate name 
> would be `certifyContent` since we're hashing a JSON file, not a website.

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
│  topics[0]: 0xe902b6df... (WebsiteCertified signature)                      │
│  topics[1]: keccak256(url)                                                  │
│  topics[2]: contentHash                                                     │
│  topics[3]: sender (Safe address)                                           │
│  data: url, description, timestamp (ABI-encoded)                            │
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
  │ STEP 1: probe-verus/action@v1                                                     │
  │ ─────────────────────────────                                                     │
  │ • Clone target repository                                                         │
  │ • Install Verus toolchain (version from Cargo.toml)                               │
  │ • Run: probe-verus atomize → atoms.json (function inventory)                      │
  │ • Run: probe-verus verify  → results.json (verification status)                   │
  │                                                                                   │
  │ Outputs: verified_count=72, total_functions=72, verus_version=0.2026.01.10        │
  └───────────────────────────────────────────────────────────────────────────────────┘
                                         │
                                         ▼
  ┌───────────────────────────────────────────────────────────────────────────────────┐
  │ STEP 2: eth_certify/action@main                                                   │
  │ ───────────────────────────────                                                   │
  │ • Compute: contentHash = keccak256(results.json)                                  │
  │ • Build Safe transaction (if using multisig)                                      │
  │ • Sign with PRIVATE_KEY from GitHub Secrets                                       │
  │ • Submit to Ethereum (mainnet or Sepolia)                                         │
  │                                                                                   │
  │ Outputs: tx_hash=0x..., content_hash=0x...                                        │
  └───────────────────────────────────────────────────────────────────────────────────┘
                                         │
                                         ▼
  ┌───────────────────────────────────────────────────────────────────────────────────┐
  │ STEP 3: Update Artifacts                                                          │
  │ ────────────────────────                                                          │
  │ • certifications/{project}/badge.json   → Shields.io endpoint                     │
  │ • certifications/{project}/badge.svg    → Static SVG asset                        │
  │ • certifications/{project}/history.json → Append certification record             │
  │ • certifications/{project}/results/{timestamp}.json → Archive                     │
  │                                                                                   │
  │ Commit and push to repository                                                     │
  └───────────────────────────────────────────────────────────────────────────────────┘
```

</div>

---

## Certification Record Structure

**`history.json`** — Full audit trail with toolchain provenance:

```json
{
  "certifications": [
    {
      "timestamp": "2026-01-27T09:49:01Z",
      "ref": "main",
      "commit": "a1b2c3d4e5f6...",
      "network": "mainnet",
      "tx_hash": "0x09f0ee375bc3801b89f75e0663b1962d08d488e3...",
      "content_hash": "0x545a9a795ee534ae61ecf4f72ad2202e823650931a...",
      "etherscan_url": "https://etherscan.io/tx/0x09f0ee...",
      "verified": 72,
      "total": 72,
      "verus_version": "0.2026.01.10.531beb1",
      "rust_version": "1.92.0",
      "results_file": "results/2026-01-27T09-49-01Z.json"
    }
  ]
}
```

**Key properties:**
- **Reproducibility:** Exact toolchain versions recorded
- **Traceability:** Git ref and commit hash linked
- **Verifiability:** Content hash can be recomputed from `results_file`

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
│  Fake certification            │  Only holders of Safe keys can certify;         │
│  (unauthorized party)          │  sender address recorded in event               │
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
│  (stolen private key)          │  without changing public identity               │
├────────────────────────────────┼─────────────────────────────────────────────────┤
│  Contract vulnerability        │  Minimal contract (events only);                │
│                                │  no state, no admin, no upgrades                │
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
│   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐          │
│   │             │    │             │    │             │    │             │          │
│   │  Rust Code  │───▶│   Verus     │───▶│  Ethereum   │───▶│   Badge     │          │
│   │  + Specs    │    │   Verifier  │    │  Mainnet    │    │   + JSON    │          │
│   │             │    │             │    │             │    │             │          │
│   └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘          │
│                                                                                     │
│        Input            Proof              Record            Display                │
│                                                                                     │
│   ─────────────────────────────────────────────────────────────────────────────     │
│                                                                                     │
│   What we have:                                                                     │
│   ✓ Mathematically verified (SMT-backed proofs)                                     │
│   ✓ Cryptographically bound (keccak256 content hash)                                │
│   ✓ Immutably recorded (Ethereum event logs)                                        │
│   ✓ Independently verifiable (public RPC, open source)                              │
│   ✓ CI/CD integrated (GitHub Actions workflows)                                     │
│                                                                                     │
│   ─────────────────────────────────────────────────────────────────────────────     │
│                                                                                     │
│   What we still need:                                                               │
│   ✗ A meaningful definition of "certify"                                            │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

</div>

---

## Open Problem: What Does "Certify" Mean?

<div align="center">

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                     │
│    ⚠️  CURRENT STATE: "Certify" = "Verus ran successfully"                          │
│                                                                                     │
│    This is necessary but NOT sufficient for meaningful certification.               │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

</div>

**The gap:**

 We've built the plumbing, the hard conceptual work of defining meaningful certification remains open.

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                     │
│   WHAT THE PROJECT             ???              WHAT VERUS                          │
│   IS SUPPOSED TO DO      ─────────────▶         ACTUALLY CHECKS                     │
│   (informal spec)           missing             (formal spec)                       │
│                             bridge                                                  │
│   "This library ensures                         requires(x > 0)                     │
│    memory safety for                            ensures(result.is_ok())             │
│    concurrent access"                           invariant(len <= cap)               │
│                                                                                     │
│   ─────────────────────────────────────────────────────────────────────────────     │
│                                                                                     │
│   Today, anyone can write formal specs that pass Verus but don't capture            │
│   the actual intent. The certification proves "specs hold" not "specs matter."      │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

**What meaningful certification would require:**

| Level | What It Proves | Status |
|-------|---------------|--------|
| **L0: Mechanical** | Verus accepts the specs | ✓ We do this |
| **L1: Refinement** | Formal specs correctly refine informal requirements | ✗ Open problem |
| **L2: Completeness** | Specs cover all security-relevant properties | ✗ Open problem |
| **L3: Review** | Independent expert validated the refinement | ✗ Open problem |

**The honest statement:**

> Right now, a BAIF certification proves that *someone wrote Verus specs and they passed*.
> It does **not** prove those specs capture what users actually care about.
> 
> We have built the **infrastructure** for certification. 
> We have not yet solved the **epistemology** of what makes a certification meaningful.

**Directions we're exploring:**

- Specification templates for common security properties
- Linking specs to natural-language documentation
- Community review processes for spec adequacy
- Formal refinement proofs from high-level to low-level specs

---

<div align="center">

*Built by the [Beneficial AI Foundation](https://github.com/Beneficial-AI-Foundation)*

**Transforming software assurance from reputation-based to evidence-based.**

*(Once we figure out what "evidence" should mean.)*

</div>

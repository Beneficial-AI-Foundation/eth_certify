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
  Source Code        Verification        On-Chain             Public
  + Specs            Engine              Certification        Badge
┌─────────────┐   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│  Rust Code  │──▶│   Verus     │──▶│  Ethereum   │──▶│  Badge      │
│  + Verus    │   │   + Z3 SMT  │   │  Event Log  │   │  + History  │
│  Annotations│   │   Solver    │   │             │   │  + JSON     │
└─────────────┘   └─────────────┘   └─────────────┘   └─────────────┘
     Input            Proof              Record            Display
```

Three layers: **verify**, **certify**, **display**.

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

# Layer 2: On-Chain Certification

The `Certify.sol` smart contract records a **content hash** on Ethereum:

```solidity
function certifyWebsite(
    string calldata url,          // project identifier
    bytes32 contentHash,          // keccak256(results.json)
    string calldata description   // "pmemlog: 72/72 verified"
) external {
    emit WebsiteCertified(
        keccak256(bytes(url)),    // indexed for lookup
        contentHash,              // the fingerprint
        msg.sender,               // BAIF Safe address
        url, description,
        block.timestamp
    );
}
```

**Stateless** — emits events only, no storage, no admin, no upgrades.

---

# Layer 2: What Gets Recorded

```
  results.json  ──▶  keccak256(bytes)  ──▶  Ethereum Event
                                             ┌─────────────────────┐
                                             │ contentHash = 0x545…│
                                             │ sender      = 0x8EA…│
                                             │ block       = 24196…│
                                             │ timestamp   = 1737… │
                                             └─────────────────────┘
```

**Anyone can verify:**
1. Fetch `results.json` from our repo
2. Compute `keccak256(file_contents)`
3. Query Ethereum for events with that hash
4. Hashes match → file is authentic, timestamp is when it was certified

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

# Why Ethereum?

| Property | How Ethereum Provides It |
|---|---|
| **Immutability** | Proof-of-stake consensus; ~1M validators |
| **Availability** | Thousands of full nodes; public RPC endpoints |
| **Timestamping** | Block timestamps with economic finality |
| **Permissionless verification** | Anyone can query via `eth_getLogs` |
| **Censorship resistance** | No single party can delete records |

The contract is verified on Etherscan — anyone can read the source.

---

<!-- _class: lead -->

# GitHub Workflows

Automating the certification and verification pipeline

---

# Workflow Overview

Two main workflows, one reusable action:

| Workflow | Trigger | Purpose |
|---|---|---|
| **certify-external.yml** | Manual dispatch | Verify + certify any Verus project |
| **verify.yml** | Manual dispatch | Independently verify a certification |
| **action/action.yml** | Used by other repos | Reusable composite action for certification |

Plus CI (`ci.yml`) for linting and testing the certify repo itself.

---

# Certification Workflow

**`certify-external.yml`** — end-to-end: verify code, certify on-chain, update registry

**Inputs** (manual dispatch):
- Repository URL, project path, git ref
- Package name (for Rust workspaces)
- Network: `mainnet` or `sepolia`

```
Trigger ──▶ Step 1: Verify ──▶ Step 2: Certify ──▶ Step 3: Registry ──▶ Step 4: Commit
```

---

# Certification — Step 1: Verify

Uses the `probe-verus/action@v1` reusable action:

```yaml
- name: Run Verus verification
  uses: beneficial-ai-foundation/probe-verus/action@v1
  with:
    project-path: target/${{ inputs.project_path }}
    package: ${{ inputs.package }}
    output-dir: ./output
```

**What it does:**
- Clones the target repo at the specified ref
- Installs the Verus toolchain (version from `Cargo.toml`)
- Runs `probe-verus atomize` → function inventory
- Runs `probe-verus verify` → `results.json`

**Outputs:** `verified-count`, `total-functions`, `verus-version`, `rust-version`

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

Then commits and pushes to the repository.

---

# Certification — Full Pipeline

```
┌───────────────┐     ┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│  Clone repo   │     │  probe-verus  │     │  certify_cli  │     │  update-      │
│  at ref       │────▶│  verify       │────▶│  certify      │────▶│  registry     │
│               │     │               │     │  --safe       │     │               │
│  target/      │     │  results.json │     │  --execute    │     │  badge + hist │
└───────────────┘     └───────────────┘     └───────────────┘     └───────────────┘
                                                    │
                                                    ▼
                                             Ethereum Event
                                             tx: 0x09f0ee…
```

The entire pipeline runs in a single GitHub Actions job — no human intervention.

---

# Verification Workflow

**`verify.yml`** — independently verify that a certification is legitimate

**Inputs** (manual dispatch):
- Repository URL, commit SHA, project path
- Package name, network

**Three levels of verification:**

| Level | What It Checks |
|---|---|
| **Stored results** | `keccak256(stored results.json)` matches on-chain `contentHash` |
| **On-chain** | Queries Ethereum for the certification event |
| **Fresh verification** | Re-runs Verus and compares results with certified counts |

---

# Verification — Step 1: Registry Lookup

```yaml
- name: Look up certification in registry
  run: |
    CERT=$(jq -r --arg commit "$COMMIT_ID" --arg network "$NETWORK" \
      '.certifications[] | select(.commit_sha == $commit
                           and .network == $network)' \
      "$HISTORY_FILE")
```

Finds the certification record matching the commit SHA and network.
Extracts: `content_hash`, `tx_hash`, `verified`, `total`, `results_file`.

---

# Verification — Step 2: Hash Verification

```yaml
- name: Verify stored results hash
  run: |
    COMPUTED_HASH=$(cast keccak < "$RESULTS_FILE")
    if [ "$COMPUTED_HASH" = "$EXPECTED_HASH" ]; then
      echo "Stored results hash matches certification record"
    fi
```

**What it checks:**
1. Reads the stored `results.json` from the certification archive
2. Computes `keccak256` of the file contents
3. Compares with the on-chain `contentHash`

If they match: the results file has not been tampered with since certification.

---

# Verification — Step 3: On-Chain Check

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
| Fake certification | Only Safe key holders can certify; sender recorded in event |
| Tampered results | keccak256 hash on-chain; any change produces different hash |
| Deleted certification | Ethereum events are append-only; always queryable |
| Backdated certification | Block timestamp from consensus; infeasible to forge |
| Key compromise | Gnosis Safe enables key rotation without changing identity |
| Contract vulnerability | Minimal contract — events only, no state, no admin |

---

# Deployed Infrastructure

| Component | Network | Address |
|---|---|---|
| Certify Contract | Mainnet | `0x4f2a70eC878E9Adae88FF0c7528ebEbf83dFD83c` |
| Certify Contract | Sepolia | `0x125721f8a45bbABC60aDbaaF102a94d9cae59238` |
| BAIF Safe | Mainnet | `0x8EAb4dB55DCEfb6D8bF76e1C6132d48D2048ef0e` |

All contract source code is verified on Etherscan.

---

# What "Certified" Means (and Doesn't)

**What a BAIF certification proves:**
- Verus accepted the formal specs — machine-checked mathematical proof
- The result is cryptographically bound to a content hash
- The hash is immutably recorded on Ethereum with a timestamp

**What it does NOT prove:**
- That the specs capture what users actually care about
- That specifications are complete (they may miss properties)
- That external dependencies or FFI are correct

**The honest statement:**
> We have built the **infrastructure** for certification.
> We should find a more meaningful definition of what is certification.

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

Sounds easy. But it introduces a set of problems far heavier
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

# Problem 3: Projects Are Never "Done"

A Docker image captures a moment in time. But verified projects continue to exist:

```
  v1.0 ──▶ v1.1 (patch) ──▶ v1.2 (new feature) ──▶ v2.0 (rewrite)
   │            │                  │                      │
   ▼            ▼                  ▼                      ▼
  image?      image?             image?                 image?
```

**Each version** potentially needs:
- Its own image (different deps, different Verus version)
- Re-certification when specs change
- Retirement when superseded

We'd be maintaining a growing fleet of images with no natural stopping point.

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
| What is it? | The proof term itself | A hash of "Verus said OK" |
| Verification | Run type-checker (~5K lines) | Re-run Verus + Z3 (millions of lines) |
| Trust assumption | Type system is sound | Z3 is correct, BAIF ran it honestly |
| Portable? | Yes — term can be checked anywhere | No — need full Verus/Z3 toolchain |

Verus/Z3 don't emit portable proof terms. Z3 returns `sat`/`unsat` —
not a checkable certificate.

**Our "certificate" is an attestation:** "BAIF claims Verus accepted this code."

---

# Should We Rename to "Attestation"?

The honest terminology:

| Term | What It Implies | Do We Provide It? |
|------|-----------------|-------------------|
| **Certificate** | Self-verifying proof object | No |
| **Attestation** | Claim by a trusted party | Yes |

**Current state:**
> "BAIF attests that Verus accepted the specs in commit X at time T."

To earn the word "certificate," we'd need either:
- Proof terms from the verifier (Verus/Z3 don't provide this)
- Or: include the **specs themselves** in the record, so reviewers can judge if they're meaningful

---

# The Missing Piece: Specs in the Certificate

Right now we record:
- ✓ Commit hash (what code)
- ✓ Content hash (what results)
- ✓ Toolchain versions (how verified)
- ✗ **The actual specifications** (what was proven)

Without the specs, a verifier can only confirm:
> "Verus accepted *something* — but what properties were actually proven?"

**To make certification meaningful:**
Include spec summaries or links to spec documentation in the certification record.
Otherwise, "72/72 verified" is just "72 functions have *some* annotations that passed."

---

<!-- _class: lead -->

# The Trust Gap

Capability to verify vs. verification actually happening

---

# Two Kinds of Assurance

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

**The trust gap:** If BAIF publishes a Dockerfile but nobody runs it,
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

# Why Deterrence Is Sufficient for BAIF

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

# Pi-Squared proof certificate model

- seems to go beyong Rocq's proof certificate model in this respect:
    - we have a 10GB proof object, then there's a verification cost, say O(proof_size), to run coqchk on this proof term
    - Pi-Squared apparently adds cryptographic verifiability on top of the proof certificate model: 
    ZK proofs have the property that verification time is constant regardless of what's proved

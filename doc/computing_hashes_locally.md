# Computing hashes for probe-verus Output

The hashes are **computed from the output files** (`results.json`, `specs.json`, `proofs.json`) using Foundry's `cast keccak`. The verify.yml workflow reads pre-stored hashes from `certifications/*/history.json` and recomputes them for comparison.

## The Output Files

The probe-verus action produces:

- `./output/atoms.json` -- function inventory (NOT hashed, intermediate only)
- `./output/results.json` -- verification results (this gets hashed as `results_hash`)

Additional steps produce:

- `./output/specs.json` -- from `probe-verus specify` (hashed as `specs_hash`)
- `./output/proof-bundle/proofs.json` -- from `certify_cli generate-proofs` (hashed as `proofs_hash`, currently optional)

## How to Compute Hashes Locally

Requires: [Foundry](https://book.getfoundry.sh/) installed (`cast` binary available).

### Step 1: Individual leaf hashes

```bash
# Hash the results file
RESULTS_HASH=$(cast keccak < ./output/results.json)
echo "Results hash: $RESULTS_HASH"

# Hash the specs file (if you ran probe-verus specify)
SPECS_HASH=$(cast keccak < ./output/specs.json)
echo "Specs hash: $SPECS_HASH"

# Hash the proofs file (if you ran certify_cli generate-proofs)
PROOFS_HASH=$(cast keccak < ./output/proof-bundle/proofs.json)
echo "Proofs hash: $PROOFS_HASH"
```

### Step 2: Merkle root (content_hash)

The content_hash is `keccak256(results_hash || specs_hash [|| proofs_hash])` where the hashes are concatenated as raw 32-byte values:

```bash
# 2-leaf Merkle (results + specs only -- current default)
COMBINED="${RESULTS_HASH#0x}${SPECS_HASH#0x}"
CONTENT_HASH=$(echo -n "$COMBINED" | xxd -r -p | cast keccak)
echo "Content hash (2-leaf): $CONTENT_HASH"

# 3-leaf Merkle (results + specs + proofs -- future)
COMBINED="${RESULTS_HASH#0x}${SPECS_HASH#0x}${PROOFS_HASH#0x}"
CONTENT_HASH=$(echo -n "$COMBINED" | xxd -r -p | cast keccak)
echo "Content hash (3-leaf): $CONTENT_HASH"
```

This is exactly what [certify_cli/foundry.py](certify_cli/foundry.py) does in `compute_merkle_content_hash()` (lines 261-308).

## Verifying a Stored Certification

Instead of running the shell commands above manually, you can use the CLI to perform all local verification checks at once (registry lookup, stored hash check, Merkle structure, proof bundle integrity, taxonomy).

Requires: [Foundry](https://book.getfoundry.sh/) (`cast`), Python 3.12+, and [uv](https://docs.astral.sh/uv/). Run `uv sync` in the certify repo first to install Python dependencies.

```bash
# From the certify repo directory (after running `uv sync`):
uv run python -m certify_cli verify-certification \
  --cert-id beneficial-ai-foundation-pmemlog_with_callgraph \
  --commit 3ea6578c0cac7aeab244e858947e1b023760baa1 \
  --network sepolia \
  --json
```

This outputs structured JSON with all check results. Add `--json` for machine-readable output, or omit it for a human-readable summary. This is the same command that [verify.yml](.github/workflows/verify.yml) uses.

## What the Dockerfile Needs

To replicate [verify.yml](.github/workflows/verify.yml), the Docker image must include:

- **Python 3.12 + uv** -- for `certify_cli` (`uv sync` in certify repo)
- **Foundry** -- for `cast keccak` and on-chain queries (install via `curl -L https://foundry.paradigm.xyz | bash && foundryup`)
- **probe-verus** -- the Rust binary (from `beneficial-ai-foundation/probe-verus`) for fresh re-verification
- **Verus** -- the verification tool (installed by probe-verus action)

### Pipeline steps to replicate:

1. Verify stored certification (registry, hashes, Merkle, proof bundle):
   `uv run python -m certify_cli verify-certification --cert-id <id> --commit <sha> --network <network>`
2. Verify on-chain:
   `uv run python -m certify_cli verify-hash <content_hash> --network <network>`
3. Fresh re-verification: re-run `probe-verus` on the same commit and compare verified/total counts

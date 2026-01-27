# BAIF Certify Action

A GitHub Action to certify content on Ethereum by recording its keccak256 hash on-chain.

## Features

- Certify local files, URLs, or GitHub artifacts
- Support for Ethereum Mainnet and Sepolia testnet
- Optional Gnosis Safe integration for multisig certification
- Outputs transaction hash and Etherscan URL

## Usage

### Basic Usage (Sepolia)

```yaml
- uses: beneficial-ai-foundation/certify/action@v1
  with:
    source: ./build/output.json
    description: "Build artifact for ${{ github.sha }}"
    network: sepolia
    rpc-url: ${{ secrets.SEPOLIA_RPC_URL }}
    private-key: ${{ secrets.SEPOLIA_PRIVATE_KEY }}
    certify-address: ${{ vars.SEPOLIA_CERTIFY_ADDRESS }}
```

### Mainnet with Gnosis Safe

```yaml
- uses: beneficial-ai-foundation/certify/action@v1
  with:
    source: ./results.json
    description: "Verification results"
    network: mainnet
    rpc-url: ${{ secrets.MAINNET_RPC_URL }}
    private-key: ${{ secrets.MAINNET_PRIVATE_KEY }}
    certify-address: ${{ vars.MAINNET_CERTIFY_ADDRESS }}
    safe-address: ${{ vars.MAINNET_SAFE_ADDRESS }}
```

### Using Outputs

```yaml
- uses: beneficial-ai-foundation/certify/action@v1
  id: certify
  with:
    source: ./data.json
    # ... other inputs

- name: Display results
  run: |
    echo "Content Hash: ${{ steps.certify.outputs.content-hash }}"
    echo "Transaction: ${{ steps.certify.outputs.etherscan-url }}"
```

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `source` | Yes | | Path to file, URL, or `github://` artifact to certify |
| `description` | No | `Content certification` | Description for the certification record |
| `network` | No | `sepolia` | Target network: `mainnet`, `sepolia`, or `anvil` |
| `rpc-url` | Yes | | RPC endpoint URL for the target network |
| `private-key` | Yes | | Private key for signing (or Safe owner key) |
| `certify-address` | Yes | | Address of the deployed Certify contract |
| `safe-address` | No | | Gnosis Safe address for multisig certification |
| `safe-execute` | No | `true` | Execute Safe transaction programmatically (automatic for 1-of-N threshold; proposes for multi-sig) |
| `etherscan-api-key` | No | | Etherscan API key for contract verification |

## Outputs

| Output | Description |
|--------|-------------|
| `tx-hash` | Transaction hash of the certification (e.g., `0x123...`) |
| `content-hash` | Keccak256 hash of the certified content |
| `etherscan-url` | Etherscan URL for the transaction |

## Source Formats

The `source` input supports multiple formats:

- **Local file**: `./path/to/file.json` or `/absolute/path`
- **URL**: `https://example.com/file.json`
- **GitHub artifact**: `github://owner/repo/artifacts/artifact_id`

## Complete Example

```yaml
name: Build and Certify

on:
  push:
    branches: [main]

jobs:
  build-and-certify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build
        run: |
          # Your build process
          echo '{"version": "1.0.0"}' > build-manifest.json

      - name: Certify build artifact
        id: certify
        uses: beneficial-ai-foundation/certify/action@v1
        with:
          source: ./build-manifest.json
          description: "Build manifest for ${{ github.sha }}"
          network: sepolia
          rpc-url: ${{ secrets.SEPOLIA_RPC_URL }}
          private-key: ${{ secrets.SEPOLIA_PRIVATE_KEY }}
          certify-address: ${{ vars.CERTIFY_ADDRESS }}

      - name: Summary
        run: |
          echo "## Certification Complete" >> $GITHUB_STEP_SUMMARY
          echo "" >> $GITHUB_STEP_SUMMARY
          echo "- **Content Hash**: \`${{ steps.certify.outputs.content-hash }}\`" >> $GITHUB_STEP_SUMMARY
          echo "- **Transaction**: [${{ steps.certify.outputs.tx-hash }}](${{ steps.certify.outputs.etherscan-url }})" >> $GITHUB_STEP_SUMMARY
```

## With Verus Verification

This action pairs well with the [probe-verus action](https://github.com/beneficial-ai-foundation/probe-verus) for certifying formal verification results:

```yaml
- uses: beneficial-ai-foundation/probe-verus/action@v1
  id: verify
  with:
    project-path: ./my-verus-crate

- uses: beneficial-ai-foundation/certify/action@v1
  with:
    source: ${{ steps.verify.outputs.results-file }}
    description: "Verus verification for ${{ github.sha }}"
    network: mainnet
    rpc-url: ${{ secrets.MAINNET_RPC_URL }}
    private-key: ${{ secrets.MAINNET_PRIVATE_KEY }}
    certify-address: ${{ vars.CERTIFY_ADDRESS }}
    safe-address: ${{ vars.SAFE_ADDRESS }}
```

## License

MIT

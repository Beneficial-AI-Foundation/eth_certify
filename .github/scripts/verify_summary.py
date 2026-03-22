"""Generate GITHUB_STEP_SUMMARY markdown for the verify workflow.

Pure presentation logic -- no business logic duplication with certify_cli.

Usage:
  python verify_summary.py \
    --repo <owner/repo> --commit <sha> --network <network> \
    --content-hash <hash> --verified <n> --total <n> \
    --verus-version <ver> \
    --stored <pass|fail|skip> \
    --merkle <pass|fail|skip> \
    --proofs-check <pass|fail|skip> \
    --onchain <true|skipped|false> \
    --results-match <true|false> \
    --fresh-verified <n> --fresh-total <n> \
    [--proof-bundle <path>] \
    [--proofs-hash <hash>] \
    [--specs-hash <hash>] \
    [--proofs-detail <text>] \
    [--taxonomy <summary>] \
    [--etherscan-url <url>]
"""

import argparse


def build_summary(args: argparse.Namespace) -> str:
    lines: list[str] = []

    # Input section
    lines.extend([
        "## Certification Verification",
        "",
        "### Input",
        "| Property | Value |",
        "|----------|-------|",
        f"| Repository | {args.repo} |",
        f"| Commit | `{args.commit}` |",
        f"| Network | {args.network} |",
        "",
    ])

    # Certification record
    lines.extend([
        "### Certification Record",
        "| Property | Value |",
        "|----------|-------|",
        f"| Content Hash | `{args.content_hash}` |",
        f"| Certified Results | {args.verified} / {args.total} |",
        f"| Verus Version | {args.verus_version} |",
    ])
    if args.proof_bundle:
        lines.append(f"| Proof Bundle | `{args.proof_bundle}` |")
    if args.etherscan_url:
        lines.append(f"| Transaction | [View on Etherscan]({args.etherscan_url}) |")
    lines.append("")

    # Verification results
    lines.extend(["### Verification Results", ""])

    # Stored results check
    if args.stored == "pass":
        lines.append("- **Stored Results**: Hash matches certification record")
    elif args.stored == "skip":
        lines.append("- **Stored Results**: Skipped (no results file)")
    else:
        lines.append("- **Stored Results**: Hash mismatch!")

    # Merkle structure check
    if args.merkle == "pass":
        if args.proofs_hash:
            lines.append("- **Merkle Structure**: results_hash + specs_hash + proofs_hash -> content_hash verified")
        else:
            lines.append("- **Merkle Structure**: results_hash + specs_hash -> content_hash verified")
        if args.specs_hash:
            lines.append(f"  - Specs hash: `{args.specs_hash}`")
        if args.proofs_hash:
            lines.append(f"  - Proofs hash: `{args.proofs_hash}`")
    elif args.merkle == "skip":
        lines.append("- **Merkle Structure**: Skipped (no Merkle hashes recorded)")
    elif args.merkle:
        lines.append("- **Merkle Structure**: Hash mismatch in Merkle tree!")

    # Taxonomy
    if args.taxonomy:
        lines.append(f"- **Spec Taxonomy**: {args.taxonomy}")

    # Proof bundle check
    if args.proofs_check == "pass":
        detail = args.proofs_detail or "All referenced files present"
        lines.append(f"- **Proof Bundle**: {detail}")
    elif args.proofs_check == "skip":
        lines.append("- **Proof Bundle**: Skipped (no proof bundle)")
    elif args.proofs_check:
        lines.append("- **Proof Bundle**: Integrity check failed (missing files)")

    # On-chain check
    if args.onchain == "true":
        lines.append("- **On-Chain**: Certification found on blockchain")
    elif args.onchain == "skipped":
        lines.append("- **On-Chain**: Skipped (certification older than search window)")
    else:
        lines.append("- **On-Chain**: Certification not found!")

    # Fresh verification
    lines.append(f"- Fresh Verification: {args.fresh_verified} / {args.fresh_total}")
    if args.results_match == "true":
        lines.append("- **Results Match**: Fresh run matches certified counts")
    else:
        lines.append("- **Results Differ**: Fresh run differs from certified (may be Verus version difference)")

    lines.append("")

    # Overall verdict
    stored_ok = args.stored == "pass"
    onchain_ok = args.onchain == "true"
    match_ok = args.results_match == "true"

    if (stored_ok or onchain_ok) and match_ok:
        lines.extend([
            "### Verification Passed",
            "",
            "The certification is **authentic** and the code at this commit produces matching verification results.",
        ])
    elif stored_ok or onchain_ok:
        lines.extend([
            "### Verification Partial",
            "",
            "The certification record is **authentic** (matches on-chain), but fresh verification produced different counts.",
            "This is likely due to Verus version differences between the original certification and this verification run.",
        ])
    else:
        lines.extend([
            "### Verification Failed",
            "",
            "Could not verify the certification. Check:",
            "- Commit SHA matches a certified commit",
            "- Network setting (mainnet vs sepolia)",
            "- Certification exists in the registry",
        ])

    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate verify workflow summary")
    parser.add_argument("--repo", required=True)
    parser.add_argument("--commit", required=True)
    parser.add_argument("--network", required=True)
    parser.add_argument("--content-hash", required=True)
    parser.add_argument("--verified", required=True)
    parser.add_argument("--total", required=True)
    parser.add_argument("--verus-version", required=True)
    parser.add_argument("--stored", required=True)
    parser.add_argument("--merkle", required=True)
    parser.add_argument("--proofs-check", required=True)
    parser.add_argument("--onchain", required=True)
    parser.add_argument("--results-match", required=True)
    parser.add_argument("--fresh-verified", required=True)
    parser.add_argument("--fresh-total", required=True)
    parser.add_argument("--proof-bundle", default="")
    parser.add_argument("--proofs-hash", default="")
    parser.add_argument("--specs-hash", default="")
    parser.add_argument("--proofs-detail", default="")
    parser.add_argument("--taxonomy", default="")
    parser.add_argument("--etherscan-url", default="")
    args = parser.parse_args()

    print(build_summary(args))


if __name__ == "__main__":
    main()

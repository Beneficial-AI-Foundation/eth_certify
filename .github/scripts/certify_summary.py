"""Generate GITHUB_STEP_SUMMARY markdown for the certify workflow.

Pure presentation logic -- no business logic duplication with certify_cli.

Usage:
  python certify_summary.py --phase verification \
    --repo <owner/repo> --ref <ref> --commit <sha> \
    --verified <n> --total <n> \
    [--specs] [--proof-bundle] [--taxonomy <summary>]

  python certify_summary.py --phase final \
    --repo <owner/repo> --cert-id <id> \
    --tx-hash <hash> --etherscan-url <url> \
    [--taxonomy <summary>]
"""

import argparse
import sys


def verification_summary(args: argparse.Namespace) -> str:
    """Markdown for the verification phase step summary."""
    lines = [
        "## Verification Results",
        "",
        f"- **Repository**: {args.repo}",
        f"- **Ref**: {args.ref}",
        f"- **Commit**: `{args.commit}`",
        f"- **Verified**: {args.verified} / {args.total}",
    ]
    if args.specs:
        lines.append("- **Specs**: Extracted (Merkle certification)")
    if args.proof_bundle:
        lines.append("- **Proof Certificates**: Generated (Z3 formulas + proofs archived)")
    if args.taxonomy:
        lines.append(f"- **Taxonomy**: {args.taxonomy}")
    return "\n".join(lines)


def final_summary(args: argparse.Namespace) -> str:
    """Markdown for the final certification step summary."""
    lines = [
        "",
        "## Certification Complete",
        "",
        f"**Transaction**: [{args.tx_hash}]({args.etherscan_url})",
    ]
    if args.taxonomy:
        lines.extend(["", f"**Spec Taxonomy**: {args.taxonomy}"])
    lines.extend([
        "",
        f"### Badge for {args.repo}",
        "",
        f"![BAIF Certified](https://raw.githubusercontent.com/Beneficial-AI-Foundation/eth_certify/main/certifications/{args.cert_id}/badge.svg)",
        "",
        "Add to README (SVG - recommended):",
        "",
        "```markdown",
        f"[![BAIF Certified](https://raw.githubusercontent.com/Beneficial-AI-Foundation/eth_certify/main/certifications/{args.cert_id}/badge.svg)](https://github.com/Beneficial-AI-Foundation/eth_certify/blob/main/certifications/{args.cert_id}/history.json)",
        "```",
    ])
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate certify workflow summaries")
    parser.add_argument("--phase", required=True, choices=["verification", "final"])
    parser.add_argument("--repo", default="")
    parser.add_argument("--ref", default="")
    parser.add_argument("--commit", default="")
    parser.add_argument("--verified", default="")
    parser.add_argument("--total", default="")
    parser.add_argument("--specs", action="store_true")
    parser.add_argument("--proof-bundle", action="store_true")
    parser.add_argument("--taxonomy", default="")
    parser.add_argument("--cert-id", default="")
    parser.add_argument("--tx-hash", default="")
    parser.add_argument("--etherscan-url", default="")
    args = parser.parse_args()

    if args.phase == "verification":
        print(verification_summary(args))
    elif args.phase == "final":
        print(final_summary(args))
    else:
        print(f"Unknown phase: {args.phase}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()

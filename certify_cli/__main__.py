"""CLI entry point for the Certify tool."""

import argparse
import sys
from pathlib import Path

from .config import CertifyConfig, EnvConfig, Network
from .deploy import certify_content, deploy_contract
from .proofs import build_proofs_json, summarise_proofs, write_proofs_json
from .registry import update_registry
from .verify import verify_by_content_hash, verify_content


def main() -> int:
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        prog="certify-cli",
        description="Content certification tools for Ethereum (supports URLs and local files)",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    # Deploy command
    deploy_parser = subparsers.add_parser("deploy", help="Deploy the Certify contract")
    deploy_parser.add_argument(
        "--network",
        type=str,
        choices=["mainnet", "sepolia", "anvil", "local"],
        default="sepolia",
        help="Network to deploy to (default: sepolia)",
    )

    # Certify command
    certify_parser = subparsers.add_parser(
        "certify", help="Certify content on-chain (URL or file)"
    )
    certify_parser.add_argument(
        "--network",
        type=str,
        choices=["mainnet", "sepolia", "anvil", "local"],
        default="sepolia",
        help="Network to use (default: sepolia)",
    )
    certify_parser.add_argument(
        "--safe",
        type=str,
        metavar="ADDRESS",
        help="Gnosis Safe address - generates transaction data for Safe UI instead of broadcasting directly",
    )
    certify_parser.add_argument(
        "--execute",
        action="store_true",
        help="When used with --safe, programmatically execute the transaction (requires owner private key)",
    )
    certify_parser.add_argument(
        "--specs-source",
        type=str,
        metavar="PATH",
        help="Path to specs JSON (from probe-verus specify). Enables Merkle-style hashing: "
        "content_hash = keccak256(results_hash || specs_hash)",
    )

    # Verify command
    verify_parser = subparsers.add_parser(
        "verify", help="Verify content against on-chain certification"
    )
    verify_parser.add_argument(
        "--rpc-url",
        type=str,
        help="RPC URL to use (default: from .env or public node)",
    )
    verify_parser.add_argument(
        "--contract",
        type=str,
        help="Contract address (default: from .env)",
    )

    # Verify-hash command (verify by content hash directly)
    verify_hash_parser = subparsers.add_parser(
        "verify-hash",
        help="Verify a content hash exists on-chain (useful for independent verification)",
    )
    verify_hash_parser.add_argument(
        "content_hash",
        type=str,
        help="The keccak256 hash to verify (with or without 0x prefix)",
    )
    verify_hash_parser.add_argument(
        "--network",
        type=str,
        choices=["mainnet", "sepolia"],
        default="sepolia",
        help="Network to verify against (default: sepolia)",
    )
    verify_hash_parser.add_argument(
        "--rpc-url",
        type=str,
        help="RPC URL to use (default: public node for selected network)",
    )
    verify_hash_parser.add_argument(
        "--contract",
        type=str,
        help="Contract address (default: from env or known address)",
    )
    verify_hash_parser.add_argument(
        "--from-block",
        type=int,
        default=None,
        help="Start block for log search (default: current - 50000)",
    )

    # Update-registry command
    registry_parser = subparsers.add_parser(
        "update-registry",
        help="Update certification registry (badges, history, README)",
    )
    registry_parser.add_argument(
        "--cert-id",
        type=str,
        required=True,
        help="Certification ID (e.g., 'owner-repo')",
    )
    registry_parser.add_argument(
        "--repo",
        type=str,
        required=True,
        help="Repository path (e.g., 'Owner/Repo')",
    )
    registry_parser.add_argument(
        "--ref",
        type=str,
        required=True,
        help="Git ref that was certified",
    )
    registry_parser.add_argument(
        "--network",
        type=str,
        required=True,
        help="Ethereum network (mainnet/sepolia)",
    )
    registry_parser.add_argument(
        "--verified",
        type=int,
        required=True,
        help="Number of verified functions",
    )
    registry_parser.add_argument(
        "--total",
        type=int,
        required=True,
        help="Total number of functions",
    )
    registry_parser.add_argument(
        "--tx-hash",
        type=str,
        required=True,
        help="Transaction hash",
    )
    registry_parser.add_argument(
        "--content-hash",
        type=str,
        required=True,
        help="Content hash that was certified",
    )
    registry_parser.add_argument(
        "--commit-sha",
        type=str,
        default=None,
        help="Git commit SHA that was certified",
    )
    registry_parser.add_argument(
        "--verus-version",
        type=str,
        default=None,
        help="Verus version used for verification",
    )
    registry_parser.add_argument(
        "--rust-version",
        type=str,
        default=None,
        help="Rust toolchain version used",
    )
    registry_parser.add_argument(
        "--results-file",
        type=str,
        default=None,
        help="Path to verification results JSON to store",
    )
    registry_parser.add_argument(
        "--results-hash",
        type=str,
        default=None,
        help="keccak256 hash of results.json (Merkle leaf)",
    )
    registry_parser.add_argument(
        "--specs-hash",
        type=str,
        default=None,
        help="keccak256 hash of specs.json (Merkle leaf)",
    )
    registry_parser.add_argument(
        "--specs-file",
        type=str,
        default=None,
        help="Path to specification manifest JSON to store",
    )
    registry_parser.add_argument(
        "--proof-bundle-dir",
        type=str,
        default=None,
        help="Path to proof bundle directory (proofs.json + smt_queries/ + z3_proofs/)",
    )
    registry_parser.add_argument(
        "--proofs-hash",
        type=str,
        default=None,
        help="keccak256 hash of proofs.json (Merkle leaf)",
    )
    registry_parser.add_argument(
        "--base-dir",
        type=str,
        default="certifications",
        help="Base directory for certifications (default: certifications)",
    )

    # Generate-proofs command
    proofs_parser = subparsers.add_parser(
        "generate-proofs",
        help="Generate Z3 proof certificates from Verus SMT logs",
    )
    proofs_parser.add_argument(
        "--smt-log-dir",
        type=str,
        required=True,
        help="Directory containing Verus .smt2 log files (from --log smt -V spinoff-all)",
    )
    proofs_parser.add_argument(
        "--results-file",
        type=str,
        required=True,
        help="Path to verification results JSON (from probe-verus verify)",
    )
    proofs_parser.add_argument(
        "--specs-file",
        type=str,
        default=None,
        help="Path to specs JSON (from probe-verus specify)",
    )
    proofs_parser.add_argument(
        "--output-dir",
        type=str,
        default="proof-bundle",
        help="Output directory for proof bundle (proofs.json + smt_queries/ + z3_proofs/)",
    )
    proofs_parser.add_argument(
        "--z3-binary",
        type=str,
        default="z3",
        help="Path to Z3 binary (default: z3)",
    )
    proofs_parser.add_argument(
        "--timeout",
        type=int,
        default=300,
        help="Z3 timeout per function in seconds (default: 300)",
    )
    proofs_parser.add_argument(
        "--no-proofs",
        action="store_true",
        help="Skip Z3 proof generation (only map functions to .smt2 queries)",
    )

    args = parser.parse_args()

    try:
        if args.command == "deploy":
            return _handle_deploy(args)
        elif args.command == "certify":
            return _handle_certify(args)
        elif args.command == "verify":
            return _handle_verify(args)
        elif args.command == "verify-hash":
            return _handle_verify_hash(args)
        elif args.command == "update-registry":
            return _handle_update_registry(args)
        elif args.command == "generate-proofs":
            return _handle_generate_proofs(args)
    except FileNotFoundError as e:
        print(f"Error: {e}")
        return 1
    except ValueError as e:
        print(f"Error: {e}")
        return 1
    except KeyboardInterrupt:
        print("\nAborted.")
        return 130

    return 0


def _handle_deploy(args: argparse.Namespace) -> int:
    """Handle the deploy command."""
    env = EnvConfig.load()
    network = _parse_network(args.network)

    result = deploy_contract(env, network)
    print(result.message)
    return 0 if result.success else 1


def _handle_certify(args: argparse.Namespace) -> int:
    """Handle the certify command."""
    env = EnvConfig.load()
    certify_config = CertifyConfig.load()
    network = _parse_network(args.network)

    # CLI --specs-source overrides config file
    if args.specs_source:
        certify_config = CertifyConfig(
            source=certify_config.source,
            description=certify_config.description,
            specs_source=args.specs_source,
        )

    # Validate --execute requires --safe
    if args.execute and not args.safe:
        print("Error: --execute requires --safe ADDRESS")
        return 1

    result = certify_content(
        env,
        certify_config,
        network,
        safe_address=args.safe,
        safe_execute=args.execute,
    )
    print(result.message)

    # Output Merkle sub-hashes for downstream consumption (e.g., workflow steps)
    if result.results_hash:
        print(f"Results Hash: {result.results_hash}")
    if result.specs_hash:
        print(f"Specs Hash: {result.specs_hash}")

    return 0 if result.success else 1


def _handle_verify(args: argparse.Namespace) -> int:
    """Handle the verify command."""
    # Load .env for optional overrides
    rpc_url = args.rpc_url
    contract = args.contract

    try:
        env = EnvConfig.load()
        rpc_url = rpc_url or env.sepolia_rpc_url
        contract = contract or env.certify_address
    except FileNotFoundError:
        pass  # .env is optional for verify

    certify_config = CertifyConfig.load()

    result = verify_content(certify_config, rpc_url, contract)
    print(result.message)
    return 0 if result.verified else 1


def _handle_verify_hash(args: argparse.Namespace) -> int:
    """Handle the verify-hash command."""
    import os

    rpc_url = args.rpc_url
    contract = args.contract
    network = args.network

    # Set up RPC URL from env or defaults
    if not rpc_url:
        if network == "mainnet":
            rpc_url = os.getenv(
                "MAINNET_RPC_URL", "https://ethereum-rpc.publicnode.com"
            )
        else:
            rpc_url = os.getenv(
                "SEPOLIA_RPC_URL", "https://ethereum-sepolia-rpc.publicnode.com"
            )

    # Set up contract address from env or defaults
    if not contract:
        contract = os.getenv("CERTIFY_ADDRESS")
        if not contract:
            # Known contract addresses
            if network == "sepolia":
                contract = "0x125721f8a45bbABC60aDbaaF102a94d9cae59238"
            # For mainnet, contract must be set via env or --contract

    if not contract:
        print(f"Error: Contract address required for {network}")
        print("Set CERTIFY_ADDRESS env var or use --contract")
        return 1

    result = verify_by_content_hash(
        args.content_hash,
        rpc_url=rpc_url,
        contract_address=contract,
        network=network,
        from_block=args.from_block,
    )
    print(result.message)
    return 0 if result.verified else 1


def _handle_update_registry(args: argparse.Namespace) -> int:
    """Handle the update-registry command."""
    result = update_registry(
        cert_id=args.cert_id,
        repo_path=args.repo,
        ref=args.ref,
        network=args.network,
        verified=args.verified,
        total=args.total,
        tx_hash=args.tx_hash,
        content_hash=args.content_hash,
        base_dir=Path(args.base_dir),
        commit_sha=args.commit_sha,
        verus_version=args.verus_version,
        rust_version=args.rust_version,
        results_file=args.results_file,
        results_hash=args.results_hash,
        specs_hash=args.specs_hash,
        specs_file=args.specs_file,
        proof_bundle_dir=args.proof_bundle_dir,
        proofs_hash=args.proofs_hash,
    )
    print(result.message)
    return 0 if result.success else 1


def _handle_generate_proofs(args: argparse.Namespace) -> int:
    """Handle the generate-proofs command."""
    import json

    smt_log_dir = Path(args.smt_log_dir)
    results_path = Path(args.results_file)
    specs_path = Path(args.specs_file) if args.specs_file else None
    output_dir = Path(args.output_dir)

    if not smt_log_dir.is_dir():
        print(f"Error: SMT log directory not found: {smt_log_dir}")
        return 1

    if not results_path.is_file():
        print(f"Error: Results file not found: {results_path}")
        return 1

    print("Generating Z3 proof certificates...")
    print(f"  SMT log dir:  {smt_log_dir}")
    print(f"  Results file: {results_path}")
    if specs_path:
        print(f"  Specs file:   {specs_path}")
    print(f"  Output dir:   {output_dir}")
    print(f"  Generate Z3 proofs: {not args.no_proofs}")
    print()

    proofs = build_proofs_json(
        smt_log_dir=smt_log_dir,
        output_dir=output_dir,
        results_path=results_path,
        specs_path=specs_path,
        z3_binary=args.z3_binary,
        timeout_seconds=args.timeout,
        generate_proofs=not args.no_proofs,
    )

    proofs_path = write_proofs_json(proofs, output_dir)

    results = json.loads(results_path.read_text())
    summary = summarise_proofs(proofs, results)
    summary.print_report()

    print(f"\nProof bundle written to {output_dir}/")
    print(f"  proofs.json:    {proofs_path}")
    print(
        f"  smt_queries/:   {len([e for e in proofs.values() if e.get('z3_formula')])} files"
    )
    print(
        f"  z3_proofs/:     {len([e for e in proofs.values() if e.get('z3_proof', {}).get('file')])} files"
    )
    return 0


def _parse_network(network_str: str) -> Network:
    """Parse network string to Network enum."""
    mapping = {
        "mainnet": Network.MAINNET,
        "sepolia": Network.SEPOLIA,
        "anvil": Network.ANVIL,
        "local": Network.LOCAL,
    }
    return mapping[network_str]


if __name__ == "__main__":
    sys.exit(main())

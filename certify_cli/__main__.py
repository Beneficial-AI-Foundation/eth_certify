"""CLI entry point for the Certify tool."""

import argparse
import sys
from pathlib import Path

from .config import CertifyConfig, EnvConfig, Network
from .deploy import certify_content, deploy_contract
from .verify import verify_content


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
        choices=["sepolia", "anvil", "local"],
        default="sepolia",
        help="Network to deploy to (default: sepolia)",
    )

    # Certify command
    certify_parser = subparsers.add_parser("certify", help="Certify content on-chain (URL or file)")
    certify_parser.add_argument(
        "--network",
        type=str,
        choices=["sepolia", "anvil", "local"],
        default="sepolia",
        help="Network to use (default: sepolia)",
    )

    # Verify command
    verify_parser = subparsers.add_parser("verify", help="Verify content against on-chain certification")
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

    args = parser.parse_args()

    try:
        if args.command == "deploy":
            return _handle_deploy(args)
        elif args.command == "certify":
            return _handle_certify(args)
        elif args.command == "verify":
            return _handle_verify(args)
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

    result = certify_content(env, certify_config, network)
    print(result.message)
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


def _parse_network(network_str: str) -> Network:
    """Parse network string to Network enum."""
    mapping = {
        "sepolia": Network.SEPOLIA,
        "anvil": Network.ANVIL,
        "local": Network.LOCAL,
    }
    return mapping[network_str]


if __name__ == "__main__":
    sys.exit(main())


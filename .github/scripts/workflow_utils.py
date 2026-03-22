"""Workflow utilities: JSON-to-GITHUB_OUTPUT bridge and repo URL parsing.

These helpers handle pure plumbing between certify_cli JSON output and
GitHub Actions' key=value output format. No business logic lives here.
"""

import json
import sys
from typing import Any


def parse_repo_url(url: str) -> dict[str, str]:
    """Parse a GitHub repository URL into components.

    Returns dict with: repo_path, owner, repo, cert_id
    """
    path = url.rstrip("/")
    for prefix in ("https://github.com/", "http://github.com/"):
        if path.startswith(prefix):
            path = path[len(prefix) :]
            break
    path = path.removesuffix(".git")

    parts = path.split("/")
    if len(parts) < 2:
        raise ValueError(f"Cannot parse GitHub URL: {url}")

    owner, repo = parts[0], parts[1]
    repo_path = f"{owner}/{repo}"
    cert_id = repo_path.replace("/", "-").lower()

    return {
        "repo_path": repo_path,
        "owner": owner,
        "repo": repo,
        "cert_id": cert_id,
    }


def _resolve_dotted(obj: Any, path: str) -> Any:
    """Resolve a dotted path like 'checks.stored_results.status' in a dict."""
    for key in path.split("."):
        if isinstance(obj, dict):
            obj = obj.get(key)
        else:
            return None
    return obj


def json_to_output(json_str: str, keys: list[str]) -> list[str]:
    """Extract selected keys from JSON and format as key=value lines.

    Keys can be:
      - bare:  "tx_hash"         -> tx_hash=<value>
      - dotted: "checks.stored_results.status:stored_results"
                -> stored_results=<value>
    """
    data = json.loads(json_str)
    lines: list[str] = []

    for spec in keys:
        if ":" in spec:
            json_path, output_key = spec.rsplit(":", 1)
        else:
            json_path = spec
            output_key = spec

        value = _resolve_dotted(data, json_path)
        if value is None:
            value = ""
        elif isinstance(value, bool):
            value = str(value).lower()
        else:
            value = str(value)

        lines.append(f"{output_key}={value}")

    return lines


def gh_warning(msg: str) -> None:
    """Emit a GitHub Actions warning annotation."""
    print(f"::warning::{msg}", file=sys.stderr)


def gh_error(msg: str) -> None:
    """Emit a GitHub Actions error annotation."""
    print(f"::error::{msg}", file=sys.stderr)


def _cli() -> None:
    """CLI entry point.

    Usage:
      python workflow_utils.py parse-repo <url>
      python workflow_utils.py json-to-output <key1> [key2 ...]
        (reads JSON from stdin)
    """
    if len(sys.argv) < 2:
        print("Usage: workflow_utils.py <command> [args...]", file=sys.stderr)
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == "parse-repo":
        if len(sys.argv) < 3:
            print("Usage: workflow_utils.py parse-repo <url>", file=sys.stderr)
            sys.exit(1)
        info = parse_repo_url(sys.argv[2])
        for k, v in info.items():
            print(f"{k}={v}")

    elif cmd == "json-to-output":
        keys = sys.argv[2:]
        if not keys:
            print(
                "Usage: workflow_utils.py json-to-output <key1> [key2 ...]",
                file=sys.stderr,
            )
            sys.exit(1)
        json_str = sys.stdin.read()
        for line in json_to_output(json_str, keys):
            print(line)

    else:
        print(f"Unknown command: {cmd}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    _cli()

"""Parse probe-lean extract output into workflow-consumable key=value pairs.

certify_cli has no knowledge of the probe-lean atoms.json format,
so this script bridges that gap.

Usage:
  python resolve_lean_extract.py \
    --atoms-file <atoms.json> \
    [--functions-file <functions.json>] \
    [--lean-toolchain-file <lean-toolchain>]

Outputs (to stdout, ready for >> $GITHUB_OUTPUT):
  results_file=<absolute path to atoms.json>
  functions_file=<absolute path to functions.json, or empty>
  verified_count=<int>
  total_functions=<int>
  unverified_count=<int>
  lean_version=<version string>
"""

import argparse
import json
import os
import sys


def resolve(
    atoms_path: str,
    functions_path: str = "",
    lean_toolchain_path: str = "",
) -> dict[str, str]:
    """Parse atoms.json and optional functions.json, returning output dict."""
    outputs: dict[str, str] = {}

    if not os.path.isfile(atoms_path):
        print(f"::error::atoms.json not found: {atoms_path}", file=sys.stderr)
        sys.exit(1)

    outputs["results_file"] = os.path.realpath(atoms_path)

    if functions_path and os.path.isfile(functions_path):
        outputs["functions_file"] = os.path.realpath(functions_path)
    else:
        outputs["functions_file"] = ""

    with open(atoms_path) as f:
        raw = json.load(f)

    data = raw.get("data", raw)
    if not isinstance(data, dict):
        print("::error::atoms.json 'data' field is not a dict", file=sys.stderr)
        sys.exit(1)

    verified = 0
    total = 0
    unverified = 0

    for atom in data.values():
        if not isinstance(atom, dict):
            continue
        if not atom.get("is-in-package"):
            continue
        if not atom.get("is-relevant"):
            continue

        total += 1
        status = atom.get("verification-status", "")
        if status == "verified":
            verified += 1
        elif status == "unverified":
            unverified += 1

    outputs["verified_count"] = str(verified)
    outputs["total_functions"] = str(total)
    outputs["unverified_count"] = str(unverified)

    # Extract lean version: prefer envelope source metadata, fall back to lean-toolchain file
    lean_version = ""
    source = raw.get("source", {})
    if isinstance(source, dict):
        lean_version = source.get("lean-version", "")

    if not lean_version and lean_toolchain_path and os.path.isfile(lean_toolchain_path):
        with open(lean_toolchain_path) as f:
            content = f.read().strip()
        # lean-toolchain contains e.g. "leanprover/lean4:v4.28.0-rc1"
        if ":" in content:
            lean_version = content.split(":", 1)[1]
        else:
            lean_version = content

    outputs["lean_version"] = lean_version

    return outputs


def main() -> None:
    parser = argparse.ArgumentParser(description="Resolve probe-lean extract outputs")
    parser.add_argument("--atoms-file", required=True, help="Path to atoms.json")
    parser.add_argument(
        "--functions-file", default="", help="Path to functions.json (from probe-aeneas)"
    )
    parser.add_argument(
        "--lean-toolchain-file",
        default="",
        help="Path to lean-toolchain (fallback for Lean version)",
    )
    args = parser.parse_args()

    outputs = resolve(args.atoms_file, args.functions_file, args.lean_toolchain_file)
    for k, v in outputs.items():
        print(f"{k}={v}")


if __name__ == "__main__":
    main()

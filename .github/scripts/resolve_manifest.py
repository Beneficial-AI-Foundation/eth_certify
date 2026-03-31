"""Download and parse a probe-manifest JSON into workflow-consumable key=value pairs.

The probe-manifest format uses project-specific field prefixes (e.g.
``dalek_lite_repo``, ``dalek_lite_resolved_commit``).  This script discovers
those fields by scanning for known suffixes (``_repo``, ``_resolved_commit``,
``_branch``) and extracts generic fields like ``verified_functions_count``
directly.

Usage:
  python resolve_manifest.py \
    --url <manifest_url> \
    --output-dir ./output

Outputs (to stdout, ready for >> $GITHUB_OUTPUT):
  manifest_file=<local path>
  repo_url=<repo URL>
  repo_path=<owner/repo>
  cert_id=<owner-repo>
  commit_sha=<resolved commit>
  branch=<branch name>
  verified_count=<int>
  total_functions=<int>
  verus_version=<version>
  verus_release_tag=<tag>
  package_name=<cargo package>
"""

import argparse
import json
import os
import sys
import urllib.request

from workflow_utils import parse_repo_url


_SUFFIX_MAP = {
    "_repo": "repo_url",
    "_resolved_commit": "commit_sha",
    "_branch": "branch",
}


def _discover_prefixed_fields(manifest: dict) -> dict[str, str]:
    """Scan top-level keys for known suffixes and return extracted values."""
    results: dict[str, str] = {}
    for key, value in manifest.items():
        if not isinstance(value, str) or not value:
            continue
        for suffix, output_key in _SUFFIX_MAP.items():
            if key.endswith(suffix) and output_key not in results:
                results[output_key] = value
    return results


def resolve(manifest_url: str, output_dir: str) -> dict[str, str]:
    """Download manifest, parse fields, return output dict."""
    os.makedirs(output_dir, exist_ok=True)
    local_path = os.path.join(output_dir, "manifest.json")

    try:
        req = urllib.request.Request(manifest_url, headers={"User-Agent": "certify-cli"})
        with urllib.request.urlopen(req, timeout=60) as resp:  # noqa: S310
            data = resp.read()
    except Exception as exc:
        print(f"::error::Failed to fetch manifest: {exc}", file=sys.stderr)
        sys.exit(1)

    with open(local_path, "wb") as f:
        f.write(data)

    try:
        manifest = json.loads(data)
    except json.JSONDecodeError as exc:
        print(f"::error::Manifest is not valid JSON: {exc}", file=sys.stderr)
        sys.exit(1)

    outputs: dict[str, str] = {"manifest_file": os.path.realpath(local_path)}

    prefixed = _discover_prefixed_fields(manifest)
    outputs.update(prefixed)

    if "repo_url" not in outputs:
        print("::warning::No *_repo field found in manifest", file=sys.stderr)

    # Derive repo_path and cert_id from the repo URL
    if outputs.get("repo_url"):
        try:
            repo_info = parse_repo_url(outputs["repo_url"])
            outputs["repo_path"] = repo_info["repo_path"]
            outputs["cert_id"] = repo_info["cert_id"]
        except (ValueError, KeyError) as exc:
            print(f"::warning::Could not parse repo URL: {exc}", file=sys.stderr)

    # Generic fields
    verified = manifest.get("verified_functions_count")
    if verified is not None:
        outputs["verified_count"] = str(verified)

    total = (manifest.get("verify_summary_from_extract") or {}).get("total_functions")
    if total is None:
        total = manifest.get("to_be_verified")
    if total is not None:
        outputs["total_functions"] = str(total)

    verus_ver = manifest.get("probe_verus_version")
    if verus_ver:
        outputs["verus_version"] = str(verus_ver)

    verus_tag = manifest.get("verus_release_tag")
    if verus_tag:
        outputs["verus_release_tag"] = str(verus_tag)

    package = manifest.get("cargo_package")
    if package:
        outputs["package_name"] = str(package)

    return outputs


def main() -> None:
    parser = argparse.ArgumentParser(description="Download and parse a probe manifest")
    parser.add_argument("--url", required=True, help="URL to the manifest JSON")
    parser.add_argument(
        "--output-dir",
        default="./output",
        help="Directory to save the downloaded manifest (default: ./output)",
    )
    args = parser.parse_args()

    outputs = resolve(args.url, args.output_dir)
    for k, v in outputs.items():
        print(f"{k}={v}")


if __name__ == "__main__":
    main()

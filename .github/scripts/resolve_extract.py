"""Parse probe-verus extract output into workflow-consumable key=value pairs.

certify_cli has no knowledge of the probe-verus extract_summary.json format,
so this script bridges that gap.

Usage:
  python resolve_extract.py \
    --summary-file <extract_summary.json> \
    --extract-file <extract.json>

Outputs (to stdout, ready for >> $GITHUB_OUTPUT):
  extract_file=<path>
  results_file=<path>
  specs_file=<path>
  taxonomy_summary=<label summary or empty>
"""

import argparse
import json
import os
import sys


def resolve(summary_path: str, extract_path: str) -> dict[str, str]:
    """Parse extract summary and extract file, returning output dict."""
    outputs: dict[str, str] = {}

    outputs["extract_file"] = extract_path if (extract_path and os.path.isfile(extract_path)) else ""

    if not os.path.isfile(summary_path):
        print(f"::error::extract_summary.json not found: {summary_path}", file=sys.stderr)
        sys.exit(1)

    with open(summary_path) as f:
        summary = json.load(f)

    data = summary.get("data", {})

    results_file = data.get("verify", {}).get("output_file", "")
    if results_file and os.path.isfile(results_file):
        outputs["results_file"] = os.path.realpath(results_file)
    else:
        if not results_file:
            print("::warning::Results file not found in extract summary", file=sys.stderr)
        outputs["results_file"] = ""

    specs_file = data.get("specify", {}).get("output_file", "")
    if specs_file and os.path.isfile(specs_file):
        outputs["specs_file"] = os.path.realpath(specs_file)
    else:
        outputs["specs_file"] = ""

    # If extract-file wasn't provided by the action, try primary_output from summary
    if not outputs["extract_file"]:
        primary = data.get("extract", {}).get("output_file", "") or summary.get("primary_output", "")
        if primary and os.path.isfile(primary):
            outputs["extract_file"] = os.path.realpath(primary)

    # Taxonomy summary: try extract.json first, fall back to specs.json
    outputs["taxonomy_summary"] = (
        _extract_taxonomy(outputs["extract_file"])
        or _extract_taxonomy(outputs.get("specs_file", ""))
    )

    return outputs


def _extract_taxonomy(path: str) -> str:
    """Extract taxonomy label summary from a JSON file containing spec-labels."""
    if not path or not os.path.isfile(path):
        return ""
    try:
        with open(path) as f:
            raw = json.load(f)

        items = raw.get("data", raw)
        if isinstance(items, dict):
            items = list(items.values())
        if not isinstance(items, list):
            return ""

        all_labels: list[str] = []
        for e in items:
            if isinstance(e, dict):
                all_labels.extend(e.get("spec-labels", []))
        if not all_labels:
            return ""

        from collections import Counter
        counts = Counter(all_labels)
        parts = [f"{count} {label}" for label, count in counts.most_common()]
        return ", ".join(parts)
    except (json.JSONDecodeError, KeyError, TypeError):
        return ""


def main() -> None:
    parser = argparse.ArgumentParser(description="Resolve probe-verus extract outputs")
    parser.add_argument("--summary-file", required=True, help="Path to extract_summary.json")
    parser.add_argument("--extract-file", required=True, help="Path to extract.json")
    args = parser.parse_args()

    outputs = resolve(args.summary_file, args.extract_file)
    for k, v in outputs.items():
        print(f"{k}={v}")


if __name__ == "__main__":
    main()

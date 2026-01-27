"""Certification registry management - badges, history, and documentation."""

import json
import shutil
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional


@dataclass
class CertificationEntry:
    """A single certification record."""
    timestamp: str
    ref: str
    network: str
    tx_hash: str
    content_hash: str
    etherscan_url: str
    verified: int
    total: int
    verus_version: Optional[str] = None
    rust_version: Optional[str] = None
    results_file: Optional[str] = None


@dataclass
class RegistryUpdateResult:
    """Result of a registry update operation."""
    success: bool
    message: str
    cert_dir: Path


def update_registry(
    cert_id: str,
    repo_path: str,
    ref: str,
    network: str,
    verified: int,
    total: int,
    tx_hash: str,
    content_hash: str,
    base_dir: Path = Path("certifications"),
    verus_version: Optional[str] = None,
    rust_version: Optional[str] = None,
    results_file: Optional[str] = None,
) -> RegistryUpdateResult:
    """
    Update the certification registry with a new certification.
    
    Creates/updates:
    - badge.json (shields.io endpoint)
    - badge.svg (custom SVG badge)
    - history.json (certification history)
    - README.md (badge instructions)
    - results/<timestamp>.json (verification results, if provided)
    
    Args:
        cert_id: Unique certification ID (e.g., "owner-repo")
        repo_path: Repository path (e.g., "Owner/Repo")
        ref: Git ref that was certified
        network: Ethereum network (mainnet/sepolia)
        verified: Number of verified functions
        total: Total number of functions
        tx_hash: Transaction hash
        content_hash: Content hash that was certified
        base_dir: Base directory for certifications
        verus_version: Verus version used for verification
        rust_version: Rust toolchain version used
        results_file: Path to verification results JSON to store
        
    Returns:
        RegistryUpdateResult with success status and message
    """
    cert_dir = base_dir / cert_id
    cert_dir.mkdir(parents=True, exist_ok=True)
    
    timestamp = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    timestamp_safe = timestamp.replace(":", "-")  # Safe for filenames
    
    try:
        # Calculate percentage for badge color
        percent = (verified * 100 // total) if total > 0 else 0
        
        # Determine Etherscan URL
        if network == "mainnet":
            etherscan_url = f"https://etherscan.io/tx/{tx_hash}"
        else:
            etherscan_url = f"https://{network}.etherscan.io/tx/{tx_hash}"
        
        # Store results file if provided
        stored_results_path = None
        if results_file:
            results_dir = cert_dir / "results"
            results_dir.mkdir(exist_ok=True)
            
            # Copy to timestamped file
            dest_file = results_dir / f"{timestamp_safe}.json"
            shutil.copy2(results_file, dest_file)
            
            # Also copy to latest.json
            latest_file = results_dir / "latest.json"
            shutil.copy2(results_file, latest_file)
            
            stored_results_path = f"results/{timestamp_safe}.json"
        
        # 1. Create badge.json for shields.io
        _create_badge_json(cert_dir, verified, total, percent)
        
        # 2. Create badge.svg
        _create_badge_svg(cert_dir, verified, total, percent)
        
        # 3. Update history.json
        entry = CertificationEntry(
            timestamp=timestamp,
            ref=ref,
            network=network,
            tx_hash=tx_hash,
            content_hash=content_hash,
            etherscan_url=etherscan_url,
            verified=verified,
            total=total,
            verus_version=verus_version,
            rust_version=rust_version,
            results_file=stored_results_path,
        )
        _update_history(cert_dir, entry)
        
        # 4. Create README.md
        _create_readme(cert_dir, cert_id, repo_path, entry)
        
        return RegistryUpdateResult(
            success=True,
            message=f"✅ Registry updated: {cert_dir}",
            cert_dir=cert_dir,
        )
        
    except Exception as e:
        return RegistryUpdateResult(
            success=False,
            message=f"❌ Failed to update registry: {e}",
            cert_dir=cert_dir,
        )


def _get_badge_color(percent: int) -> str:
    """Get shields.io color based on verification percentage."""
    if percent >= 90:
        return "brightgreen"
    elif percent >= 70:
        return "green"
    elif percent >= 50:
        return "yellow"
    else:
        return "orange"


def _get_svg_bg_color(percent: int) -> str:
    """Get SVG background color based on verification percentage."""
    if percent == 100:
        return "#2ea44f"  # GitHub green
    elif percent >= 50:
        return "#dbab09"  # Yellow
    else:
        return "#cb2431"  # Red


def _create_badge_json(cert_dir: Path, verified: int, total: int, percent: int) -> None:
    """Create shields.io badge JSON."""
    badge_data = {
        "schemaVersion": 1,
        "label": "BAIF Certified",
        "message": f"{verified}/{total} verified",
        "color": _get_badge_color(percent),
        "namedLogo": "ethereum",
        "logoColor": "white",
    }
    
    badge_file = cert_dir / "badge.json"
    with open(badge_file, "w") as f:
        json.dump(badge_data, f, indent=2)


def _create_badge_svg(cert_dir: Path, verified: int, total: int, percent: int) -> None:
    """Create custom SVG badge."""
    bg_color = _get_svg_bg_color(percent)
    label_width = 110  # Wider for better spacing
    message_width = 95
    total_width = label_width + message_width
    
    # Checkmark position based on total width
    checkmark_x = total_width - 18
    
    # Checkmark for 100% verified
    checkmark = ""
    if percent == 100:
        checkmark = f'''<g transform="translate({checkmark_x}, 8)">
    <circle cx="5" cy="5" r="5" fill="#fff" fill-opacity="0.3"/>
    <path d="M2 5l2 2 4-4" stroke="#fff" stroke-width="1.5" fill="none"/>
  </g>'''
    
    svg_content = f'''<svg xmlns="http://www.w3.org/2000/svg" width="{total_width}" height="28" role="img" aria-label="BAIF Certified: {verified}/{total} verified">
  <title>BAIF Certified: {verified}/{total} verified</title>
  <defs>
    <linearGradient id="bg" x2="0" y2="100%">
      <stop offset="0" stop-color="#555" stop-opacity=".1"/>
      <stop offset="1" stop-opacity=".1"/>
    </linearGradient>
    <clipPath id="r">
      <rect width="{total_width}" height="28" rx="6" fill="#fff"/>
    </clipPath>
  </defs>
  <g clip-path="url(#r)">
    <rect width="{label_width}" height="28" fill="#333"/>
    <rect x="{label_width}" width="{message_width}" height="28" fill="{bg_color}"/>
    <rect width="{total_width}" height="28" fill="url(#bg)"/>
  </g>
  <g fill="#fff" text-anchor="middle" font-family="Verdana,Geneva,DejaVu Sans,sans-serif" font-size="11" font-weight="bold">
    <g transform="translate(6, 6) scale(0.038)">
      <path fill="#fff" fill-opacity="0.9" d="M127.961 0l-2.795 9.5v275.668l2.795 2.79 127.962-75.638z"/>
      <path fill="#fff" fill-opacity="0.7" d="M127.962 0L0 212.32l127.962 75.639V154.158z"/>
      <path fill="#fff" fill-opacity="0.9" d="M127.961 312.187l-1.575 1.92v98.199l1.575 4.601L256 236.587z"/>
      <path fill="#fff" fill-opacity="0.7" d="M127.962 416.905v-104.72L0 236.585z"/>
    </g>
    <text x="62" y="18" fill="#fff">BAIF Certified</text>
    <text x="{label_width + message_width // 2}" y="18" fill="#fff">{verified}/{total} verified</text>
  </g>
  {checkmark}
</svg>
'''
    
    svg_file = cert_dir / "badge.svg"
    with open(svg_file, "w") as f:
        f.write(svg_content)


def _update_history(cert_dir: Path, entry: CertificationEntry) -> None:
    """Update certification history JSON."""
    history_file = cert_dir / "history.json"
    
    if history_file.exists():
        with open(history_file) as f:
            history = json.load(f)
    else:
        history = {"certifications": []}
    
    # Add new entry at the beginning
    new_entry = {
        "timestamp": entry.timestamp,
        "ref": entry.ref,
        "network": entry.network,
        "tx_hash": entry.tx_hash,
        "content_hash": entry.content_hash,
        "etherscan_url": entry.etherscan_url,
        "verified": entry.verified,
        "total": entry.total,
    }
    
    # Add optional fields if present
    if entry.verus_version:
        new_entry["verus_version"] = entry.verus_version
    if entry.rust_version:
        new_entry["rust_version"] = entry.rust_version
    if entry.results_file:
        new_entry["results_file"] = entry.results_file
    
    history["certifications"].insert(0, new_entry)
    
    with open(history_file, "w") as f:
        json.dump(history, f, indent=2)


def _create_readme(
    cert_dir: Path,
    cert_id: str,
    repo_path: str,
    entry: CertificationEntry,
) -> None:
    """Create README with badge instructions."""
    # Build toolchain info section
    toolchain_info = ""
    if entry.verus_version or entry.rust_version:
        toolchain_info = "\n### Toolchain\n"
        if entry.verus_version:
            toolchain_info += f"- **Verus**: {entry.verus_version}\n"
        if entry.rust_version:
            toolchain_info += f"- **Rust**: {entry.rust_version}\n"
    
    # Build results link if available
    results_link = ""
    if entry.results_file:
        results_link = f"\n- **Results**: [{entry.results_file}]({entry.results_file})"
    
    readme_content = f'''# BAIF Certification: {repo_path}

<p align="center">
  <a href="https://github.com/Beneficial-AI-Foundation/eth_certify/blob/main/certifications/{cert_id}/history.json">
    <img src="badge.svg" alt="BAIF Certified" />
  </a>
</p>

## Badge

Add this to your project's README:

**Option 1: SVG Badge (recommended)**
```markdown
[![BAIF Certified](https://raw.githubusercontent.com/Beneficial-AI-Foundation/eth_certify/main/certifications/{cert_id}/badge.svg)](https://github.com/Beneficial-AI-Foundation/eth_certify/blob/main/certifications/{cert_id}/history.json)
```

**Option 2: Shields.io Endpoint**
```markdown
[![BAIF Certified](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/Beneficial-AI-Foundation/eth_certify/main/certifications/{cert_id}/badge.json)](https://github.com/Beneficial-AI-Foundation/eth_certify/blob/main/certifications/{cert_id}/history.json)
```

## Latest Certification

- **Verified**: {entry.verified}/{entry.total} functions
- **Network**: {entry.network}
- **Transaction**: [{entry.tx_hash}]({entry.etherscan_url})
- **Content Hash**: `{entry.content_hash}`{results_link}
{toolchain_info}
## Verification History

See [history.json](history.json) for all certifications.
'''
    
    readme_file = cert_dir / "README.md"
    with open(readme_file, "w") as f:
        f.write(readme_content)

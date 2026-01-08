"""Foundry CLI wrappers (forge and cast commands)."""

import io
import os
import subprocess
import zipfile
from dataclasses import dataclass
from typing import Optional

import httpx


@dataclass(frozen=True)
class ForgeResult:
    """Result of a forge command execution."""
    success: bool
    stdout: str
    stderr: str


def run_forge(args: list[str], capture_output: bool = False) -> ForgeResult:
    """Run a forge command with the given arguments."""
    cmd = ["forge"] + args
    result = subprocess.run(
        cmd,
        capture_output=capture_output,
        text=True,
    )
    return ForgeResult(
        success=result.returncode == 0,
        stdout=result.stdout if capture_output else "",
        stderr=result.stderr if capture_output else "",
    )


def run_cast(args: list[str]) -> str:
    """Run a cast command and return stdout."""
    cmd = ["cast"] + args
    result = subprocess.run(cmd, capture_output=True, text=True, check=True)
    return result.stdout.strip()


def cast_keccak(data: str | bytes) -> str:
    """Compute keccak256 hash using cast."""
    if isinstance(data, str):
        data = data.encode()
    result = subprocess.run(
        ["cast", "keccak"],
        input=data,
        capture_output=True,
        check=True,
    )
    return result.stdout.decode().strip()


def cast_block_number(rpc_url: str) -> int:
    """Get the current block number."""
    output = run_cast(["block-number", "--rpc-url", rpc_url])
    return int(output)


def cast_to_dec(hex_value: str) -> int:
    """Convert hex to decimal."""
    output = run_cast(["to-dec", hex_value])
    return int(output)


def cast_logs(
    rpc_url: str,
    address: str,
    event_sig: str,
    topic1: str,
    from_block: int,
) -> Optional[str]:
    """Query event logs from the blockchain."""
    try:
        output = run_cast([
            "logs",
            "--rpc-url", rpc_url,
            "--from-block", str(from_block),
            "--address", address,
            event_sig,
            topic1,
        ])
        return output if output else None
    except subprocess.CalledProcessError:
        return None


def fetch_content(source: str, filename: Optional[str] = None) -> bytes:
    """Fetch content from a URL, GitHub artifact, or local file path.
    
    Supported source formats:
    - Local file: ./path/to/file.json or /absolute/path
    - URL: https://example.com/file.json
    - GitHub raw: https://raw.githubusercontent.com/owner/repo/branch/path
    - GitHub artifact: github://owner/repo/artifacts/artifact_id[/filename.json]
    
    Args:
        source: The source path, URL, or GitHub artifact reference
        filename: For artifacts containing multiple files, specify which file to extract
    """
    if source.startswith("github://"):
        return _fetch_github_artifact(source, filename)
    elif _is_url(source):
        response = httpx.get(source, follow_redirects=True)
        response.raise_for_status()
        return response.content
    else:
        # Treat as local file path
        from pathlib import Path
        path = Path(source).expanduser().resolve()
        if not path.exists():
            raise FileNotFoundError(f"File not found: {path}")
        return path.read_bytes()


def _fetch_github_artifact(source: str, filename: Optional[str] = None) -> bytes:
    """Fetch a GitHub Actions workflow artifact.
    
    Format: github://owner/repo/artifacts/artifact_id[/filename]
    
    Requires GITHUB_TOKEN environment variable for private repos.
    """
    # Parse: github://owner/repo/artifacts/artifact_id[/filename]
    parts = source.replace("github://", "").split("/")
    if len(parts) < 4 or parts[2] != "artifacts":
        raise ValueError(
            f"Invalid GitHub artifact URL: {source}\n"
            "Expected format: github://owner/repo/artifacts/artifact_id[/filename]"
        )
    
    owner = parts[0]
    repo = parts[1]
    artifact_id = parts[3]
    
    # Filename can be in the URL or passed as argument
    if len(parts) > 4:
        filename = "/".join(parts[4:])
    
    # Get GitHub token
    token = os.getenv("GITHUB_TOKEN")
    headers = {}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    headers["Accept"] = "application/vnd.github+json"
    headers["X-GitHub-Api-Version"] = "2022-11-28"
    
    # Download the artifact zip
    url = f"https://api.github.com/repos/{owner}/{repo}/actions/artifacts/{artifact_id}/zip"
    
    response = httpx.get(url, headers=headers, follow_redirects=True)
    if response.status_code == 401:
        raise PermissionError(
            "GitHub authentication required. Set GITHUB_TOKEN environment variable."
        )
    response.raise_for_status()
    
    # Artifacts are always zipped - extract the content
    with zipfile.ZipFile(io.BytesIO(response.content)) as zf:
        names = zf.namelist()
        
        if not names:
            raise ValueError(f"Artifact {artifact_id} is empty")
        
        if filename:
            # Extract specific file
            if filename not in names:
                raise FileNotFoundError(
                    f"File '{filename}' not found in artifact. Available: {names}"
                )
            return zf.read(filename)
        elif len(names) == 1:
            # Single file - extract it
            return zf.read(names[0])
        else:
            # Multiple files - need to specify which one
            raise ValueError(
                f"Artifact contains multiple files: {names}\n"
                f"Specify which file to use: github://{owner}/{repo}/artifacts/{artifact_id}/FILENAME"
            )


def compute_content_hash(source: str, filename: Optional[str] = None) -> str:
    """Fetch content from URL, file, or artifact and compute its keccak256 hash."""
    content = fetch_content(source, filename)
    return cast_keccak(content)


def _is_url(source: str) -> bool:
    """Check if source is a URL or a file path."""
    return source.startswith(("http://", "https://"))


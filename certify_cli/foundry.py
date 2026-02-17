"""Foundry CLI wrappers (forge and cast commands)."""

import io
import ipaddress
import os
import socket
import subprocess
import zipfile
from dataclasses import dataclass
from typing import Optional
from urllib.parse import urlparse

import httpx


@dataclass(frozen=True)
class ForgeResult:
    """Result of a forge command execution."""

    success: bool
    stdout: str
    stderr: str


def run_forge(
    args: list[str],
    capture_output: bool = False,
    env_extra: dict[str, str] | None = None,
) -> ForgeResult:
    """Run a forge command with the given arguments.

    Args:
        args: Arguments to pass to forge.
        capture_output: Capture stdout/stderr instead of inheriting.
        env_extra: Extra environment variables merged into the current env.
                   Use this instead of CLI flags for secrets (e.g. private keys)
                   to avoid leaking them in /proc/<pid>/cmdline.
    """
    cmd = ["forge"] + args
    env = None
    if env_extra:
        env = {**os.environ, **env_extra}
    result = subprocess.run(
        cmd,
        capture_output=capture_output,
        text=True,
        env=env,
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
    topic2: Optional[str] = None,
) -> Optional[str]:
    """Query event logs from the blockchain.

    Args:
        rpc_url: RPC endpoint URL
        address: Contract address
        event_sig: Event signature hash
        topic1: First indexed topic (or empty string "" to match any)
        from_block: Starting block number
        topic2: Optional second indexed topic
    """
    try:
        args = [
            "logs",
            "--rpc-url",
            rpc_url,
            "--from-block",
            str(from_block),
            "--address",
            address,
            event_sig,
            topic1,
        ]
        if topic2 is not None:
            args.append(topic2)

        output = run_cast(args)
        return output if output else None
    except subprocess.CalledProcessError:
        return None


def _validate_url(url: str) -> None:
    """Validate a URL against SSRF attacks.

    Blocks private/loopback/link-local IPs, non-HTTP(S) schemes,
    and URLs without a hostname.

    Raises:
        ValueError: If the URL is unsafe.
    """
    parsed = urlparse(url)
    if parsed.scheme not in ("http", "https"):
        raise ValueError(f"Unsupported URL scheme '{parsed.scheme}': {url}")

    hostname = parsed.hostname
    if not hostname:
        raise ValueError(f"No hostname in URL: {url}")

    # Resolve hostname and check all addresses
    try:
        for info in socket.getaddrinfo(hostname, None, proto=socket.IPPROTO_TCP):
            addr = ipaddress.ip_address(info[4][0])
            if addr.is_private or addr.is_loopback or addr.is_link_local or addr.is_reserved:
                raise ValueError(
                    f"URL resolves to blocked address {addr}: {url}"
                )
    except socket.gaierror as exc:
        raise ValueError(f"Cannot resolve hostname '{hostname}': {exc}") from exc


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
        _validate_url(source)
        response = httpx.get(source, follow_redirects=False)
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


def compute_merkle_content_hash(
    results_source: str,
    specs_source: str,
    proofs_source: Optional[str] = None,
) -> tuple[str, str, str, Optional[str]]:
    """Compute a Merkle-style content hash from results, specs, and optionally proofs.

    The on-chain hash is the keccak256 of the concatenation of the
    individual hashes (each a 32-byte value).  This allows independent
    verification of each artifact while only requiring a single
    on-chain transaction.

    When proofs_source is provided, the Merkle tree has three leaves:
        content_hash = keccak256(results_hash || specs_hash || proofs_hash)

    When proofs_source is None (backwards compatible), it uses two leaves:
        content_hash = keccak256(results_hash || specs_hash)

    Args:
        results_source: Path/URL/artifact reference for results.json
        specs_source: Path/URL/artifact reference for specs.json
        proofs_source: Optional path/URL/artifact reference for proofs.json

    Returns:
        Tuple of (content_hash, results_hash, specs_hash, proofs_hash) where:
          results_hash = keccak256(results.json)
          specs_hash   = keccak256(specs.json)
          proofs_hash  = keccak256(proofs.json) or None
          content_hash = keccak256(results_hash || specs_hash [|| proofs_hash])
    """
    results_content = fetch_content(results_source)
    specs_content = fetch_content(specs_source)

    results_hash = cast_keccak(results_content)
    specs_hash = cast_keccak(specs_content)

    # Concatenate the raw 32-byte hashes
    combined = bytes.fromhex(results_hash[2:]) + bytes.fromhex(specs_hash[2:])

    proofs_hash = None
    if proofs_source:
        proofs_content = fetch_content(proofs_source)
        proofs_hash = cast_keccak(proofs_content)
        combined += bytes.fromhex(proofs_hash[2:])

    content_hash = cast_keccak(combined)

    return content_hash, results_hash, specs_hash, proofs_hash


def _is_url(source: str) -> bool:
    """Check if source is a URL or a file path."""
    return source.startswith(("http://", "https://"))

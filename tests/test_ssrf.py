"""P6: SSRF prevention tests for _validate_url and fetch_content.

Security boundary -- SSRF allows attackers to hit internal services
(cloud metadata, internal APIs) from CI runners via crafted CERTIFY_SOURCE.
"""

import socket
from unittest.mock import patch

import pytest

from certify_cli.foundry import _validate_url, fetch_content


def _mock_getaddrinfo(ip: str):
    """Return a mock getaddrinfo result that resolves to the given IP."""

    def _inner(hostname, port, **kwargs):
        return [(socket.AF_INET, socket.SOCK_STREAM, socket.IPPROTO_TCP, "", (ip, 0))]

    return _inner


class TestSchemeBlocking:
    """Only http and https schemes are allowed."""

    @pytest.mark.parametrize(
        "url",
        [
            "file:///etc/passwd",
            "ftp://evil.com/data",
            "gopher://internal:70/",
            "data:text/html,<script>alert(1)</script>",
        ],
    )
    def test_non_http_scheme_blocked(self, url: str):
        with pytest.raises(ValueError, match="Unsupported URL scheme"):
            _validate_url(url)


class TestHostnameValidation:
    """URLs must have a resolvable hostname."""

    @pytest.mark.parametrize(
        "url",
        [
            "http://",
            "https:///path/only",
        ],
    )
    def test_missing_hostname_blocked(self, url: str):
        with pytest.raises(ValueError, match="No hostname"):
            _validate_url(url)

    def test_dns_failure_blocked(self):
        with patch(
            "certify_cli.foundry.socket.getaddrinfo",
            side_effect=socket.gaierror("NXDOMAIN"),
        ):
            with pytest.raises(ValueError, match="Cannot resolve hostname"):
                _validate_url("https://nonexistent.invalid")


class TestIPBlocking:
    """Private, loopback, link-local, and reserved IPs are blocked."""

    @pytest.mark.parametrize(
        "ip,label",
        [
            ("10.0.0.1", "RFC 1918 class A"),
            ("172.16.0.1", "RFC 1918 class B"),
            ("192.168.1.1", "RFC 1918 class C"),
            ("127.0.0.1", "loopback IPv4"),
            ("169.254.169.254", "cloud metadata / link-local"),
            ("0.0.0.0", "reserved"),
        ],
    )
    def test_blocked_ip(self, ip: str, label: str):
        with patch("certify_cli.foundry.socket.getaddrinfo", _mock_getaddrinfo(ip)):
            with pytest.raises(ValueError, match="blocked address"):
                _validate_url("https://attacker-controlled.com")


class TestValidURL:
    """Public IPs should pass validation."""

    def test_public_ip_allowed(self):
        with patch(
            "certify_cli.foundry.socket.getaddrinfo", _mock_getaddrinfo("93.184.216.34")
        ):
            _validate_url("https://example.com")


class TestFetchContentIntegration:
    """Verify _validate_url is actually called before HTTP fetching."""

    def test_ssrf_blocked_in_fetch_content(self):
        with patch(
            "certify_cli.foundry.socket.getaddrinfo",
            _mock_getaddrinfo("169.254.169.254"),
        ):
            with pytest.raises(ValueError, match="blocked address"):
                fetch_content("https://evil.com/steal-metadata")

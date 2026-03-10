"""Utilities for handling probe-verus Schema 2.0 metadata envelopes.

Since probe-verus v2.0.0, all JSON outputs are wrapped in a metadata envelope:

    {"tool": {...}, "source": {...}, "timestamp": "...", "data": <payload>}

The helper here transparently unwraps the envelope when present, while
remaining backward-compatible with bare (v1.x) JSON files.
"""

from typing import Any


def unwrap_envelope(data: Any) -> Any:
    """Unwrap a Schema 2.0 envelope if present, otherwise return data as-is.

    Detects the envelope by checking for a ``"data"`` key alongside at least
    one of the standard envelope metadata keys (``tool``, ``source``,
    ``timestamp``).
    """
    if (
        isinstance(data, dict)
        and "data" in data
        and any(k in data for k in ("tool", "source", "timestamp"))
    ):
        return data["data"]
    return data

"""Envelope unwrapping correctness tests.

probe-verus Schema 2.0 wraps data in a metadata envelope. The unwrap
function must detect and strip it, while passing bare data through.
"""

from certify_cli.envelope import unwrap_envelope


class TestUnwrapEnvelope:
    def test_schema_2_with_tool_key(self):
        envelope = {"tool": {"name": "probe-verus"}, "data": {"atoms": {"fn": {}}}}
        assert unwrap_envelope(envelope) == {"atoms": {"fn": {}}}

    def test_schema_2_with_all_metadata(self):
        envelope = {
            "tool": {"name": "probe-verus", "version": "2.0.0"},
            "source": {"commit": "abc123"},
            "timestamp": "2026-03-22T12:00:00Z",
            "data": [1, 2, 3],
        }
        assert unwrap_envelope(envelope) == [1, 2, 3]

    def test_bare_dict_no_envelope(self):
        bare = {"atoms": {"fn_a": {"verified": True}}}
        assert unwrap_envelope(bare) is bare

    def test_dict_with_data_key_but_no_metadata(self):
        """A dict that has 'data' but no tool/source/timestamp is NOT an envelope."""
        not_envelope = {"data": 42, "other": "thing"}
        assert unwrap_envelope(not_envelope) is not_envelope

    def test_non_dict_input(self):
        assert unwrap_envelope([1, 2, 3]) == [1, 2, 3]
        assert unwrap_envelope("just a string") == "just a string"
        assert unwrap_envelope(42) == 42

    def test_nested_data_preserved(self):
        inner = {"nested": {"deep": [1, {"key": "val"}]}}
        envelope = {"tool": {"name": "test"}, "data": inner}
        result = unwrap_envelope(envelope)
        assert result == inner
        assert result is inner

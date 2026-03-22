"""P9: Proof bundle correctness. C2 regression: name-matching heuristics.

Locks down the function mapping behavior so regressions in the fragile
name-matching heuristics (C2) are caught immediately.
"""

from pathlib import Path

from certify_cli.proofs import (
    _prepare_proof_query,
    build_function_mapping,
    extract_function_def,
    extract_module_from_probe_key,
    extract_module_from_verus_name,
    normalise_probe_name,
    normalise_verus_name,
)


class TestFunctionDefExtraction:
    """Extract the ;; Function-Def name from .smt2 files."""

    def test_single_function_def(self, tmp_path):
        smt2 = tmp_path / "test.smt2"
        smt2.write_text(
            "(set-logic ALL)\n"
            ";; Function-Def lib::mod::MyStruct::my_func\n"
            "(check-sat)\n"
        )
        assert extract_function_def(smt2) == "lib::mod::MyStruct::my_func"

    def test_multiple_function_defs_returns_last(self, tmp_path):
        smt2 = tmp_path / "test.smt2"
        smt2.write_text(
            ";; Function-Def lib::dep::helper\n"
            ";; Function-Def lib::mod::actual_target\n"
            "(check-sat)\n"
        )
        assert extract_function_def(smt2) == "lib::mod::actual_target"

    def test_no_function_def(self, tmp_path):
        smt2 = tmp_path / "test.smt2"
        smt2.write_text("(set-logic ALL)\n(check-sat)\n")
        assert extract_function_def(smt2) is None


class TestNameNormalization:
    """Verus and probe name normalization for matching."""

    def test_verus_name_extracts_bare_function(self):
        assert (
            normalise_verus_name("lib::logimpl_v::UntrustedLogImpl::untrusted_append")
            == "untrusted_append"
        )

    def test_verus_single_segment(self):
        assert normalise_verus_name("standalone_func") == "standalone_func"

    def test_probe_name_extracts_function(self):
        assert (
            normalise_probe_name(
                "probe:pmemlog/0.1.0/logimpl_v/&mut/impl&%0.UntrustedLogImpl#untrusted_append()"
            )
            == "untrusted_append"
        )

    def test_probe_name_without_hash(self):
        assert (
            normalise_probe_name("probe:crate/1.0/mod/simple_func()") == "simple_func"
        )

    def test_probe_name_no_parens(self):
        assert normalise_probe_name("probe:crate/1.0/mod#my_func") == "my_func"


class TestModuleExtraction:
    """Module name extraction for matching disambiguation."""

    def test_verus_module_with_lib_prefix(self):
        assert (
            extract_module_from_verus_name("lib::logimpl_v::UntrustedLogImpl::append")
            == "logimpl_v"
        )

    def test_verus_module_without_lib(self):
        assert extract_module_from_verus_name("mymod::MyStruct::func") == "mymod"

    def test_verus_single_segment_returns_none(self):
        assert extract_module_from_verus_name("func") is None

    def test_probe_module(self):
        assert (
            extract_module_from_probe_key("probe:pmemlog/0.1.0/logimpl_v/path/to/func")
            == "logimpl_v"
        )

    def test_probe_short_key_returns_none(self):
        assert extract_module_from_probe_key("probe:x/y") is None


class TestFunctionMapping:
    """C2 regression: function mapping correctness."""

    def _make_smt2(self, tmp_path: Path, filename: str, func_def: str) -> Path:
        p = tmp_path / filename
        p.write_text(f";; Function-Def {func_def}\n(check-sat)\n")
        return p

    def test_exact_module_match(self, tmp_path):
        smt2 = self._make_smt2(
            tmp_path, "test._01.smt2", "lib::logimpl_v::UntrustedLogImpl::append"
        )
        results = {"probe:pmemlog/0.1.0/logimpl_v/impl#append()": {"verified": True}}

        mapping = build_function_mapping([smt2], results)
        assert "probe:pmemlog/0.1.0/logimpl_v/impl#append()" in mapping

    def test_unique_fallback(self, tmp_path):
        """When function name is unique across all files, match by name alone."""
        smt2 = self._make_smt2(tmp_path, "test._01.smt2", "lib::other_mod::unique_func")
        results = {
            "probe:crate/1.0/different_mod/path#unique_func()": {"verified": True}
        }

        mapping = build_function_mapping([smt2], results)
        assert "probe:crate/1.0/different_mod/path#unique_func()" in mapping

    def test_ambiguous_with_module_hint(self, tmp_path):
        """Multiple candidates, module substring narrows to one."""
        smt2_a = self._make_smt2(
            tmp_path, "a._01.smt2", "lib::mod_a::MyStruct::do_thing"
        )
        smt2_b = self._make_smt2(
            tmp_path, "b._01.smt2", "lib::mod_b::OtherStruct::do_thing"
        )
        results = {"probe:crate/1.0/mod_a/impl#do_thing()": {"verified": True}}

        mapping = build_function_mapping([smt2_a, smt2_b], results)
        key = "probe:crate/1.0/mod_a/impl#do_thing()"
        assert key in mapping
        assert "mod_a" in mapping[key]["verus_function_name"]

    def test_no_match_excluded(self, tmp_path):
        smt2 = self._make_smt2(tmp_path, "test._01.smt2", "lib::mod::existing_func")
        results = {"probe:crate/1.0/mod/path#nonexistent_func()": {"verified": True}}

        mapping = build_function_mapping([smt2], results)
        assert len(mapping) == 0


class TestProofQueryPreparation:
    """_prepare_proof_query injects proof options correctly."""

    def test_injects_proof_option_and_get_proof(self, tmp_path):
        input_smt2 = tmp_path / "input.smt2"
        output_smt2 = tmp_path / "output.smt2"
        input_smt2.write_text(
            "(set-logic ALL)\n"
            "(declare-const x Int)\n"
            "(assert (> x 0))\n"
            "(check-sat)\n"
            "(exit)\n"
        )

        _prepare_proof_query(input_smt2, output_smt2)

        output = output_smt2.read_text()
        lines = output.strip().split("\n")

        assert lines[0] == "(set-option :proof true)"
        assert "(get-proof)" in output

        check_sat_idx = next(
            i for i, line in enumerate(lines) if line.strip() == "(check-sat)"
        )
        assert lines[check_sat_idx + 1].strip() == "(get-proof)"

    def test_original_file_unchanged(self, tmp_path):
        input_smt2 = tmp_path / "input.smt2"
        output_smt2 = tmp_path / "output.smt2"
        original = "(check-sat)\n"
        input_smt2.write_text(original)

        _prepare_proof_query(input_smt2, output_smt2)

        assert input_smt2.read_text() == original

    def test_multiple_check_sat(self, tmp_path):
        input_smt2 = tmp_path / "input.smt2"
        output_smt2 = tmp_path / "output.smt2"
        input_smt2.write_text("(check-sat)\n(reset)\n(check-sat)\n")

        _prepare_proof_query(input_smt2, output_smt2)

        output = output_smt2.read_text()
        assert output.count("(get-proof)") == 2

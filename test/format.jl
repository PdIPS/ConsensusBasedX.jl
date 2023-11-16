using CBX, JuliaFormatter, Test

function tests()
  function f(s)
    return format(
      s,
      always_for_in = true,
      always_use_return = true,
      for_in_replacement = "∈",
      format_docstrings = true,
      indent = 2,
      indent_submodule = true,
      long_to_short_function_def = true,
      margin = 80,
      normalize_line_endings = "unix",
      remove_extra_newlines = true,
      short_to_long_function_def = true,
      whitespace_in_kwargs = true,
      whitespace_ops_in_indices = true,
      whitespace_typedefs = true,
    )
  end
  f("..")
  @test f("..")
end

tests()

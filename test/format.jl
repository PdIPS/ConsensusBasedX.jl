using CBX
using Test
using JuliaFormatter

function tests()
  f(s) = format(
    s,
    always_for_in = true,
    always_use_return = true,
    indent = 2,
    long_to_short_function_def = true,
    margin = 80,
    normalize_line_endings = "unix",
    remove_extra_newlines = true,
    whitespace_ops_in_indices = true,
    whitespace_typedefs = true,
  )
  f("../src")
  f("../test")
  f("../experiments")
  f("../src")
  f("../test")
  f("../experiments")
  @test f("../src")
  @test f("../test")
  @test f("../experiments")
end

if !Sys.iswindows()
  tests()
end

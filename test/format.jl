using CBX, JuliaFormatter, Test

function tests()
  f(s) = format(s; CBX.FORMAT_SETTINGS...)
  f("..")
  @test f("..")
end

tests()

using ConsensusBasedX, JuliaFormatter, Test

function tests()
  f(s) = format(s; ConsensusBasedX.FORMAT_SETTINGS...)
  f("..")
  @test f("..")
end

tests()

using ConsensusBasedX, Test

function tests()
  f(x) = ConsensusBasedX.Quadratic(x, shift = 1)

  config = (; D = 2)
  @test_nowarn sample(f, config)
end

tests()

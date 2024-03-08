using ConsensusBasedX, Test

function tests()
  alloc(x) = Base.gc_alloc_count(x.gcstats)

  config = (; D = 2, benchmark = true)

  f(x) = -ConsensusBasedX.Quadratic(x, shift = 1)
  @test alloc(maximise(f, config)) == 0

  g(x) = -ConsensusBasedX.Ackley(x, shift = 1)
  @test alloc(maximise(g, config)) == 0

  h(x) = -ConsensusBasedX.Rastrigin(x, shift = 1)
  @test alloc(maximise(h, config)) == 0

  return config = (; D = 2,)
end

tests()

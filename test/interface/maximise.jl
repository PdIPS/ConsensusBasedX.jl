using ConsensusBasedX, Test

function tests()
  alloc(x) = Base.gc_alloc_count(x.gcstats)
  f(x) = -ConsensusBasedX.Quadratic(x, shift = 1)
  g(x) = -ConsensusBasedX.Ackley(x, shift = 1)
  h(x) = -ConsensusBasedX.Rastrigin(x, shift = 1)

  config = (; D = 2,)
  @test_nowarn maximise(f, config)

  config = Dict(:D => 2)
  @test_nowarn maximise(f, config)

  config = (; D = 2, benchmark = true)
  @test alloc(maximise(f, config)) == 0
  @test alloc(maximise(g, config)) == 0
  @test alloc(maximise(h, config)) == 0
end

tests()

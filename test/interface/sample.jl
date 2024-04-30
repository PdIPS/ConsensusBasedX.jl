using ConsensusBasedX, Test

function tests()
  alloc(x) = Base.gc_alloc_count(x.gcstats)
  f(x) = ConsensusBasedX.Quadratic(x, shift = 1)

  config = (; D = 2,)
  @test_nowarn sample(f, config)

  config = Dict(:D => 2)
  @test_nowarn sample(f, config)

  config = (; D = 2, root = :SymmetricRoot)
  @test_nowarn sample(f, config)

  config = (; D = 2, root = :AsymmetricRoot)
  @test_nowarn sample(f, config)

  config = (; D = 2, root = :AsymmetricRoot, benchmark = true)
  @test alloc(sample(f, config)) == 0

  config = (; D = 2, CBS_mode = :wrongCBSMode)
  @test_throws ArgumentError sample(f, config)
end

tests()

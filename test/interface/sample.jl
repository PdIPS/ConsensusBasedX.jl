using ConsensusBasedX, Test

function tests()
  f(x) = ConsensusBasedX.Quadratic(x, shift = 1)

  config = (; D = 2, root = :SymmetricRoot)
  @test_nowarn sample(f, config)

  config = (; D = 2, root = :AsymmetricRoot)
  @test_nowarn sample(f, config)

  alloc(x) = Base.gc_alloc_count(x.gcstats)
  config = (; D = 2, root = :AsymmetricRoot, benchmark = true)
  @test alloc(minimise(f, config)) == 0
end

tests()

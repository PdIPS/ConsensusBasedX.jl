using CBX, Test

function tests()
  alloc(x) = Base.gc_alloc_count(x.gcstats)

  config = (; D = 2, benchmark = true)

  f(x) = CBX.Quadratic(x, shift = 1)
  @test alloc(minimise(f, config)) == 0

  g(x) = CBX.Ackley(x, shift = 1)
  @test alloc(minimise(g, config)) == 0

  h(x) = CBX.Rastrigin(x, shift = 1)
  @test alloc(minimise(h, config)) == 0
end

tests()

using ConsensusBasedX, ConsensusBasedX.ConsensusBasedXLowLevel, Test

function tests()
  mode = ParticleMode

  x = rand(2, 3, 4)
  y = reshape(x, mode)
  @test length(y) == 4
  @test length(y[1]) == 3
  @test length(y[1][1]) == 2
  @test reshape(y, mode) === y

  x = rand(2, 3)
  y = reshape(x, mode)
  @test length(y) == 1
  @test length(y[1]) == 3
  @test length(y[1][1]) == 2
  @test reshape(y, mode) === y
end

tests()

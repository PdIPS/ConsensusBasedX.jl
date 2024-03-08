using ConsensusBasedX, ConsensusBasedX.ConsensusBasedXLowLevel, Test

function tests()
  @test_throws ArgumentError parse_config(NamedTuple())

  @test_throws ArgumentError parse_config((; D = 2, mode = "wrongMode"))
  @test_throws ArgumentError parse_config((; D = 2, mode = :wrongMode))
  @test_throws ArgumentError parse_config((; D = 2, mode = 1.0))

  @test_throws ArgumentError parse_config((; D = 2, noise = "wrongNoise"))
  @test_throws ArgumentError parse_config((; D = 2, noise = :wrongNoise))
  @test_throws ArgumentError parse_config((; D = 2, noise = 1.0))

  @test_throws ArgumentError parse_config((;
    D = 2,
    parallelisation = "wrongParallelisation",
  ))
  @test_throws ArgumentError parse_config((;
    D = 2,
    parallelisation = :wrongParallelisation,
  ))
  @test_throws ArgumentError parse_config((; D = 2, parallelisation = 1.0))
end

tests()

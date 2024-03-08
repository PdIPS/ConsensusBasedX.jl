using ConsensusBasedX, ConsensusBasedX.ConsensusBasedXLowLevel, Test

function tests()
  x = 1 + rand()

  noCorrection = NoCorrection()
  @test noCorrection(x) == 1
  @test noCorrection(-x) == 1

  heavisideCorrection = HeavisideCorrection()
  @test heavisideCorrection(x) == 1
  @test heavisideCorrection(-x) == 0

  regularCorrection = RegularisedHeavisideCorrection(1e-1)
  sharpCorrection = RegularisedHeavisideCorrection(1e-2)
  @test regularCorrection(x) <= 1
  @test regularCorrection(x) >= 0
  @test regularCorrection(-x) <= 1
  @test regularCorrection(-x) >= 0
  @test regularCorrection(x) <= sharpCorrection(x)
  @test regularCorrection(-x) >= sharpCorrection(-x)
end

tests()

using ConsensusBasedX, Test

function tests()
  out = @test_nowarn ConsensusBasedX.parse_config((; D = 2))
  @test haskey(out, :D)
  @test haskey(out, :N)
  @test haskey(out, :M)
  @test haskey(out, :mode)

  @test_nowarn ConsensusBasedX.check_config_has_D((; D = 2, N = 20))
  @test_throws ArgumentError ConsensusBasedX.check_config_has_D((; N = 20))

  @test_nowarn ConsensusBasedX.parse_config_mode(NamedTuple())

  out = @test_nowarn ConsensusBasedX.parse_config_mode((;
    mode = ConsensusBasedX.ParticleMode
  ))
  @test out.mode isa ConsensusBasedX.TParticleMode
  out = @test_nowarn ConsensusBasedX.parse_config_mode((;
    mode = Val(:ParticleMode)
  ))
  @test out.mode isa ConsensusBasedX.TParticleMode
  out = @test_nowarn ConsensusBasedX.parse_config_mode((; mode = :ParticleMode))
  @test out.mode isa ConsensusBasedX.TParticleMode
  out =
    @test_nowarn ConsensusBasedX.parse_config_mode((; mode = "ParticleMode"))
  @test out.mode isa ConsensusBasedX.TParticleMode

  @test_throws ArgumentError ConsensusBasedX.parse_config_mode((;
    mode = Val(:WrongMode)
  ))
  @test_throws ArgumentError ConsensusBasedX.parse_config_mode((;
    mode = :WrongMode
  ))
  @test_throws ArgumentError ConsensusBasedX.parse_config_mode((;
    mode = "WrongMode"
  ))
end

tests()

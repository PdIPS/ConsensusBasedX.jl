using ConsensusBasedX

using SafeTestsets, Test

@testset "ConsensusBasedX.jl" begin
  for test ∈ [
    "CBO/corrections",
    "CBO/is_method_pending",
    "dynamics/is_dynamic_pending",
    "interface/initialise_particles",
    "interface/maximise",
    "interface/minimise",
    "interface/parse_config",
    "tuples/types",
    "aqua",
    "examples",
    "format",
  ]
    @eval begin
      @safetestset $test begin
        include($test * ".jl")
      end
    end
  end
end

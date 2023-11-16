using Test, SafeTestsets

@testset "CBX.jl" begin
  for test ∈ ["aqua", "format", "init_particles", "Objectives"]
    @eval begin
      @safetestset $test begin
        include($test * ".jl")
      end
    end
  end
end

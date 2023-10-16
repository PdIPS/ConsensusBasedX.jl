using Test
using SafeTestsets

@testset "CBX.jl" begin
  @safetestset "init_particles" begin
    include("init_particles.jl")
  end

  @safetestset "Objectives" begin
    include("Objectives.jl")
  end

  @safetestset "format" begin
    include("format.jl")
  end
end

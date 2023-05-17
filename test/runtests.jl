using SafeTestsets

@safetestset "init_particles" begin
  include("init_particles.jl")
end

@safetestset "format" begin
  include("format.jl")
end

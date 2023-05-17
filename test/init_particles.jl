using CBX.LowLevel
using Test
using Distributions

function tests()
  N, d = 10, 20
  target = (d, N)

  @testset "init_particles direct" begin
    conf = config(; N, d)

    distribution_scalar = Uniform()
    @test size(init_particles(conf, distribution_scalar)) == target

    distribution_one_particle =
      product_distribution((distribution_scalar for _ in 1:d)...)
    @test size(init_particles(conf, distribution_one_particle)) == target

    distribution_one_dimension =
      product_distribution((distribution_scalar for _ in 1:N)...)
    @test size(init_particles(conf, distribution_one_dimension)) == target

    distribution_state =
      product_distribution((distribution_one_particle for _ in 1:N)...)
    @test size(init_particles(conf, distribution_state)) == target

    distribution_transposed =
      product_distribution((distribution_one_dimension for _ in 1:d)...)
    @test size(init_particles(conf, distribution_transposed)) == target
  end

  @testset "init_particles uniform" begin
    conf =
      config(sampling = :uniform, sampling_x_min = -3, sampling_x_max = 3; N, d)
    @test size(init_particles(conf)) == target

    conf = config(sampling = :uniform, sampling_μ = 1, sampling_σ = 2; N, d)
    @test size(init_particles(conf)) == target
  end

  @testset "init_particles normal" begin
    conf = config(sampling = :normal, sampling_μ = 1, sampling_σ = 2; N, d)
    @test size(init_particles(conf)) == target
  end

  @testset "init_particles default" begin
    conf = config(; N, d)
    @test size(init_particles(conf)) == target
  end
end

tests()

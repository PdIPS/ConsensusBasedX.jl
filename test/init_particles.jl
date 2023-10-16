using CBX.LowLevel
using Test
using Distributions, LinearAlgebra

const D = 20;
const N = 10;
const M = 2;
const target = (D, N, M);

function test_init_particles_uniform()
  config = (; D, N, M)
  X = init_particles(config)
  @test size(X) == target
  @test minimum(X) >= -1
  @test maximum(X) <= 1

  config =
    (; D, N, M, sampling = :uniform, sampling_x_min = -3, sampling_x_max = 3)
  X = init_particles(config)
  @test size(X) == target
  @test minimum(X) >= -3
  @test maximum(X) <= 3

  config =
    (; D, N, M, sampling = :uniform, sampling_x_min = 2, sampling_x_max = 3)
  X = init_particles(config)
  @test size(X) == target
  @test minimum(X) >= 2
  @test maximum(X) <= 3
end

function test_init_particles_normal()
  config = (; D, N, M, sampling = :normal, sampling_μ = 1, sampling_σ = 2)
  X = init_particles(config)
  @test size(X) == target
end

function test_init_particles_dist()
  distribution_scalar = Normal(1, 2)
  @test size(init_particles((; D, N, M, dist = distribution_scalar))) == target

  distribution_one_particle = MultivariateNormal(D, 2)
  @test size(init_particles((; D, N, M, dist = distribution_one_particle))) ==
        target

  distribution_one_realisation =
    MatrixNormal(zeros(D, N), Matrix(I, D, D), Matrix(I, N, N))
  @test size(
    init_particles((; D, N, M, dist = distribution_one_realisation)),
  ) == target
end

function tests()
  @testset "init_particles_uniform" test_init_particles_uniform()
  @testset "init_particles_normal" test_init_particles_normal()
  @testset "init_particles_dist" test_init_particles_dist()
end

tests()

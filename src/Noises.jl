const DEFAULT_NOISE_CONFIG = NamedTuple();

abstract type Noise end;

struct DistributionNoise{T} <: Noise
  dist::T
end
export DistributionNoise;
function (noise::DistributionNoise)(method)
  @. method.dW = rand(noise.dist)
  return nothing
end

struct WeightedDistributionNoise{T} <: Noise
  dist::T
end
export WeightedDistributionNoise;
function (noise::WeightedDistributionNoise)(method)
  for p in 1:(method.N)
    dv = view(method.mean_difference, :, p)
    dv_abs = LinearAlgebra.norm(dv)
    for i in 1:(method.d)
      method.dW[i, p] = dv_abs * rand(noise.dist)
    end
  end
  return nothing
end

function NormalNoise(; Δt::Real, args...)
  dist = Distributions.Normal(0, √(2 * Δt))
  return DistributionNoise(dist)
end
@splat_conf NormalNoise DEFAULT_NOISE_CONFIG
export NormalNoise;

function WeightedNormalNoise(; Δt::Real, args...)
  dist = Distributions.Normal(0, √(2 * Δt))
  return WeightedDistributionNoise(dist)
end
@splat_conf WeightedNormalNoise DEFAULT_NOISE_CONFIG
export WeightedNormalNoise;

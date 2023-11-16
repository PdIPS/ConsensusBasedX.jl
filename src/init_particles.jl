const DEFAULT_SAMPLING_CONFIG = (;
  sampling = nothing,
  sampling_x_min = -1,
  sampling_x_max = 1,
  sampling_μ = 0,
  sampling_σ = 1,
  dist = Distributions.Uniform(-1, 1),
);

@config DEFAULT_SAMPLING_CONFIG function init_particles(; sampling)
  if isnothing(sampling)
    return init_particles_dist(config)
  end

  if sampling == :uniform
    return init_particles_uniform(config)
  elseif sampling == :normal
    return init_particles_normal(config)
  else
    throw(
      ArgumentError(
        "The specified sampling method is not valid. Please use :uniform or :normal.",
      ),
    )
  end
end

@config DEFAULT_SAMPLING_CONFIG function init_particles_uniform(;
  sampling_x_min::Real,
  sampling_x_max::Real,
)
  dist = Distributions.Uniform(sampling_x_min, sampling_x_max)
  return init_particles_dist_expanded(config; dist)
end

@config DEFAULT_SAMPLING_CONFIG function init_particles_normal(;
  sampling_μ::Real,
  sampling_σ::Real,
)
  dist = Distributions.Normal(sampling_μ, sampling_σ)
  return init_particles_dist_expanded(config; dist)
end

@config DEFAULT_SAMPLING_CONFIG function init_particles_dist(;
  dist::Distributions.Distribution,
)
  D, N, M = config.D, config.N, config.M
  s = rand(dist)
  if size(s) == (D, N, M)
    return s
  elseif size(s) == (D,)
    return cat((rand(dist, N) for m ∈ 1:M)..., dims = 3)
  elseif size(s) == (D, N)
    return cat((rand(dist) for m ∈ 1:M)..., dims = 3)
  elseif size(s) == ()
    return rand(dist, D, N, M)
  else
    throw(
      ArgumentError(
        "The specified distribution is nor valid. Please use a scalar distribution, a distribution of size D (for a single particle), a distribution of size D×N (for a full realisation), or a distribution of size D×N×M (for the full swarm).",
      ),
    )
  end
end

const initialise_particles = init_particles;
const initialize_particles = init_particles;

const DEFAULT_SAMPLING_CONFIG = (;
  sampling = nothing,
  sampling_x_min = nothing,
  sampling_x_max = nothing,
  sampling_μ = nothing,
  sampling_σ = nothing,
  dist = Distributions.Uniform(-1, 1),
);

function init_particles(conf::NamedTuple, dist::Distributions.Distribution)
  d, N = conf[:d], conf[:N]
  s = rand(dist)

  if size(s) == (d, N)
    return s
  elseif size(s) == (N, d)
    return Array(s')
  elseif size(s) == (d,)
    return rand(dist, N)
  elseif size(s) == (N,)
    return Array(rand(dist, d)')
  elseif size(s) == ()
    return rand(dist, d, N)
  else
    throw(
      ArgumentError(
        "The specified distribution is nor valid. Please use a scalar distribution, a distribution of size d (for a single particle), a distribution of size N (for a single component of the swarm), or a distribution of size d×N (for the full swarm).",
      ),
    )
  end
end
const initialise_particles = init_particles;
const initialize_particles = init_particles;

@parsing_routine init_particles DEFAULT_SAMPLING_CONFIG;

function init_particles_parsed(conf::NamedTuple)
  sampling = conf[:sampling]
  if isnothing(sampling)
    return init_particles(conf, conf.dist)
  end

  parsed = parse_label(sampling)
  if parsed == :uniform
    return init_particles_uniform(conf::NamedTuple)
  elseif parsed == :normal
    return init_particles_normal(conf::NamedTuple)
  else
    throw(
      ArgumentError(
        "The specified sampling method is not valid. Please use :uniform or :normal.",
      ),
    )
  end
end

function init_particles_uniform(conf::NamedTuple)
  if isnothing(conf[:sampling_μ]) && isnothing(conf[:sampling_σ])
    return init_particles_uniform_a_b(conf::NamedTuple)
  else
    return init_particles_uniform_μ_σ(conf::NamedTuple)
  end
end

function init_particles_uniform_a_b(conf::NamedTuple)
  a = get_with_default(conf, :sampling_x_min, -1.0, true)
  b = get_with_default(conf, :sampling_x_max, 1.0, true)
  dist = Distributions.Uniform(a, b)
  return init_particles(conf, dist)
end

function init_particles_uniform_μ_σ(conf::NamedTuple)
  μ = get_with_default(conf, :sampling_μ, 0.0, true)
  σ = get_with_default(conf, :sampling_σ, 1.0, true)
  a = μ - σ * √3
  b = μ + σ * √3
  dist = Distributions.Uniform(a, b)
  return init_particles(conf, dist)
end

function init_particles_normal(conf::NamedTuple)
  μ = get_with_default(conf, :sampling_μ, 0.0, true)
  σ = get_with_default(conf, :sampling_σ, 1.0, true)
  dist = Distributions.Normal(μ, σ)
  return init_particles(conf, dist)
end

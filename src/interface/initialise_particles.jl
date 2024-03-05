function initialise_particles(config::NamedTuple)
  @verb " • Initialising particles"
  if haskey(config, :initial_particles)
    return initialise_particles_user(config)
  end

  if haskey(config, :initial_radius) || (
    haskey(config, :initialisation) &&
    (config.initialisation == :uniform || config.initialisation == "uniform")
  )
    return initialise_particles_uniform(config)
  end

  return initialise_particles_normal(config)
end

function initialise_particles_user(config::NamedTuple)
  @verb " • Particle initialisation provided by user"
  X₀ = config.initial_particles
  if X₀ isa AbstractArray{<:Real, 3}
    if size(X₀) != (config.D, config.N, config.M)
      explanation = "`initial_particles` must be an `AbstractArray` of size `(D, N, M)`."
      throw(ArgumentError(explanation))
    end
  else
    explanation = "`initial_particles` must be an `AbstractArray{<:Real,3}`."
    throw(ArgumentError(explanation))
  end

  return deepcopy(X₀)
end

function initialise_particles_uniform(config::NamedTuple)
  if haskey(config, :initial_mean)
    μ = config.initial_mean
  elseif haskey(config, :initial_guess)
    μ = config.initial_guess
  else
    μ = 0
  end
  if haskey(config, :initial_radius)
    r = config.initial_radius
  elseif haskey(config, :initial_diameter)
    r = config.initial_diameter / 2
  else
    r = 1
  end

  if μ isa AbstractVector
    if length(μ) != config.D
      explanation = "`initial_guess`/`initial_mean` must be an `AbstractVector` of size `(D,)`."
      throw(ArgumentError(explanation))
    end
  elseif !(μ isa Real)
    explanation = "`initial_guess`/`initial_mean` must be a `Real` or an `AbstractVector`."
    throw(ArgumentError(explanation))
  end

  if r isa AbstractVector
    if length(r) != config.D
      explanation = "`initial_radius` must be an `AbstractVector` of size `(D,)`."
      throw(ArgumentError(explanation))
    end
  elseif !(r isa Real)
    explanation = "`initial_radius` must be a `Real` or an `AbstractVector`."
    throw(ArgumentError(explanation))
  end

  return initialise_particles_uniform(config, μ, r)
end

function initialise_particles_uniform(config::NamedTuple, μ::Real, r)
  return initialise_particles_uniform(config, μ * ones(config.D), r)
end

function initialise_particles_uniform(
  config::NamedTuple,
  μ::AbstractVector,
  r::Real,
)
  return initialise_particles_uniform(config, μ, r * ones(config.D))
end

function initialise_particles_uniform(
  config::NamedTuple,
  μ::AbstractVector,
  r::AbstractVector,
)
  @verb " • Particle initialisation from uniform distribution"
  D, N, M = config.D, config.N, config.M
  X₀ = rand(D, N, M)
  for m ∈ 1:M, n ∈ 1:N, d ∈ 1:D
    X₀[d, n, m] = μ[d] + r[d] * (X₀[d, n, m] * 2 - 1)
  end
  return X₀
end

function initialise_particles_normal(config::NamedTuple)
  if haskey(config, :initial_mean)
    μ = config.initial_mean
  elseif haskey(config, :initial_guess)
    μ = config.initial_guess
  else
    μ = 0
  end
  if haskey(config, :initial_variance)
    Σ = config.initial_variance
  elseif haskey(config, :initial_covariance)
    Σ = config.initial_covariance
  else
    Σ = 1
  end

  if μ isa AbstractVector
    if length(μ) != config.D
      explanation = "`initial_guess`/`initial_mean` must be an `AbstractVector` of size `(D,)`."
      throw(ArgumentError(explanation))
    end
  elseif !(μ isa Real)
    explanation = "`initial_guess`/`initial_mean` must be a `Real` or an `AbstractVector`."
    throw(ArgumentError(explanation))
  end

  if Σ isa AbstractMatrix
    if size(Σ) != (config.D, config.D)
      explanation = "`initial_variance` must be an `AbstractMatrix` of size `(D, D)`."
      throw(ArgumentError(explanation))
    end
  elseif Σ isa AbstractVector
    if length(Σ) != config.D
      explanation = "`initial_variance` must be an AbstractVector` of size `(D,)`."
      throw(ArgumentError(explanation))
    end
  elseif !(Σ isa Real)
    explanation = "`initial_variance` must be a `Real`, an `AbstractVector`, or an `AbstractMatrix`."
    throw(ArgumentError(explanation))
  end

  return initialise_particles_normal(config, μ, Σ)
end

function initialise_particles_normal(config::NamedTuple, μ::Real, Σ)
  return initialise_particles_normal(config, μ * ones(config.D), Σ)
end

function initialise_particles_normal(
  config::NamedTuple,
  μ::AbstractVector,
  Σ::Real,
)
  return initialise_particles_normal(config, μ, Σ * ones(config.D))
end

function initialise_particles_normal(
  config::NamedTuple,
  μ::AbstractVector,
  Σ::AbstractVector,
)
  return initialise_particles_normal(config, μ, LinearAlgebra.Diagonal(Σ))
end

function initialise_particles_normal(
  config::NamedTuple,
  μ::AbstractVector,
  Σ::AbstractMatrix,
)
  @verb " • Particle initialisation from normal distribution"
  D, N, M = config.D, config.N, config.M
  dist = Distributions.MvNormal(μ, Σ)
  X₀ = rand(dist, N * M)
  return reshape(X₀, D, N, M)
end

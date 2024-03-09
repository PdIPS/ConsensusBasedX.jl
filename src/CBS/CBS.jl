"""
```julia
ConsensusBasedSampling
```

Fields:

  - `f`, the objective function.
  - `α::Float64`, the exponential weight parameter.
  - `λ::Float64`, the mode parameter. `λ = 1 / (1 + α)` corresponds to `CBS_mode = :sampling`, and `λ = 1` corresponds to `CBS_mode = :minimise`.
"""
mutable struct ConsensusBasedSampling{TF} <: CBXMethod
  f::TF
  α::Float64
  λ::Float64
end

@config function construct_CBS(f; α::Real = 10, CBS_mode = :sampling)
  @assert α >= 0
  if Symbol(CBS_mode) == :sampling
    λ = 1 / (1 + α)
  elseif Symbol(CBS_mode) in
         [:minimise, :minimisation, :optimise, :optimisation]
    λ = 1
  else
    explanation = "`CBS_mode` should be either `:sampling` or `:minimise`."
    throw(ArgumentError(explanation))
  end
  return ConsensusBasedSampling(f, float(α), float(λ))
end

"""
```julia
ConsensusBasedSamplingCache{T}
```

**It is strongly recommended that you do not construct `ConsensusBasedSamplingCache` by hand.** Instead, use [`ConsensusBasedX.construct_method_cache`](@ref).

Fields:

  - `consensus::Vector{Vector{T}}`, the consensus point of each ensemble.
  - `consensus_energy::Vector{T}`, the energy (value of the objective function) of each consensus point.
  - `consensus_energy_previous::Vector{T}`, the previous energy.
  - `energy::Vector{Vector{T}}`, the energy of each particle.
  - `exponents::Vector{Vector{T}}`, an exponent used to compute `logsums`.
  - `logsums::Vector{T}`, a normalisation factor for `weights`.
  - `noise::Vector{Vector{T}}`, a vector to contain the noise of one iteration.
  - `root_covariance::Vector{Matrix{T}}`, the matrix square root of the weighted covariance of the particles.
  - `weights::Vector{Vector{T}}`, the exponential weight of each particle.
  - `energy_threshold::Float64`, the energy threshold.
  - `energy_tolerance::Float64`, the energy tolerance.
  - `max_evaluations::Float64`, the maximum number of `f` evaluations.
  - `evaluations::Vector{Int}`, the current number of `f` evaluations.
  - `exp_minus_Δt::Float64`, the time-stepping parameter.
  - `noise_factor::Float64`, the noise multiplier.
"""
mutable struct ConsensusBasedSamplingCache{T} <: CBXMethodCache
  consensus::Vector{Vector{T}}
  consensus_energy::Vector{T}
  consensus_energy_previous::Vector{T}
  energy::Vector{Vector{T}}
  exponents::Vector{Vector{T}}
  logsums::Vector{T}
  noise::Vector{Vector{T}}
  root_covariance::Vector{Matrix{T}}
  weights::Vector{Vector{T}}

  energy_threshold::Float64
  energy_tolerance::Float64
  max_evaluations::Float64

  evaluations::Vector{Int}

  exp_minus_Δt::Float64
  noise_factor::Float64
end

@config function construct_method_cache(
  X₀::AbstractArray,
  method::ConsensusBasedSampling,
  particle_dynamic::ParticleDynamic;
  D::Int,
  N::Int,
  M::Int,
  energy_threshold::Real = -Inf,
  energy_tolerance::Real = 1e-8,
  max_evaluations::Real = Inf,
)
  @assert energy_tolerance >= 0
  @assert max_evaluations >= 0

  type = deep_eltype(X₀)
  consensus = nested_zeros(type, M, D)
  consensus_energy = nested_zeros(type, M)
  consensus_energy_previous = nested_zeros(type, M)
  energy = nested_zeros(type, M, N)
  exponents = nested_zeros(type, M, N)
  logsums = nested_zeros(type, M)
  noise = nested_zeros(type, M, D)
  root_covariance = nested_zeros(type, M, (D, D))
  weights = nested_zeros(type, M, N)

  evaluations = zeros(Int, M)

  exp_minus_Δt = 0.0
  noise_factor = 0.0

  method_cache = ConsensusBasedSamplingCache{type}(
    consensus,
    consensus_energy,
    consensus_energy_previous,
    energy,
    exponents,
    logsums,
    noise,
    root_covariance,
    weights,
    energy_threshold,
    energy_tolerance,
    max_evaluations,
    evaluations,
    exp_minus_Δt,
    noise_factor,
  )

  return method_cache
end

function set_Δt!(
  method::ConsensusBasedSampling,
  method_cache::ConsensusBasedSamplingCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  Δt::Real,
)
  method_cache.exp_minus_Δt = exp(-Δt)
  method_cache.noise_factor = sqrt((1 - method_cache.exp_minus_Δt^2) / method.λ)
  return nothing
end

function initialise_method_cache!(
  X₀::AbstractArray,
  method::ConsensusBasedSampling,
  method_cache::ConsensusBasedSamplingCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  @expand particle_dynamic_cache M
  @expand method_cache evaluations

  for m ∈ 1:M
    evaluations[m] = 0
  end
  return nothing
end

function initialise_method!(
  method::ConsensusBasedSampling,
  method_cache::ConsensusBasedSamplingCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  @expand method_cache consensus_energy_previous

  for m ∈ 1:(particle_dynamic_cache.M)
    compute_CBO_consensus!(
      method,
      method_cache,
      particle_dynamic,
      particle_dynamic_cache,
      m,
    )
    compute_CBS_root_covariance!(
      method,
      method_cache,
      particle_dynamic,
      particle_dynamic_cache,
      m,
    )
    consensus_energy_previous[m] = Inf
  end
  return nothing
end

function compute_method_step!(
  method::ConsensusBasedSampling,
  method_cache::ConsensusBasedSamplingCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  compute_CBS_update!(
    method,
    method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )
  return nothing
end

function finalise_method_step!(
  method::ConsensusBasedSampling,
  method_cache::ConsensusBasedSamplingCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  compute_CBO_consensus!(
    method,
    method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )
  compute_CBS_root_covariance!(
    method,
    method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )
  return nothing
end

function wrap_output(
  X₀::AbstractArray,
  method::ConsensusBasedSampling,
  method_cache::ConsensusBasedSamplingCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  ensemble_minimiser = method_cache.consensus
  minimiser = sum(ensemble_minimiser) / length(ensemble_minimiser)
  initial_particles = X₀
  final_particles = particle_dynamic_cache.X
  sample = final_particles
  return (;
    minimiser,
    ensemble_minimiser,
    initial_particles,
    final_particles,
    method,
    method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    sample,
  )
end

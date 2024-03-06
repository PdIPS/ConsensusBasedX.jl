"""
```julia
ConsensusBasedOptimisation
```

Fields:

  - `f`, the objective function.
  - `correction<:ConsensusBasedXCorrection`, a correction term.
  - `α::Float64`, the the exponential weight parameter.
  - `λ::Float64`, the drift strengh.
  - `σ::Float64`, the noise strengh.
"""
mutable struct ConsensusBasedOptimisation{
  TF,
  TCorrection <: ConsensusBasedXCorrection,
  TNoise <: Noises,
} <: ConsensusBasedXMethod
  f::TF
  correction::TCorrection
  noise::TNoise
  α::Float64
  λ::Float64
  σ::Float64
end

@config function construct_CBO(
  f,
  correction::ConsensusBasedXCorrection,
  noise::Noises;
  α::Real = 10,
  λ::Real = 1,
  σ::Real = 1,
)
  @assert α >= 0
  @assert λ >= 0
  @assert σ >= 0
  return ConsensusBasedOptimisation(
    f,
    correction,
    noise,
    float(α),
    float(λ),
    float(σ),
  )
end

"""
```julia
ConsensusBasedOptimisationCache{T}
```

**It is strongly recommended that you do not construct `ConsensusBasedOptimisationCache` by hand.** Instead, use [`ConsensusBasedX.construct_method_cache`](@ref).

Fields:

  - `consensus::Vector{Vector{T}}`, the consensus point of each ensemble.
  - `consensus_energy::Vector{T}`, the energy (value of the objective function) of each consensus point.
  - `consensus_energy_previous::Vector{T}`, the previous energy.
  - `distance::Vector{Vector{T}}`, the distance of each particle to the consensus point.
  - `energy::Vector{Vector{T}}`, the energy of each particle.
  - `exponents::Vector{Vector{T}}`, an exponent used to compute `logsums`.
  - `logsums::Vector{T}`, a normalisation factor for `weights`.
  - `weights::Vector{Vector{T}}`, the exponential weight of each particle.
  - `energy_threshold::Float64`, the energy threshold.
  - `energy_tolerance::Float64`, the energy tolerance.
  - `max_evaluations::Float64`, the maximum number of `f` evaluations.
  - `evaluations::Vector{Int}`, the current number of `f` evaluations.
"""
mutable struct ConsensusBasedOptimisationCache{T} <: ConsensusBasedXMethodCache
  consensus::Vector{Vector{T}}
  consensus_energy::Vector{T}
  consensus_energy_previous::Vector{T}
  distance::Vector{Vector{T}}
  energy::Vector{Vector{T}}
  exponents::Vector{Vector{T}}
  logsums::Vector{T}
  weights::Vector{Vector{T}}

  energy_threshold::Float64
  energy_tolerance::Float64
  max_evaluations::Float64

  evaluations::Vector{Int}
end

@config function construct_method_cache(
  X₀::AbstractArray,
  method::ConsensusBasedOptimisation,
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
  distance = nested_zeros(type, M, N)
  energy = nested_zeros(type, M, N)
  exponents = nested_zeros(type, M, N)
  logsums = nested_zeros(type, M)
  weights = nested_zeros(type, M, N)

  evaluations = zeros(Int, M)

  method_cache = ConsensusBasedOptimisationCache{type}(
    consensus,
    consensus_energy,
    consensus_energy_previous,
    distance,
    energy,
    exponents,
    logsums,
    weights,
    energy_threshold,
    energy_tolerance,
    max_evaluations,
    evaluations,
  )

  return method_cache
end

"""
```julia
construct_method_cache(
  config::NamedTuple,
  X₀::AbstractArray,
  method::ConsensusBasedXMethod,
  particle_dynamic::ParticleDynamic,
)
```

A constructor helper for `ConsensusBasedXMethodCache`.
"""
construct_method_cache

function initialise_method_cache!(
  X₀::AbstractArray,
  method::ConsensusBasedOptimisation,
  method_cache::ConsensusBasedOptimisationCache,
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
  method::ConsensusBasedOptimisation,
  method_cache::ConsensusBasedOptimisationCache,
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
    consensus_energy_previous[m] = Inf
  end
  return nothing
end

function compute_method_step!(
  method::ConsensusBasedOptimisation,
  method_cache::ConsensusBasedOptimisationCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  compute_CBO_update!(
    method,
    method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )
  return nothing
end

function finalise_method_step!(
  method::ConsensusBasedOptimisation,
  method_cache::ConsensusBasedOptimisationCache,
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
  return nothing
end

function wrap_output(
  X₀::AbstractArray,
  method::ConsensusBasedOptimisation,
  method_cache::ConsensusBasedOptimisationCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  ensemble_minimiser = method_cache.consensus
  minimiser = sum(ensemble_minimiser) / length(ensemble_minimiser)
  initial_particles = X₀
  final_particles = particle_dynamic_cache.X
  return (;
    minimiser,
    ensemble_minimiser,
    initial_particles,
    final_particles,
    method,
    method_cache,
    particle_dynamic,
    particle_dynamic_cache,
  )
end

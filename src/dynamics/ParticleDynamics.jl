"""
```julia
ParticleDynamic
```

Fields:

  - `method<:CBXMethod`, the optimisation method.
  - `Δt::Float64`, the time step.
"""
mutable struct ParticleDynamic{TM <: CBXMethod}
  method::TM
  Δt::Float64
end

@config function construct_particle_dynamic(method; Δt::Real = 0.1)
  @assert Δt > 0
  return ParticleDynamic(method, float(Δt))
end

"""
```julia
ParticleDynamicCache
```

**It is strongly recommended that you do not construct `ParticleDynamicCache` by hand.** Instead, use [`ConsensusBasedX.construct_particle_dynamic_cache`](@ref).

Fields:

  - `mode` should be set to `ParticleMode`.
  - `parallelisation<:Parallelisations`, the parallelisation mode.
  - `method_cache<:CBXMethodCache`, a cache for the `method` field of `ParticleDynamic`.
  - `D::Int`, the dimension of the problem.
  - `N::Int`, the number of particles per ensemble.
  - `M::Int`, the number of ensembles.
  - `X`, the particle array.
  - `dX`, the time derivative array.
  - `Δt::Float64`, the time step.
  - `root_Δt::Float64`, the square root of the time step.
  - `root_2Δt::Float64`, the square root of twice the time step.
  - `max_iterations::Float64`, the maximum number of iterations.
  - `max_time::Float64`, the maximal time.
  - `iteration::Vector{Int}`, the vector containing the iteration count per ensemble.
"""
mutable struct ParticleDynamicCache{
  TMode <: Modes,
  TParallelisation <: Parallelisations,
  TMC <: CBXMethodCache,
  TX,
  TdX,
}
  mode::TMode
  parallelisation::TParallelisation
  method_cache::TMC

  D::Int
  N::Int
  M::Int

  X::TX
  dX::TdX

  Δt::Float64
  root_Δt::Float64
  root_2Δt::Float64

  max_iterations::Float64
  max_time::Float64

  iteration::Vector{Int}
end

@config function construct_particle_dynamic_cache(
  X₀::AbstractArray,
  particle_dynamic::ParticleDynamic;
  D::Int,
  N::Int,
  M::Int,
  mode::Val = ParticleMode,
  parallelisation::Val = NoParallelisation,
  max_iterations::Real = 1000,
  max_time::Real = Inf,
)
  @verb " • Constructing caches"

  @assert max_iterations >= 1
  @assert max_time >= 0

  X = deep_zero(X₀)
  dX = deep_zero(X₀)
  Δt = 0.0
  root_Δt = 0.0
  root_2Δt = 0.0

  iteration = zeros(Int, M)

  method_cache = construct_method_cache(
    config,
    X₀,
    particle_dynamic.method,
    particle_dynamic,
  )

  particle_dynamic_cache = ParticleDynamicCache(
    mode,
    parallelisation,
    method_cache,
    D,
    N,
    M,
    X,
    dX,
    Δt,
    root_Δt,
    root_2Δt,
    float(max_iterations),
    float(max_time),
    iteration,
  )

  return particle_dynamic_cache
end

"""
```julia
construct_particle_dynamic_cache(
  config::NamedTuple,
  X₀::AbstractArray,
  particle_dynamic::ParticleDynamic,
)
```

A constructor helper for `ParticleDynamicCache`. Calls [`ConsensusBasedX.construct_method_cache`](@ref) to construct the corresponding `CBXMethodCache`.
"""
construct_particle_dynamic_cache

@config construct_method_cache(
  X₀::AbstractArray,
  method::CBXMethod,
  particle_dynamic::ParticleDynamic,
) = nothing

function initialise_particle_dynamic_cache!(
  X₀::AbstractArray,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  @expand particle_dynamic_cache M iteration

  deep_copyto!(particle_dynamic_cache.X, X₀)
  set_Δt!(particle_dynamic, particle_dynamic_cache, particle_dynamic.Δt)
  for m ∈ 1:M
    iteration[m] = 0
  end

  initialise_method_cache!(
    X₀,
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
  )
  return nothing
end

function set_Δt!(
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  Δt::Real,
)
  particle_dynamic_cache.Δt = Δt
  particle_dynamic_cache.root_Δt = sqrt(Δt)
  particle_dynamic_cache.root_2Δt = sqrt(2) * particle_dynamic_cache.root_Δt
  set_Δt!(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    Δt,
  )
  return nothing
end

function set_Δt!(
  method::CBXMethod,
  method_cache::CBXMethodCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  Δt::Real,
)
  return nothing
end

function initialise_method_cache!(
  X₀::AbstractArray,
  method::CBXMethod,
  method_cache::CBXMethodCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  return nothing
end

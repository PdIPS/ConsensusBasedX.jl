# Low-level interface examples

We provide two low-level interface examples for the convenience of advanced users.

## Manual method definition

This example bypasses the `minimise` interface, and defines the `ParticleDynamic` and `ConsensusBasedOptimisation` structs directly. However, [`CBX.construct_particle_dynamic_cache`](@ref) is used to construct the caches:
```julia
config =
  (; D = 2, N = 20, M = 1, α = 10.0, λ = 1.0, σ = 1.0, Δt = 0.1, verbosity = 0)

f(x) = CBX.Ackley(x, shift = 1)

X₀ = [[rand(config.D) for n ∈ 1:(config.N)] for m ∈ 1:(config.M)]

correction = HeavisideCorrection()
method = ConsensusBasedOptimisation(f, correction, config.α, config.λ, config.σ)

Δt = 0.1
particle_dynamic = ParticleDynamic(method, Δt)

particle_dynamic_cache =
  construct_particle_dynamic_cache(config, X₀, particle_dynamic)

method_cache = particle_dynamic_cache.method_cache

initialise_particle_dynamic_cache!(X₀, particle_dynamic, particle_dynamic_cache)
initialise_dynamic!(particle_dynamic, particle_dynamic_cache)
compute_dynamic!(particle_dynamic, particle_dynamic_cache)
finalise_dynamic!(particle_dynamic, particle_dynamic_cache)

out = wrap_output(X₀, particle_dynamic, particle_dynamic_cache)
```
[Full-code example](https://github.com/PdIPS/CBX.jl/blob/main/examples/low_level/low_level.jl).

## Manual stepping

This bypasses the `compute_dynamic!` method, performing the stepping manually instead:
```julia
config =
  (; D = 2, N = 20, M = 1, α = 10.0, λ = 1.0, σ = 1.0, Δt = 0.1, verbosity = 0)

f(x) = CBX.Ackley(x, shift = 1)

X₀ = [[rand(config.D) for n ∈ 1:(config.N)] for m ∈ 1:(config.M)]

correction = HeavisideCorrection()
method = ConsensusBasedOptimisation(f, correction, config.α, config.λ, config.σ)

Δt = 0.1
particle_dynamic = ParticleDynamic(method, Δt)

particle_dynamic_cache =
  construct_particle_dynamic_cache(config, X₀, particle_dynamic)

method_cache = particle_dynamic_cache.method_cache

initialise_particle_dynamic_cache!(X₀, particle_dynamic, particle_dynamic_cache)
initialise_dynamic!(particle_dynamic, particle_dynamic_cache)

for it ∈ 1:100
  for m ∈ 1:(config.M)
    compute_dynamic_step!(particle_dynamic, particle_dynamic_cache, m)
  end
end

finalise_dynamic!(particle_dynamic, particle_dynamic_cache)

out = wrap_output(X₀, particle_dynamic, particle_dynamic_cache)
```
[Full-code example](https://github.com/PdIPS/CBX.jl/blob/main/examples/low_level/manual_stepping.jl).

using Pkg;
Pkg.activate(".");

using CBX, CBX.CBXLowLevel

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

@show out.minimiser # should be close to [1, 1]

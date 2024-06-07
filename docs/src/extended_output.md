# Extended output

By default, the `minimise` and `sample` routines return their best guess for the global minimiser of the function `f`. However, it is possible to access the extended output by passing the `extended_output = true` option.

When calling `minimise`, the extended output is a `NamedTuple` which contains:
- `minimiser`, a `Vector{Float64}`, the candidate to the global minimiser of `f`;
- `ensemble_minimiser`, a `Vector` of the `M` minimisers computed by each ensemble. `minimiser` is equal to their mean;
- `initial_particles`, the initial position of the particles, see [Particle initialisation](@ref);
- `final_particles`, the final position of the particles.

When calling `sample`, the extended output also includes `sample`, which is an alias for `final_particles`. The final position of the particles is the distribution sample when running with `CBS_mode = :sampling`.

In both cases, certain low-level caches are included as well:
- `method`, by default a `ConsensusBasedOptimisation` object;
- `method_cache`, by default a `ConsensusBasedOptimisationCache` object;
- `particle_dynamic`, by default a `ParticleDynamic` object;
- `particle_dynamic_cache`, by default a `ParticleDynamicCache` object. 
These objects are part of the [Low-level interface](@ref).

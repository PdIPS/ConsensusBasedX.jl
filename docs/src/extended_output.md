# Extended output

By default, the `minimise` routine returns its best guess for the global minimiser of the function `f`. However, it is possible to access the extended output by passing the `extended_output = true` option.

The extended output is a `NamedTuple` which contains:
- `minimiser`, the usual output of the `minimise`;
- `ensemble_minimiser`, a `Vector` of the `M` minimisers computed by each ensemble. `minimiser` is equal to their mean;
- `initial_particles`, the initial position of the particles, see Particle initialisationref;
- `final_particles`, the final position of the particles;
- `method`, by default a `ConsensusBasedOptimisation` object;
- `method_cache`, by default a `ConsensusBasedOptimisationCache` object;
- `particle_dynamic`, by default a `ParticleDynamic` object;
- `particle_dynamic_cache`, by default a `ParticleDynamicCache` object.

TODO: ref objects.
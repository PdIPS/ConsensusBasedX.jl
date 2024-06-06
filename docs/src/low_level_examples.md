# Low-level interface examples

We provide two low-level interface examples for the convenience of advanced users.

## Manual method definition

This example bypasses the `minimise` interface, and defines the `ParticleDynamic` and `ConsensusBasedOptimisation` structs directly. However, [`ConsensusBasedX.construct_particle_dynamic_cache`](@ref) is used to construct the caches:
{{low_level/low_level.jl}}

## Manual stepping

This bypasses the `compute_dynamic!` method, performing the stepping manually instead:
{{low_level/manual_stepping.jl}}

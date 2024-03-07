# Low-level interface

Internally, the `minimise` routine relies on two constructs: the `ParticleDynamic` and a `CBXMethod`.

## ConsensusBasedXLowLevel

ConsensusBasedX.jl defines the ConsensusBasedXLowLevel submodule for the convenience of advanced users. It can be imported by
```julia
using ConsensusBasedX, ConsensusBasedX.ConsensusBasedXLowLevel
```

## `ParticleDynamic`

The `ParticleDynamic` struct defines the *evolution in time* of particles, and is agnostic of the specific method in question. Its functionality currently serves `ConsensusBasedOptimisation`, but can be extended to other methods.

```@docs
ConsensusBasedX.ParticleDynamic
```

### `ParticleDynamicCache`

`ParticleDynamic` requires a cache, `ParticleDynamicCache`. This can be constructed with:
```@docs
ConsensusBasedX.construct_particle_dynamic_cache
```

The full reference is:
```@docs
ConsensusBasedX.ParticleDynamicCache
```

## `ConsensusBasedOptimisation`

The `ConsensusBasedOptimisation` struct (of type `CBXMethod`) defines the details of the *consensus-based optimisation method* (function evaluations, consensus point...).

```@docs
ConsensusBasedX.ConsensusBasedOptimisation
```

### `ConsensusBasedOptimisationCache`

`ConsensusBasedOptimisation` requires a cache, `ConsensusBasedOptimisationCache` (of type `CBXMethodCache`). This can be constructed with:
```@docs
ConsensusBasedX.construct_method_cache
```
Note that this method is called automatically by [`ConsensusBasedX.construct_particle_dynamic_cache`](@ref).

The full reference is:
```@docs
ConsensusBasedX.ConsensusBasedOptimisationCache
```

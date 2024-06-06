"""
```julia
minimise(f; keywords...)
```

```julia
minimise(f, config::NamedTuple)
```

Minimise the function `f` using Consensus-Based Optimisation (see [Function minimisation](@ref)).

You must specify the dimension `D` of the problem. Other parameters (e.g. the number of particles `N` or the number of ensembles `M`) can also be specified; see [Summary of options](@ref).

`optimise` is an alias for `minimise`.

# Examples

```julia
minimise(f, D = 2)
```

```julia
config = (; D = 2);
minimise(f, config)
```

```julia
minimise(f, D = 2, N = 20)
```

```julia
config = (; D = 2, N = 20);
minimise(f, config)
```
"""
function minimise(f, config::NamedTuple)
  return minimise_with_parsed_config(parse_config(config), f)
end
export minimise

@config function minimise_with_parsed_config(f; mode)
  @verb "[ConsensusBasedX.jl]: Executing minimisation..."

  X₀ = initialise_particles(config)
  parsed_X₀ = reshape(X₀, mode)

  particle_dynamic = get_minimise_particle_dynamic(config, f)

  particle_dynamic_cache =
    construct_particle_dynamic_cache(config, parsed_X₀, particle_dynamic)

  return wrapped_run_dynamic!(
    config,
    parsed_X₀,
    particle_dynamic,
    particle_dynamic_cache,
  )
end

@config function get_minimise_particle_dynamic(f)
  @verb " • Constructing dynamic"
  correction = HeavisideCorrection()
  method = construct_CBO(config, f, correction, config.noise)
  particle_dynamic = construct_particle_dynamic(config, method)
  return particle_dynamic
end

"""
```julia
minimise(f; keywords...)
```

```julia
minimise(f, config::NamedTuple)
```

Minimise the function `f` using Consensus-Based Optimisation (see [Function minimisation](@ref)).

You must specify the dimension `D` of the problem. Other paramters (e.g. the number of particles `N` or the number of ensembles `M` can also be specified; see [Summary of options](@ref).

`minimize`, `optimise`, or `optimize` are aliases for `minimise`.

# Examples

```julia-repl
julia> minimise(f, D = 2)

```

```julia-repl
julia> minimise(f, config)
config = (; D = 2);
```

```julia-repl
julia> minimise(f, D = 2, N = 20)

```

```julia-repl
julia> minimise(f, config)
config = (; D = 2, N = 20);
```
"""
function minimise(f, config::NamedTuple)
  return minimise_with_parsed_config(parse_config(config), f)
end
export minimise

@config function minimise_with_parsed_config(f; mode)
  @verb "[CBX.jl]: Executing minimisation..."

  X₀ = initialise_particles(config)
  parsed_X₀ = reshape(X₀, mode)

  particle_dynamic = get_particle_dynamic(config, f)

  particle_dynamic_cache =
    construct_particle_dynamic_cache(config, parsed_X₀, particle_dynamic)

  return wrapped_run_dynamic!(
    config,
    parsed_X₀,
    particle_dynamic,
    particle_dynamic_cache,
  )
end

@config function get_particle_dynamic(f)
  @verb " • Constructing dynamic"

  # correction = NoCorrection()
  correction = HeavisideCorrection()
  # correction = RegularisedHeavisideCorrection(1e-3)

  method = construct_CBO(config, f, correction)
  particle_dynamic = construct_particle_dynamic(config, method)
  return particle_dynamic
end

const minimize = minimise
export minimize

"""
```julia
sample(f; keywords...)
```

```julia
sample(f, config::NamedTuple)
```

Sample the distribution `exp(-αf)` using Consensus-Based Sampling (see [Distribution sampling](@ref)).

You must specify the dimension `D` of the problem. Other paramters (e.g. the number of particles `N` or the number of ensembles `M`) can also be specified; see [Summary of options](@ref).

# Examples

```julia
out = sample(f, D = 2, extended_output = true);
out.sample
```

```julia
config = (; D = 2, extended_output = true);
out = sample(f, config);
out.sample
```

```julia
out = sample(f, D = 2, N = 20, extended_output = true);
out.sample
```

```julia
config = (; D = 2, N = 20, extended_output = true);
out = sample(f, config);
out.sample
```
"""
function sample(f, config::NamedTuple)
  return sample_with_parsed_config(parse_config(config), f)
end
export sample

@config function sample_with_parsed_config(f; mode)
  @verb "[ConsensusBasedX.jl]: Executing sampling..."

  X₀ = initialise_particles(config)
  parsed_X₀ = reshape(X₀, mode)

  particle_dynamic = get_sample_particle_dynamic(config, f)

  particle_dynamic_cache =
    construct_particle_dynamic_cache(config, parsed_X₀, particle_dynamic)

  return wrapped_run_dynamic!(
    config,
    parsed_X₀,
    particle_dynamic,
    particle_dynamic_cache,
  )
end

@config function get_sample_particle_dynamic(f)
  @verb " • Constructing dynamic"
  method = construct_CBS(config, f)
  particle_dynamic = construct_particle_dynamic(config, method)
  return particle_dynamic
end

"""
```julia
maximise(f; keywords...)
```

```julia
maximise(f, config::NamedTuple)
```

Maximise the function `f` using Consensus-Based Optimisation.

Attempts to define `x -> -f(x)` and calls the `minimise` routine. This might be better handled directly by the user (see [Maximisation](@ref)).

`maximize` is an alias for `maximise`.

See also [`minimise`](@ref).
"""
function maximise(f, config::NamedTuple)
  return maximise_with_parsed_config(parse_config(config), f)
end
export maximise

function maximise_with_parsed_config(config::NamedTuple, f)
  g(x) = -f(x)
  return minimise_with_parsed_config(config, g)
end

const maximize = maximise
export maximize

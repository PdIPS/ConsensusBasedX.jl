"""
```julia
maximise(f; keywords...)
```

```julia
maximise(config::NamedTuple, f)
```

Maximise the function `f` using Consensus-Based Optimisation.

Attempts to define `x -> -f(x)` and calls the `minimise` routine. This might be better handled directly by the user (see [Maximisation](@ref)).

`maximize` is an alias for `maximise`.

See also [`minimise`](@ref).
"""
function maximise(f, config::NamedTuple)
  if haskey(config, :mode)
    if !(config.mode isa TParticleMode)
      explanation =
        "ConsensusBasedX.jl cannot define the function `x -> -f(x)` in mode `" *
        string(get_val(config.mode)) *
        "`. You should define the function yourself and call `minimise` instead."
      throw(ArgumentError(explanation))
    end
  end
  g(x) = -f(x)
  return minimise(config, g)
end
export maximise

const maximize = maximise
export maximize

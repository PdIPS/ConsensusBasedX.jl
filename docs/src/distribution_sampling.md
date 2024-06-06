# Distribution sampling

ConsensusBasedX.jl also provides [Consensus-Based Sampling](@ref).

The package exports `sample`, which behaves exactly as `minimise` in [Function minimisation](@ref). It assumes you have defined a function `f(x::AbstractVector)` that takes a single vector argument `x` of length `D = length(x)`.

For instance, if `D = 2`, you can sample `exp(-αf)` by running:
```julia
out = sample(f, D = 2, extended_output=true)
out.sample
```

!!! note
    You must always provide `D`.

{{basic_usage/sample_with_keywords.jl}}


## Using a `config` object

For more advanced usage, you will select several options. You can pass these as extra keyword arguments to `sample`, or you can create a `NamedTuple` called `config` and pass that:
```julia
config = (; D = 2, extended_output=true)
out = sample(f, config)
out.sample
```

!!! note
    If you pass a `Dict` instead, it will be converted to a `NamedTuple` automatically.

{{basic_usage/sample_with_config.jl}}


## Running on minimisation mode

Consensus-based sampling can also be used for minimisation (see [Consensus-Based Sampling](@ref)). If you want to run it in that mode, pass the option `CBS_mode = :minimise`.


## Method reference

```@index
Pages = ["distribution_sampling.md"]
```

```@docs
ConsensusBasedX.sample
```

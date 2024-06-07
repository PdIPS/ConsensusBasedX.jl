# Function minimisation

The main functionality of ConsensusBasedX.jl is function minimisation via [Consensus-Based Optimisation](@ref). It assumes you have defined a function `f(x::AbstractVector)` that takes a single vector argument `x` of length `D = length(x)`.

For instance, if `D = 2`, you can minimise `f` by running:
```julia
minimise(f, D = 2)
```
By default, `minimise` returns a `Vector{Float64}` of length `D`.

!!! note
    You must always provide `D`.

{{basic_usage/minimise_with_keywords.jl}}


## Using a `config` object

For more advanced usage, you will select several options. You can pass these as extra keyword arguments to `minimise`, or you can create a `NamedTuple` called `config` and pass that:
```julia
config = (; D = 2)
minimise(f, config)
```

!!! note
    If you pass a `Dict` instead, it will be converted to a `NamedTuple` automatically.

This is a version of the full-code example above, using `config` instead:
{{basic_usage/minimise_with_config.jl}}


## Aliases

ConsensusBasedX.jl also defines `optimise` as an alias of `minimise`.


## Maximisation

ConsensusBasedX.jl also defines `maximise` for convenience. If you call
```julia
maximise(f, D = 2)
```
or 
```julia
config = (; D = 2)
maximise(f, config)
```
`maximise` will attempt to define `g(x) = -f(x)` and call `minimise(g, config)`.

These are full-code examples using keywords
{{basic_usage/maximise_with_keywords.jl}}
or using `config`
{{basic_usage/maximise_with_config.jl}}


## Method reference

```@index
Pages = ["function_minimisation.md"]
```

```@docs
ConsensusBasedX.maximise
ConsensusBasedX.minimise
```

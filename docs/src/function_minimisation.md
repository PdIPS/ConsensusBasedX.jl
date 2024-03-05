# Function minimisation

The main functionality of CBX.jl is function minimisation. It assumes you have defined a function `f(x::AbstractVector)` that takes a single vector argumemt `x` of length `D = length(x)`.

For instance, if `D = 2`, you can minimise `f` by running:
```julia
minimise(f, D = 2)
```
[Full-code example](https://github.com/PdIPS/CBX.jl/blob/main/examples/basic_usage/minimise_with_keywords.jl).

!!! note
    You must always provide `D`.


## Using a `config` object

For more advanced usage, you will select several options. You can pass these as extra keyword arguments to `minimise`, or you can create a `NamedTuple` called `config` and pass that:
```julia
config = (; D = 2)
minimise(f, config)
```
[Full-code example](https://github.com/PdIPS/CBX.jl/blob/main/examples/basic_usage/minimise_with_config.jl).

!!! note
    If you pass a `Dict` instead, it will be converted to a `NamedTuple` automatically.


## Aliases

CBX.jl also defines `minimize`, `optimise`, and `optimize`. These are all aliases of `minimise`.


## Maximisation

CBX.jl also defines `maximise` (and its alias, `maximize`) for convenience. If you call
```julia
maximise(f, D = 2)
```
or 
```julia
config = (; D = 2)
maximise(f, config)
```

Full-code examples are provided for the [keyword](https://github.com/PdIPS/CBX.jl/blob/main/examples/basic_usage/maximise_with_keywords.jl) and [config](https://github.com/PdIPS/CBX.jl/blob/main/examples/basic_usage/maximise_with_config.jl) approaches.


## Method reference


```@index
Pages = ["function_minimisation.md"]
```

```@docs
CBX.maximise
CBX.minimise
```

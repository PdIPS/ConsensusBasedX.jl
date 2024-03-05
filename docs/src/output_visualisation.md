# Output visualisation

CBX.jl offers the `CBXPlots` submodule, which provides routines to visualise the output of `minimise` for problems in one or two dimensions.

Simply run `minimise` with `extended_output = true` (see [Extended output](@ref)), and then call the `plot_CBO` method:
```julia
out = minimise(f, D = 2, extended_output = true)
using CBX.CBXPlots
plot_CBO(out)
```
Full-code examples in [one dimension](https://github.com/PdIPS/CBX.jl/blob/main/examples/advanced_usage/output_visualisation_1D.jl) and [two dimensions](https://github.com/PdIPS/CBX.jl/blob/main/examples/advanced_usage/output_visualisation_2D.jl).

!!! compat
    The developers of CBX.jl intend to segregate `CBXPlots` as a separate package in the future, in order to avoid having `Plots` as a dependency of `CBX`.

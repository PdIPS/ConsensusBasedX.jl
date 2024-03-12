# Output visualisation

The auxiliary package [ConsensusBasedXPlots.jl](https://github.com/PdIPS/ConsensusBasedXPlots.jl) provides routines to visualise the output of `minimise` for problems in one or two dimensions. These routines are kept as a separate package in order to minimise the dependencies of ConsensusBasedX.jl, since not every user will require visualisation tools.

To plot the output of CBO, simply run `minimise` with `extended_output = true` (see [Extended output](@ref)), and then call the `plot_CBO` method:
```julia
out = minimise(f, D = 2, extended_output = true)
using ConsensusBasedXPlots
plot_CBO(out)
```
Full-code examples in [one dimension](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/examples/advanced_usage/output_visualisation_1D.jl) and [two dimensions](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/examples/advanced_usage/output_visualisation_2D.jl).

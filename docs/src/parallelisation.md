# Parallelisation

Consensus-based optimisation is often used to tackle minimisation problems where `f(x)` is expensive to evaluate (for instance, parameter estimation in a [partial differential equation](https://en.wikipedia.org/wiki/Partial_differential_equation) model). Therefore, ConsensusBasedX.jl does not use parallelisation by default, as it assumes the implementation of `f` will be parallelised if possible.

However, you can enable parallelisation by passing the option `parallelisation=:EnsembleParallelisation`. With this option, ConsensusBasedX.jl will run each of the `M` particle ensembles in parallel, using multithreading.

!!! warning
    Parallelisation leads to memory allocations which cannot be avoided, as there is overhead associated with distributing the tasks. If you activate parallelisation, and then run `minimise` in benchmark mode (see [Performance and benchmarking](@ref)), you will detect some allocations, and this is expected.

{{advanced_usage/parallelisation.jl}}

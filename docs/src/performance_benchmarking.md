# Performance and benchmarking

ConsensusBasedX.jl has been developed with performance in mind. As such, it follows the recommended code patterns, such as avoiding global variables, or keeping memory allocation outside of performance-critical functions.

In order to maintain good performance, it's important that your function `f` also follows these patterns. We recommend the [performance tips](https://docs.julialang.org/en/v1/manual/performance-tips/) section of the Julia documentation. You should benchmark `f`, paying attention to memory allocations.

Once you have benchmarked `f`, you might want to test its performance within ConsensusBasedX.jl. You could run
```julia
config = (; D = 2)
@time minimise(f, config)
```
but the output of `@time` will be noisy, as it will include the time and memory allocations due to the caches created by ConsensusBasedX.jl. 

If, instead, you want to test only the performance-critical parts of the code, you can run the routine in *benchmark mode*:
```julia
config = (; D = 2, benchmark = true)
minimise(f, config)
```
This will run the beginning of the `minimise` routine as normal, creating the required caches. However, instead of computing the full particle evolution, it will only calculate a few steps, printing the output of `@time` to console, and returning the output of `@timed`.

!!! tip
    The benchmark mode reports zero allocations with all the [Example objectives](@ref) provided by ConsensusBasedX.jl. [Full-code example](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/examples/advanced_usage/benchmark.jl). Wherever possible, your function should also lead to zero allocations.

!!! warning
    If you are running [Consensus-Based Sampling](@ref) by calling `sample`, allocations might occur whenever the `root = :SymmetricRoot` is automatically selected (see [Root-covariance types](@ref)). To have zero allocations, you must run with the option `root = :AsymmetricRoot`. Nevertheless, despite the allocations, the `root = :SymmetricRoot` option offers better performance when `N` is large (roughly if `N > 10 * D`).

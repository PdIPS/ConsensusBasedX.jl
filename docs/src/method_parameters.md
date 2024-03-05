# Method parameters

You can change any of these parameters by passing them as keywords to the `minimise` routine.

## Number of particles

ConsensusBasedX.jl uses `N = 20` particles by default. At each iteration of the method, the function `f` is evaluated at the position of each particle.

!!! tip
    Using more particles is likely to yield better results, but it will increase the computational cost of the minimisation.


## Number of ensembles

ConsensusBasedX.jl uses `M = 1` ensembles by default. Each ensemble will perform its own minimisation of `f`, and the final results will be averaged.

!!! tip
    Using more ensembles is likely to yield better results, but it will increase the computational cost of the minimisation.


## Time step

ConsensusBasedX.jl uses a time step of `Δt = 0.1` by default. The evolution of the particles is given by a certain [stochastic differential equation](https://en.wikipedia.org/wiki/Stochastic_differential_equation), which is solved using an [Euler-Maruyama scheme](https://en.wikipedia.org/wiki/Euler%E2%80%93Maruyama_method) with time step `Δt`.

!!! tip
    Reducing `Δt` will require more iterations of the method to converge, but will provide additional stability. Reduce `Δt` only if your minimisation "blows up" (returns unusually large numbers, `Inf`, or `NaN`).


## Consensus parameters

Consensus-based optimisation requires three parameters:
- `σ::Real = 1` is the noise strengh;
- `λ::Real = 1` is the drift strengh;
- `α::Real = 10` is the exponential weight parameter.

!!! tip
    A low value of `σ` and a high value of `λ` make the particles converge towards the consensus point more directly; this is a good idea if you have a very good guess for the global minimiser (see [Particle initialisation](@ref)). A high value of `σ` and a low value of `λ` make the particles explore more of the landscape before converging, which is useful if your initial guess is bad. Similarly, a higher value of `α` biases the consensus point towards the current best particle, which is only desirable if your initial guess is good.

[Full-code example](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/examples/basic_usage/method_parameters.jl).

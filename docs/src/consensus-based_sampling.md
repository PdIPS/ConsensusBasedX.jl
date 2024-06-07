# Consensus-Based Sampling

[Consensus-Based Optimisation](@ref) (CBO) solves the problem of minimising a function ``f`` by computing weighted means of the associated "Gibbs-like" distribution ``\exp(-\alpha f(x))``. A related problem is the sampling problem:
!!! note "Sampling problem"
    Given a *target distribution* ``g(x)=\mathbb{R}^D \rightarrow \mathbb{R}^+``, find ``N`` independent samples ``X^i \in \mathbb{R}^D`` from the random variable ``X`` with ``\operatorname*{Law}(X) = g``. Informally, this means that a normalised histogram of ``X^i`` will resemble ``g(x)`` when ``N`` is large.

Consensus-based sampling (CBS) is an approach to the sampling problem in the case ``g(x) \propto \exp(-\alpha f(x))``. This is a common scenario that arises, for instance, in [Bayesian inference](https://en.wikipedia.org/wiki/Bayesian_inference). It uses the same *consensus point* as CBO, 
```math
c_\alpha(x_t) =
\frac{1}{ \sum_{i=1}^N \omega_\alpha(x_t^i) }
\sum_{i=1}^N x_t^i \, \omega_\alpha(x_t^i),
\quad\text{where}\quad
\omega_\alpha(\,\cdot\,) = \mathrm{exp}(-\alpha f(\,\cdot\,)),
```
for some ``\alpha>0``. It additionally defines a *weighted covariance matrix*,
```math
V_\alpha(x_t) =
\frac{1}{ \sum_{i=1}^N \omega_\alpha(x_t^i) }
\sum_{i=1}^N
\left( x_t^i - c_\alpha(x_t) \right) \otimes \left( x_t^i - c_\alpha(x_t) \right)
\, \omega_\alpha(x_t^i).
```

On each method iteration, the particles evolve in time following the rule
```math
x_{n+1}^i =
\underbrace{
\beta x_n^i + (1-\beta) c_\alpha(x_n)
}_{
\text{consensus drift}
}
+ \sqrt{\frac{ 1 - \beta^2 }{ \lambda }}\ \underbrace{
V_\alpha^{\frac{1}{2}}(x_n) \xi^i
}_{
\text{scaled diffusion}
},
```
where ``\beta\in(0,1)`` is an interpolation parameter, and where ``\xi^i`` are independent standard normal random variables in ``D`` dimensions. The *consensus drift* is a deterministic interpolation towards the consensus point; meanwhile, the *scaled diffusion* is a stochastic term that controls the variance of ``x_n^i``. This update rule can be understood as a numerical scheme for an SDE with a time step ``\Delta t``, where ``\beta = \exp(-\Delta t)``. The corresponding SDE would be 
```math
\mathrm{d}x_t^i =
- \underbrace{
\left( x_t^i - c_\alpha(x_t) \right) \mathrm{d}t
}_{
\text{consensus drift}
}
+ \sqrt{2\lambda^{-1}}\ \underbrace{
V_\alpha^{\frac{1}{2}}(x_t) \mathrm{d}B_t^i
}_{
\text{scaled diffusion}
}.
```

The matrix ``V_\alpha^{\frac{1}{2}}(x_t)`` is the *matrix square-root* of the covariance ``V_\alpha(x_t)``, in the sense that ``V_\alpha = V_\alpha^{\frac{1}{2}} \left( V_\alpha^{\frac{1}{2}} \right) ^T``. An alternative (distributionally equivalent) covariance square-root is given in [A. Garbuno-Inigo, N. Nüsken, and S. Reich (2020)](https://epubs.siam.org/doi/10.1137/19M1304891), and also implemented in ConsensusBasedX.jl (see [Root-covariance types](@ref)). By default, the version with the best performance is selected, as a function of ``D`` and ``N``.

The parameter ``\lambda`` controls the overall behaviour of the algorithm. If ``\lambda = (1+\alpha)^{-1}``, the particles will converge in time towards the distribution ``\exp(-\alpha f(x))``; therefore, their final positions are approximately samples of the target distribution. If ``\lambda = 1``, the particles will converge towards the consensus point, which will be an approximation of the global minimiser of ``f``, just as in CBO.

For additional details, see [J. A. Carrillo, F. Hoffmann, A. M. Stuart, and U. Vaes (2022)](https://onlinelibrary.wiley.com/doi/10.1111/sapm.12470). Note that, in their notation, the roles of ``\alpha`` and ``\beta`` are switched.

# Consensus-Based Optimisation

Consensus-based optimisation (CBO) is an approach to solve the *global minimisation problem*:
!!! note "Global minimisation problem"
    Given a (continuous) *objective function* ``f(x)=\mathbb{R}^D \rightarrow \mathbb{R}``, find
    ```math
    x^* = \operatorname*{argmin}_{x\in\mathbb{R}^D} f(x);
    ```
    i.e., find the point where ``f`` takes its lowest value.

CBO uses a finite number ``N`` of *agents* (driven particles), ``x_t=(x_t^1,\dots,x_t^N)``, to explore the landscape of ``f`` without evaluating any of its derivatives. At each time ``t``, the agents evaluate the objective function at their position, ``f(x_t^i)``, and define a  *consensus point* ``c_\alpha``. This point is an approximation of the global minimiser ``x^*``, and is constructed by weighing each agent's position against a ["Gibbs-like" distribution](https://en.wikipedia.org/wiki/Boltzmann_distribution), ``\exp(-\alpha f(x))``:
```math
c_\alpha(x_t) =
\frac{1}{ \sum_{i=1}^N \omega_\alpha(x_t^i) }
\sum_{i=1}^N x_t^i \, \omega_\alpha(x_t^i),
\quad\text{where}\quad
\omega_\alpha(\,\cdot\,) = \mathrm{exp}(-\alpha f(\,\cdot\,)),
```
for some ``\alpha>0``. The exponential weights in the definition favour those points ``x_t^i`` where ``f(x_t^i)`` is lowest, and comparatively ignore the rest. If all the found values of the objective function are approximately the same, ``c_\alpha(x_t)`` is roughly an arithmetic mean; if, instead, one particle is much better than the rest, ``c_\alpha(x_t)`` will be very close to its position.

Once the consensus point is defined, the particles evolve in time following the stochastic differential equation (SDE)
```math
\mathrm{d}x_t^i =
-\lambda\ \underbrace{
\left( x_t^i - c_\alpha(x_t) \right) \mathrm{d}t
}_{
\text{consensus drift}
}
+ \sqrt{2\sigma^2}\ \underbrace{
\left\| x_t^i - c_\alpha(x_t) \right\| \mathrm{d}B_t^i
}_{
\text{scaled diffusion}
},
```
where ``\lambda`` and ``\sigma`` are positive parameters, and where ``B_t^i`` are independent Brownian motions in ``D`` dimensions. The *consensus drift* is a deterministic term which drives each agent towards the consensus point, at rate ``\lambda``; meanwhile, the *scaled diffusion* is a stochastic term that encourages exploration.

For additional details, see [R. Pinnau, C. Totzeck, O. Tse, and S. Martin (2017)](http://dx.doi.org/10.1142/S0218202517400061).

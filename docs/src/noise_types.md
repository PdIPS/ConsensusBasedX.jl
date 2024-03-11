# Noise types

## Isotropic noise

By default, [Consensus-Based Optimisation](@ref) uses so-called *isotropic noise* (option `noise = :IsotropicNoise`), given by
```math
\mathrm{d}x_t^i =
\cdots
+ \sqrt{2\sigma^2} 
\left\| x_t^i - c_\alpha(x_t) \right\| \mathrm{d}B_t^i,
```
where ``B_t^i`` are independent Brownian motions in ``D`` dimensions. The intensity of the noise depends on the distance of each particle to the consensus point, ``\left\| x_t^i - c_\alpha(x_t) \right\|``. [Full-code example](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/examples/advanced_usage/isotropic_noise.jl).

## Anisotropic noise

ConsensusBasedX.jl also offers *anisotropic noise*, given by 
```math
\mathrm{d}x_t^i =
\cdots
+ \sqrt{2\sigma^2} 
\operatorname*{diag} \left( x_t^i - c_\alpha(x_t) \right) \mathrm{d}B_t^i,
```
The intensity of the noise now varies along each dimension. This can be selected with the option `noise = :AnisotropicNoise`. [Full-code example](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/examples/advanced_usage/anisotropic_noise.jl).

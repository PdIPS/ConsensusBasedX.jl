# Noise types

By default, ConsensusBasedX.jl uses so-called *isotropic noise* (option `noise = :IsotropicNoise`), given by
```math
\mathrm{d}X_i(t) = \cdots + \sqrt{2} \sigma \left| X_i(t) - V(t) \right| \mathrm{d}W_i(t),
```
where ``W_i`` are independent Brownian processes. The intensity of the noise depends on the distance of each particle to the consensus point, ``\left| X_i(t) - V(t) \right|``. [Full-code example](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/examples/advanced_usage/isotropic_noise.jl).

## Anisotropic noise

ConsensusBasedX.jl also offers *anisotropic noise*, given by 
```math
\mathrm{d}X_i(t) = \cdots + \sqrt{2} \sigma \,\mathrm{diag} \left( X_i(t) - V(t) \right) \mathrm{d}W_i(t).
```
The intensity of the noise now varies along each dimension. This can be selected with the option `noise = :AnisotropicNoise`. [Full-code example](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/examples/advanced_usage/anisotropic_noise.jl).

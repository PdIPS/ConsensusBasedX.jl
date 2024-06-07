![ConsensusBasedXjl](https://github.com/PdIPS/ConsensusBasedX.jl/assets/44805883/238eca7e-00b7-4008-82ec-1fe233c8f8e1)

# ConsensusBasedX.jl: Consensus-Based Optimisation in Julia

[![status](https://joss.theoj.org/papers/008799348e8232eb9fe8180712e2dfb8/status.svg)](https://joss.theoj.org/papers/008799348e8232eb9fe8180712e2dfb8)
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://PdIPS.github.io/ConsensusBasedX.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://PdIPS.github.io/ConsensusBasedX.jl/dev/)
[![Build Status](https://github.com/PdIPS/ConsensusBasedX.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/PdIPS/ConsensusBasedX.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/PdIPS/ConsensusBasedX.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/PdIPS/ConsensusBasedX.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**ConsensusBasedX.jl** is a gradient-free stochastic optimisation package for Julia, born out of [Consensus.jl](https://github.com/rafaelbailo/Consensus.jl) and [CBXpy](https://github.com/PdIPS/CBXpy). It uses _Consensus-Based Optimisation_ (CBO), a flavour of _Particle Swarm Optimisation_ (PSO) first introduced by [R. Pinnau, C. Totzeck, O. Tse, and S. Martin (2017)][1]. This is a method of global optimisation particularly suited for rough functions, where gradient descent would fail. It is useful for optimisation in higher dimensions. It also implements _Consensus-Based Sampling_ (CBS), as introduced in [J. A. Carrillo, F. Hoffmann, A. M. Stuart, and U. Vaes (2022)][2].


## How to install and use

To install ConsensusBasedX.jl, simply run
```julia
using Pkg; Pkg.add("ConsensusBasedX")
```
in the Julia REPL. You can then load the package in a script or in the REPL by running
```julia
using ConsensusBasedX
```

## Basic minimisation

The main functionality of ConsensusBasedX.jl is function minimisation via CBO. It assumes you have defined a function `f(x::AbstractVector)` that takes a single vector argument `x` of length `D = length(x)`.

For instance, if `D = 2`, you can minimise `f` by running:
```julia
minimise(f, D = 2)
```

Your full code might look like this:
```julia
using ConsensusBasedX
f(x) = x[1]^2 + x[2]^2
x = minimise(f, D = 2)
```

## Basic sampling

ConsensusBasedX.jl also provides CBS. The package exports `sample`, which has the same syntax as `minimise`.

For instance, if `D = 2`, you can sample `exp(-αf)` by running:
```julia
out = sample(f, D = 2, extended_output=true)
out.sample
```

For more detailed explanations and full-code examples, see the [documentation](https://PdIPS.github.io/ConsensusBasedX.jl/stable/).

## Bug reports, feature requests, and contributions

See [the contribution guidelines](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/CONTRIBUTING.md).

[1]: http://dx.doi.org/10.1142/S0218202517400061
[2]: https://onlinelibrary.wiley.com/doi/10.1111/sapm.12470

*Copyright © 2024 [Dr Rafael Bailo](https://rafaelbailo.com/) and [Purpose-Driven Interacting Particle Systems Group](https://github.com/PdIPS). [MIT License](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/LICENSE).*


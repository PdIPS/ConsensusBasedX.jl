```@meta
CurrentModule = ConsensusBasedX
```

# ConsensusBasedX.jl: Consensus-Based Optimisation in Julia

```@raw html
<iframe src="https://ghbtns.com/github-btn.html?user=PdIPS&repo=ConsensusBasedX.jl&type=star&count=true&size=large" frameborder="0" scrolling="0" width="170" height="30" title="GitHub"></iframe>
```

**ConsensusBasedX.jl** is a gradient-free stochastic optimisation package for Julia, born out of [Consensus.jl](https://github.com/rafaelbailo/Consensus.jl) and [CBXpy](https://github.com/PdIPS/CBXpy). It uses _Consensus-Based Optimisation_ (CBO), a flavour of _Particle Swarm Optimisation_ (PSO) first introduced by [R. Pinnau, C. Totzeck, O. Tse, and S. Martin (2017)](http://dx.doi.org/10.1142/S0218202517400061). This is a method of global optimisation particularly suited for rough functions, where gradient descent would fail. It is also useful for optimisation in higher dimensions. It also implements _Consensus-Based Sampling_ (CBS), as introduced in [J. A. Carrillo, F. Hoffmann, A. M. Stuart, and U. Vaes (2022)](https://onlinelibrary.wiley.com/doi/10.1111/sapm.12470). 

[![Static Badge](https://img.shields.io/badge/View%20on%20Github-grey?logo=github)](https://github.com/PdIPS/ConsensusBasedX.jl)
[![Build Status](https://github.com/PdIPS/ConsensusBasedX.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/PdIPS/ConsensusBasedX.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/PdIPS/ConsensusBasedX.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/PdIPS/ConsensusBasedX.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

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

The main functionality of ConsensusBasedX.jl is function minimisation via CBO. It assumes you have defined a function `f(x::AbstractVector)` that takes a single vector argumemt `x` of length `D = length(x)`.

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
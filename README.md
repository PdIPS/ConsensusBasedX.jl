![cbxjl](https://github.com/PdIPS/CBX.jl/assets/44805883/238eca7e-00b7-4008-82ec-1fe233c8f8e1)

# CBX.jl: Consensus-Based Optimisation in Julia

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://PdIPS.github.io/CBX.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://PdIPS.github.io/CBX.jl/dev/)
[![Build Status](https://github.com/PdIPS/CBX.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/PdIPS/CBX.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/PdIPS/CBX.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/PdIPS/CBX.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**CBX.jl** is a gradient-free stochastic optimisation package for Julia, born out of [Consensus.jl](https://github.com/rafaelbailo/Consensus.jl) and [CBXpy](https://github.com/PdIPS/CBXpy). It uses _Consensus-Based Optimisation_ (CBO), a flavour of _Particle Swarm Optimisation_ (PSO) first introduced by [R. Pinnau, C. Totzeck, O. Tse, and S. Martin (2017)][1]. This is a method of global optimisation particularly suited for rough functions, where gradient descent would fail. It is also useful for optimisation in higher dimensions.


## Basic Usage

The main functionality of CBX.jl is function minimisation. It assumes you have defined a function `f(x::AbstractVector)` that takes a single vector argumemt `x` of length `D = length(x)`.

For instance, if `D = 2`, you can minimise `f` by running:
```julia
minimise(f, D = 2)
```

For more detailed explanations and full-code examples, see the [documentation](https://PdIPS.github.io/CBX.jl/stable/).


## Consensus-Based Optimisation

Consensus-based optimisation uses *particles* to minimise a function $f(x)$. The particles evolve following a stochastic differential equation:
```math
\mathrm{d}X_i(t) = -\lambda \left( X_i - V \right) H \left[ f(X_i) - f(V) \right] \mathrm{d}t + \sqrt{2} \sigma \left| X_i(t) - V(t) \right| \mathrm{d}W_i(t),
```
where ``W_i`` are independent Brownian processes, and where
```math
V(t) = \frac{
\sum\limits_{i} X_i \exp(-\alpha f(X_i))
}{
\sum\limits_{i} \exp(-\alpha f(X_i))
},
```
is a weighted average of the particle's positions called the **consensus point**. $\lambda$, $\sigma$, and $\alpha$ are given positive parameters.

[1]: http://dx.doi.org/10.1142/S0218202517400061


*Copyright © 2024 [Dr Rafael Bailo](https://rafaelbailo.com/) and [Purpose-Driven Interacting Particle Systems Group](https://github.com/PdIPS). [MIT License](https://github.com/PdIPS/CBX.jl/blob/main/LICENSE).*


```@meta
CurrentModule = ConsensusBasedX
```

# ConsensusBasedX.jl: Consensus-Based Optimisation in Julia

```@raw html
<iframe src="https://ghbtns.com/github-btn.html?user=PdIPS&repo=ConsensusBasedX.jl&type=star&count=true&size=large" frameborder="0" scrolling="0" width="170" height="30" title="GitHub"></iframe>
```

**ConsensusBasedX.jl** is a gradient-free stochastic optimisation package for Julia, born out of [Consensus.jl](https://github.com/rafaelbailo/Consensus.jl) and [CBXpy](https://github.com/PdIPS/CBXpy). It uses _Consensus-Based Optimisation_ (CBO), a flavour of _Particle Swarm Optimisation_ (PSO) first introduced by [R. Pinnau, C. Totzeck, O. Tse, and S. Martin (2017)](http://dx.doi.org/10.1142/S0218202517400061). This is a method of global optimisation particularly suited for rough functions, where gradient descent would fail. It is also useful for optimisation in higher dimensions.


## Consensus-Based Optimisation

Consensus-based optimisation uses *particles* to minimise a function ``f(x)``. The particles evolve following a stochastic differential equation:
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
is a weighted average of the particle's positions called the **consensus point**. ``\lambda``, ``\sigma``, and ``\alpha`` are given positive parameters.

[![Static Badge](https://img.shields.io/badge/View%20on%20Github-grey?logo=github)](https://github.com/PdIPS/ConsensusBasedX.jl)
[![Build Status](https://github.com/PdIPS/ConsensusBasedX.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/PdIPS/ConsensusBasedX.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/PdIPS/ConsensusBasedX.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/PdIPS/ConsensusBasedX.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

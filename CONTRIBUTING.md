# Contributing to ConsensusBasedX.jl

We are always happy to receive community contributions, thank you in advance for your contribution and for reading through these guidelines! We are open to various inputs, including but not limited to
- new features;
- feature requests;
- bug reports;
- bug fixes;
- documentation.

## How to contribute

### Features, bug fixes, and documentation

The preferred workflow is to fork the ConsensusBasedX.jl repository, to commit your changes to the fork, and to create a pull request.

ConsensusBasedX.jl employs unit tests to ensure code quality. Please make sure that your contribution passes all unit tests before creating the pull request.

**To run the tests locally** (preferred): activate the Julia environment in your local clone of the fork, and then run
```julia
using Pkg; Pkg.test()
```

**To run the tests on Github**: you will have to enable [GitHub workflows](https://github.com/PdIPS/CBXpy/blob/main/.github/workflows/Tests.yml) on your fork. Workflows are turned off by default in forks for security reasons. Unit tests are run as part of the *CI* (continuous integration) [GitHub action](https://docs.github.com/en/actions).

### Feature requests and bug reports

If you want to request a new feature or report a bug (e.g. wrong output, unexpected behaviour), please [open an issue here](https://github.com/PdIPS/ConsensusBasedX.jl/issues/new/choose). There are *Feature request* and *Bug report* templates that might be useful.

## Scope of new features

ConsensusBasedX.jl has been designed with flexibility in mind, in order to accomodate the growing number of consensus-based particle methods in one library. We recommend reading the [documentation](https://pdips.github.io/ConsensusBasedX.jl/) carefully before contributing new features. The main criteria for a contribution are:
- **Novelty**: New features should add functionality that cannot already be accomplished with the existing interface. For example, a good contribution would be the implementation of [constrained minimisation](https://en.wikipedia.org/wiki/Constrained_optimization), whereas a bad contribution would be to define new version of `sample` that is hard-coded to run on [minimisation mode](https://pdips.github.io/ConsensusBasedX.jl/stable/distribution_sampling/#Running-on-minimisation-mode).
- **Consistency**: We try to keep a unified syntax across ConsensusBasedX.jl (e.g. the methods `minimise` and `sample` use the same syntax and accept many of the same arguments). New features should adhere to this pattern.
- **Performance**: Optimisation problems are extremely computationally demanding, so it is important to offer good performance. You should read the [performance and benchmarking](https://pdips.github.io/ConsensusBasedX.jl/stable/performance_benchmarking/) section of the documentation and consider including "zero-allocation" unit tests for your implementation, [similar to those included for `minimise`](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/test/interface/minimise.jl). For more information, see the [performance tips](https://docs.julialang.org/en/v1/manual/performance-tips/) page of the Julia documentation.

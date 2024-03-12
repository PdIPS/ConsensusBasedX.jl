# Root-covariance types

[Consensus-Based Sampling](@ref) uses the usual matrix square root to compute the root-covariance matrix ``V_\alpha^{\frac{1}{2}}(x_t)`` (option `root = :SymmetricRoot`). However, an alternative, non-symmetric, distributionally equivalent approach is given in [A. Garbuno-Inigo, N. Nüsken, and S. Reich (2020)](https://epubs.siam.org/doi/10.1137/19M1304891) (option `root = :AsymmetricRoot`).

By default, CBS uses `root = :AsymmetricRoot` if `N <= 10 * D`, and `root = :SymmetricRoot` otherwise, as this approach gives (roughly) the best performance.

# Summary of options

## Basic options

- `D::Int` is the dimension of the problem. **This option must always be provided by the user**.
- `N::Int = 20` is the number of particles.
- `M::Int = 1` is the number of ensembles.
- `Δt::Real = 0.1` is the time step.
- `σ::Real = 1` is the noise strengh.
- `λ::Real = 1` is the drift strengh.
- `α::Real = 10` is the exponential weight parameter.

## Initialisation options

See [Particle initialisation](@ref).

- `initialisation = :normal` is the default sampling method. You can change it to `initialisation = :uniform` in order to sample uniformly from a hyperbox around `initial_guess`.
- `initial_guess::Union{Real,AbstractVector}` provides an initial guess for the global minimiser.
- `initial_mean::Union{Real,AbstractVector}` customises the mean of the initial distribution of particles. This is an alias for `initial_guess`.
- `initial_variance::Union{Real,AbstractVector,AbstractMatrix}` customises the mean of the initial distribution of particles (if the sampling is normal). It has the alias `initial_covariance`.
- `initial_radius::Union{Real,AbstractVector}` specifies the size of the hyperbox (if the sampling is uniform). You specify `initial_diameter` instead.
- `initial_particles::AbstractArray{<:Real,3}` specifies the initial position of the particles.

## Stopping options 

See [Stopping criteria](@ref).

- `energy_threshold::Real = -Inf` is the stopping threshold for the value of `f`.
- `energy_tolerance::Real = 1e-8` is the stopping tolerance for the value of `f`.
- `max_evaluations::Real = Inf` is the maximum number of evaluations of `f`.
- `max_iterations::Real = 1000` is the maximum number of iterations.
- `max_time::Real = Inf` is the maximal simulation time.

## Advanced options

- `noise = :IsotropicNoise` controls the type of noise, see [Noise types](@ref).
- `benchmark::Bool = false` controls the benchmark behaviour. `benchmark = true` runs the `ParticleDynamic` on benchmark mode, see [Performance and benchmarking](@ref).
- `extended_output::Bool = false` controls the output, and by default returns only the computed minimiser. `extended_output = true` returns additional information, see [Extended output](@ref).
- `parallelisation = :NoParallelisation` controls the parallelisation of the `minimise` routine, switched off by default. `parallelisation=:EnsembleParallelisation` enables parallelisation, see  [Parallelisation](@ref).
- `verbosity::Int = 0` is the verbosity level. `verbosity = 0` produces no output to console. `verbosity = 1` produces some output. 

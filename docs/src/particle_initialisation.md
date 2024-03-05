# Particle initialisation

ConsensusBasedX.jl needs to initialise particles in order to perform function minimisation.


## Default initialisation

If no options are provided, ConsensusBasedX.jl initialises its particles by sampling a [standard normal distribution](https://en.wikipedia.org/wiki/Normal_distribution#Standard_normal_distribution) (a [normal distribution](https://en.wikipedia.org/wiki/Normal_distribution) with zero mean and unit variance).


## Initial guess

If you have an initial guess for the global minimiser of the function `f`, you can pass the option `initial_guess` (or `initial_mean`). This can be a `Real`, if you want to use the same value for each coordinate of the initial guess, or an `AbstractVector` of size `size(initial_guess) = (D,)`. The particles will be initisalised by sampling a normal distribution with mean `initial_guess`/`initial_mean` and unit variance. [Full-code example](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/examples/basic_usage/initial_guess.jl).


### Specify a normal distribution

If you want to specify the variance of the normal distribution sampled around `initial_guess`/`initial_mean`, you can pass the option `initial_variance` (or `initial_covariance`). This can be a `Real`, if you want an isotropic distribution, an `AbstractVector` of size `size(initial_variance) = (D,)`, if you want to specify the variance along each axis, or an `AbstractMatrix` of size `size(initial_variance) = (D, D)`, if you want a general [multivariate normal distribution](https://en.wikipedia.org/wiki/Multivariate_normal_distribution). [Full-code example](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/examples/basic_usage/initial_variance.jl).


### Specify a uniform distribution

You can instead initialise the particles by sampling uniformly from a box around `initial_guess`/`initial_mean`. To do so, pass the option `initialisation = :uniform`. [Full-code example](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/examples/basic_usage/initialisation_uniform.jl).

You can specify the radius of the box with the option `initial_radius`, or the diameter with `initial_diameter`. This can be a `Real`, if you want a hypercube, or an `AbstractVector` of size `size(initial_guess) = (D,)`, if you want a hyperbox with different dimensions along each axis. [Full-code example](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/examples/basic_usage/initial_radius.jl).


## Custom initialisation

You can provide the initial position of the particles direcly by passing the option `initial_particles`. This must be an `AbstractArray{<:Real,3}` of size `(D, N, M)`. [Full-code example](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/examples/basic_usage/initial_particles.jl).

!!! tip
    If you are initialising the particles yourself, you might find the [Distributions.jl](https://juliastats.org/Distributions.jl/stable/) package useful.

using CBX.LowLevel
import Distributions

N = 10;
d = 20;

## Initialise particles uniformly with each coordinate in [-3, 3]
conf =
  config(sampling = :uniform, sampling_x_min = -3, sampling_x_max = 3; N, d)
x = init_particles(conf)

### Initialise particles uniformly with mean 1 and standard deviation 2
conf = config(sampling = :uniform, sampling_μ = 1, sampling_σ = 2; N, d)
x = init_particles(conf)

### Initialise particles normally with mean 1 and standard deviation 2
conf = config(sampling = :normal, sampling_μ = 1, sampling_σ = 2; N, d)
x = init_particles(conf)

### Initialise particles specifying a scalar distribution for each coordinate
dist = Distributions.Normal(1, 2)
conf = config(; N, d, dist)
x = init_particles(conf)

### Initialise particles specifying a multivariate distribution for each particle
dist = Distributions.MultivariateNormal(d, 2)
conf = config(; N, d, dist)
x = init_particles(conf)

### Initialise particles passing the distribution as argument to init_particles
conf = config(; N, d)
x = init_particles(conf, Distributions.Normal(1, 2))

### The sampling defaults to Uniform(-1,1) for each coordinate
conf = config(; N, d)
x = init_particles(conf)

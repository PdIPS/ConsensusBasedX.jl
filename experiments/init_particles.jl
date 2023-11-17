using CBX.LowLevel

using Random
import Distributions, LinearAlgebra

Random.seed!(0);

D = 20;
N = 10;
M = 2;

### The sampling defaults to Uniform(-1,1) for each coordinate
config = (; D, N, M)
X = init_particles(config)

### Initialise particles uniformly with each coordinate in [-3, 3]
config =
  (; D, N, M, sampling = :uniform, sampling_x_min = -3, sampling_x_maX = 3)
X = init_particles(config)

### Initialise particles normally with mean 1 and standard deviation 2
config = (; D, N, M, sampling = :normal, sampling_μ = 1, sampling_σ = 2)
X = init_particles(config)

### Initialise particles specifying a scalar distribution for each coordinate
dist = Distributions.Normal(1, 2)
config = (; D, N, M, dist)
X = init_particles(config)

### Initialise particles specifying a multivariate distribution for each particle
dist = Distributions.MvNormal(LinearAlgebra.Diagonal([2 for d ∈ 1:D]))
config = (; D, N, M, dist)
X = init_particles(config)

### Initialise particles specifying a multivariate distribution for each realisation
dist = Distributions.MatrixNormal(
  zeros(D, N),
  Matrix(LinearAlgebra.I, D, D),
  Matrix(LinearAlgebra.I, N, N),
)
config = (; D, N, M, dist)
X = init_particles(config)

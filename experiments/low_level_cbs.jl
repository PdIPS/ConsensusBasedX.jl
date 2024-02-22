# For local testing:
#
using Pkg; Pkg.activate(".")

using CBX.LowLevel, Random

Random.seed!(0);

### Choose the configuration
config = (;
  D = 20,
  N = 100,
  M = 5,
  sampling = :uniform,
  sampling_x_min = -3,
  sampling_x_max = 3,
  Δt = 0.01,
  α = 30.0,
  track_step = 20,
  track_list = [:x, :consensus, :energy, :update_norm],
  scheduler = [
    (; field = :λ, action = :multiply, factor = 1.0)
  ],
  max_it = 1000,
  mode = :sampling,
)

X = rand(config.D, config.N, config.M);
Y = zeros(config.N, config.M);

### Define the objective function
f = Rastrigin()

### Define the initial positions of the particles
x = init_particles(config)

### Define the CBO algorithm
method = CBS(config, f, x)
step!(method)

### Run the CBS algorithm
for i in 1:100
  step!(method)
  if method.it % 10 == 0
    println("\nIteration $(method.it):")
    println("\tBest energy: $(method.best_energy)")
  end
end

### Plot the particle trajectories
plot(method)

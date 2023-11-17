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
  # σ=8.1,
  σ = 1.0,
  correction = :Heaviside_reg,
  noise = :isotropic,
  track_step = 20,
  track_list = [:x, :consensus, :energy, :update_norm],
  scheduler = [
    (; field = :α, action = :multiply, factor = 1.1, max = 1e15)
    (; field = :σ, action = :multiply, factor = 0.995)
  ],
  max_it = 1000,
)

X = rand(config.D, config.N, config.M);
Y = zeros(config.N, config.M);

### Define the objective function
f = Rastrigin()

### Define the initial positions of the particles
x = init_particles(config)

### Define the CBO algorithm
method = CBO(config, f, x)

### Run the CBO algorithm
while !terminate(method)
  step!(method)
  if method.it % 10 == 0
    println("\nIteration $(method.it):")
    println("\tBest energy: $(method.best_energy)")
  end
end

### Plot the particle trajectories
plot(method)

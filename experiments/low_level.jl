using CBX.LowLevel

using Random
# using Distributions

Random.seed!(0);

### Choose the configuration
config = (;
  D = 10,
  N = 200,
  M = 5,
  sampling = :uniform,
  sampling_x_min = -5,
  sampling_x_max = 5,
  Δt = 0.1,
  α = 30.0,
  σ = 20.0,
  correction = :Heaviside_reg,
  noise = :anisotropic,
  track_step = 100,
  track_list = [:x, :consensus, :energy, :update_norm],
)

X = rand(config.D, config.N, config.M);
Y = zeros(config.N, config.M);

### Define the objective function
# f = Quadratic()
f = Rastrigin()

### Define the initial positions of the particles
x = init_particles(config)

### Define the CBO algorithm
method = CBO(config, f, x)

# ### Run the CBO algorithm
# while !terminate(method)
for k ∈ 1:10000
  step!(method)
  if method.it % 10 == 0
    println(method.best_energy)
  end
end

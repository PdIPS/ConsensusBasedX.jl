using CBX.LowLevel

using Distributions

#%% Choose the configuration
conf = config(#
  alpha = 10,
  sigma = 5,
  λ = 1,
  d = 20,
  N = 100,
  T = 100,
  Δt = 0.001,
  sampling = :uniform,
  sampling_x_min = -3,
  sampling_x_max = 3,
)

#%% Define the objective function
f = Quadratic()

#%% Define the initial positions of the particles
x = init_particles(conf)

#%% Define the noise function
noise = WeightedNormalNoise(conf)

#%% Define the noise scheduler
scheduler = ExponentialScheduler(conf)

#%% Define the CBO algorithm
method = CBO(conf, f, x, noise, scheduler)

#%% Run the CBO algorithm
global it = 0
while !terminate(method)
  global it
  step!(method)

  if it % 10 == 0
    println(method.f_min)
  end
  it += 1
end

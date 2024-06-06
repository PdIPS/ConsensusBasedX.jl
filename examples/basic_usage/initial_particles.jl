using ConsensusBasedX
f(x) = ConsensusBasedX.Ackley(x, shift = 1)
config = (; D = 2, N = 20, M = 1, initial_particles = rand(2, 20, 1))
minimise(f, config) # should be close to [1, 1]

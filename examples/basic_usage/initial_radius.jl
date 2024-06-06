using ConsensusBasedX
f(x) = ConsensusBasedX.Ackley(x, shift = 1)
config = (; D = 2, N = 20, initial_radius = 3)
minimise(f, config) # should be close to [1, 1]

using ConsensusBasedX
f(x) = ConsensusBasedX.Ackley(x, shift = 1)
config = (; D = 2, energy_tolerance = 1e-4)
minimise(f, config) # should be close to [1, 1]

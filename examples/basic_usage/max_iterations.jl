using ConsensusBasedX
f(x) = ConsensusBasedX.Ackley(x, shift = 1)
config = (; D = 2, max_iterations = 80)
minimise(f, config) # should be close to [1, 1]

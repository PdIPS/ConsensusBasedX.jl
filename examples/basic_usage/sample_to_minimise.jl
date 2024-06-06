using ConsensusBasedX
f(x) = ConsensusBasedX.Ackley(x, shift = 1)
config = (; D = 2, N = 20, CBS_mode = :minimise)
sample(f, config)

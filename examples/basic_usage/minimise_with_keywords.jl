using ConsensusBasedX
f(x) = ConsensusBasedX.Ackley(x, shift = 1)
minimise(f, D = 2) # should be close to [1, 1]

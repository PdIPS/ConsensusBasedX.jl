using ConsensusBasedX

f(x) = ConsensusBasedX.Ackley(x, shift = 1)

config = (; D = 2, M = 5, parallelisation = :EnsembleParallelisation)
minimise(f, config)

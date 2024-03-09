using ConsensusBasedX

f(x) = ConsensusBasedX.Ackley(x, shift = 1)

out = sample(f, D = 2, N = 20, extended_output = true)
out.sample

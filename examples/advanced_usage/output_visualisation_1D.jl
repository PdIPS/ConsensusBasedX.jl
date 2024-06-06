using ConsensusBasedX, ConsensusBasedXPlots
f(x) = ConsensusBasedX.Ackley(x, shift = 1)
out = minimise(f, D = 1, extended_output = true)
plot_CBO(out)
savefig("CBO_1D")

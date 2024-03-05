using CBX

f(x) = CBX.Ackley(x, shift = 1)

config = (; D = 2, energy_threshold = 1e-2)
minimise(f, config) # should be close to [1, 1]

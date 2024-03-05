using CBX

f(x) = -CBX.Ackley(x, shift = 1)

maximise(f, D = 2) # should be close to [1, 1]

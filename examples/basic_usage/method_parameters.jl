using CBX

f(x) = CBX.Ackley(x, shift = 1)

config = (; D = 2, N = 20, M = 1, Δt = 0.01, σ = 1, λ = 1, α = 10)
minimise(f, config) # should be close to [1, 1]

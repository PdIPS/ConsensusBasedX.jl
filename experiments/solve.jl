using CBX

config = (; D = 10, N = 200, M = 5)
f = CBX.Objectives.Rastrigin()
method = CBO(config, f)
# x = minimise(method)

using ConsensusBasedX, Test

function tests()
  for fun ∈ [
    ConsensusBasedX.Quadratic,
    ConsensusBasedX.Ackley,
    ConsensusBasedX.Rastrigin,
  ]
    for shift ∈ [-1, 0, 1]
      for CBS_mode ∈ [:sampling, :minimise]
        D = 5
        config = (;
          D,
          M = 1_000,
          Δt = 0.01,
          initialisation = :uniform,
          initial_radius = 5,
          CBS_mode,
        )
        f(x) = fun(x; shift)
        out = sample(f, config)
        dist = sum((out .- shift) .^ 2) / D
        @test dist < 0.5
      end
    end
  end
end

tests()

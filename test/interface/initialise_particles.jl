using ConsensusBasedX, Test

function tests()
  config =
    (; D = 3, N = 2, M = 1, mode = ConsensusBasedX.ParticleMode, verbosity = 0)

  initial_particles = rand(3, 2, 1)
  X₀ =
    ConsensusBasedX.initialise_particles((merge(config, (; initial_particles))))
  @test X₀ == initial_particles

  @test_throws ArgumentError ConsensusBasedX.initialise_particles((merge(
    config,
    (; initial_particles = rand(1, 2, 3)),
  )))

  X₀ = ConsensusBasedX.initialise_particles((merge(
    config,
    (; initialisation = :uniform),
  )))
  @test all(map(s -> abs(s) <= 1, X₀))

  X₀ = ConsensusBasedX.initialise_particles((merge(
    config,
    (; initialisation = "uniform"),
  )))
  @test all(map(s -> abs(s) <= 1, X₀))

  X₀ = ConsensusBasedX.initialise_particles_uniform(config)
  @test all(map(s -> abs(s) <= 1, X₀))

  X₀ = ConsensusBasedX.initialise_particles_uniform(
    merge(config, (; initial_guess = 5)),
  )
  @test all(map(s -> abs(s - 5) <= 1, X₀))

  X₀ = ConsensusBasedX.initialise_particles_uniform(
    merge(config, (; initial_mean = 5)),
  )
  @test all(map(s -> abs(s - 5) <= 1, X₀))

  X₀ = ConsensusBasedX.initialise_particles_uniform(
    merge(config, (; initial_guess = [1, 2, 3])),
  )
  @test all(map(s -> abs(s - 1) <= 1, X₀[1, :, :])) &&
        all(map(s -> abs(s - 2) <= 1, X₀[2, :, :])) &&
        all(map(s -> abs(s - 3) <= 1, X₀[3, :, :]))

  X₀ = ConsensusBasedX.initialise_particles_uniform(
    merge(config, (; initial_guess = [1, 2, 3], initial_radius = 0.1)),
  )
  @test all(map(s -> abs(s - 1) <= 0.1, X₀[1, :, :])) &&
        all(map(s -> abs(s - 2) <= 0.1, X₀[2, :, :])) &&
        all(map(s -> abs(s - 3) <= 0.1, X₀[3, :, :]))

  X₀ = ConsensusBasedX.initialise_particles_uniform(
    merge(
      config,
      (; initial_guess = [1, 2, 3], initial_radius = [0.1, 0.2, 0.3]),
    ),
  )
  @test all(map(s -> abs(s - 1) <= 0.1, X₀[1, :, :])) &&
        all(map(s -> abs(s - 2) <= 0.2, X₀[2, :, :])) &&
        all(map(s -> abs(s - 3) <= 0.3, X₀[3, :, :]))

  X₀ = ConsensusBasedX.initialise_particles_uniform(config, 5, 0.1)
  @test all(map(s -> abs(s - 5) <= 0.1, X₀))

  X₀ = ConsensusBasedX.initialise_particles_uniform(
    config,
    [1, 2, 3],
    [0.1, 0.2, 0.3],
  )
  @test all(map(s -> abs(s - 1) <= 0.1, X₀[1, :, :])) &&
        all(map(s -> abs(s - 2) <= 0.2, X₀[2, :, :])) &&
        all(map(s -> abs(s - 3) <= 0.3, X₀[3, :, :]))

  @test_throws ArgumentError ConsensusBasedX.initialise_particles_uniform(
    merge(config, (; initial_mean = "test")),
  )

  @test_throws ArgumentError ConsensusBasedX.initialise_particles_uniform(
    merge(config, (; initial_mean = rand(4))),
  )

  @test_throws ArgumentError ConsensusBasedX.initialise_particles_uniform(
    merge(config, (; initial_radius = "test")),
  )

  @test_throws ArgumentError ConsensusBasedX.initialise_particles_uniform(
    merge(config, (; initial_radius = rand(4))),
  )

  X₀ = ConsensusBasedX.initialise_particles_normal((merge(
    config,
    (; initial_variance = 0),
  )))
  @test all(map(s -> s == 0, X₀))

  X₀ = ConsensusBasedX.initialise_particles_normal((merge(
    config,
    (; initial_guess = 3, initial_variance = 0),
  )))
  @test all(map(s -> s == 3, X₀))

  X₀ = ConsensusBasedX.initialise_particles_normal((merge(
    config,
    (; initial_mean = [1, 2, 3], initial_variance = 0),
  )))
  @test all(map(s -> s == 1, X₀[1, :, :])) &&
        all(map(s -> s == 2, X₀[2, :, :])) &&
        all(map(s -> s == 3, X₀[3, :, :]))

  X₀ = ConsensusBasedX.initialise_particles_normal((merge(
    config,
    (; initial_mean = [1, 2, 3], initial_variance = [1, 0, 0]),
  )))
  @test (X₀[1, 1, 1] != X₀[1, 2, 1]) &&
        all(map(s -> s == 2, X₀[2, :, :])) &&
        all(map(s -> s == 3, X₀[3, :, :]))

  @test_throws ArgumentError ConsensusBasedX.initialise_particles_normal(
    merge(config, (; initial_mean = "test")),
  )

  @test_throws ArgumentError ConsensusBasedX.initialise_particles_normal(
    merge(config, (; initial_mean = rand(4))),
  )

  @test_throws ArgumentError ConsensusBasedX.initialise_particles_normal(
    merge(config, (; initial_variance = "test")),
  )

  @test_throws ArgumentError ConsensusBasedX.initialise_particles_normal(
    merge(config, (; initial_variance = rand(4))),
  )

  @test_throws ArgumentError ConsensusBasedX.initialise_particles_normal(
    merge(config, (; initial_variance = rand(4, 4))),
  )
end

tests()

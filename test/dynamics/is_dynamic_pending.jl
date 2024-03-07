using ConsensusBasedX, ConsensusBasedX.ConsensusBasedXLowLevel, Test

function get_objects()
  config = parse_config((; D = 2,))
  f(x) = ConsensusBasedX.Ackley(x, shift = 1)
  X₀ = reshape(initialise_particles(config), config.mode)
  correction = HeavisideCorrection()
  method = construct_CBO(config, f, correction, config.noise)
  particle_dynamic = construct_particle_dynamic(config, method)
  particle_dynamic_cache =
    construct_particle_dynamic_cache(config, X₀, particle_dynamic)
  initialise_particle_dynamic_cache!(
    X₀,
    particle_dynamic,
    particle_dynamic_cache,
  )
  initialise_dynamic!(particle_dynamic, particle_dynamic_cache)
  return particle_dynamic, particle_dynamic_cache
end

function tests()
  m = 1

  particle_dynamic, particle_dynamic_cache = get_objects()
  @test is_dynamic_pending(particle_dynamic, particle_dynamic_cache, m)[1]

  particle_dynamic, particle_dynamic_cache = get_objects()
  particle_dynamic_cache.iteration[m] =
    particle_dynamic_cache.max_iterations - 1
  @test is_dynamic_pending(particle_dynamic, particle_dynamic_cache, m)[1]
  particle_dynamic_cache.iteration[m] = particle_dynamic_cache.max_iterations
  pending, label =
    is_dynamic_pending(particle_dynamic, particle_dynamic_cache, m)
  @test !pending
  @test label == "max_iterations"

  particle_dynamic, particle_dynamic_cache = get_objects()
  particle_dynamic_cache.max_time = 1.0
  particle_dynamic_cache.iteration[m] =
    ceil(Int, particle_dynamic_cache.max_time / particle_dynamic.Δt) - 1
  @test is_dynamic_pending(particle_dynamic, particle_dynamic_cache, m)[1]
  particle_dynamic_cache.iteration[m] =
    ceil(Int, particle_dynamic_cache.max_time / particle_dynamic.Δt)
  pending, label =
    is_dynamic_pending(particle_dynamic, particle_dynamic_cache, m)
  @test !pending
  @test label == "max_time"
end

tests()

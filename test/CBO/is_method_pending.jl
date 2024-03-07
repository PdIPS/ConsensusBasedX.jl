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
  method_cache = particle_dynamic_cache.method_cache
  return method, method_cache, particle_dynamic, particle_dynamic_cache
end

function tests()
  m = 1

  method, method_cache, particle_dynamic, particle_dynamic_cache = get_objects()
  method_cache.energy_threshold = eps()
  method_cache.consensus_energy[m] = 2 * eps()
  @test is_dynamic_pending(particle_dynamic, particle_dynamic_cache, m)[1]
  method_cache.consensus_energy[m] = 0
  pending, label =
    is_dynamic_pending(particle_dynamic, particle_dynamic_cache, m)
  @test !pending
  @test label == "energy_threshold"

  method, method_cache, particle_dynamic, particle_dynamic_cache = get_objects()
  method_cache.energy_tolerance = 1e-8
  method_cache.consensus_energy[m] = 0
  method_cache.consensus_energy_previous[m] = 1e-7
  @test is_dynamic_pending(particle_dynamic, particle_dynamic_cache, m)[1]
  method_cache.consensus_energy_previous[m] = 1e-9
  pending, label =
    is_dynamic_pending(particle_dynamic, particle_dynamic_cache, m)
  @test !pending
  @test label == "energy_tolerance"

  method, method_cache, particle_dynamic, particle_dynamic_cache = get_objects()
  method_cache.max_evaluations = 10
  method_cache.evaluations[m] = 9
  @test is_dynamic_pending(particle_dynamic, particle_dynamic_cache, m)[1]
  method_cache.evaluations[m] = 10
  pending, label =
    is_dynamic_pending(particle_dynamic, particle_dynamic_cache, m)
  @test !pending
  @test label == "max_evaluations"
end

tests()

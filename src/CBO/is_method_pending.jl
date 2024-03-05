function is_method_pending(
  method::ConsensusBasedOptimisation,
  method_cache::ConsensusBasedOptimisationCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  pending_energy_threshold = is_method_pending_energy_threshold(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )

  pending_energy_tolerance = is_method_pending_energy_tolerance(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )

  pending_max_evaluations = is_method_pending_max_evaluations(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )

  pending =
    pending_energy_threshold &&
    pending_energy_tolerance &&
    pending_max_evaluations
  return pending
end

function is_method_pending_energy_threshold(
  method::ConsensusBasedOptimisation,
  method_cache::ConsensusBasedOptimisationCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  @expand method_cache consensus_energy energy_threshold
  return consensus_energy[m] > energy_threshold
end

function is_method_pending_energy_tolerance(
  method::ConsensusBasedOptimisation,
  method_cache::ConsensusBasedOptimisationCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  @expand method_cache consensus_energy consensus_energy_previous energy_tolerance
  return abs(consensus_energy_previous[m] - consensus_energy[m]) >
         energy_tolerance
end

function is_method_pending_max_evaluations(
  method::ConsensusBasedOptimisation,
  method_cache::ConsensusBasedOptimisationCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  @expand method_cache evaluations max_evaluations
  return evaluations[m] < max_evaluations
end

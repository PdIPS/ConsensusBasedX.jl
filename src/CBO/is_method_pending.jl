function is_method_pending(
  method::CBXMethod,
  method_cache::CBXMethodCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  if !is_method_pending_energy_threshold(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )
    return false, "energy_threshold"
  end

  if !is_method_pending_energy_tolerance(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )
    return false, "energy_tolerance"
  end

  if !is_method_pending_max_evaluations(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )
    return false, "max_evaluations"
  end

  return true, "method_pending"
end

function is_method_pending_energy_threshold(
  method::CBXMethod,
  method_cache::CBXMethodCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  @expand method_cache consensus_energy energy_threshold
  return consensus_energy[m] > energy_threshold
end

function is_method_pending_energy_tolerance(
  method::CBXMethod,
  method_cache::CBXMethodCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  @expand method_cache consensus_energy consensus_energy_previous energy_tolerance
  return abs(consensus_energy_previous[m] - consensus_energy[m]) >
         energy_tolerance
end

function is_method_pending_max_evaluations(
  method::CBXMethod,
  method_cache::CBXMethodCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  @expand method_cache evaluations max_evaluations
  return evaluations[m] < max_evaluations
end

function is_dynamic_pending(
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  pending_max_iterations = is_dynamic_pending_max_iterations(
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )

  pending_max_time =
    is_dynamic_pending_max_time(particle_dynamic, particle_dynamic_cache, m)

  pending_method = is_method_pending(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )

  pending = pending_max_iterations && pending_max_time && pending_method
  return pending
end

function is_dynamic_pending_max_iterations(
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  @expand particle_dynamic_cache iteration max_iterations
  return iteration[m] < max_iterations
end

function is_dynamic_pending_max_time(
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  @expand particle_dynamic Δt
  @expand particle_dynamic_cache iteration max_time
  return iteration[m] * Δt <= max_time
end

function is_method_pending(
  method::ConsensusBasedXMethod,
  method_cache::ConsensusBasedXMethodCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  return true
end

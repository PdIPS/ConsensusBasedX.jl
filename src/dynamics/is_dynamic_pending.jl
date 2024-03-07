function is_dynamic_pending(
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  if !is_dynamic_pending_max_iterations(
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )
    return false, "max_iterations"
  end

  if !is_dynamic_pending_max_time(particle_dynamic, particle_dynamic_cache, m)
    return false, "max_time"
  end

  return is_method_pending(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )
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
  return iteration[m] * Δt < max_time
end

function is_method_pending(
  method::CBXMethod,
  method_cache::CBXMethodCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  return true, "method_pending"
end

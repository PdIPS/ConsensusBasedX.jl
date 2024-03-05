@config function wrapped_benchmark_dynamic!(
  X₀::AbstractArray,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  @verb " • Running on benchmark mode"
  initialise_particle_dynamic_cache!(
    X₀,
    particle_dynamic,
    particle_dynamic_cache,
  )
  initialise_dynamic!(particle_dynamic, particle_dynamic_cache)
  out = benchmark_dynamic!(particle_dynamic, particle_dynamic_cache)
  return out
end

function benchmark_dynamic!(
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  compute_dynamic_step!(particle_dynamic, particle_dynamic_cache, 1)
  @time compute_dynamic_step!(particle_dynamic, particle_dynamic_cache, 1)
  return @timed compute_dynamic_step!(
    particle_dynamic,
    particle_dynamic_cache,
    1,
  )
end

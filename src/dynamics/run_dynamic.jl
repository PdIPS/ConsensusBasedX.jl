@config function wrapped_run_dynamic!(
  X₀::AbstractArray,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  @verb " • Calculating dynamic"

  if (haskey(config, :benchmark) && config.benchmark)
    return wrapped_benchmark_dynamic!(
      config,
      X₀,
      particle_dynamic,
      particle_dynamic_cache,
    )
  end

  run_dynamic!(X₀, particle_dynamic, particle_dynamic_cache)
  @verb " • Done!"

  out = wrap_output(X₀, particle_dynamic, particle_dynamic_cache)
  if (haskey(config, :extended_output) && config.extended_output)
    return out
  end
  return out.minimiser
end

function run_dynamic!(
  X₀::AbstractArray,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  initialise_particle_dynamic_cache!(
    X₀,
    particle_dynamic,
    particle_dynamic_cache,
  )
  initialise_dynamic!(particle_dynamic, particle_dynamic_cache)
  compute_dynamic!(particle_dynamic, particle_dynamic_cache)
  finalise_dynamic!(particle_dynamic, particle_dynamic_cache)
  return nothing
end

function initialise_dynamic!(
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  initialise_method!(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
  )
  return nothing
end

function compute_dynamic!(
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache{<:Modes, <:Parallelisations},
)
  for m ∈ 1:(particle_dynamic_cache.M)
    compute_dynamic!(particle_dynamic, particle_dynamic_cache, m)
  end
  return nothing
end

function compute_dynamic!(
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache{
    <:Modes,
    <:TEnsembleParallelisation,
  },
)
  Threads.@threads for m ∈ 1:(particle_dynamic_cache.M)
    compute_dynamic!(particle_dynamic, particle_dynamic_cache, m)
  end
  return nothing
end

function compute_dynamic!(
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  while is_dynamic_pending(particle_dynamic, particle_dynamic_cache, m)[1]
    compute_dynamic_step!(particle_dynamic, particle_dynamic_cache, m)
  end
  return nothing
end

function compute_dynamic_step!(
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  particle_dynamic_cache.iteration[m] += 1
  prepare_method_step!(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )
  compute_method_step!(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )
  update_dynamic!(particle_dynamic, particle_dynamic_cache, m)
  finalise_method_step!(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
    m,
  )
  return nothing
end

function prepare_method_step!(
  method::CBXMethod,
  method_cache::CBXMethodCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  return nothing
end

function update_dynamic!(
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  deep_add!(particle_dynamic_cache.X[m], particle_dynamic_cache.dX[m])
  return nothing
end

function finalise_dynamic!(
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  finalise_method!(
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
  )
  return nothing
end

function finalise_method!(
  method::CBXMethod,
  method_cache::CBXMethodCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  return nothing
end

function wrap_output(
  X₀::AbstractArray,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
)
  return wrap_output(
    X₀,
    particle_dynamic.method,
    particle_dynamic_cache.method_cache,
    particle_dynamic,
    particle_dynamic_cache,
  )
end

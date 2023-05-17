abstract type Scheduler end

const DEFAULT_SCHEDULER_CONFIG = (; α = 1.0, α_max = 1e5);

mutable struct ExponentialScheduler <: Scheduler
  α::Float64
  α_max::Float64
  rate::Float64
  factor::Float64
end
export ExponentialScheduler;

function ExponentialScheduler(; rate = 1.0, α, α_max, Δt, args...)
  factor = exp(rate * Δt)
  return ExponentialScheduler(α, α_max, rate, factor)
end
@splat_conf ExponentialScheduler DEFAULT_SCHEDULER_CONFIG

function update_scheduler!(scheduler::ExponentialScheduler)
  scheduler.α = min(scheduler.α * scheduler.factor, scheduler.α_max)
  return nothing
end

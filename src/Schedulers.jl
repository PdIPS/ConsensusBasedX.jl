const DEFAULT_SCHEDULER_CONFIG = (scheduler = []);

struct Scheduler{T}
  actions::T
end
export Scheduler;

@config DEFAULT_SCHEDULER_CONFIG function Scheduler(; scheduler)
  actions = map(s -> SchedulerAction(s), scheduler)
  return Scheduler(actions)
end

SchedulerAction(action) = ACTION_DICT[action.action](action)

function update_scheduler!(method::ParticleDynamic)
  for action ∈ method.scheduler.actions
    update_scheduler!(method, action)
  end
  return nothing
end
export update_scheduler!

struct MultiplySchedulerAction <: AbstractSchedulerAction
  field::Symbol
  factor::Float64
  min::Float64
  max::Float64
end
@config function MultiplySchedulerAction(;
  field::Symbol,
  factor::Float64 = 1.0,
  min::Float64 = -Inf,
  max::Float64 = Inf,
)
  return MultiplySchedulerAction(field, factor, min, max)
end
export MultiplySchedulerAction;

function update_scheduler!(
  method::ParticleDynamic,
  action::MultiplySchedulerAction,
)
  val = getfield(method, action.field)
  new_val = clamp(val * action.factor, action.min, action.max)
  return setfield!(method, action.field, new_val)
end

const ACTION_DICT = Dict(:multiply => MultiplySchedulerAction);

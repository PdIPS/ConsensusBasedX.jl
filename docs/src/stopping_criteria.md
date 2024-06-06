# Stopping criteria

You can apply any of these criteria by passing them as keywords to the `minimise` routine.


## Energy threshold

`energy_threshold::Real = -Inf` sets a stopping threshold for the value of `f(v)`, where `v` is the current consensus point. For each ensemble, if `f(v) < energy_threshold`, the minimisation stops.

{{basic_usage/energy_threshold.jl}}


## Energy tolerance

`energy_tolerance::Real = 1e-8` dictates a tolerance for the change in `f(v)`, where `v` is the current consensus point. For each ensemble, if `abs(f(v) - f(v_prev)) < energy_tolerance`, where `v_prev` is the previous consensus point, the minimisation stops.

{{basic_usage/energy_tolerance.jl}}


## Max evaluations

`max_evaluations::Real = Inf` determines the maximum number of times `f` may be evaluated by the minimisation. If the value is exceeded, the minimisation stops.

{{basic_usage/max_evaluations.jl}}


## Max iterations

`max_iterations::Real = 1000` specifies the maximal number of iterations that the time integrator can perform. If the number is reached, the minimisation stops.

{{basic_usage/max_iterations.jl}}


## Max time

`max_time::Real = Inf` determines the maximal simulation time. If the number of iterations times `Δt` surpasses this value, the minimisation stops. 

{{basic_usage/max_time.jl}}

const DEFAULT_CBO_CONFIG = (;
  λ = 1.0,
  σ = 1.0,
  ε = 1e-3,
  correction = :Heaviside_reg,
  energy_tol = 1e-5,
  diff_tol = 1e-5,
);

mutable struct CBO{Tf, TH} <: Method
  d::Int
  N::Int

  f::Tf
  f_min::Float64
  t::Float64
  T::Float64
  Δt::Float64

  x::Matrix{Float64}
  x_old::Matrix{Float64}
  x_difference::Float64
  dW::Matrix{Float64}
  update::Matrix{Float64}

  energy::Vector{Float64}
  mean::Vector{Float64}
  mean_difference::Matrix{Float64}
  mean_energy::Float64

  energy_tol::Float64
  diff_tol::Float64

  λ::Float64
  σ::Float64

  H::TH

  noise::Noise
  scheduler::Scheduler
end
export CBO;

function CBO(
  f,
  x,
  noise,
  scheduler;
  d,
  N,
  T,
  Δt,
  energy_tol,
  diff_tol,
  λ,
  σ,
  ε,
  correction,
  args...,
)
  if correction == :Heaviside ||
     correction == :Heaviside_reg ||
     correction == :identity
    val = Val(correction)
  else
    throw(
      ArgumentError(
        "The specified correction function is nor valid. Please use a :Heaviside, :Heaviside_reg, or :identity.",
      ),
    )
  end
  H(s::Real) = CBO_H(val, s, ε)

  f_min = Inf
  t = 0.0
  x_old = copy(x)
  x_difference = Inf
  dW = zeros(d, N)
  update = zeros(d, N)

  energy = zeros(N)
  mean = zeros(d)
  mean_difference = zeros(d, N)
  mean_energy = Inf

  return CBO(
    d,
    N,
    f,
    f_min,
    t,
    1.0 * T,
    1.0 * Δt,
    x,
    x_old,
    x_difference,
    dW,
    update,
    energy,
    mean,
    mean_difference,
    mean_energy,
    energy_tol,
    diff_tol,
    1.0 * λ,
    1.0 * σ,
    H,
    noise,
    scheduler,
  )
end
@splat_conf CBO DEFAULT_CBO_CONFIG f x noise scheduler

CBO_H(v::Val{:Heaviside}, s, ε) = Heaviside(s);
CBO_H(v::Val{:Heaviside_reg}, s, ε) = Heaviside_reg(s, ε);
CBO_H(v::Val{:identity}, s, ε) = s;

function step!(method::CBO)
  ###TODO: batches
  update_mean!(method)
  copyto!(method.x_old, method.x)
  method.noise(method)

  @. method.update =
    method.λ *
    method.mean_difference *
    method.H(method.energy - method.mean_energy)' + method.σ * method.dW
  @. method.x += method.update
  method.x_difference = LinearAlgebra.norm(method.update)
  method.f_min = minimum(method.energy)

  update_scheduler!(method.scheduler)
  method.t += method.Δt
  return nothing
end

function update_mean!(method::CBO)
  @. method.mean = 0
  total_weight = 0

  for p in 1:(method.N)
    x_p = view(method.x, :, p)
    energy = method.f(x_p)
    method.energy[p] = energy
    weight = exp(-method.scheduler.α * energy)
    @. method.mean += weight * x_p
    total_weight += weight
  end

  @. method.mean /= total_weight
  method.mean_energy = method.f(method.mean)

  @. method.mean_difference = method.mean - method.x
  return nothing
end

function terminate(method::CBO)
  for check in [check_max_time, check_energy, check_update_diff, check_max_eval]
    if check(method)
      println("Returning on check: $check")
      return true
    end
  end
  return false
end

check_max_time(method::CBO) = method.t > method.T;

check_energy(method::CBO) = method.f_min < method.energy_tol;

check_update_diff(method::CBO) = method.x_difference < method.diff_tol;

###TODO: max evals
check_max_eval(method::CBO) = false;

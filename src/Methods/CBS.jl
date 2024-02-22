# Todo:
# - Add scheduler based on ESS
# - Refactor with CBO
# - Add termination criterion?

const DEFAULT_CBS_CONFIG = (;
  Δt = 0.1,
  α = 1.0,
  λ = 1.0,
  track_step = 1,
  track_list = Symbol[],
  energy_tol = -Inf,
  diff_tol = 0.0,
  max_eval = 1_000_000_000_000_000,
  max_it = 1_000_000_000_000_000,
  max_x_thresh = Inf,
  mode = :sampling
);

mutable struct CBS{T, S} <: ParticleDynamic{T, S}
  D::Int
  N::Int
  M::Int

  f::Objective
  x::Array{Float64, 3}
  x_old::Array{Float64, 3}

  t::Float64
  Δt::Float64
  sqrt_Δt::Float64
  it::Int

  α::Float64
  λ::Float64

  consensus::Matrix{Float64}

  update_diff::Vector{Float64}

  energy::Matrix{Float64}
  exponents::Matrix{Float64}
  logsums::Matrix{Float64}
  consensus_energy::Vector{Float64}
  best_cur_energy::Vector{Float64}
  best_energy::Vector{Float64}

  f_min::Vector{Float64}
  f_min_idx::Vector{Int}
  num_f_eval::Int

  best_cur_particle::Matrix{Float64}
  best_particle::Matrix{Float64}

  track_step::Int
  track_list::Vector{Symbol}
  track::T
  track_functions::Vector{Function}

  scheduler::S

  energy_tol::Float64
  diff_tol::Float64
  max_eval::Int
  max_it::Int
  max_x_thresh::Float64
end

@config CBS(f) = CBS(config, f, init_particles(config));

@config DEFAULT_CBS_CONFIG function CBS(
  f,
  x;
  Δt::Real,
  α::Real,
  track_step::Int,
  track_list::Vector{Symbol},
  energy_tol::Float64,
  diff_tol::Float64,
  max_eval::Int,
  max_it::Int,
  max_x_thresh::Float64,
  mode::Symbol,
)
  D, N, M = config.D, config.N, config.M

  x = copy(x)
  x_old = copy(x)

  t = 0.0
  sqrt_Δt = sqrt(Δt)
  it = 1

  consensus = zeros(D, M)
  update_diff = fill(Inf, M)

  energy = fill(Inf, N, M)
  exponents = fill(Inf, N, M)
  logsums = fill(Inf, 1, M)
  consensus_energy = fill(Inf, M)
  best_cur_energy = zeros(M)
  best_energy = fill(Inf, M)

  σ = fill(zeros(D, D), M)
  f_min = fill(Inf, M)
  f_min_idx = ones(Int, M)
  num_f_eval = 0

  best_cur_particle = zeros(D, M)
  best_particle = zeros(D, M)

  track_list = [:it, track_list...]
  track, track_functions = init_track(track_list)
  λ = mode === :optim ? 1 : 1/(1 + α)

  scheduler = Scheduler(config)

  return CBS(
    D,
    N,
    M,
    f,
    x,
    x_old,
    t,
    Δt,
    sqrt_Δt,
    it,
    α,
    λ,
    consensus,
    update_diff,
    energy,
    exponents,
    logsums,
    consensus_energy,
    best_cur_energy,
    best_energy,
    f_min,
    f_min_idx,
    num_f_eval,
    best_cur_particle,
    best_particle,
    track_step,
    track_list,
    track,
    track_functions,
    scheduler,
    energy_tol,
    diff_tol,
    max_eval,
    max_it,
    max_x_thresh,
  )
end

export CBS;

function inner_step!(method::CBS)
  D, N, M = method.D, method.N, method.M
  Δt, λ = method.Δt, method.λ

  compute_consensus!(method)
  @threads for m ∈ 1:M
    x = view(method.x, :, :, m)
    energy = view(method.energy, :, m)
    consensus = view(method.consensus,:, m)
    drift = x .- consensus

    # This ensures that the maximum weight is 1 before normalization
    weights = exp.(- method.α .* (energy .- minimum(energy)))
    rt_weights = sqrt.(reshape(weights / sum(weights), 1, N))

    # Use square root of weights to ensure symmetry
    weighted_cov = (rt_weights .* drift)*(rt_weights .* drift)'
    sqrt_cov = real(sqrt(weighted_cov))

    γdrif, γdiff = exp(-Δt), √((1 - exp(-2Δt))/λ)
    x .= consensus .+ γdrif*drift .+ γdiff*sqrt_cov*randn(D, N)
  end
  return nothing
end

function compute_consensus!(method::CBS)
  D, N, M = method.D, method.N, method.M

  apply!(method.f, method.energy, method.x)
  # @show method.energy
  method.num_f_eval += method.N * method.M

  @. method.exponents = -method.α * method.energy
  LogExpFunctions.logsumexp!(method.logsums, method.exponents)

  @threads for m ∈ 1:M
    c = view(method.consensus, :, m)
    X = view(method.x, :, :, m)

    c .= 0.0
    for n ∈ 1:N
      weight = exp(-method.α * method.energy[n, m] - method.logsums[1, m])
      x = view(X, :, n)
      @. c += weight * x
    end
    method.consensus_energy[m] = apply!(method.f, c)
  end

  return nothing
end

# vim: tabstop=2 shiftwidth=2

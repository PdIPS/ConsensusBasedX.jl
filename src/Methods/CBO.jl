const DEFAULT_CBO_CONFIG = (;
  Δt = 0.1,
  α = 1.0,
  λ = 1.0,
  σ = 1.0,
  ε = 1e-3,
  correction = :Heaviside,
  noise = :isotropic,
  track_step = 1,
  track_list = Symbol[],
  energy_tol = -Inf,
  diff_tol = 0.0,
  max_eval = 1_000_000_000_000_000,
  max_it = 1_000_000_000_000_000,
  max_x_thresh = Inf,
);

mutable struct CBO{T, S} <: ParticleDynamic{T, S}
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
  σ::Real
  ε::Real
  correction::Function
  noise::Function

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

@config CBO(f) = CBO(config, f, init_particles(config));

@config DEFAULT_CBO_CONFIG function CBO(
  f,
  x;
  Δt::Real,
  α::Real,
  λ::Real,
  σ::Real,
  ε::Real,
  correction::Symbol,
  noise::Symbol,
  track_step::Int,
  track_list::Vector{Symbol},
  energy_tol::Float64,
  diff_tol::Float64,
  max_eval::Int,
  max_it::Int,
  max_x_thresh::Float64,
)
  D, N, M = config.D, config.N, config.M

  x = copy(x)
  x_old = copy(x)

  t = 0.0
  sqrt_Δt = sqrt(Δt)
  it = 1

  correction_dict = Dict(
    :identity => corr_identity,
    :Heaviside => corr_Heaviside,
    :Heaviside_reg => corr_Heaviside_reg,
  )
  correction_method = correction_dict[correction]

  noise_dict =
    Dict(:isotropic => noise_isotropic, :anisotropic => noise_isotropic)
  noise_method = noise_dict[noise]

  consensus = zeros(D, M)

  update_diff = fill(Inf, M)

  energy = fill(Inf, N, M)
  exponents = fill(Inf, N, M)
  logsums = fill(Inf, 1, M)
  consensus_energy = fill(Inf, M)
  best_cur_energy = zeros(M)
  best_energy = fill(Inf, M)

  f_min = fill(Inf, M)
  f_min_idx = ones(M)
  num_f_eval = 0

  best_cur_particle = zeros(D, M)
  best_particle = zeros(D, M)

  track_list = [:it, track_list...]
  track, track_functions = init_track(track_list)

  scheduler = Scheduler(config)

  return CBO(
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
    σ,
    ε,
    correction_method,
    noise_method,
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

export CBO;

corr_identity(method, scaled_drift::Real, energy_diff::Real) = scaled_drift;
function corr_Heaviside(method, scaled_drift::Real, energy_diff::Real)
  return scaled_drift * (energy_diff > 0)
end;
function corr_Heaviside_reg(method, scaled_drift::Real, energy_diff::Real)
  return scaled_drift * (1 + tanh(energy_diff / method.ε)) / 2
end;

noise_isotropic(model, drift) = model.sqrt_Δt * randn();
noise_anisotropic(model, drift) = model.sqrt_Δt * randn() * drift;

function inner_step!(method::CBO)
  D, N, M = method.D, method.N, method.M

  compute_consensus!(method)
  @threads for m ∈ 1:M
    for n ∈ 1:N
      energy_diff = method.energy[n, m] - method.consensus_energy[m]
      for d ∈ 1:D
        drift = method.x[d, n, m] - method.consensus[d, m]
        scaled_drift = method.Δt * method.λ * drift
        # @show drift
        noise = method.σ * method.noise(method, drift)
        shift = method.correction(method, scaled_drift, energy_diff)
        method.x[d, n, m] += noise - shift
      end
    end
  end

  return nothing
end

function compute_consensus!(method::CBO)
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

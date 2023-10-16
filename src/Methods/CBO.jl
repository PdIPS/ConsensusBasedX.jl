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
);

mutable struct CBO{T} <: CBXDynamic{T}
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
)
  D, N, M = config.D, config.N, config.M

  x = copy(x)
  x_old = copy(x)

  t = 0.0
  sqrt_Δt = sqrt(Δt)
  it = 0

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

  update_diff = [Inf for m in 1:M]

  energy = [Inf for n in 1:N, m in 1:M]
  consensus_energy = [Inf for m in 1:M]
  best_cur_energy = zeros(M)
  best_energy = [Inf for m in 1:M]

  f_min = [Inf for m in 1:M]
  f_min_idx = [1 for m in 1:M]
  num_f_eval = 0

  best_cur_particle = zeros(D, M)
  best_particle = zeros(D, M)

  track, track_functions = init_track(track_list)

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
  )
end

export CBO;

corr_identity(method, s::Real) = s;
corr_Heaviside(method, s::Real) = 1.0 * (s > 0);
corr_Heaviside_reg(method, s::Real) = (1 + tanh(s / method.ε)) / 2;

noise_isotropic(model, drift) = model.sqrt_Δt * randn()
noise_anisotropic(model, drift) = model.sqrt_Δt * randn() * drift

function inner_step!(method::CBO)
  D, N, M = method.D, method.N, method.M

  compute_consensus!(method)
  @threads for m in 1:M
    for n in 1:N
      mul =
        -method.Δt *
        method.λ *
        method.correction(
          method,
          method.energy[n, m] - method.consensus_energy[m],
        )
      for d in 1:D
        drift = method.x[d, n, m] - method.consensus[d, m]
        method.x[d, n, m] += mul * drift + method.noise(method, drift)
      end
    end
  end

  return nothing
end

function compute_consensus!(method::CBO)
  D, N, M = method.D, method.N, method.M

  apply!(method.f, method.energy, method.x)
  method.num_f_eval += method.N * method.M

  @threads for m in 1:M
    c = view(method.consensus, :, m)
    X = view(method.x, :, :, m)

    c .= 0.0
    weight_sum = 0.0
    for n in 1:N
      weight = exp(-method.α * method.energy[n, m])
      weight_sum += weight
      x = view(X, :, n)
      @. c += weight * x
    end
    c ./= weight_sum

    method.consensus_energy[m] = apply!(method.f, c)
  end

  return nothing
end

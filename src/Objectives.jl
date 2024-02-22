function apply!(
  obj::Objective,
  Y::AbstractArray{Float64, 2},
  X::AbstractArray{Float64, 3},
)
  D, N, M = size(X)
  @threads for m ∈ 1:M
    for n ∈ 1:N
      Y[n, m] = apply!(obj, view(X, :, n, m))
    end
  end
  return Y
end
export apply!

struct Quadratic <: Objective
  α::Float64
end
Quadratic(; α::Real = 1) = Quadratic(α);
export Quadratic;

function apply!(obj::Quadratic, X::AbstractArray{Float64, 1})
  return obj.α * LinearAlgebra.norm_sqr(X) / 2
end

struct Rastrigin <: Objective
  b::Float64
  c::Float64
end
Rastrigin(; b::Real = 0, c::Real = 0) = Rastrigin(b, c);
export Rastrigin;

function apply!(obj::Rastrigin, X::AbstractArray{Float64, 1})
  result = 0.0
  for d ∈ eachindex(X)
    x = X[d] - obj.b
    result += x^2 + 10 * (1 - cos(2π * x))
  end
  return result / length(X) + obj.c
end

struct Ackley <: Objective
  shift::Float64
  dim::Float64
end
Ackley(; shift::Real = 0, dim::Real = 2) = Ackley(shift, dim);
export Ackley;

function apply!(obj::Ackley, X::AbstractVector{Float64})
  result = 0.0
  A = 20 + exp(1)
  Z = X .- obj.shift
  result = 20 + exp(1)
  result += - 20 * exp(-.2*sqrt(1/obj.dim * sum(abs2, Z)))
  result += - exp(1/obj.dim * sum(cos, 2π*Z))
  return result
end

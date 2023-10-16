abstract type Objective end;

function apply!(
  obj::Objective,
  Y::AbstractArray{Float64, 2},
  X::AbstractArray{Float64, 3},
)
  D, N, M = size(X)
  @threads for m in 1:M
    for n in 1:N
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
apply!(obj::Quadratic, X::AbstractArray{Float64, 1}) =
  obj.α * LinearAlgebra.norm_sqr(X) / 2;

struct Rastrigin <: Objective
  b::Float64
  c::Float64
end
Rastrigin(; b::Real = 0, c::Real = 0) = Rastrigin(b, c);
export Rastrigin;

function apply!(obj::Rastrigin, X::AbstractArray{Float64, 1})
  result = 0.0
  for d in eachindex(X)
    x = X[d] - obj.b
    result += x^2 + 10 * (1 - cos(2π * x))
  end
  return result / length(X) + obj.c
end

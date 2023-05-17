abstract type Objective end;

struct Quadratic <: Objective
  α::Float64
end
export Quadratic;
Quadratic(; α = 1) = Quadratic(α);
(f::Quadratic)(x) = f.α * LinearAlgebra.norm_sqr(x);

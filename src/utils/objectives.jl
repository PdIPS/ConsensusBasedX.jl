@doc raw"""
```
Quadratic(x::AbstractVector; shift = 0)
```

A quadratic function in dimension `D = length(x)` with global minimum at the point `` x = (\textrm{shift}, \textrm{shift}, \cdots, \textrm{shift})``:
```math
f(x) =
\frac{1}{D}
\sum_{d=1}^{D} (x_d - \textrm{shift})^2
.
```
"""
function Quadratic(x::AbstractVector{<:Real}; shift::Real = 0)
  D = length(x)
  sum_squares = mapreduce(s -> (s - shift)^2, +, x) / D
  return sum_squares
end

@doc raw"""
```
Ackley(x::AbstractVector; a = 20, b = 0.2, c = 2π, shift = 0)
```

The Ackley function in dimension `D = length(x)` with global minimum at the point `` x = (\textrm{shift}, \textrm{shift}, \cdots, \textrm{shift})``:
```math
f(x) =
a \left[
1 - \exp \left(
-b \sqrt{
\frac{1}{D}
\sum_{d=1}^{D} (x_d - \textrm{shift})^2
}
\right)
\right]
+ \left[
\exp(1)
-
\exp \left(
\frac{1}{D}
\sum_{d=1}^{D} \cos( c (x_d - \textrm{shift}) )
\right)
\right]
.
```

See also the [Wikipedia article](https://en.wikipedia.org/wiki/Ackley_function).
"""
function Ackley(
  x::AbstractVector{<:Real};
  a::Real = 20,
  b::Real = 0.2,
  c::Real = 2π,
  shift::Real = 0,
)
  D = length(x)
  sum_squares = mapreduce(s -> (s - shift)^2, +, x) / D
  sum_cosines = mapreduce(s -> cos(c * (s - shift)), +, x) / D

  first = 1 - exp(-b * sqrt(sum_squares))
  second = ℯ - exp(sum_cosines)

  return a * first + second
end

@doc raw"""
```
Rastrigin(x::AbstractVector; a = 10, c = 2π, shift = 0)
```

The Rastrigin function in dimension `D = length(x)` with global minimum at the point `` x = (\textrm{shift}, \textrm{shift}, \cdots, \textrm{shift})``:
```math
f(x) =
\frac{1}{D}
\sum_{d=1}^{D} (x_d - \textrm{shift})^2
+ a \left(
1
-
\frac{1}{D}
\sum_{d=1}^{D} \cos( c (x_d - \textrm{shift}) )
\right)
.
```

See also the [Wikipedia article](https://en.wikipedia.org/wiki/Rastrigin_function).
"""
function Rastrigin(
  x::AbstractVector{<:Real};
  a::Real = 10,
  c::Real = 2π,
  shift::Real = 0,
)
  D = length(x)
  sum_squares = mapreduce(s -> (s - shift)^2, +, x) / D
  sum_cosines = mapreduce(s -> cos(c * (s - shift)), +, x) / D

  first = sum_squares
  second = 1 - sum_cosines

  return first + a * second
end

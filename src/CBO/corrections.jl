struct NoCorrection <: CBXCorrection end
(c::NoCorrection)(s::Real) = 1.0

struct HeavisideCorrection <: CBXCorrection end
(c::HeavisideCorrection)(s::Real) = 1.0 * (s > 0)

struct RegularisedHeavisideCorrection <: CBXCorrection
  ε::Float64
end
(c::RegularisedHeavisideCorrection)(s::Real) = (1 + tanh(s / c.ε)) / 2

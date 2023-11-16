module CBX

using Default
using Reexport
import Distributions

include("./init_particles.jl")

module Objectives
  import Base.Threads.@threads
  import LinearAlgebra
  include("./Objectives.jl")
end
export Objectives

module Methods
  using Default
  import Base.Threads.@threads
  import ..init_particles
  import ..Objectives.Objective, ..Objectives.apply!

  include("./Methods/ParticleDynamic.jl")
  include("./Methods/CBXDynamic.jl")
  include("./Methods/CBO.jl")

  export minimise, minimize
  export step!
end
export Methods
@reexport import CBX.Methods.CBO
@reexport import CBX.Methods.minimise, CBX.Methods.minimize

module LowLevel
  using Reexport
  @reexport using CBX
  @reexport using CBX.Objectives
  @reexport using CBX.Methods
  @reexport import CBX.Methods.terminate
  @reexport import ..init_particles,
    ..initialise_particles, ..initialize_particles

end
export LowLevel

end

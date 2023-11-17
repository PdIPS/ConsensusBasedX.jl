module CBX

using Default, Reexport

import Distributions

module Types

  include("./Types.jl")

end
export Types

include("./init_particles.jl")

module Objectives

  using Reexport
  @reexport using ..Types

  import Base.Threads.@threads
  import LinearAlgebra

  include("./Objectives.jl")

end
export Objectives

module Schedulers

  using Default, Reexport
  @reexport using ..Types

  include("./Schedulers.jl")

end
export Schedulers

module Methods

  using Default, Reexport
  @reexport using ..Types

  import Base.Threads.@threads
  import LogExpFunctions
  import ..init_particles
  import ..Objectives.Objective, ..Objectives.apply!
  import ..Schedulers.Scheduler,
    ..Schedulers.MultiplySchedulerAction, ..Schedulers.update_scheduler!

  include("./Methods/ParticleDynamic.jl")
  include("./Methods/CBO.jl")

  export minimise, minimize
  export step!

end
export Methods
@reexport import CBX.Methods.CBO
@reexport import CBX.Methods.minimise, CBX.Methods.minimize

module Plotting

  using Plots, Reexport
  @reexport using ..Types

  import Plots.plot

  include("./Plotting.jl")
  export plot

end
export Plotting

module LowLevel

  using Reexport
  @reexport using CBX
  @reexport using CBX.Objectives
  @reexport using CBX.Schedulers
  @reexport using CBX.Methods
  @reexport using CBX.Plotting
  @reexport import CBX.Methods.terminate
  @reexport import ..init_particles,
    ..initialise_particles, ..initialize_particles

end
export LowLevel

end

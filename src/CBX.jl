module CBX

import Distributions

include("./defaults.jl")
include("./macros.jl")
include("./config.jl")
include("./functions.jl")

include("./init_particles.jl")

module Noises
import Distributions
import LinearAlgebra
import ..@splat_conf, ..@parsing_routine, ..parse_args
include("./Noises.jl")
end
export Noises

module Schedulers
import ..@splat_conf, ..@parsing_routine, ..parse_args
include("./Scheduler.jl")
end
export Schedulers

module Methods
import LinearAlgebra
import ..Noises.Noise
import ..Schedulers.Scheduler, ..Schedulers.update_scheduler!
import ..Heaviside, ..Heaviside_reg
import ..@splat_conf, ..@parsing_routine, ..parse_args
include("./Methods/Method.jl")
include("./Methods/CBO.jl")
export step!
export terminate
end
export Methods

module Objectives
import LinearAlgebra
include("./Objectives.jl")
end
export Objectives

module LowLevel
using Reexport
@reexport using CBX
@reexport using CBX.Schedulers
@reexport using CBX.Methods
@reexport using CBX.Noises
@reexport using CBX.Objectives
@reexport import ..config, ..configuration
@reexport import ..init_particles,
  ..initialise_particles, ..initialize_particles
end
export LowLevel

end

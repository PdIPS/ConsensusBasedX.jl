const DEFAULT_PARSED_CONFIG = (;
  N = 20,
  M = 1,
  mode = ParticleMode,
  parallelisation = NoParallelisation,
  verbosity = 0,
)

function parse_config(config::NamedTuple)
  check_config_has_D(config)
  config = parse_config_default(config)
  config = parse_config_mode(config)
  config = parse_config_parallelisation(config)
  return config
end

function check_config_has_D(config::NamedTuple)
  if !(haskey(config, :D))
    explanation = "The dimension of the problem **must** be specified. Please provide the keyword `D`."
    throw(ArgumentError(explanation))
  end
  return nothing
end

parse_config_default(config::NamedTuple) = merge(DEFAULT_PARSED_CONFIG, config)

function parse_config_mode(config::NamedTuple)
  if (haskey(config, :mode))
    mode = config.mode
    mode = (mode isa String) ? Symbol(mode) : mode
    mode = (mode isa Symbol) ? Val(mode) : mode
    if mode isa Val
      if !(mode isa Modes)
        explanation = "The selected `mode` is not recognised as an instance of `ConsensusBasedX.Modes`."
        throw(ArgumentError(explanation))
      end
    else
      explanation = "The keyword `mode` should be a `Symbol`, a `String`, or an instance of `ConsensusBasedX.Modes`."
      throw(ArgumentError(explanation))
    end
    return merge(config, (; mode))
  end
  return config
end

function parse_config_parallelisation(config::NamedTuple)
  if (haskey(config, :parallelisation))
    parallelisation = config.parallelisation
    parallelisation =
      (parallelisation isa String) ? Symbol(parallelisation) : parallelisation
    parallelisation =
      (parallelisation isa Symbol) ? Val(parallelisation) : parallelisation
    if parallelisation isa Val
      if !(parallelisation isa Parallelisations)
        explanation = "The selected `parallelisation` is not recognised as an instance of `ConsensusBasedX.Parallelisations`."
        throw(ArgumentError(explanation))
      end
    else
      explanation = "The keyword `parallelisation` should be a `Symbol`, a `String`, or an instance of `ConsensusBasedX.Parallelisations`."
      throw(ArgumentError(explanation))
    end
    return merge(config, (; parallelisation))
  end
  return config
end

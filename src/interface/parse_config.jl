const DEFAULT_PARSED_CONFIG = (;
  N = 20,
  M = 1,
  mode = ParticleMode,
  noise = IsotropicNoise,
  parallelisation = NoParallelisation,
  verbosity = 0,
)

function parse_config(config::NamedTuple)
  check_config_has_D(config)
  config = parse_config_default(config)
  config = parse_config_mode(config)
  config = parse_config_noise(config)
  config = parse_config_root(config)
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

function parse_config_noise(config::NamedTuple)
  if (haskey(config, :noise))
    noise = config.noise
    noise = (noise isa String) ? Symbol(noise) : noise
    noise = (noise isa Symbol) ? Val(noise) : noise
    if noise isa Val
      if !(noise isa Noises)
        explanation = "The selected `noise` is not recognised as an instance of `ConsensusBasedX.Noises`."
        throw(ArgumentError(explanation))
      end
    else
      explanation = "The keyword `noise` should be a `Symbol`, a `String`, or an instance of `ConsensusBasedX.Noises`."
      throw(ArgumentError(explanation))
    end
    return merge(config, (; noise))
  end
  return config
end

function parse_config_root(config::NamedTuple)
  if (haskey(config, :root))
    root = config.root
    root = (root isa String) ? Symbol(root) : root
    root = (root isa Symbol) ? Val(root) : root
    if root isa Val
      if !(root isa Roots)
        explanation = "The selected `root` is not recognised as an instance of `ConsensusBasedX.Roots`."
        throw(ArgumentError(explanation))
      end
    else
      explanation = "The keyword `root` should be a `Symbol`, a `String`, or an instance of `ConsensusBasedX.Roots`."
      throw(ArgumentError(explanation))
    end
    return merge(config, (; root))
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

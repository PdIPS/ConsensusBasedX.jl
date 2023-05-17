@parsing_routine main_config DEFAULT_CONFIG;
const config = main_config_parse_config;
const configuration = config;

function parse_args(args)
  tuple_args = NamedTuple(args)
  parsed_args = parse_labels(tuple_args)
  return parsed_args
end

parse_labels(tuple::NamedTuple) =
  (; (parse_label(s[1]) => s[2] for s in zip(keys(tuple), values(tuple)))...);

parse_label(s::Symbol) = haskey(DEFAULT_NAMES, s) ? DEFAULT_NAMES[s] : s;
parse_label(s::String) = parse_label(Symbol(s));

function get_with_default(
  collection,
  key,
  default::Float64,
  warn = false,
)::Float64
  if hasproperty(collection, key)
    prop = getproperty(collection, key)
    if !isnothing(prop)
      return prop
    end
  end
  if warn
    @warn "Option $key not specified. Resorting to default value $default."
  end
  return default
end

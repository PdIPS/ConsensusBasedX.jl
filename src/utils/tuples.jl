forced_convert_2_NamedTuple(tuple::NamedTuple) = tuple

forced_convert_2_NamedTuple(dict::Dict{Symbol}) = NamedTuple(dict)

function forced_convert_2_NamedTuple(dict::Dict)
  return NamedTuple(map(s -> Symbol(s[1]) => s[2], [dict...]))
end

function forced_convert_2_NamedTuple(other)
  explanation =
    "An argument of type `" *
    string(typeof(other)) *
    "` cannot be converted to a `NamedTuple`."
  throw(ArgumentError(explanation))
end

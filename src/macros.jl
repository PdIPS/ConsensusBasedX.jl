macro parsing_routine(name, default, args...)
  name_parse_config = Symbol(name, :_parse_config)
  name_parsed = Symbol(name, :_parsed)

  return esc(quote
    function $(name_parse_config)(; other...)
      parsed = parse_args(other)
      merged = merge($(default), parsed)
      return merged
    end

    function $(name)(conf::NamedTuple, $(args...))
      parsed = $(name_parse_config)(; conf...)
      return $(name_parsed)(parsed, $(args...))
    end
  end)
end

macro splat_conf(name, default, args...)
  name_parsed = Symbol(name, :_parsed)

  return esc(quote
    @parsing_routine $(name) $(default) $(args...)
    $(name_parsed)(conf, $(args...)) = $(name)($(args...); conf...)
  end)
end

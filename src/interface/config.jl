for routine ∈ (:minimise, :maximise, :sample)
  @eval begin
    function $routine(f; kw...)
      config = NamedTuple(kw)
      return $routine(f, config)
    end

    function $routine(f, config)
      converted_config = forced_convert_2_NamedTuple(config)
      return $routine(f, converted_config)
    end
  end
end

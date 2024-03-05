const ProtoParallelisations = (:NoParallelisation, :EnsembleParallelisation)

for Parallelisation ∈ ProtoParallelisations
  @eval begin
    const $Parallelisation = Val($(Meta.quot(Parallelisation)))
    const $(Symbol(:T, Parallelisation)) = Val{$(Meta.quot(Parallelisation))}
  end
end

@eval begin
  const Parallelisations =
    Union{$(map(s -> Symbol(:T, s), ProtoParallelisations)...)}
end

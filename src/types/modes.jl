const ProtoModes = (:ParticleMode,)

for Mode ∈ ProtoModes
  @eval begin
    const $Mode = Val($(Meta.quot(Mode)))
    const $(Symbol(:T, Mode)) = Val{$(Meta.quot(Mode))}
  end
end

@eval begin
  const Modes = Union{$(map(s -> Symbol(:T, s), ProtoModes)...)}
end

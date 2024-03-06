const ProtoNoises = (:IsotropicNoise, :AnisotropicNoise)

for Noise ∈ ProtoNoises
  @eval begin
    const $Noise = Val($(Meta.quot(Noise)))
    const $(Symbol(:T, Noise)) = Val{$(Meta.quot(Noise))}
  end
end

@eval begin
  const Noises = Union{$(map(s -> Symbol(:T, s), ProtoNoises)...)}
end

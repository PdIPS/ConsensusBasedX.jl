const ProtoRoots = (:SymmetricRoot, :AsymmetricRoot)

for Root ∈ ProtoRoots
  @eval begin
    const $Root = Val($(Meta.quot(Root)))
    const $(Symbol(:T, Root)) = Val{$(Meta.quot(Root))}
  end
end

@eval begin
  const Roots = Union{$(map(s -> Symbol(:T, s), ProtoRoots)...)}
end

function auto_select_root_mode(D::Int, N::Int)
  return (N <= 10 * D) ? AsymmetricRoot : SymmetricRoot
end

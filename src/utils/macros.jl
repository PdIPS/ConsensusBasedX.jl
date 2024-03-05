macro expand(args...)
  cache = args[1]
  keys = args[2:end]
  assignments =
    [Expr(:(=), key, Expr(:., cache, Meta.quot(key))) for key ∈ keys]
  expr = Expr(:block, assignments...)
  return esc(expr)
end

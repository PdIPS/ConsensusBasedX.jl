macro verb(text::String)
  return :(@verb 0 $text)
end

macro verb(level::Int, text::String)
  condition = esc(Expr(:call, :>, :(config.verbosity), level))
  call = Expr(:call, :println, text)
  conditional = esc(Expr(:if, condition, call))
  return conditional
end

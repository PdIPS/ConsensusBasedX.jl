function Base.reshape(x::AbstractArray{<:Number, 3}, mode::TParticleMode)
  D, N, M = size(x)
  return [[x[:, n, m] for n ∈ 1:N] for m ∈ 1:M]
end

function Base.reshape(x::AbstractArray{<:Number, 2}, mode::TParticleMode)
  D, N = size(x)
  return [[x[:, n] for n ∈ 1:N]]
end

Base.reshape(x::AbstractArray{<:AbstractArray}, mode::TParticleMode) = x

function reverse_reshape(
  x::AbstractVector{<:AbstractVector{<:AbstractVector{<:Number}}},
)
  M = length(x)
  N = length(x[1])
  D = length(x[1][1])
  return [x[m][n][d] for d ∈ 1:D, n ∈ 1:N, m ∈ 1:M]
end

function reverse_reshape(x::AbstractVector{<:AbstractMatrix{<:Number}})
  M = length(x)
  D, N = size(x[1])
  return [x[m][d, n] for d ∈ 1:D, n ∈ 1:N, m ∈ 1:M]
end

function deep_add!(
  dest::AbstractArray{<:Any, N},
  src::AbstractArray{<:Any, N},
) where {N}
  for n ∈ eachindex(src)
    deep_add!(dest[n], src[n])
  end
  return nothing
end

function deep_add!(
  dest::AbstractArray{<:Number, N},
  src::AbstractArray{<:Number, N},
) where {N}
  for n ∈ eachindex(src)
    dest[n] += src[n]
  end
  return nothing
end

deep_copyto!(dest, src) = copyto!(dest, src)

function deep_copyto!(
  dest::AbstractArray{<:AbstractArray, N},
  src::AbstractArray{<:AbstractArray, N},
) where {N}
  for n ∈ eachindex(src)
    deep_copyto!(dest[n], src[n])
  end
  return nothing
end

deep_eltype(x) = eltype(x)

deep_eltype(x::AbstractArray{<:AbstractArray}) = deep_eltype(first(x))

function deep_set_zero!(x::AbstractArray)
  for n ∈ eachindex(x)
    x[n] = 0
  end
  return nothing
end

function deep_set_zero!(x::AbstractArray{<:AbstractArray})
  for n ∈ eachindex(x)
    deep_set_zero!(x[n])
  end
  return nothing
end

function deep_zero(x::AbstractArray)
  y = deepcopy(x)
  deep_set_zero!(y)
  return y
end

nested_zeros(type::Type, dim) = zeros(type, dim)

nested_zeros(type::Type, dim::Int, dim2) = [zeros(type, dim2) for k ∈ 1:dim]

function nested_zeros(type::Type, dim::Int, dim2::Int, dim3)
  return [zeros(type, dim2, dim3) for k ∈ 1:dim]
end

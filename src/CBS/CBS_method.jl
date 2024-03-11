function compute_CBS_root_covariance!(
  method::ConsensusBasedSampling{TF, <:TSymmetricRoot},
  method_cache::ConsensusBasedSamplingCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
) where {TF}
  @expand particle_dynamic_cache D N X
  @expand method_cache consensus root_covariance weights

  for d ∈ 1:D, d2 ∈ 1:D
    root_covariance[m][d2, d] = 0
  end

  for n ∈ 1:N
    for d ∈ 1:D, d2 ∈ d:D
      root_covariance[m][d2, d] +=
        weights[m][n] *
        (X[m][n][d] - consensus[m][d]) *
        (X[m][n][d2] - consensus[m][d2])
      root_covariance[m][d, d2] = root_covariance[m][d2, d]
    end
  end

  root_covariance[m] .= real.(sqrt(root_covariance[m]))

  return nothing
end

function compute_CBS_root_covariance!(
  method::ConsensusBasedSampling{TF, <:TAsymmetricRoot},
  method_cache::ConsensusBasedSamplingCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
) where {TF}
  @expand particle_dynamic_cache D N X
  @expand method_cache consensus root_covariance weights

  for n ∈ 1:N
    weight = sqrt(weights[m][n])
    for d ∈ 1:D
      root_covariance[m][d, n] = weight * (X[m][n][d] - consensus[m][d])
    end
  end

  return nothing
end

function compute_CBS_update!(
  method::ConsensusBasedSampling{TF, <:TSymmetricRoot},
  method_cache::ConsensusBasedSamplingCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
) where {TF}
  @expand particle_dynamic_cache D N X dX
  @expand method_cache consensus exp_minus_Δt noise noise_factor root_covariance

  for n ∈ 1:N
    for d ∈ 1:D
      noise[m][d] = noise_factor * randn()
    end
    LinearAlgebra.mul!(dX[m][n], root_covariance[m], noise[m])

    for d ∈ 1:D
      dX[m][n][d] +=
        (exp_minus_Δt - 1) * X[m][n][d] + (1 - exp_minus_Δt) * consensus[m][d]
    end
  end

  return nothing
end

function compute_CBS_update!(
  method::ConsensusBasedSampling{TF, <:TAsymmetricRoot},
  method_cache::ConsensusBasedSamplingCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
) where {TF}
  @expand particle_dynamic_cache D N X dX
  @expand method_cache consensus exp_minus_Δt noise noise_factor root_covariance

  for n ∈ 1:N
    for n2 ∈ 1:N
      noise[m][n2] = noise_factor * randn()
    end
    LinearAlgebra.mul!(dX[m][n], root_covariance[m], noise[m])

    for d ∈ 1:D
      dX[m][n][d] +=
        (exp_minus_Δt - 1) * X[m][n][d] + (1 - exp_minus_Δt) * consensus[m][d]
    end
  end

  return nothing
end

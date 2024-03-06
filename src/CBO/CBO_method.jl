function compute_CBO_consensus!(
  method::ConsensusBasedOptimisation,
  method_cache::ConsensusBasedOptimisationCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
)
  @expand particle_dynamic_cache D N X
  @expand method f α
  @expand method_cache consensus consensus_energy consensus_energy_previous energy evaluations exponents logsums weights

  for d ∈ 1:D
    consensus[m][d] = 0
  end

  for n ∈ 1:N
    energy[m][n] = f(X[m][n])
    exponents[m][n] = -α * energy[m][n]
  end

  logsums[m] = LogExpFunctions.logsumexp(exponents[m])

  for n ∈ 1:N
    weights[m][n] = exp(-α * energy[m][n] - logsums[m])

    for d ∈ 1:D
      consensus[m][d] += weights[m][n] * X[m][n][d]
    end
  end

  consensus_energy_previous[m] = consensus_energy[m]
  consensus_energy[m] = f(consensus[m])

  evaluations[m] += (N + 1)
  return nothing
end

function compute_CBO_update!(
  method::ConsensusBasedOptimisation{TF, TCorrection, <:TIsotropicNoise},
  method_cache::ConsensusBasedOptimisationCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
) where {TF, TCorrection}
  @expand particle_dynamic_cache D N X dX Δt root2Δt
  @expand method correction λ σ
  @expand method_cache consensus consensus_energy distance energy

  for n ∈ 1:N
    distance[m][n] = 0
    for d ∈ 1:D
      distance[m][n] += (consensus[m][d] - X[m][n][d])^2
    end
    distance[m][n] = sqrt(distance[m][n])

    for d ∈ 1:D
      dX[m][n][d] =
        Δt *
        λ *
        (consensus[m][d] - X[m][n][d]) *
        correction(energy[m][n] - consensus_energy[m]) +
        root2Δt * σ * distance[m][n] * randn()
    end
  end
  return nothing
end

function compute_CBO_update!(
  method::ConsensusBasedOptimisation{TF, TCorrection, <:TAnisotropicNoise},
  method_cache::ConsensusBasedOptimisationCache,
  particle_dynamic::ParticleDynamic,
  particle_dynamic_cache::ParticleDynamicCache,
  m::Int,
) where {TF, TCorrection}
  @expand particle_dynamic_cache D N X dX Δt root2Δt
  @expand method correction λ σ
  @expand method_cache consensus consensus_energy energy

  for n ∈ 1:N
    for d ∈ 1:D
      dX[m][n][d] =
        (consensus[m][d] - X[m][n][d]) * (
          Δt * λ * correction(energy[m][n] - consensus_energy[m]) +
          root2Δt * σ * randn()
        )
    end
  end
  return nothing
end

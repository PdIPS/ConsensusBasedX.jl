abstract type ParticleDynamic{T} end;

function step!(method::ParticleDynamic)
  pre_step!(method)
  inner_step!(method)
  post_step!(method)
  return nothing
end

function pre_step!(method::ParticleDynamic)
  copyto!(method.x_old, method.x)
  ###TODO: batching
  return nothing
end

function post_step!(method::ParticleDynamic)
  D, N, M = method.D, method.N, method.M

  @threads for m ∈ 1:M
    method.update_diff[m] = 0.0
    for n ∈ 1:N, d ∈ 1:D
      method.update_diff[m] += (method.x[d, n, m] - method.x_old[d, n, m])^2
    end
    method.update_diff[m] /= N
  end

  update_best_cur_particle!(method)
  update_best_particle!(method)

  return nothing
end

function update_best_cur_particle!(method::ParticleDynamic)
  D, N, M = method.D, method.N, method.M

  @threads for m ∈ 1:M
    method.f_min[m], method.f_min_idx[m] = findmin(view(method.energy, :, m))
    copyto!(
      view(method.best_cur_particle, :, m),
      view(method.x, :, method.f_min_idx[m], m),
    )
    method.best_cur_energy[m] = method.energy[method.f_min_idx[m], m]
  end

  return nothing
end

function update_best_particle!(method::ParticleDynamic)
  D, N, M = method.D, method.N, method.M

  @threads for m ∈ 1:M
    if (method.best_energy[m] > method.best_cur_energy[m])
      method.best_energy[m] = method.best_cur_energy[m]
      copyto!(
        view(method.best_particle, :, m),
        view(method.best_cur_particle, :, m),
      )
    end
  end

  track!(method)
  method.t += method.Δt
  method.it += 1

  ###TODO: resampling

  return nothing
end

function init_track(track_list::Vector{Symbol})
  dict_track = Dict(
    :consensus => Array{Float64, 2}[],
    :energy => Vector{Float64}[],
    :update_norm => Vector{Float64}[],
    :x => Array{Float64, 3}[],
  )

  dict_method = Dict(
    :consensus => track_consensus!,
    :energy => track_energy!,
    :update_norm => track_update_norm!,
    :x => track_x!,
  )

  track = (; (s => dict_track[s] for s ∈ track_list)...)
  track_functions = Function[dict_method[s] for s ∈ track_list]

  return track, track_functions
end

function track!(method::ParticleDynamic)
  if method.it % method.track_step == 0
    for fun ∈ method.track_functions
      fun(method)
    end
  end
  return nothing
end

function track_consensus!(method::ParticleDynamic)
  return push!(method.track.consensus, copy(method.consensus))
end;

function track_energy!(method::ParticleDynamic)
  return push!(method.track.energy, copy(method.best_energy))
end;

function track_update_norm!(method::ParticleDynamic)
  return push!(method.track.update_norm, copy(method.update_diff))
end;

track_x!(method::ParticleDynamic) = push!(method.track.x, copy(method.x));

function terminate(method::ParticleDynamic)
  # def terminate(self, verbosity = 0):
  #         loc_check = np.zeros((self.M,len(self.checks)), dtype=bool)
  #         for i,check in enumerate(self.checks):
  #             loc_check[:,i] = check()

  #         all_check = np.sum(loc_check, axis=1)

  #         for j in range(self.M):
  #             if all_check[j] and not self.all_check[j]:
  #                 self.term_reason[j] = np.where(loc_check[j,:])[0]
  #         self.all_check = all_check

  #         if np.all(self.all_check):
  #             for j in range(self.M):
  #                 if verbosity > 0:
  #                     print('Run ' + str(j) + ' returning on checks: ')
  #                     for k in self.term_reason[j]:
  #                         print(self.checks[k].__name__)
  #             return True
  #         else:
  #             return False
  return true
end

const minimise = nothing;

const minimize = minimise;

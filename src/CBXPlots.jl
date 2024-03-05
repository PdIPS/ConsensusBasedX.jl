module CBXPlots

using Reexport
@reexport using LaTeXStrings, Plots

import ..@expand, ..reverse_reshape

const DEFAULT_PLOT_OPTIONS =
  (; dpi = 150, fontfamily = "Computer Modern", widen = true, yflip = false)

function plot_CBO(out::NamedTuple; keywords...)
  D = out.particle_dynamic_cache.D
  if D == 1
    return plot_CBO_1D(out; keywords...)
  elseif D == 2
    return plot_CBO_2D(out; keywords...)
  end
  explanation = "The `plot_CBO` routine is only defined for problems in 1D or 2D."
  throw(ArgumentError(explanation))
end
export plot_CBO

function plot_CBO_1D(
  out::NamedTuple;
  show_objective = true,
  show_initial_particles = true,
  show_final_particles = true,
  show_ensemble_minimiser = true,
  show_minimiser = true,
  keywords...,
)
  if show_initial_particles
    initial_particles = reverse_reshape(out.initial_particles)
  end
  if show_final_particles
    final_particles = reverse_reshape(out.final_particles)
  end
  ensemble_minimiser = out.ensemble_minimiser
  minimiser = out.minimiser

  @expand out.particle_dynamic_cache D N M
  if show_initial_particles && show_final_particles
    ranges = get_range_by_dimension(initial_particles, final_particles)
  elseif show_initial_particles
    ranges = get_range_by_dimension(initial_particles)
  elseif show_final_particles
    ranges = get_range_by_dimension(final_particles)
  else
    ranges = [(0.9 * minimiser[d] - 1, 1.1 * minimiser[d] + 1) for d ∈ 1:D]
  end

  colours = (M <= 16) ? palette(:default) : palette(:default, M)
  markersize_min = 2
  markersize_max = 8
  markeralpha_min = 0.5
  markeralpha_max = 1
  markersize = markersize_min + (markersize_max - markersize_min) * exp(-N / 10)
  markeralpha =
    markeralpha_min + (markeralpha_max - markeralpha_min) * exp(-N / 10)

  plt =
    plot(xlabel = L"x", ylabel = L"f(x)"; DEFAULT_PLOT_OPTIONS..., keywords...)

  f(x) = out.method.f([x])

  if show_objective
    x_vec = range(ranges[1]..., length = 200)
    plot!(x_vec, f, c = :black, label = L"f(x)", keywords...)
  end

  if show_initial_particles
    for m ∈ 1:M
      scatter!(
        initial_particles[1, :, m],
        f.(initial_particles[1, :, m]),
        c = colours[m],
        markershape = :x,
        label = "";
        markersize,
        markeralpha,
        keywords...,
      )
    end
    scatter!(
      [],
      [],
      label = "Initial particles",
      c = colours[1],
      markershape = :x;
      keywords...,
    )
  end

  if show_final_particles
    for m ∈ 1:M
      scatter!(
        final_particles[1, :, m],
        f.(final_particles[1, :, m]),
        c = colours[m],
        markershape = :o,
        label = "";
        markersize,
        markeralpha,
        keywords...,
      )
    end
    scatter!(
      [],
      [],
      label = "Final particles",
      c = colours[1],
      markershape = :o;
      keywords...,
    )
  end

  if show_ensemble_minimiser
    for m ∈ 1:M
      scatter!(
        [ensemble_minimiser[m][1]],
        [f(ensemble_minimiser[m][1])],
        c = colours[m],
        markershape = :square,
        label = "",
        markersize = 2 * markersize;
        keywords...,
      )
    end
    scatter!(
      [],
      [],
      label = "Ensemble minimiser",
      c = colours[1],
      markershape = :square;
      keywords...,
    )
  end

  if show_minimiser
    scatter!(
      [minimiser[1]],
      [f(minimiser[1])],
      c = :white,
      markershape = :star5,
      label = "",
      markersize = 2 * markersize;
      keywords...,
    )
    scatter!(
      [],
      [],
      label = "Global minimiser",
      c = :white,
      markershape = :star5;
      keywords...,
    )
  end

  return plt
end

function plot_CBO_2D(
  out::NamedTuple;
  show_objective = true,
  show_initial_particles = true,
  show_final_particles = true,
  show_ensemble_minimiser = true,
  show_minimiser = true,
  keywords...,
)
  if show_initial_particles
    initial_particles = reverse_reshape(out.initial_particles)
  end
  if show_final_particles
    final_particles = reverse_reshape(out.final_particles)
  end
  ensemble_minimiser = out.ensemble_minimiser
  minimiser = out.minimiser

  @expand out.particle_dynamic_cache D N M
  if show_initial_particles && show_final_particles
    ranges = get_range_by_dimension(initial_particles, final_particles)
  elseif show_initial_particles
    ranges = get_range_by_dimension(initial_particles)
  elseif show_final_particles
    ranges = get_range_by_dimension(final_particles)
  else
    ranges = [(0.9 * minimiser[d] - 1, 1.1 * minimiser[d] + 1) for d ∈ 1:D]
  end

  colours = (M <= 16) ? palette(:default) : palette(:default, M)
  markersize_min = 2
  markersize_max = 8
  markeralpha_min = 0.5
  markeralpha_max = 1
  markersize = markersize_min + (markersize_max - markersize_min) * exp(-N / 10)
  markeralpha =
    markeralpha_min + (markeralpha_max - markeralpha_min) * exp(-N / 10)

  plt = plot(xlabel = L"x", ylabel = L"y"; DEFAULT_PLOT_OPTIONS..., keywords...)

  if show_objective
    x_vec = range(ranges[1]..., length = 200)
    y_vec = range(ranges[2]..., length = 200)
    heatmap!(
      x_vec,
      y_vec,
      (x, y) -> out.method.f([x, y]),
      c = :nipy_spectral,
      levels = 31,
      colorbar_title = L"f(x,y)";
      keywords...,
    )
  end

  if show_initial_particles
    for m ∈ 1:M
      scatter!(
        initial_particles[1, :, m],
        initial_particles[2, :, m],
        c = colours[m],
        markershape = :x,
        label = "";
        markersize,
        markeralpha,
        keywords...,
      )
    end
    scatter!(
      [],
      [],
      label = "Initial particles",
      c = colours[1],
      markershape = :x;
      keywords...,
    )
  end

  if show_final_particles
    for m ∈ 1:M
      scatter!(
        final_particles[1, :, m],
        final_particles[2, :, m],
        c = colours[m],
        markershape = :o,
        label = "";
        markersize,
        markeralpha,
        keywords...,
      )
    end
    scatter!(
      [],
      [],
      label = "Final particles",
      c = colours[1],
      markershape = :o;
      keywords...,
    )
  end

  if show_ensemble_minimiser
    for m ∈ 1:M
      scatter!(
        [ensemble_minimiser[m][1]],
        [ensemble_minimiser[m][2]],
        c = colours[m],
        markershape = :square,
        label = "",
        markersize = 2 * markersize;
        keywords...,
      )
    end
    scatter!(
      [],
      [],
      label = "Ensemble minimiser",
      c = colours[1],
      markershape = :square;
      keywords...,
    )
  end

  if show_minimiser
    scatter!(
      [minimiser[1]],
      [minimiser[2]],
      c = :white,
      markershape = :star5,
      label = "",
      markersize = 2 * markersize;
      keywords...,
    )
    scatter!(
      [],
      [],
      label = "Global minimiser",
      c = :white,
      markershape = :star5;
      keywords...,
    )
  end

  return plt
end

function get_range_by_dimension(x::AbstractArray, y::AbstractArray)
  range_x = get_range_by_dimension(x)
  range_y = get_range_by_dimension(y)
  range = map(s -> combine_ranges(s[1], s[2]), zip(range_x, range_y))
  return range
end

function get_range_by_dimension(x::AbstractArray{<:Number, 3})
  max = maximum(x, dims = (2, 3))[:]
  min = minimum(x, dims = (2, 3))[:]
  range = map(s -> s, zip(min, max))
  return range
end

function combine_ranges(x::Tuple{<:Real, <:Real}, y::Tuple{<:Real, <:Real})
  range = (min(x[1], y[1]), max(x[2], y[2]))
  return range
end

end

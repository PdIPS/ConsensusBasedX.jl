function plot(method::ParticleDynamic; dims = [1, 2], range = [-3, 3])
  K = length(method.track.it)
  println("\nPlotting evolution...")
  anim = @animate for k ∈ 1:K
    iteration_plot(method, k, dims, range)
  end
  println("\nSaving GIF...")
  return gif(anim, "CBX.gif", fps = 10)
end

function iteration_plot(method, k, dims, range)
  x = method.track.x[k]
  it = method.track.it[k]
  println("Plotting iteration $it")

  dx, dy = dims
  X = x[dx, :, :][:]
  Y = x[dy, :, :][:]

  plot(dpi = 300, size = (700, 700))
  scatter!(X, Y, label = "")
  plot!(title = "Iteration $it", xlabel = "dim = $dx", ylabel = "dim = $dy")
  return plot!(xlims = range, ylims = range, aspect_ratio = :equal)
end

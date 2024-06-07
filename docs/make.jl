push!(LOAD_PATH, "../src/")

using ConsensusBasedX
using Documenter

extension(s) = split(s, ".")[end]
is_md(s) = extension(s) == "md"

const SRC_DIR = joinpath(@__DIR__, "src")
const PARSED_DIR = joinpath(@__DIR__, "parsed")
const EXAMPLE_DIR = joinpath(@__DIR__, "../examples")

rm(PARSED_DIR, force = true, recursive = true)
mkdir(PARSED_DIR)

function parse(source, target)
  touch(target)
  open(target, "w") do file
    for line ∈ readlines(source)
      if first(line, 2) == "{{" && last(line, 2) == "}}"
        example_name = line[3:(end - 2)]
        example = joinpath(EXAMPLE_DIR, example_name)

        println(file, "!!! details \"Full example\"")
        println(file, "\t```julia")
        for src_line ∈ readlines(example)
          print(file, "\t")
          println(file, src_line)
        end
        println(file, "\t```")
      else
        println(file, line)
      end
    end
  end
  return nothing
end

for (root, dirs, files) ∈ walkdir(SRC_DIR)
  for file ∈ files
    if is_md(file)
      source = joinpath(root, file)
      target = replace(source, SRC_DIR => PARSED_DIR)
      mkpath(dirname(target))
      # cp(source, target)
      parse(source, target)
    end
  end
end

DocMeta.setdocmeta!(
  ConsensusBasedX,
  :DocTestSetup,
  :(using ConsensusBasedX);
  recursive = true,
)

makedocs(;
  modules = [ConsensusBasedX],
  authors = "Dr Rafael Bailo",
  repo = "https://github.com/PdIPS/ConsensusBasedX.jl/blob/{commit}{path}#{line}",
  sitename = "ConsensusBasedX.jl",
  format = Documenter.HTML(;
    sidebar_sitename = false,
    prettyurls = get(ENV, "CI", "false") == "true",
    canonical = "https://PdIPS.github.io/ConsensusBasedX.jl",
    edit_link = "main",
    assets = ["assets/favicon.ico"],
    footer = "Copyright © 2024 [Dr Rafael Bailo](https://rafaelbailo.com/) and [Purpose-Driven Interacting Particle Systems Group](https://github.com/PdIPS). [MIT License](https://github.com/PdIPS/ConsensusBasedX.jl/blob/main/LICENSE).",
  ),
  source = "parsed",
  pages = [
    "Home" => "index.md",
    "Mathematical background" => [
      "Consensus-based optimisation" => "consensus-based_optimisation.md"
      "Consensus-based sampling" => "consensus-based_sampling.md"
    ],
    "Basic usage" => [
      "Function minimisation" => "function_minimisation.md"
      "Distribution sampling" => "distribution_sampling.md"
      "Method parameters" => "method_parameters.md"
      "Stopping criteria" => "stopping_criteria.md"
      "Particle initialisation" => "particle_initialisation.md"
      "Example objectives" => "example_objectives.md"
    ],
    "Mid-level usage" => [
      "Noise types" => "noise_types.md"
      "Root-covariance types" => "root-covariance_types.md"
      "Extended output" => "extended_output.md"
      "Output visualisation" => "output_visualisation.md"
      "Performance and benchmarking" => "performance_benchmarking.md"
      "Parallelisation" => "parallelisation.md"
    ],
    "Advanced usage" => [
      "Low-level interface" => "low_level.md"
      "Low-level interface examples" => "low_level_examples.md"
    ],
    "Summary of options" => "summary_options.md",
  ],
)

deploydocs(; repo = "github.com/PdIPS/ConsensusBasedX.jl", devbranch = "main")

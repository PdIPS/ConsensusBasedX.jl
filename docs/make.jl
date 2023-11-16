push!(LOAD_PATH, "../src/")

using CBX
using Documenter

DocMeta.setdocmeta!(CBX, :DocTestSetup, :(using CBX); recursive = true)

makedocs(;
  modules = [CBX],
  authors = "Dr Rafael Bailo",
  repo = "https://github.com/PdIPS/CBX.jl/blob/{commit}{path}#{line}",
  sitename = "CBX.jl",
  format = Documenter.HTML(;
    prettyurls = get(ENV, "CI", "false") == "true",
    canonical = "https://PdIPS.github.io/CBX.jl",
    edit_link = "main",
    assets = String[],
  ),
  pages = ["Home" => "index.md"],
)

deploydocs(; repo = "github.com/PdIPS/CBX.jl", devbranch = "main")

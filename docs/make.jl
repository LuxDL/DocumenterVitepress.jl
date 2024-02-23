using Documenter
using DocumenterVitepress

makedocs(; 
    sitename = "DocumenterVitepress", 
    authors = "LuxDL et al.",
    modules = [DocumenterVitepress],
    warnonly = true,
    checkdocs=:all,
    format=DocumenterVitepress.MarkdownVitepress(
        repo = "github.com/LuxDL/DocumenterVitepress.jl", # this must be the full URL!
        devbranch = "master",
        devurl = "dev",;
    ),
    draft = false,
    source = "src",
    build = joinpath(@__DIR__, "build"),
)


deploydocs(; 
    repo = "github.com/LuxDL/DocumenterVitepress.jl", # this must be the full URL!
    target = "build", # this is where Vitepress stores its output
    branch = "gh-pages",
    devbranch = "master",
    push_preview = true
)
using Documenter
using DocumenterVitepress

makedocs(; sitename="DocumenterVitepress", authors="Avik Pal et al.",
    #clean=true, doctest=true,
    #modules=[DocumenterVitepress],
    checkdocs=:all,
    format=DocumenterVitepress.MarkdownVitepress(),
    draft=false,
    #strict=[:doctest, :linkcheck, :parse_error, :example_block, :missing_docs],
    source="src", build=joinpath(@__DIR__, "docs"))

deploydocs(; repo="github.com/LuxDL/DocumenterVitepress.jl.git", push_preview=true, target="docs",
    devbranch="master")
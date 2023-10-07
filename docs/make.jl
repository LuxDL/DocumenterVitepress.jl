using Documenter
using DocumenterVitepress

makedocs(; sitename="DocumenterVitepress", authors="LuxDL et al.",
    modules=[DocumenterVitepress],
    checkdocs=:all,
    format=DocumenterVitepress.MarkdownVitepress(),
    draft=false,
    source="src", build=joinpath(@__DIR__, "docs"))
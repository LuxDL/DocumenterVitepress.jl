using Documenter
using DocumenterVitepress
using GLMakie

makedocs(; 
    sitename="DocumenterVitepress", 
    authors="LuxDL et al.",
    modules=[DocumenterVitepress],
    warnonly = true,
    checkdocs=:all,
    format=DocumenterVitepress.MarkdownVitepress(),
    draft=false,
    source="src", build=joinpath(@__DIR__, "docs_site")
)

# To edit the sidebar, you must edit `docs/src/.vitepress/config.mts`.
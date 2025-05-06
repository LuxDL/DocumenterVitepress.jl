using Documenter, DocumenterVitepress

makedocs(
    sitename = "DocumenterVitepress Test Site",
    modules = [DocumenterVitepress],
    format = MarkdownVitepress(;
        repo = "https://github.com/JuliaDocs/DocumenterVitepress.jl",
        build_vitepress = false,
    ),
    pages = [
        "Home" => "index.md",
        "API" => "api.md"
    ],
    root = joinpath(@__DIR__, "sites"),
    source = "inventory",
    build = "build_inventory",
    warnonly = true,
)

t = Threads.@spawn DocumenterVitepress.dev_docs(joinpath(@__DIR__, "sites", "build_inventory"))

kill(t)
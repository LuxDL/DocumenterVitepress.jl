"""
    DocumenterVitepress

Similar to DocumentationMarkdown.jl but designed to work with
[vitepress](https://vitepress.dev/).
"""
module DocumenterVitepress

using Documenter: Documenter, Selectors

using DocStringExtensions
using NodeJS_20_jll: npm

const ASSETS = normpath(joinpath(@__DIR__, "..", "assets"))

include("vitepress_config.jl")
include("writer.jl")
include("ANSIBlocks.jl")

export MarkdownVitepress

# Selectors interface in Documenter, for dispatching on different writers
abstract type MarkdownFormat <: Documenter.FormatSelector end

Selectors.order(::Type{MarkdownFormat}) = 0.0
Selectors.matcher(::Type{MarkdownFormat}, fmt, _) = isa(fmt, MarkdownVitepress)
Selectors.runner(::Type{MarkdownFormat}, fmt, doc) = render(doc, fmt)

end

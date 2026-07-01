"""
    BonitoPlugin()

A `Documenter.Plugin` that ships Bonito's JS/CSS bundle through `public/`
once instead of inlining a copy per figure. Requires `using Bonito`.
"""
function BonitoPlugin(args...; kwargs...)
    error(
        "DocumenterVitepress.BonitoPlugin requires Bonito.jl to be loaded. " *
        "Run `using Bonito` (e.g. in your `make.jl`) before constructing it."
    )
end

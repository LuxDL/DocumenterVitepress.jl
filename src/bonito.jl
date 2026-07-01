"""
    BonitoPlugin()

A `Documenter.Plugin` that makes [Bonito](https://github.com/SimonDanisch/Bonito.jl)
output (WGLMakie figures, interactive widgets, …) work well inside a
DocumenterVitepress site. Add it to `makedocs(plugins = [...])`:

```julia
using Documenter, DocumenterVitepress, Bonito
makedocs(;
    format = DocumenterVitepress.MarkdownVitepress(; repo = "github.com/Org/Package.jl"),
    plugins = [DocumenterVitepress.BonitoPlugin()],
)
```

Once added, plain `Bonito.Page()` calls in `@example` blocks (Bonito's own documented
usage — no changes needed there) ship Bonito's JS/CSS bundle into the site's `public/`
folder instead of re-embedding a multi-MB copy inline on every figure. Requires
`using Bonito`; the implementation lives in the `DocumenterVitepressBonitoExt` package
extension and errors here if Bonito has not been loaded.
"""
function BonitoPlugin(args...; kwargs...)
    error(
        "DocumenterVitepress.BonitoPlugin requires Bonito.jl to be loaded. " *
        "Run `using Bonito` (e.g. in your `make.jl`) before constructing it."
    )
end

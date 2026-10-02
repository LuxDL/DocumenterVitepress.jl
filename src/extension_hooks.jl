# Extension hooks for `Documenter.Plugin`s to inject npm deps, Vue components,
# config transforms, and assets into the generated site. Defaults are no-ops;
# `doc.plugins` iterates non-deterministically, so on a key clash the last wins.

"""
    vitepress_dependencies(plugin::Documenter.Plugin) -> Dict{String,String}

npm dependencies to merge into the generated `package.json`, just before
`npm install`. Values are npm specifiers: a version range (`"^1.2.3"`), a local
path (`"file:/abs/path"`), a git URL, etc. Default: empty.
"""
vitepress_dependencies(::Documenter.Plugin) = Dict{String,String}()

"""
    vitepress_components(plugin::Documenter.Plugin) -> Vector{@NamedTuple{name::String, import_path::String}}

Vue components to register globally in `theme/index.ts` via `app.component(name, …)`.
`import_path` is anything Vite can resolve (`"my-pkg/Component.vue"`, a relative
path, etc.); `name` should be a valid JS identifier. Default: empty.
"""
vitepress_components(::Documenter.Plugin) = @NamedTuple{name::String, import_path::String}[]

"""
    vitepress_config_transform(plugin::Documenter.Plugin, config::String) -> String

Transform the `config.mts` source, called once per plugin after DocumenterVitepress's
own substitutions. Default: identity. Edits should key off a stable marker rather
than exact whitespace so they survive template changes.
"""
vitepress_config_transform(::Documenter.Plugin, config::String) = config

"""
    vitepress_assets(plugin::Documenter.Plugin) -> Vector{String}

Absolute directory paths whose *contents* are copied into the Vitepress `public/`
directory (a file lands at `public/<filename>`). Missing paths are warned about
and skipped. Default: empty.
"""
vitepress_assets(::Documenter.Plugin) = String[]

"""
    vitepress_render_codeblock(plugin::Documenter.Plugin, io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, code::Documenter.MarkdownAST.CodeBlock, page, doc; kwargs...) -> Bool

Hook for plugins to intercept rendering of `MarkdownAST.CodeBlock` nodes. Return `true` if handled, `false` to fall back to default rendering.
"""
vitepress_render_codeblock(::Documenter.Plugin, io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, code::Documenter.MarkdownAST.CodeBlock, page, doc; kwargs...) = false

"""
    vitepress_render_multicodeblock(plugin::Documenter.Plugin, io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, mcb::Documenter.MultiCodeBlock, page, doc; kwargs...) -> Bool

Hook for plugins to intercept rendering of `Documenter.MultiCodeBlock` nodes. Return `true` if handled, `false` to fall back to default rendering.
"""
vitepress_render_multicodeblock(::Documenter.Plugin, io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, mcb::Documenter.MultiCodeBlock, page, doc; kwargs...) = false

"""
    vitepress_page_footer(plugin::Documenter.Plugin, io::IO, page, doc; kwargs...)

Hook for plugins to append content (e.g. tooltip payloads) to the end of a page's markdown output.
"""
vitepress_page_footer(::Documenter.Plugin, io::IO, page, doc; kwargs...) = nothing


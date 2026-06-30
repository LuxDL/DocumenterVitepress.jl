# Extension hooks for `Documenter.Plugin` integration.
#
# Third-party Documenter plugins can overload these to inject npm dependencies,
# Vue components, config transforms, and static assets into the generated
# Vitepress site. All defaults are no-ops, so existing plugins are unaffected.
#
# At build time DocumenterVitepress collects the results from every plugin in
# `doc.plugins`. That `Dict` iterates in **non-deterministic** order, so when two
# plugins claim the same key (npm package, component name, asset filename) the
# last one wins — pick distinct keys to avoid colliding.

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

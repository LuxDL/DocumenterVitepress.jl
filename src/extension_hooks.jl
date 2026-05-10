# Extension hooks for `Documenter.Plugin` integration.
#
# Third-party Documenter plugins can overload these to inject npm dependencies,
# Vue components, Vite config transforms, and static assets into the generated
# Vitepress site. All defaults are no-ops, so existing plugins are unaffected.
#
# At build time, DocumenterVitepress walks `doc.plugins` (a `Dict` of every
# `Documenter.Plugin` registered with the `Documenter.Document`) and merges the
# results from each. Iteration order over a `Dict` is **non-deterministic**, so
# if two plugins register the same key (a npm package name, a component name,
# etc.) the winner is implementation-defined; document which key your plugin
# claims and avoid colliding with others.

"""
    vitepress_dependencies(plugin::Documenter.Plugin) -> Dict{String,String}

Return npm dependencies to merge into the generated `package.json`'s
`dependencies`. Values are normal npm specifiers: a version range (`"^1.2.3"`),
a local path (`"file:/abs/path"`), a git URL, etc. Default: empty Dict.

DocumenterVitepress walks every plugin registered with the `Documenter.Document`
and merges the results into `package.json` just before running `npm install`.
Later plugins win on key collisions; iteration order over `doc.plugins` is
non-deterministic, so plugins should not rely on a particular merge order.
"""
vitepress_dependencies(::Documenter.Plugin) = Dict{String,String}()

"""
    vitepress_components(plugin::Documenter.Plugin) -> Vector{@NamedTuple{name::String, import_path::String}}

Return Vue components to globally register in the generated `theme/index.ts` via
`app.component(name, ImportedSymbol)`. `import_path` is anything Vite can resolve
(an npm package path like `"my-pkg/Component.vue"`, a relative path, etc.).
Default: empty.

The generated import uses a synthesized symbol name derived from `name`, so
`name` should be a valid JavaScript identifier. As with `vitepress_dependencies`,
iteration over `doc.plugins` is non-deterministic; if two plugins register a
component under the same `name`, the winner is implementation-defined.
"""
vitepress_components(::Documenter.Plugin) = @NamedTuple{name::String, import_path::String}[]

"""
    vitepress_config_transform(plugin::Documenter.Plugin, config::String) -> String

Transform the `config.mts` source string. Called once per plugin after
DocumenterVitepress's own substitutions have run. Default: identity (returns
`config` unchanged).

Use cases: injecting a Vite plugin entry, extending `vue.template.compilerOptions`,
adding head tags, etc. Plugins should make their edits resilient to small DV
template changes (regex on a stable marker, not on whitespace). Iteration order
over `doc.plugins` is non-deterministic; if two plugins both try to edit the
same region of the config, the result depends on whichever ran last.
"""
vitepress_config_transform(::Documenter.Plugin, config::String) = config

"""
    vitepress_assets(plugin::Documenter.Plugin) -> Vector{String}

Return absolute directory paths whose contents should be copied into the
Vitepress `public/` directory at build time. The directory's *contents* are
copied (not the directory itself), so files end up at `public/<filename>`.
Default: empty.

If a returned path does not exist, DocumenterVitepress logs a warning and
skips it rather than erroring. Iteration order over `doc.plugins` is
non-deterministic; if two plugins ship a file with the same name, the
winner is implementation-defined.
"""
vitepress_assets(::Documenter.Plugin) = String[]

module DocumenterVitepressBonitoExt

using Bonito
import DocumenterVitepress as DV
using Documenter: Documenter

# Page()'s default folder is per-page, relative to the source `.md` — that
# only works for Documenter's HTML writer; we share one folder instead.
struct VitepressAssetFolder <: Bonito.AbstractAssetFolder
    folder::String
end
Base.similar(a::VitepressAssetFolder) = a

const ASSETS_DIR = Ref{Union{Nothing, String}}(nothing)

function assets_dir()
    dir = ASSETS_DIR[]
    if dir === nothing || !isdir(dir)
        dir = mktempdir(; prefix = "dv_bonito_assets_")
        ASSETS_DIR[] = dir
    end
    return dir
end

VitepressAssetFolder() = VitepressAssetFolder(assets_dir())

# Root-relative, not page-relative — `public/` serves from the site root.
# The base isn't known while pages render; the writer prefixes it per build
# (see `vitepress_asset_prefixes` / `rebase_asset_urls!`).
function Bonito.url(a::VitepressAssetFolder, asset::Bonito.Asset)
    isempty(asset.online_path) || return asset.online_path
    path = Bonito.write_to_assetfolder(a, asset)
    rel = replace(relpath(path, a.folder), "\\" => "/")
    return "/" * rel
end

# The `import(new URL(…))` Bonito builds for an ES6 module asset is serialized
# into the session's binary blob, so neither `rebase_asset_urls!` (the blob is
# msgpack, not Markdown) nor the theme's `rebase` (this never goes through
# `Bonito.load_script`) can reach it. Read the base off the page instead; the
# theme sets `__DV_BASE__` before it activates any Bonito script, and the `'/'`
# fallback is the pre-existing root-relative behaviour.
function Bonito.import_js_url(a::VitepressAssetFolder, asset::Bonito.Asset)
    ref = Bonito.url(a, asset)
    # An `online_path` asset resolves against nothing of ours.
    startswith(ref, "/") || return "new URL('$(ref)', window.location.href).href"
    return "new URL((window.__DV_BASE__ || '/') + '$(lstrip(ref, '/'))', window.location.origin).href"
end

struct BonitoAssetsPlugin <: Documenter.Plugin end

function DV.BonitoPlugin()
    # Must run before `@example` blocks eval, so this is a side effect of
    # construction. A page can still opt out via `Page(exportable=true)`.
    Bonito.force_asset_server!(VitepressAssetFolder)
    return BonitoAssetsPlugin()
end

DV.vitepress_assets(::BonitoAssetsPlugin) = [assets_dir()]

# `assets_dir()` holds a single `bonito/` tree, so every URL we emit lives under
# this prefix — that's what the writer rebases per deploy base.
DV.vitepress_asset_prefixes(::BonitoAssetsPlugin) = ["/bonito/"]

const THEME_HELPERS_MARKER = "// __DV_PLUGIN_THEME_HELPERS__"
const THEME_SCRIPT_HOOK_MARKER = "// __DV_PLUGIN_SCRIPT_HOOK__"

# Bonito's own inline bootstrap calls fetch_binary/load_script directly, with
# URLs the theme's generic `rebase()` (on <script src>/<link href>) can't reach.
# A safety net now that `rebase_asset_urls!` bakes the base in at build time:
# `rebase` no-ops on URLs that already carry it, so this can't double-prefix, and
# it still catches anything rendered outside the Markdown the writer rewrites.
# `rebase` lives in index.ts; this is a call-time-only import, so the circular
# reference (index.ts imports runPluginScriptHooks back from here) is fine.
const FETCH_PATCH_JS = """
import { rebase } from './index'

function patchBonitoFetchUrls(): void {
  // Read by the `import(new URL(…))` Bonito serializes into its session blob;
  // `rebase('/')` is the deploy base ('/' when the site is served from the root).
  ;(window as any).__DV_BASE__ = rebase('/')
  const B = (window as any).Bonito
  if (!B || B.__dvRebased) return
  B.__dvRebased = true
  for (const name of ['fetch_binary', 'load_script']) {
    const orig = B[name]
    if (typeof orig === 'function') {
      B[name] = (url: string, ...rest: unknown[]) => orig.call(B, rebase(url), ...rest)
    }
  }
}"""

function DV.vitepress_theme_transform(::BonitoAssetsPlugin, theme::String)
    if !occursin(THEME_HELPERS_MARKER, theme) || !occursin(THEME_SCRIPT_HOOK_MARKER, theme)
        @warn """
            DocumenterVitepress: BonitoPlugin could not patch `window.Bonito`'s asset
            URLs for the deploy base — `theme/plugin-hooks.ts` is missing the
            `$THEME_HELPERS_MARKER` / `$THEME_SCRIPT_HOOK_MARKER` markers. Bonito
            assets may 404 under a non-root base. Add these markers to your custom
            `theme/plugin-hooks.ts` (see the template for where they go).
            """
        return theme
    end
    return replace(
        theme,
        THEME_HELPERS_MARKER => FETCH_PATCH_JS,
        THEME_SCRIPT_HOOK_MARKER => "patchBonitoFetchUrls()",
    )
end

end

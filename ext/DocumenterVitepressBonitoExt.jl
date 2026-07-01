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
# Base isn't known yet (multi-base builds); `withBase()` adds it client-side.
function Bonito.url(a::VitepressAssetFolder, asset::Bonito.Asset)
    isempty(asset.online_path) || return asset.online_path
    path = Bonito.write_to_assetfolder(a, asset)
    rel = replace(relpath(path, a.folder), "\\" => "/")
    return "/" * rel
end

struct BonitoAssetsPlugin <: Documenter.Plugin end

function DV.BonitoPlugin()
    # Must run before `@example` blocks eval, so this is a side effect of
    # construction. A page can still opt out via `Page(exportable=true)`.
    Bonito.force_asset_server!(VitepressAssetFolder)
    return BonitoAssetsPlugin()
end

DV.vitepress_assets(::BonitoAssetsPlugin) = [assets_dir()]

const THEME_HELPERS_MARKER = "// __DV_PLUGIN_THEME_HELPERS__"
const THEME_SCRIPT_HOOK_MARKER = "// __DV_PLUGIN_SCRIPT_HOOK__"

# Bonito's own inline bootstrap calls fetch_binary/load_script directly, with
# URLs the theme's generic `rebase()` (on <script src>/<link href>) can't reach.
const FETCH_PATCH_JS = """
function patchBonitoFetchUrls(): void {
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
            URLs for the deploy base — `theme/index.ts` is missing the
            `$THEME_HELPERS_MARKER` / `$THEME_SCRIPT_HOOK_MARKER` markers. Bonito
            assets may 404 under a non-root base. Add these markers to your custom
            theme (one after `rebase()`, one inside `activateScripts`'s loop).
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

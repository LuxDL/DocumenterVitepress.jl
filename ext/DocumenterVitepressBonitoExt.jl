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

end

module DocumenterVitepressBonitoExt

using Bonito
import DocumenterVitepress as DV
using Documenter: Documenter

# Bonito's own `Page()` (its documented, zero-setup usage) writes every asset it
# serves into a folder next to the *source* `.md` file being evaluated, keyed off
# `pwd()` at `@example`-eval time. That convention exists for Documenter's legacy
# HTML writer, whose build directory mirrors the source tree 1:1, so the file Bonito
# just wrote is already sitting in its final served location. DocumenterVitepress's
# build is not that: markdown is rendered once into an intermediate tree and then fed
# through `vitepress build`, which does not know to carry along an arbitrary extra
# `bonito/` folder dropped next to a source page. So instead of the per-page
# directory, every page here shares one fixed physical folder, registered once via
# `vitepress_assets` and copied into `public/` a single time (see `writer.jl`).
struct VitepressAssetFolder <: Bonito.AbstractAssetFolder
    folder::String
end
Base.similar(a::VitepressAssetFolder) = a

const ASSETS_DIR = Ref{Union{Nothing, String}}(nothing)

function assets_dir()
    dir = ASSETS_DIR[]
    if dir === nothing
        dir = mktempdir(; prefix = "dv_bonito_assets_")
        ASSETS_DIR[] = dir
    end
    return dir
end

VitepressAssetFolder() = VitepressAssetFolder(assets_dir())

# `public/` is served from the site root regardless of which page references it, so
# unlike Bonito's own `AbstractAssetFolder` implementations this returns a root-
# relative URL instead of one relative to the current page. That URL still needs the
# deploy `base` (e.g. `/DocumenterVitepress.jl/`) prepended, which isn't known at
# `@example`-eval time (DocumenterVitepress renders the same markdown once, then runs
# `vitepress build` again per version/preview base — see `writer.jl`). Emitting a
# root-relative path and letting `withBase()` resolve it client-side (in
# `theme/index.ts`) sidesteps needing to know the base this early.
function Bonito.url(a::VitepressAssetFolder, asset::Bonito.Asset)
    isempty(asset.online_path) || return asset.online_path
    path = Bonito.write_to_assetfolder(a, asset)
    rel = replace(relpath(path, a.folder), "\\" => "/")
    return "/" * rel
end

struct BonitoAssetsPlugin <: Documenter.Plugin end

function DV.BonitoPlugin()
    # Must happen before `Documenter.makedocs` evaluates any `@example` block (that's
    # where `Page()` runs), so this is done as a side effect of constructing the
    # plugin rather than in `vitepress_assets` below, which only runs afterwards, once
    # the writer assembles `public/`. `force_asset_server!` takes priority over
    # Bonito's own registry-based default, but a page can still opt back out with an
    # explicit `Page(exportable=true)`.
    Bonito.force_asset_server!(VitepressAssetFolder)
    return BonitoAssetsPlugin()
end

DV.vitepress_assets(::BonitoAssetsPlugin) = [assets_dir()]

end

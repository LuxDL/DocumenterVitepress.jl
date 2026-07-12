"""
    DocumenterVitepress

Similar to DocumentationMarkdown.jl but designed to work with
[vitepress](https://vitepress.dev/).
"""
module DocumenterVitepress

using Documenter: Documenter, Selectors

using DocStringExtensions
using NodeJS_20_jll: node, npm

const ASSETS = normpath(joinpath(@__DIR__, "..", "assets"))

include("vitepress_interface.jl")
include("extension_hooks.jl")
include("bonito.jl")
include("vitepress_config.jl")
include("frontmatter.jl")
include("writer.jl")
include("ANSIBlocks.jl")

export MarkdownVitepress
# `vitepress_*` hooks and `BonitoPlugin` are public but not exported —
# reach them as `DocumenterVitepress.vitepress_dependencies` etc.

# Selectors interface in Documenter, for dispatching on different writers
abstract type MarkdownFormat <: Documenter.FormatSelector end

Selectors.order(::Type{MarkdownFormat}) = 0.0
Selectors.matcher(::Type{MarkdownFormat}, fmt, _) = isa(fmt, MarkdownVitepress)
Selectors.runner(::Type{MarkdownFormat}, fmt, doc) = render(doc, fmt)

"""
    generate_template(target_directory::String, package = "YourPackage")

Copies template files from `DocumenterVitepress.jl` to a target directory, replacing
"YourPackage" with the specified package name in `package`.

`target` should be the directory of your package's documentation, and not its root!

Skips existing files and only updates new ones.

## Arguments
- `target_directory`: Destination for template files.
- `package`: Name to replace "YourPackage" with, defaulting to "YourPackage".

## Example
```julia
generate_template(".julia/dev/MyPackage/docs", "MyPackage")
```
"""
function generate_template(target::String, package = "YourPackage")
    # This is the `template` directory in the source tree of DocumenterVitepress.jl
    template_dir = joinpath(dirname(@__DIR__), "template")
    # Iterate through each file in `template_dir`
    for (root, dirs, files) in walkdir(template_dir)
        # Determine the relative path of the current directory
        path = relpath(root, template_dir)
        # Create a path to the equivalent directory in `target`
        target_path = mkpath(joinpath(target, path))
        # Iterate through each file in this repo!
        for file in files
            # Check if the file already exists in the target directory
            if isfile(joinpath(target, path, file))
                @debug "File $(joinpath(path, file)) already exists!"
                continue
            # If the file does not exist, we have to copy it in!
            else
                contents = read(joinpath(root, file), String)
                new_contents = replace(contents, "YourPackage" => package)
                write(joinpath(target_path, file), new_contents)
            end
        end
    end
end

struct BaseVersion
    base::String
end

function Documenter.determine_deploy_subfolder(deploy_decision, versions::BaseVersion)
    # we never use a subfolder and just set that manually via the `dirname`
    return nothing
end

function Documenter.postprocess_before_push(versions::BaseVersion; subfolder, devurl, deploy_dir, dirname)
    if islink(deploy_dir)
        error("Deploy directory \"$deploy_dir\" is a symbolic link which points to \"$(readlink(deploy_dir))\". This symlink probably exists from previous deployments using Documenter's versioning mechanism. DocumenterVitepress has to write an actual build to \"$(versions.base)\" so you need to remove the symlink manually before trying to deploy again.")
    end
    # deploydocs gets the subfolder as dirname, so to get back to the root (temp folder) we remove the appendix
    root = replace(deploy_dir, Regex("$(versions.base)\$") => "")
    all_version_folders = filter(d -> isdir(joinpath(root, d)) && (d == "stable" || d == devurl || match(r"^v\d", d) !== nothing), readdir(root))
    @info "Found version folders" all_version_folders
    version_number_folders = filter(d -> !(d == "stable" || d == devurl), all_version_folders)
    named_folders = setdiff(all_version_folders, version_number_folders)
    stored_versions = map(version_number_folders) do vfolder
        try
            siteinfo = read(joinpath(root, vfolder, "siteinfo.js"), String)
            vstr = match(r"DOCUMENTER_CURRENT_VERSION\s+=\s+\"(.*?)\"", siteinfo)[1]
            VersionNumber(vstr)
        catch
            v"0.0.0"
        end
    end
    order = sortperm(stored_versions, rev = true)
    ordered_versions = [named_folders; version_number_folders[order]]
    open(joinpath(root, "versions.js"), "w") do io
        println(io, "var DOC_VERSIONS = [")
        for v in ordered_versions
            println(io, "  ", repr(v), ",")
        end
        println(io, "];")
        if !isempty(version_number_folders)
            println(io, "var DOCUMENTER_NEWEST = ", repr(string(stored_versions[order[1]])), ";")
        end
        if "stable" in named_folders
            println(io, "var DOCUMENTER_STABLE = \"stable\";")
        end
    end
    @info "Wrote versions.js with the following content:"
    println(read(joinpath(root, "versions.js"), String))

    # Documenter's own fallback for standard `versions=` writes this too; ours
    # doesn't hit that method, so a fresh site would 404 at its root without it.
    redirect_target = if "stable" in named_folders
        "stable"
    elseif devurl in named_folders
        devurl
    elseif !isempty(ordered_versions)
        first(ordered_versions)
    else
        nothing
    end
    write_redirect_index!(root, redirect_target)
    return
end

"""
    write_redirect_index!(root, target)

Write `root/index.html` as a meta-refresh redirect to `./target/`, mirroring what
`Documenter.deploydocs` does for the standard `versions=` argument. No-op if
`target` is `nothing`, or if `index.html` exists and wasn't generated by
Documenter or DocumenterVitepress (a user-provided landing page is left alone).
"""
function write_redirect_index!(root::AbstractString, target::Union{AbstractString, Nothing})
    target === nothing && return
    index_file = joinpath(root, "index.html")
    marker = "<!--This file is automatically generated by DocumenterVitepress.jl-->"
    documenter_marker = "<!--This file is automatically generated by Documenter.jl-->"
    if isfile(index_file)
        existing = read(index_file, String)
        is_generated = startswith(existing, marker) || startswith(existing, documenter_marker)
        is_generated || return
    end
    open(index_file, "w") do io
        println(io, marker)
        println(io, "<meta http-equiv=\"refresh\" content=\"0; url=./$(target)/\"/>")
    end
    return
end

"""
    deploydocs(; repo, target, branch, devbranch, push_preview, kwargs...)

Deploy the documentation built with DocumenterVitepress.

The `repo` keyword argument is required, all others are optional and default to
the defaults of `Documenter.deploydocs` (see its documentation for more details).

This function only shares a name with `Documenter.deploydocs`, it should
therefore be invoked with `DocumenterVitepress.deploydocs`. Because of
DocumenterVitepress's need to build a separate website for each base alias
like `v1.2.3`, `v1.2`, `v1` and `stable`, the deployment using `Documenter.deploydocs`
does not work with the default settings. This function offers a wrapper over
`Documenter.deploydocs` which deploys each separate build in sequence.
"""
function deploydocs(;
    root = Documenter.currentdir(),
    repo,
    target = "build",
    dirname = "",
    kwargs...
)

    if haskey(kwargs, :versions)
        error("""
        `DocumenterVitepress.deploydocs` does not support the `versions` keyword argument;
        Instead, amend the `deploy_decision` you pass into `MarkdownVitepress`.
        """)
    end

    bases_file = joinpath(root, target, "bases.txt")
    if !isfile(bases_file)
        error("Expected a file at $bases_file listing the separate bases that DocumenterVitepress has built the docs for.")
    end
    bases = filter(!isempty, readlines(bases_file))
    if isempty(bases)
        @info "Found no bases suitable for deployment (empty bases are skipped)."
        return
    end
    @info "Found bases for deployment: $bases"

    for (i, base) in enumerate(bases)
        dir = joinpath(target, "$i")
        @info "Deploying docs for base $(repr(base)) from $dir"
        Documenter.deploydocs(;
            root,
            repo,
            target = dir, # each version built has its own dir
            versions = DocumenterVitepress.BaseVersion(base), # the base version
            dirname = isempty(dirname) ? base : joinpath(dirname, base), # the dirname to use
            kwargs...
        )
    end

    first_version = last(bases)
    isempty(first_version) && return

    # Push the correct version to the GH Actions documenter/deploy action.
    # If we have reached this point, then the build was a success, so we can push
    # the "success" type of result.
    try
        deploy_config = Documenter.auto_detect_deploy_system()
        Documenter.post_status(deploy_config; type = "success", repo = repo, subfolder = first_version)
    catch e
        @warn "DocumenterVitepress: Error while pushing status to CI"
        rethrow(e)
    end

end

end

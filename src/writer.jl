import Documenter: Documenter, Builder, Expanders, MarkdownAST
import Documenter.DOM: escapehtml
using DocInventories: DocInventories, Inventory, InventoryItem
using TOML: TOML

import ANSIColoredPrinters
using Base64: base64decode, base64encode

# import Markdown as Markdown
import Markdown
"""
    MarkdownVitepress(; repo, devbranch, devurl, kwargs...)

This is the main entry point for the Vitepress Markdown writer.

It is a config which can be passed to the `format` keyword argument in `Documenter.makedocs`, and causes it to emit a Vitepress site.

!!! tip "Quick start"
    When invoking `Documenter.makedocs`, replace the default `format=Documenter.HTML(...)` with:
    ```julia
    format=DocumenterVitepress.MarkdownVitepress(; repo = "...", devbranch = "...", devurl = "...")
    ```

## Keyword arguments (config)
$(FIELDS)

## Extended help

The `repo` kwarg is used to set the edit link for the documentation.

The `devbranch` and `devurl` kwargs are used to set the path of the static site, which Vitepress expects in advance.
"""
Base.@kwdef struct MarkdownVitepress <: Documenter.Writer
    "*Required*: The full URL of the repository to which the documentation will be deployed."
    repo::String
    "The name of the development branch, like `master` or `main`."
    devbranch::String = Documenter.git_remote_head_branch("MarkdownVitepress(devbranch = ...)", Documenter.currentdir())
    "The URL path to the development site, like `dev` or `dev-branch`."
    devurl::String = "dev"
    """
    The URL of the repository to which the documentation will be deployed.
    This **must** be the full URL, **including `https://`**, like `https://rafaqz.github.io/Rasters.jl` or `https://geo.makie.jl/`.
    """
    deploy_url::Union{String, Nothing} = nothing
    "A description of the website as a String."
    description::String = "Documentation for $(splitdir(repo)[end])"
    """Determines whether to build the Vitepress site or only emit markdown files.  Defaults to `true`, i.e., building the full Vitepress site."""
    build_vitepress::Bool = true
    "Determines whether to run `npm install` before building the Vitepress site.  Defaults to `true`."
    install_npm::Bool = true
    """The path to which the Markdown files will be output.  Defaults to `\$build/.documenter`."""
    md_output_path::String = ".documenter"
    """
    DeployDecision from Documenter.jl. This is used to determine whether to deploy the documentation or not.
    Options are:
    - `nothing`: **Default**. Automatically determine whether to deploy the documentation.
    - `Documenter.DeployDecision`: Override the automatic decision and deploy based on the passed config.
    It might be useful to use the latter if DocumenterVitepress fails to deploy automatically.
    You can pass a manually constructed `Documenter.DeployDecision` struct, or the output of
    `Documenter.deploy_folder(Documenter.auto_detect_deploy_system(); repo, devbranch, devurl, push_preview)`.
    """
    deploy_decision::Union{Nothing, Documenter.DeployDecision} = nothing
    "A list of assets, the same as what is provided to Documenter's HTMLWriter."
    assets = nothing
    "A version string to write to the header of the objects.inv inventory file. This should be a valid version number without a v prefix. Defaults to the version defined in the Project.toml file in the parent folder of the documentation root"
    inventory_version::Union{String,Nothing} = nothing
    "Whether to write inventory or not"
    write_inventory = true
    """
    Sets the granularity of versions which should be kept. Options are :patch, :minor or :breaking (the default).
    You can use this to reduce the number of docs versions that coexist on your dev branch. With :patch, every patch
    version will be stored. With :minor, v1.1.0, v1.1.1, v1.1.2 etc. will overwrite each other as v1.1. With :breaking,
    only the major versions v1, v2, v3 etc. will be kept, except below v1 where each minor version will be kept, as these are
    considered breaking under Julia's interpretation of SemVer.
    """
    keep = :breaking
    ansicolor::Bool = true
end

# return the same file with the extension changed to .md
mdext(f) = string(splitext(f)[1], ".md")

@static if  :writer_supports_ansicolor in names(Documenter; all = true) # only on Documenter v1.11.something
    Documenter.writer_supports_ansicolor(::MarkdownVitepress) = true
end

"""
    docpath(file, mdfolder)

This function takes the filename `file`, and returns a file path in the `mdfolder` directory which has the same tree as the `src` directory.  This is used to ensure that the Markdown files are output in the correct location for Vitepress to find them.

"""
function docpath(file, builddir, mdfolder)
    # For Windows, handle the build prefix and get the relative part
    if Sys.iswindows() && startswith(file, "build\\")
        # Extract everything after "build\"
        relative_part = split(file, "build\\")[2]
        # Join with target directory structure
        return normpath(joinpath(builddir, mdfolder, relative_part))
    else
        # Unix systems or non-build prefix
        path = relpath(file, builddir)
        filename = mdext(path)
        return joinpath(builddir, mdfolder, filename)
    end
end

"""
    render(args...)

This is the main entry point and recursive function to render a Documenter document to
Markdown in the Vitepress flavour.  It is called by `Documenter.build` and should not be
called directly.

## Methods

To extend this function, the general signature is:
```julia
render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, element::Eltype, page, doc; kwargs...)
```
where `Eltype` is the type of the `element` field of the `node` object which you care about.
"""
function render(doc::Documenter.Document, settings::MarkdownVitepress=MarkdownVitepress())
    @info "DocumenterVitepress: rendering MarkdownVitepress pages."

    # We manually obtain the Documenter deploy configuration,
    # so we can use it to set Vitepress's settings.
    if settings.deploy_decision === nothing
        # TODO: make it so that the user does not have to provide a repo url!
        deploy_config = Documenter.auto_detect_deploy_system()
        deploy_decision = Documenter.deploy_folder(
            deploy_config;
            repo = settings.repo, # this must be the full URL!
            devbranch = settings.devbranch,
            devurl = settings.devurl,
            push_preview=true,
        )
    else
        deploy_decision = settings.deploy_decision
    end

    # copy_assets(doc, settings.md_output_path)
    # Handle the case where the site name has to be set...
    mime = MIME"text/plain"() # TODO: why?
    builddir = isabspath(doc.user.build) ? doc.user.build : joinpath(doc.user.root, doc.user.build)
    # Main.@infiltrate
    sourcedir = isabspath(doc.user.source) ? doc.user.source : joinpath(doc.user.root, doc.user.source)
    # First, we check what Documenter has copied for us already:
    current_build_files_or_dirs = readdir(builddir)
    # Then, we create a path to the folder where we will emit the markdown,
    mkpath(joinpath(builddir, settings.md_output_path))
    # and copy the previous build files to the new location.
    if settings.md_output_path != "."
        for file_or_dir in current_build_files_or_dirs

            src = joinpath(builddir, file_or_dir)
            dst = joinpath(builddir, settings.md_output_path, file_or_dir)

            if src == joinpath(builddir, settings.md_output_path)
                continue
            end
            if src != dst
                cp(src, dst; force = true)
                rm(src; recursive = true)
            else
                println(src, dest)
            end
        end
    end
    # copy vue components
    source_components = joinpath(dirname(@__DIR__), "template/src/components")
    destination_dir = joinpath(builddir, settings.md_output_path, "components")
    # Ensure the destination directory exists
    mkpath(destination_dir)
    for item in readdir(source_components)
        src = joinpath(source_components, item)
        dest = joinpath(destination_dir, item)
        if !isfile(dest) && !isdir(dest)
            try
                if isdir(src)
                    cp(src, dest; force=true)
                else
                    cp(src, dest; force=true)
                end
                println("Copied: $dest")
            catch e
                println("Error copying $src to $dest: $e")
            end
        else
            println("Skipping: $dest (already exists)")
        end
    end
    # Documenter.jl wants assets in `assets/`, but Vitepress likes them in `public/`,
    # so we rename the folder.
    mkpath(joinpath(builddir, settings.md_output_path, "public"))
    if isdir(joinpath(sourcedir, "assets")) && !isdir(joinpath(sourcedir, "public"))
        files = readdir(joinpath(builddir, settings.md_output_path, "assets"); join = true)
        logo_files = contains.(last.(splitdir.(files)), "logo")
        favicon_files = contains.(last.(splitdir.(files)), "favicon")
        if any(logo_files)
            for file in files[logo_files]
                file_relpath = relpath(file, joinpath(builddir, settings.md_output_path, "assets"))
                file_destpath = joinpath(builddir, settings.md_output_path, "public", file_relpath)
                if normpath(file) != normpath(file_destpath)
                    cp(file, file_destpath; force = true)
                end
            end
        end
        if any(favicon_files)
            for file in files[favicon_files]
                file_relpath = relpath(file, joinpath(builddir, settings.md_output_path, "assets"))
                file_destpath = joinpath(builddir, settings.md_output_path, "public", file_relpath)
                dest_dir = dirname(file_destpath)
                mkpath(dest_dir) # Ensure destination directory exists
                if normpath(file) != normpath(file_destpath)
                    cp(file, file_destpath; force = true)
                end
            end
        end
    end

    inventory = if settings.write_inventory
        version = settings.inventory_version
        if isnothing(version)
            project_toml = joinpath(dirname(doc.user.root), "Project.toml")
            version = _get_inventory_version(project_toml)
        end
        Inventory(; project=doc.user.sitename, version)
    else
        nothing
    end

    # Iterate over the pages, render each page separately
    for (src, page) in doc.blueprint.pages
        # This is where you can operate on a per-page level.
        open(docpath(page.build, builddir, settings.md_output_path), "w") do io
            merge_and_render_frontmatter(io, MIME("text/yaml"), page, doc)
            for node in page.mdast.children
                kwargs = if settings.write_inventory
                    (; inventory = inventory)
                else
                    (;)
                end
                render(io, mime, node, page, doc; kwargs...)
            end
        end
        if settings.write_inventory
            item = InventoryItem(
                name = replace(splitext(src)[1], "\\" => "/"),
                domain = "std",
                role = "doc",
                dispname = _pagetitle(page),
                priority = -1,
                uri = _get_inventory_uri(doc, page, nothing)
            )
            push!(inventory, item)
        end
    end
    if settings.write_inventory
        objects_inv = joinpath(builddir, settings.md_output_path, "public", "objects.inv")
        DocInventories.save(objects_inv, inventory)
    end

    bases = determine_bases(deploy_decision.subfolder; settings.keep)

    for (i_base, base) in enumerate(bases)
        # from `vitepress_config.jl`
        # This needs to be run after favicons and logos are moved to the public subfolder
        modify_config_file(doc, settings, deploy_decision, i_base, base)
        open(joinpath(builddir, "bases.txt"), i_base == 1 ? "w" : "a") do io
            println(io, base)
        end

        config_path = joinpath(builddir, settings.md_output_path, ".vitepress", "config.mts")
        if isfile(config_path)
            mkpath(dirname(config_path)) # Ensure .vitepress directory exists
            touch(config_path)
        end

        # Now that the Markdown files are written, we can build the Vitepress site if required.
        if settings.build_vitepress
            build_vitepress(bases, base, i_base, builddir, deploy_decision.subfolder, settings)
        else
            @info """
                DocumenterVitepress: did not build Vitepress site because `build_vitepress` was set to `false`.
                You can view it yourself by running the following in the `docs` folder:
                ```
                npm run docs:dev
                ```
                and if you haven't run `npm` in this repo before, install all packages by running `npm install`.

                All emitted markdown can be found in `$(joinpath(builddir, settings.md_output_path))`.
                """
        end
        # This is only useful if placed in the root of the `docs` folder, and we don't
        # have any names which conflict with Jekyll (beginning with _ or .) in any case.
        # touch(joinpath(builddir, "final_site", ".nojekyll"))
    end

    return
end

function build_vitepress(bases, base, i_base, builddir, subfolder, settings)
    @info "DocumenterVitepress: building Vitepress site $i_base of $(length(bases)) with base \"$base\"."
    # Build the docs using `npm`
    should_remove_package_json = false
    try
        if !isfile(joinpath(dirname(builddir), "package.json"))
            @warn "DocumenterVitepress: Did not find `docs/package.json` in your repository.  Substituting default for now."
            cp(joinpath(dirname(@__DIR__), "template", "package.json"), joinpath(dirname(builddir), "package.json"))
            should_remove_package_json = true
        end

        cd(dirname(builddir)) do
            # NodeJS_20_jll treats `npm` as a `FileProduct`, meaning that it has no associated environment variable
            # when interpolating the `npm` command.
            # However, `node() do ...` actually uses `withenv` internally, so we can wrap all invocations of `npm` in
            # a `node()` block to ensure that the `npm` from the JLL finds the `node` from the JLL.

            package_json_path = joinpath(dirname(builddir), "package.json")
            template_path = joinpath(dirname(@__DIR__), "template", "package.json")
            build_output_path = joinpath(builddir, settings.md_output_path)

            if settings.install_npm || should_remove_package_json
                if !isfile(package_json_path)
                    cp(template_path, package_json_path)
                    should_remove_package_json = true
                end
                # wrap in `node(...) do _`
                node(; adjust_PATH = true, adjust_LIBPATH = true) do _
                    # On Windows systems
                    if Sys.iswindows()
                        # system_npm = "C:\\Program Files\\nodejs\\npm.cmd"
                        # install dependecies
                        run(`cmd /c $npm install`)
                        # run(`cmd /c $npm exec vitepress build $build_output_path`) # activate once a new > NodeJS_20_jll artifact is available.
                        # Debugging alternative
                        # run(`cmd /c "set DEBUG=vitepress:* & $npm exec vitepress build $build_output_path"`)
                        @warn "On Windows, use `npm run docs:dev` and `npm run docs:build` directly in the terminal inside your `docs` folder."
                        @info "Go to https://nodejs.org/en, download, and install the latest version. Version 22.11.0 or higher should work."
                    else
                        run(`$(npm) install`)
                        run(`$(npm) run env -- vitepress build $(build_output_path)`)
                    end
                end
            end
        end
        basedir = joinpath(builddir, "$i_base")
        # On Windows, the build is manual. This check ensures we only write `siteinfo.js` if the build output directory exists and is not empty. This also handles cases where an automated build might fail on other systems.
        if isdir(basedir) && !isempty(readdir(basedir))
            # Documenter normally writes this itself in `deploydocs`, but we're not using its versioning
            open(joinpath(basedir, "siteinfo.js"), "w") do io
                println(io, """var DOCUMENTER_CURRENT_VERSION = "$(subfolder)";""")
            end
        end

    catch e
        rethrow(e)
    finally
        if should_remove_package_json
            rm(joinpath(dirname(builddir), "package.json"))
            rm(joinpath(dirname(builddir), "package-lock.json"))
        end
    end
end

is_version_string(str) = try (VersionNumber(str); true) catch; false end

function determine_bases(
        subfolder;
        keep::Symbol,
        all_tagged_versions::Vector{VersionNumber} = get_all_tagged_release_versions(),
        log = true,
    )::Vector{String}

    keep in (:patch, :minor, :breaking) || error("Invalid `keep` value $(repr(keep)). Only :patch, :minor or :breaking are allowed.")
    bases = if is_version_string(subfolder)
        v = VersionNumber(subfolder)
        log && @info "Subfolder is a version: $v"

        patch_base = "v$(v.major).$(v.minor).$(v.patch)"
        minor_base = "v$(v.major).$(v.minor)"
        major_base = "v$(v.major)"

        bases = []
        if keep === :patch || (v.major == 0 && v.minor == 0)
            log && @info "Adding base `$(patch_base)`"
            push!(bases, patch_base)
        else
            log && @info "Not adding base `$(patch_base)` because keep == $(repr(keep))"
        end

        higher_versions = filter(>(v), all_tagged_versions)
        if !isempty(v.prerelease)
            log && @info "`$v` is a prerelease, not adding base `stable`"
        elseif isempty(higher_versions)
            log && @info "No higher versions than `$v` found, adding base `stable`"
            push!(bases, "stable")
        else
            log && @info "Found release tag `$(first(higher_versions))` which is a higher version than `$v`, not adding base `stable`"
        end

        higher_versions_same_major = filter(v2 -> v2.major == v.major, higher_versions)
        if v.major == 0
            log && @info "All-zero major alias `v0` will not be added as a base"
        elseif isempty(higher_versions_same_major)
            log && @info "No higher versions than `$v` with same major version found, adding base `$(major_base)`"
            push!(bases, major_base)
        else
            log && @info "Found release tag `$(first(higher_versions_same_major))` which is a higher version with same major version than `$v`, not adding base `$(major_base)`"
        end

        higher_versions_same_minor = filter(v2 -> v2.minor == v.minor, higher_versions_same_major)
        if v.major == 0 && v.minor == 0
            log && @info "All-zero major minor alias `v0.0` will not be added as a base"
        elseif isempty(higher_versions_same_minor)
            if keep === :breaking && v.major > 0
                log && @info "No higher versions than `$v` with same major and minor version found, but not adding base `$(minor_base)` because keep == :breaking"
            else
                log && @info "No higher versions than `$v` with same major and minor version found, adding base `$(minor_base)`"
                push!(bases, minor_base)
            end
        else
            log && @info "Found release tag `$(first(higher_versions_same_minor))` which is a higher version with same major and minor version than `$v`, not adding base `$(minor_base)`"
        end

        filter!(x -> x ∉ ("v0", "v0.0"), bases)
    else
        [subfolder]
    end

    log && @info "Bases that will be built: $bases"

    return bases
end

stripped_version(v::VersionNumber) = VersionNumber(v.major, v.minor, v.patch)

function get_all_tagged_release_versions()::Vector{VersionNumber}
    tags = readlines(`$(Documenter.git()) tag`)
    version_numbers = stripped_version.(VersionNumber.(filter(is_version_string, tags)))
    filter!(version_numbers) do v
        isempty(v.prerelease) # we never want alias bases for prereleases so we don't clobber `stable` etc.
    end
    # For comparison purposes, we don't care about build versions. If the new version
    # is otherwise the same as an existing one, we push it as an update to that older one
    stripped_version_numbers = unique(stripped_version.(version_numbers))
    return sort(stripped_version_numbers, rev = true)
end

# This function catches all nodes and decomposes them to their elements.
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, page, doc; kwargs...)
    render(io, mime, node, node.element, page, doc; kwargs...)
end

# This function catches nodes dispatched with their children, and renders each child.
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, children::Documenter.MarkdownAST.NodeChildren{<: Documenter.MarkdownAST.Node}, page, doc; kwargs...)
    for child in children
        render(io, mime, child, child.element, page, doc; kwargs...)
    end
end

function copy_assets(doc::Documenter.Document, mdfolder::String)
    @debug "copying assets to build directory."
    assets = ASSETS
    if isdir(assets)
        builddir = joinpath(doc.user.build, mdfolder, "assets")
        isdir(builddir) || mkdir(builddir)
        for each in readdir(assets)
            src = joinpath(assets, each)
            dst = joinpath(builddir, each)
            ispath(dst) && @warn "DocumenterMarkdownVitepress: overwriting '$dst'."
            cp(src, dst; force=true)
        end
    else
        @warn "DocumenterVitepress: no assets directory found."
    end
end

function render(io::IO, mime::MIME"text/plain", vec::Vector, page, doc; kwargs...)
    for each in vec
        render(io, mime, each, page, doc; kwargs...)
    end
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, anchor::Documenter.Anchor, page, doc; kwargs...)
    anchor_id = lstrip(Documenter.anchor_fragment(anchor), '#')
    println(io, "\n<a id='", anchor_id, "'></a>")
    return render(io, mime, node, anchor.object, page, doc; kwargs...)
end


## Documentation Nodes.

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, docblock::Documenter.DocsNodesBlock, page, doc; kwargs...)
    render(io, mime, node, node.children, page, doc; kwargs...)
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, docs::Documenter.DocsNodes, page, doc; kwargs...)
    for docstr in docs.docs
        render(io, mime, docstr, page, doc; kwargs...)
    end
end

function sanitized_anchor_label(anchor)
    # vitepress doesn't like special markdown characters in the id slug, so we just remove them.
    # it seems unlikely to get conflicts with other slugs this way, and escaping the characters with
    # backslashes did not make the slugs work correctly in vitepress, either
    label = Documenter.anchor_label(anchor)
    return replace(label, r"[\[\]\(\)*]" => "")
end


function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, docs::Documenter.DocsNode, page, doc; kwargs...)
    open_txt = get(page.globals.meta, :CollapsedDocStrings, false) ? "" : "open"
    anchor_id = sanitized_anchor_label(docs.anchor)
    category = Documenter.doccat(docs.object)
    if haskey(kwargs, :inventory)
        item = InventoryItem(
            name = docs.anchor.id,
            role = lowercase(category),
            uri = _get_inventory_uri(doc, page, anchor_id),
        )
        push!(kwargs[:inventory], item)
    end
    # Docstring header based on the name of the binding and it's category.
    _badge_text = """<Badge type="info" class="jlObjectType jl$(category)" text="$(category)" />"""
    print(io ,"""<details class='jldocstring custom-block' $(open_txt)>
    <summary><a id='$(anchor_id)' href='#$(anchor_id)'><span class="jlbinding">$(docs.object.binding)</span></a> $(_badge_text)</summary>\n
    """)
    # Body. May contain several concatenated docstrings.
    renderdoc(io, mime, node, page, doc; kwargs...)
    return println(io, "</details>\n")
end

function renderdoc(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, page, doc; kwargs...)
    @assert node.element isa Documenter.DocsNode
    # The `:results` field contains a vector of `Docs.DocStr` objects associated with
    # each markdown object. The `DocStr` contains data such as file and line info that
    # we need for generating correct source links.
    for (docstringast, result) in zip(node.element.mdasts, node.element.results)
        println(io)
        render(io, mime, docstringast, docstringast.children, page, doc; kwargs...)
        println(io)
        # When a source link is available then print the link.
        url = Documenter.source_url(doc, result)
        if url !== nothing
            # This is how Documenter does it:
            # push!(ret.nodes, a[".docs-sourcelink", :target=>"_blank", :href=>url]("source"))
            println(io, "\n", """<Badge type="info" class="source-link" text="source"><a href="$url" target="_blank" rel="noreferrer">source</a></Badge>""", "\n")
        end
    end
end

function renderdoc(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, other, page, doc; kwargs...)
    # TODO: properly support non-markdown docstrings at some point.
    return render(io, mime, other, page, doc; kwargs...)
end

## Index, Contents, and Eval Nodes.

function render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, index::Documenter.IndexNode, page, doc; kwargs...)
    for (object, _, page, mod, cat) in index.elements
        page = mdext(page)
        url = string("#", Documenter.slugify(object))
        println(io, "- [`", object.binding, "`](", replace(url, " " => "%20"), ")")
    end
    return println(io)
end

function starts_with_at(anchor_frag)
    starts_with_at = startswith(anchor_frag, "@")
    if starts_with_at
        # Remove the @ symbol
        anchor_frag = anchor_frag[2:end]
    end
    return anchor_frag
end

function vitepress_anchor(anchor::String)
    # Remove the leading # if it exists
    anchor_frag = startswith(anchor, "#") ? anchor[2:end] : anchor
    anchor_frag_at = starts_with_at(anchor_frag)
    # Check if the anchor is a single word (no special characters besides dots)
    if !occursin(r"[-_,:;!?@#$%^&*()\s]", anchor_frag_at)
        # Single words get lowercased first
        lowercased = lowercase(anchor_frag_at)
        # Then transform all dots to hyphens
        transformed = replace(lowercased, "." => "-")
        return "#" * transformed
    else
        return "#" * anchor_frag
    end
end

function render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, contents::Documenter.ContentsNode, page, doc; kwargs...)
    current_path = nothing
    for (count, path, anchor) in contents.elements
        path = mdext(path)
        header = anchor.object
        anchor_frag = Documenter.anchor_fragment(anchor)
        anchor_frag = vitepress_anchor(anchor_frag)
        url = replace(string(path, anchor_frag), " " => "%20")
        anchor_id = replace(anchor.id, "-" => " ")
        link = Markdown.Link(anchor_id, url)
        level = header.level
        # Reset level to 1 if this is a new path
        if path != current_path
            level = 1
            current_path = path
        end

        print(io, "    "^(level - 1), "- ")
        linkfix = ".md#"
        println(io, replace(Markdown.plaininline(link), linkfix => "#"))
    end
    return println(io)
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, evalnode::Documenter.EvalNode, page, doc; kwargs...)
    return evalnode.result === nothing ? nothing : render(io, mime, node, evalnode.result, page, doc; kwargs...)
end

function intelligent_language(lang::String)
    if lang == "documenter-ansi"
        "ansi"
    elseif lang ∈ ("ansi", "julia-repl", "@repl", "@example", "@doctest")
        "julia" # /julia>/ TODO: implement this highlighting for the `julia-repl` and `@doctest` languages.
    else
        lang
    end
end

function join_multiblock(node::Documenter.MarkdownAST.Node)
    @assert node.element isa Documenter.MultiCodeBlock
    mcb = node.element
    if mcb.language == "ansi"
        # Return a vector of Markdown code blocks
        # where each block is a single line of the output or input.
        # Basically, we iterate through the code,
        # and whenever the language changes, we
        # start a new code block and push the old one to the array!
        codes = Markdown.Code[]
        current_language = mcb.language
        current_string = ""
        code_blocks = mcb.content
        for thing in code_blocks
            # reset the buffer and push the old code block
            if thing.language != current_language
                # Remove this if statement if you want to
                # include empty code blocks in the output.
                if isempty(thing.code)
                    current_string *= "\n\n"
                    continue
                end
                push!(codes, Markdown.Code(intelligent_language(current_language), current_string))
                current_string = ""
                current_language = thing.language # reset the current language
            end
            # push the current code to `io`
            current_string *= thing.code
        end
        # push the last code block
        push!(codes, Markdown.Code(intelligent_language(current_language), current_string))
        return codes

    else
        io = IOBuffer()
        codeblocks = [n.element::MarkdownAST.CodeBlock for n in node.children]
        for (i, thing) in enumerate(codeblocks)
            print(io, thing.code)
            if i != length(codeblocks)
              !isempty(thing.code) && println(io)
                if findnext(x -> x.info == mcb.language, codeblocks, i + 1) == i + 1
                    println(io)
                end
            end
        end
        return [Markdown.Code(intelligent_language(mcb.language), String(take!(io)))]
    end
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, mcb::Documenter.MultiCodeBlock, page, doc; kwargs...)
    return render(io, mime, node, join_multiblock(node), page, doc; kwargs...)
end


function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, d::Documenter.MultiOutput, page, doc; kwargs...)
    # @infiltrate
    return render(io, mime, node, node.children, page, doc; kwargs...)
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, d::Documenter.MultiOutputElement, page, doc; kwargs...)
    return render(io, mime, node, d.element, page, doc; kwargs...)
end

# Select the "best" rendering MIME for markdown output!

# NOTE: Documenter only supports the mime types in here:
# https://github.com/JuliaDocs/Documenter.jl/blob/ea353add145560aae2d550ed4d9b133d36fc229c/src/utilities/utilities.jl#L619-L630
# so make sure that you are aware of that!  Something like a video would need a PR to Documenter to be supported/returned.

"""
    mime_priority(mime::MIME)::Float64

This function returns a priority for a given MIME type, which
is used to select the best MIME type for rendering a given
element.  Priority is in ascending order, i.e., 1 has more priority than 0.
"""
function mime_priority end
mime_priority(::MIME"text/plain") = 0.0
mime_priority(::MIME"text/latex") = 0.5
mime_priority(::MIME"text/markdown") = 1.0
mime_priority(::MIME"text/html") = 2.0
mime_priority(::MIME"image/svg+xml") = 3.0
mime_priority(::MIME"image/png") = 4.0
mime_priority(::MIME"image/webp") = 5.0
mime_priority(::MIME"image/jpeg") = 6.0
mime_priority(::MIME"image/png+lightdark") = 7.0
mime_priority(::MIME"image/jpeg+lightdark") = 8.0
mime_priority(::MIME"image/svg+xml+lightdark") = 9.0
mime_priority(::MIME"image/gif") = 10.0
mime_priority(::MIME"video/mp4") = 11.0

mime_priority(::MIME) = nothing # unknown MIMEs are filtered out

function render_mime(io::IO, mime::MIME, node, element, page, doc; kwargs...)
    @warn("DocumenterVitepress: Unknown MIME type $mime provided and no alternatives given.  Ignoring render!")
end

function render_mime(io::IO, mime::MIME"text/markdown", node, element, page, doc; kwargs...)
    println(io, element)
end

function render_mime(io::IO, mime::MIME"text/latex", node, element, page, doc; kwargs...)
    # println(io, "```math")
    println(io, element)
    # println(io, "```")
end

function render_mime(io::IO, mime::MIME"text/html", node, element, page, doc; kwargs...)
    function escapehtml(io, text::AbstractString)
        for char in text
            char === '<' ? write(io, "&lt;") :
            char === '>' ? write(io, "&gt;") :
            char === '&' ? write(io, "&amp;") :
            char === '\'' ? write(io, "&#39;") :
            char === '`' ? write(io, "\\`") :
            char === '\n' ? write(io, "&#10;") :
            char === '"' ? write(io, "&quot;") :
            char === '$' ? write(io, "\\\$") : write(io, char)
        end
        return
    end
    # v-html takes a javascript expression that results in a string of html, but this
    # has to be parsed within the context of an html attribute, so we escape all the offending
    # characters. vitepress will not further modify this html as is usually intended with display values.
    print(io, "<div v-html=\"`")
    escapehtml(io, repr(mime, element))
    println(io, "`\"></div>")
end

function render_mime(io::IO, mime::MIME"image/svg+xml", node, element, page, doc; md_output_path, kwargs...)
    # NOTE: It seems that we can't always simply save the SVG images as a file and include them
    # as browsers seem to need to have the xmlns attribute set in the <svg> tag if you
    # want to include it with <img>. However, setting that attribute is up to the code
    # creating the SVG image.
    has_xml_namespace = match(r"<svg[^>].*?xmlns\s*=", element) !== nothing

    if has_xml_namespace
        filename = String(rand('a':'z', 7))
        write(
            joinpath(
                doc.user.build,
                md_output_path,
                dirname(relpath(page.build, doc.user.build)),
                "$(filename).svg"
            ),
            element
        )
        println(io, "![]($(filename).svg)")
    else
        # Vitepress complains about the XML version and encoding string when used as an inline svg
        # so we remove that
        image_text = replace(
            element,
            r"<\?xml.*?>\s*"i => ""
        )
        println(io, "<img src=\"data:image/svg+xml;base64," * base64encode(image_text) * "\"/>")
    end
end

# Taken from https://github.com/PumasAI/QuartoNotebookRunner.jl/, MIT licensed
function png_image_metadata(bytes::Vector{UInt8})
    if @view(bytes[1:8]) != b"\x89PNG\r\n\x1a\n"
        throw(ArgumentError("Not a png file"))
    end

    chunk_start::Int = 9

    _load(T, bytes, index) = ntoh(reinterpret(T, @view(bytes[index:index+sizeof(T)-1]))[])

    function read_chunk!()
        chunk_start > lastindex(bytes) && return nothing
        chunk_data_length = _load(UInt32, bytes, chunk_start)
        type = @view(bytes[chunk_start+4:chunk_start+7])
        data = @view(bytes[chunk_start+8:chunk_start+8+chunk_data_length-1])
        result = (; chunk_start, type, data)

        # advance the chunk_start state variable
        chunk_start += 4 + 4 + chunk_data_length + 4 # length, type, data, crc

        return result
    end

    chunk = read_chunk!()
    if chunk === nothing
        error("PNG file had no chunks")
    end
    if chunk.type != b"IHDR"
        error("PNG file must start with IHDR chunk, started with $(chunk.type)")
    end

    width = Int(_load(UInt32, chunk.data, 1))
    height = Int(_load(UInt32, chunk.data, 5))

    # if the png reports a physical pixel size, i.e., it has a pHYs chunk
    # with the pixels per meter unit flag set, correct the basic width and height
    # by those physical pixel sizes
    while true
        chunk = read_chunk!()
        chunk === nothing && break
        chunk.type == b"IDAT" && break
        if chunk.type == b"pHYs"
            is_in_meters = Bool(_load(UInt8, chunk.data, 9))
            is_in_meters || break
            x_px_per_meter = _load(UInt32, chunk.data, 1)
            y_px_per_meter = _load(UInt32, chunk.data, 5)
            # it seems sensible to round the final image size to full CSS pixels,
            # especially given that png doesn't store dpi but px per meter
            # in an integer format, losing some precision
            width = round(Int, width / x_px_per_meter * (96 / 0.0254))
            height = round(Int, height / y_px_per_meter * (96 / 0.0254))
            break
        end
    end

    return (; width, height)
end

function render_mime(io::IO, mime::MIME"image/png", node, element, page, doc; md_output_path, kwargs...)
    filename = String(rand('a':'z', 7))
    pngpath = joinpath(doc.user.build, md_output_path, dirname(relpath(page.build, doc.user.build)), "$(filename).png")
    bytes = base64decode(element)
    write(pngpath, bytes)
    p = png_image_metadata(bytes)
    println(io, "![]($(filename).png){width=$(p.width)px height=$(p.height)px}")
end

function render_mime(io::IO, mime::MIME"image/webp", node, element, page, doc; md_output_path, kwargs...)
    filename = String(rand('a':'z', 7))
    write(joinpath(doc.user.build, md_output_path, dirname(relpath(page.build, doc.user.build)), "$(filename).webp"),
        base64decode(element))
    println(io, "![]($(filename).webp)")
end

function render_mime(io::IO, mime::MIME"image/jpeg", node, element, page, doc; md_output_path, kwargs...)
    filename = String(rand('a':'z', 7))
    write(joinpath(doc.user.build, md_output_path, dirname(relpath(page.build, doc.user.build)), "$(filename).jpeg"),
        base64decode(element))
    println(io, "![]($(filename).jpeg)")
end

function render_mime(io::IO, mime::MIME"image/png+lightdark", node, element, page, doc; md_output_path, kwargs...)
    fig_light, fig_dark, backend = element
    filename = String(rand('a':'z', 7))
    write(joinpath(doc.user.build, md_output_path, dirname(relpath(page.build, doc.user.build)), "$(filename)_light.png"), fig_light)
    write(joinpath(doc.user.build, md_output_path, dirname(relpath(page.build, doc.user.build)), "$(filename)_dark.png"), fig_dark)
    println(io,
        """
        ![]($(filename)_light.png){.light-only}
        ![]($(filename)_dark.png){.dark-only}
        """
    )
end

function render_mime(io::IO, mime::MIME"image/jpeg+lightdark", node, element, page, doc; md_output_path, kwargs...)
    fig_light, fig_dark, backend = element
    filename = String(rand('a':'z', 7))
    Main.Makie.save(joinpath(doc.user.build, md_output_path, dirname(relpath(page.build, doc.user.build)), "$(filename)_light.jpeg"), fig_light)
    Main.Makie.save(joinpath(doc.user.build, md_output_path, dirname(relpath(page.build, doc.user.build)), "$(filename)_dark.jpeg"), fig_dark)
    println(io,
        """
        ![]($(filename)_light.jpeg){.light-only}
        ![]($(filename)_dark.jpeg){.dark-only}
        """
    )
end

function render_mime(io::IO, mime::MIME"image/svg+xml+lightdark", node, element, page, doc; md_output_path, kwargs...)
    fig_light, fig_dark, backend = element
    filename = String(rand('a':'z', 7))
    Main.Makie.save(joinpath(doc.user.build, md_output_path, dirname(relpath(page.build, doc.user.build)), "$(filename)_light.svg"), fig_light)
    Main.Makie.save(joinpath(doc.user.build, md_output_path, dirname(relpath(page.build, doc.user.build)), "$(filename)_dark.svg"), fig_dark)
    println(io,
        """
        <img src = "$(filename)_light.svg" style=".light-only"></img>
        <img src = "$(filename)_dark.svg" style=".dark-only"></img>
        """
    )
end

function render_mime(io::IO, mime::MIME"image/gif", node, element, page, doc; md_output_path, kwargs...)
    filename = String(rand('a':'z', 7))
    write(joinpath(doc.user.build, md_output_path, dirname(relpath(page.build, doc.user.build)), "$(filename).gif"),
        base64decode(element))
    println(io, "![]($(filename).gif)")
end

function render_mime(io::IO, mime::MIME"video/mp4", node, element, page, doc; md_output_path, kwargs...)
    filename = String(rand('a':'z', 7))
    write(joinpath(doc.user.build, md_output_path, dirname(relpath(page.build, doc.user.build)), "$(filename).mp4"),
        base64decode(element))
    println(io, "<video src='$filename.mp4' controls='controls' autoplay='autoplay'></video>")
end

function render_mime(io::IO, mime::MIME"text/plain", node, element, page, doc; kwargs...)
    # Note: this should specifically be ansi so that Vitepress picks it up.
    return render(io, mime, node, Markdown.Code("ansi", element), page, doc; kwargs...)
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, d::Dict{MIME, Any}, page, doc; kwargs...)

    settings_ind = findfirst(x -> x isa MarkdownVitepress, doc.user.format)
    settings = doc.user.format[settings_ind]
    md_output_path = settings.md_output_path

    available_mimes = filter(mime -> mime_priority(mime) !== nothing, collect(keys(d)))
    if isempty(available_mimes)
        return nothing
    end
    # Sort the available mimes by priority
    sorted_mimes = sort(available_mimes, by = mime_priority)
    # Select the best MIME type for rendering
    best_mime = sorted_mimes[end]
    # Render the best MIME type
    render_mime(io, best_mime, node, d[best_mime], page, doc; md_output_path, kwargs...)
end

## Basic Nodes. AKA: any other content that hasn't been handled yet.

function render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, other, page, doc; kwargs...)
    println(io)
    linkfix = ".md#"
    return println(io, replace(Markdown.plain(other), linkfix => "#"))
end

render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, str::AbstractString, page, doc; kwargs...) = print(io, str)

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, evalnode::Documenter.MarkdownAST.Node{Nothing}, page, doc; kwargs...)
    return render(io, mime, node, evalnode.children, page, doc; kwargs...)

end

# Metadata Nodes get dropped from the final output for every format but are needed throughout
# the rest of the build, and so we just leave them in place and print a blank line in their place.
render(io::IO, ::MIME"text/plain", n::Documenter.MarkdownAST.Node, node::Documenter.MetaNode, page, doc; kwargs...) = println(io, "\n")
# In the original AST, SetupNodes were just mapped to empty Markdown.MD() objects.
render(io::IO, mime::MIME"text/plain", node::MarkdownAST.Node, ::Documenter.SetupNode, page, doc; kwargs...) = nothing


# Raw nodes are used to insert raw HTML into the output. We just print it as is.
# TODO: what if the `raw` is not HTML?  That is not addressed here but we ought to address it...
function render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, raw::Documenter.RawNode, page, doc; kwargs...)
    if startswith(raw.text, "---")
        return # this was already handled by frontmatter.
    end
    return raw.name === :html ? println(io, raw.text, "\n") : nothing
end

# This is straight Markdown to Markdown, so no issues for most of these!

# Paragraphs - they have special regions _and_ plain text
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, ::MarkdownAST.Paragraph, page, doc; prenewline = true, kwargs...)
    prenewline && println(io)
    render(io, mime, node, node.children, page, doc; prenewline, kwargs...)
    println(io)
end
# Plain text
const EQREF_REGEX = r"(?<![$\\])\\(eqref|ref)\{[^}]+\}"

function autowrap_eqref(text::AbstractString)
    replace(text, EQREF_REGEX => m -> "\$$(m)\$")
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, text::MarkdownAST.Text, page, doc; kwargs...)
    wrapped = autowrap_eqref(text.text)
    print(io, escapehtml(wrapped))
end
# Heading
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, text::MarkdownAST.Heading, page, doc; kwargs...)
    print(io, "\n# ")
    render(io, mime, node, node.children, page, doc; kwargs...)
    print(io, "\n")
end
# Bold text (strong)
# These are wrapper elements - so the wrapper doesn't actually contain any text, the current node's children do.
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, strong::MarkdownAST.Strong, page, doc; kwargs...)
    # @infiltrate
    print(io, "**")
    render(io, mime, node, node.children, page, doc; kwargs...)
    print(io, "**")
end
# Italic text (emph)
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, emph::MarkdownAST.Emph, page, doc; kwargs...)
    print(io, "_")
    render(io, mime, node, node.children, page, doc; kwargs...)
    print(io, "_")
end
# Links
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, link::MarkdownAST.Link, page, doc; kwargs...)
    # @infiltrate
    # For HTML links, use:
    # print(io, "<a href=\"$(link.destination)\">")
    # render(io, mime, node, node.children, page, doc; kwargs...)
    # print(io, "</a>")
    # However, we may have Markdown syntax in these links
    # so, we use markdown link syntax which Vitepress can parse
    # appropriately.
    print(io, "[")
    render(io, mime, node, node.children, page, doc; prenewline = false, kwargs...)
    print(io, "]($(replace(link.destination, " " => "%20")))")
end
# Code blocks
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, code::MarkdownAST.CodeBlock, page, doc; kwargs...)
    if startswith(code.info, "@")
        @warn """
        DocumenterVitepress: un-expanded `$(code.info)` block encountered on page $(page.source).
        The first few lines of code in this node are:
        ```
        $(join(Iterators.take(split(code.code, '\n'), 6), "\n"))
        ```
        """
    end
    info = intelligent_language(code.info)
    render(io, mime, node, Markdown.Code(info, code.code), page, doc; kwargs...)
end
# Inline code
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, code::MarkdownAST.Code, page, doc; kwargs...)
    print(io, "`", code.code, "`")
end
# Headers
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, header::Documenter.AnchoredHeader, page, doc; kwargs...)
    anchor = header.anchor
    id = replace(sanitized_anchor_label(anchor), " " => "-")  # potentially use MarkdownAST.mdflatten here?
    heading = first(node.children)
    println(io)
    print(io, "#"^(heading.element.level), " ")
    heading_iob = IOBuffer()
    render(heading_iob, mime, node, heading.children, page, doc; kwargs...)
    heading_text = rstrip(String(take!(heading_iob)))
    print(io, heading_text)
    print(io, " {#$(id)}")
    if haskey(kwargs, :inventory)
        item = InventoryItem(
            name = header.anchor.id,
            domain = "std",
            role = "label",
            dispname = _get_inventory_dispname(header.anchor.id, Documenter.MDFlatten.mdflatten(anchor.node)),
            priority = -1,
            uri = _get_inventory_uri(doc, page, id),
        )
        push!(kwargs[:inventory], item)
    end
    println(io)
end
# Thematic breaks
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, thematic::MarkdownAST.ThematicBreak, page, doc; kwargs...)
    println(io); println(io)
    println(io, "---")
    println(io)
end
# Admonitions
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, admonition::MarkdownAST.Admonition, page, doc; kwargs...)
    # Main.@infiltrate
    category = admonition.category
    if category == "note" # Julia markdown says note, but Vitepress says tip
        category = "tip"
    end
    title = admonition.title
    if !(category ∈ ("tip", "warning", "danger", "caution"))
        if isempty(admonition.title)
            admonition.title = category
        end
        category = "tip"
    end
    println(io, "\n::: $(category) $(title)")
    render(io, mime, node, node.children, page, doc; kwargs...)
    println(io, "\n:::")
end
# Block quotes
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, q::MarkdownAST.BlockQuote, page, doc; kwargs...)
    # Main.@infiltrate
    iob = IOBuffer()
    render(iob, mime, node, node.children, page, doc; kwargs...)
    output = String(take!(iob))
    eachline = split(output, '\n')
    println.((io,), "> " .* eachline)
    println(io) # newline after block quote, so that successive quotes don't merge
end
# Inline math
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, math::MarkdownAST.InlineMath, page, doc; kwargs...)
    # Main.@infiltrate
    print(io, "\$", math.math, "\$")
end
# Display math
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, math::MarkdownAST.DisplayMath, page, doc; kwargs...)
    # Main.@infiltrate
    println(io)
    println(io, "\$\$", math.math, "\$\$")
end
# Lists
# TODO: list ordering is broken!
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, list::MarkdownAST.List, page, doc; kwargs...)
    # @infiltrate
    k = 0
    bullet() = list.type === :ordered ? "$(k+=1). " : "- "
    iob = IOBuffer()
    for item in node.children
        render(iob, mime, item, item.children, page, doc; prenewline = false, kwargs...)
        eachline = split(String(take!(iob)), '\n')
        eachline[2:end] .= "  " .* eachline[2:end]
        print(io, bullet())
        println.((io,), eachline)
    end
end
# HTMLInline
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, html::MarkdownAST.HTMLInline, page, doc; kwargs...)
    println(io, html.html)
end
# Tables
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, table::MarkdownAST.TableCell, page, doc; kwargs...)
    println("Encountered table cell!")
end
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, table::MarkdownAST.Table, page, doc; kwargs...)
    alignment_style = map(table.spec) do align
        if align == :right
            :r
        elseif align == :center
            :c
        elseif align == :left
            :l
        else
            @warn """
            Invalid alignment style $align encountered in a markdown table at:
            $(joinpath(doc.user.root, page.source))
            Valid alignment styles are `:left`, `:center`, and `:right`.

            Defaulting to left alignment.
            """
            :l
        end
    end
    # We create this IOBuffer in order to render to it.
    iob = IOBuffer()
    # This will eventually hold the rendered table cells as Strings.
    cell_strings = Vector{Vector{String}}()
    current_row_vec = String[]
    # We iterate over the rows of the table, rendering each cell in turn.
    for (i, row) in enumerate(MarkdownAST.tablerows(node))
        current_row_vec = String[]
        push!(cell_strings, current_row_vec)
        for (j, cell) in enumerate(row.children)
            render(iob, mime, cell, cell.children, page, doc; kwargs...)
            push!(current_row_vec, String(take!(iob)))
        end
    end
    # Finally, convert to Markdown table and render.
    println(io)
    println(io, Markdown.plain(Markdown.MD(Markdown.Table(cell_strings, alignment_style))))

end

const VIDEO_EXTENSIONS = [".mp4", ".webm", ".ogg", ".ogv", ".m4v", ".avi", ".mov", ".mkv"]
function is_video_file(video_path::AbstractString)
    return any(ext -> endswith(lowercase(video_path), ext), VIDEO_EXTENSIONS)
end

function render_video_tag(io::IO, mime, node, video_path, page, doc; kwargs...)
    vp_parts = split(video_path, '"', limit=2)
    actual_path = strip(vp_parts[1])
    title = ""
    if length(vp_parts) > 1
        title = strip(vp_parts[2])  # Title is in the second part (after the first quote)
        title = strip(title, ['"', ' ']) # Remove any remaining quotes or whitespace
    elseif !isempty(node.children)
        title = strip(sprint() do io_alt
            render(io_alt, mime, node, node.children, page, doc; kwargs...)
        end)
    end

    print(io, "<video src=\"", escapehtml(actual_path), "\" controls")
    if !isempty(title)
        print(io, " title=\"", escapehtml(title), "\"")
    end
    println(io, "></video>")
end
# Images
# Here, we are rendering images as HTML.  It is my hope that at some point we figure out how to render them in Markdown, but for now, this is also perfectly sufficient.
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, image::MarkdownAST.Image, page, doc; kwargs...)
    println(io)
    url = replace(image.destination, "\\" => "/")
    url_video_check = strip(first(split(url, '"', limit=2)))
    if is_video_file(url_video_check)
        render_video_tag(io, mime, node, url, page, doc; kwargs...)
    else
        print(io, "<img src=\"", url, "\" alt=\"")
        render(io, mime, node, node.children, page, doc; kwargs...)
        println(io, "\">")
    end
end

# ### Footnote Links

# This is literally emitting back to standard Markdown - we don't need any fancypants handling because the footnote will be at the bottom
# of the original Markdown page anyway.
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, link::MarkdownAST.FootnoteLink, page, doc; kwargs...)
    print(io, "[^", link.id, "]")
end

# This is literally emitting back to standard Markdown - we don't need any fancypants handling because the footnote will be at the bottom
# of the original Markdown page anyway.
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, footnote::MarkdownAST.FootnoteDefinition, page, doc; kwargs...)
    println(io)
    print(io, "[^", footnote.id, "]: ")
    render(io, mime, node, node.children, page, doc; prenewline = false, kwargs...)
    println(io)
end

# ### Interpolated Julia values
# This is pretty self-explanatory.  We just print the value of the interpolated Julia value, and warn in stdout that one has been encountered.
function render(io::IO, mime::MIME"text/plain", node::MarkdownAST.Node, value::MarkdownAST.JuliaValue, page, doc; kwargs...)
    @warn("""
    Unexpected Julia interpolation in the Markdown. This probably means that you
    have an unbalanced or un-escaped \$ in the text.

    To write the dollar sign, escape it with `\\\$`

    We don't have the file or line number available, but we got given the value:

    `$(value.ref)` which is of type `$(typeof(value.ref))`
    """)
    print(io, value.ref)
end

# ### Documenter.jl page links
# We figure out the correct path to the page, and render it as a link in Markdown.
# TODO: generate a `Markdown.Link` object?  But that seems like overkill...
function resolve_relative_path(from_page::String, to_page::Documenter.Page, doc)
    to_page_path = to_page.build
    relative_path = relpath(to_page_path, dirname(from_page))
    return relative_path
end
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, link::Documenter.PageLink, page, doc; kwargs...)
    # Main.@infiltrate
    path = if !isempty(link.fragment)
        "/" * replace(Documenter.pagekey(doc, link.page), ".md" => "") * "#" * string(link.fragment)
    else
        resolve_relative_path(page.build, link.page, doc)
    end
    print(io, "[")
    render(io, mime, node, node.children, page, doc; kwargs...)
    print(io, "]($(replace(path, " " => "%20")))")
end

# Documenter.jl local links
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, link::Documenter.LocalLink, page, doc; kwargs...)
    path = if isempty(link.fragment)
        link.path
    else
        relative_path = resolve_relative_path(page.build, page.build, doc)
        replace(relative_path, ".md" => "") * "#" * link.fragment
    end
    print(io, "[")
    render(io, mime, node, node.children, page, doc; kwargs...)
    print(io, "]($(replace(path, " " => "%20")))")
end
# Documenter.jl local images
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, image::Documenter.LocalImage, page, doc; kwargs...)

    abs_path = joinpath(doc.user.build, image.path)
    image_path = relpath(abs_path, dirname(page.build))
    image_path = replace(image_path, "\\" => "/") # windows paths are the worst
    println(io)
    if is_video_file(image_path)
        image_path = dirname(image_path) == "" ? "./" * image_path : image_path
        render_video_tag(io, mime, node, image_path, page, doc; kwargs...)
    else
        println(io, "![]($image_path)")
    end
end

function _get_inventory_version(project_toml)
    version = ""
    if isfile(project_toml)
        project_data = TOML.parsefile(project_toml)
        if haskey(project_data, "version")
            version = project_data["version"]
            @info "Automatic `version=$(repr(version))` for inventory from $(relpath(project_toml))"
        else
            @warn "Cannot extract version for inventory from $(project_toml): no version information"
        end
    else
        @warn "Cannot extract version for inventory from $(project_toml): no such file"
    end
    if isempty(version)
        # The automatic `inventory_version` determined in this function is intended only for
        # projects with a standard layout with Project.toml file in the expected
        # location (the parent folder of doc.user.root). Any non-standard project should
        # explicitly set an `inventory_version` as an option to `MarkdownVitepress()` in `makedocs`, or
        # specifically set `inventory_version=""` so that `_get_inventory_version` is never
        # called, and thus this warning is suppressed.
        @warn "Please set `inventory_version` in the `MarkdownVitepress()` options passed to `makedocs`."
    end
    return version
end


function _get_inventory_uri(doc, page, anchor_id)
    filename = relpath(page.build, doc.user.build)
    page_url = splitext(filename)[1]
    if Sys.iswindows()
        page_url = replace(page_url, "\\" => "/")
    end
    uri = join(map(_escapeuri, split(page_url, "/")), "/")
    if !isnothing(anchor_id)
        uri = uri * "#" * _escapeuri(anchor_id)
    end
    return uri
end


function _get_inventory_dispname(name, dispname)
    if dispname == name
        dispname = "-"
    end
    return dispname
end


function _pagetitle(page)
    page_mdast = page.mdast
    @assert page_mdast.element isa MarkdownAST.Document
    title_node = nothing
    for node in page_mdast.children
        # AnchoredHeaders should have just one child node, which is the Heading node
        if isa(node.element, Documenter.AnchoredHeader)
            node = first(node.children)
        end
        if isa(node.element, MarkdownAST.Heading) && node.element.level == 1
            title_node = collect(node.children)
            break
        end
    end
    if isnothing(title_node)
        return "-"
    else
        return Documenter.MDFlatten.mdflatten(title_node)
    end
end


@inline _issafe(c::Char) =
    c == '-' || c == '.' || c == '_' || (isascii(c) && (isletter(c) || isnumeric(c)))

_utf8_chars(str::AbstractString) = (Char(c) for c in codeunits(str))

_escapeuri(c::Char) = string('%', uppercase(string(Int(c), base = 16, pad = 2)))
_escapeuri(str::AbstractString) =
    join(_issafe(c) ? c : _escapeuri(c) for c in _utf8_chars(str))

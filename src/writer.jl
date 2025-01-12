import Documenter: Documenter, Builder, Expanders, MarkdownAST
import Documenter.DOM: escapehtml

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
    Determines whether to clean up the Markdown assets after build, i.e., whether to remove the contents of `md_output_path` after the Vitepress site is built.  
    Options are:
    - `nothing`: **Default**.  Only remove the contents of `md_output_path` if the documentation will deploy, to save space.
    - `true`: Removes the contents of `md_output_path` after the Vitepress site is built.
    - `false`: Does not remove the contents of `md_output_path` after the Vitepress site is built.
    """
    clean_md_output::Union{Nothing, Bool} = nothing
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
end

# return the same file with the extension changed to .md
mdext(f) = string(splitext(f)[1], ".md")

"""
    docpath(file, mdfolder)

This function takes the filename `file`, and returns a file path in the `mdfolder` directory which has the same tree as the `src` directory.  This is used to ensure that the Markdown files are output in the correct location for Vitepress to find them.

"""
function docpath(file, builddir, mdfolder)
    path = relpath(file, builddir)
    filename = mdext(path)
    return joinpath(builddir, mdfolder, filename) 
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
    if isdir(joinpath(sourcedir, "assets")) && !isdir(joinpath(sourcedir, "public"))
        mkpath(joinpath(builddir, settings.md_output_path, "public"))
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
                if normpath(file) != normpath(file_destpath)
                    cp(file, file_destpath; force = true)
                end
            end
        end
    end
     # from `vitepress_config.jl`
    # This needs to be run after favicons and logos are moved to the public subfolder
    modify_config_file(doc, settings, deploy_decision)

    # Iterate over the pages, render each page separately
    for (src, page) in doc.blueprint.pages
        # This is where you can operate on a per-page level.
        open(docpath(page.build, builddir, settings.md_output_path), "w") do io
            for node in page.mdast.children
                render(io, mime, node, page, doc)
            end
        end
    end

    mkpath(joinpath(builddir, "final_site"))
    if isfile(joinpath(builddir, settings.md_output_path, ".vitepress", "config.mts"))
        touch(joinpath(builddir, settings.md_output_path, ".vitepress", "config.mts"))
    end

    # Now that the Markdown files are written, we can build the Vitepress site if required.
    if settings.build_vitepress
        @info "DocumenterVitepress: building Vitepress site."
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
                node(; adjust_PATH = true, adjust_LIBPATH = true) do _
                    if settings.install_npm || should_remove_package_json
                        if !isfile(joinpath(dirname(builddir), "package.json"))
                            cp(joinpath(dirname(@__DIR__), "template", "package.json"), joinpath(dirname(builddir), "package.json"))
                            should_remove_package_json = true
                        end
                        run(`$(npm) install`)
                    end
                    run(`$(npm) run env -- vitepress build $(joinpath(builddir, settings.md_output_path))`)
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
        # This is only useful if placed in the root of the `docs` folder, and we don't 
        # have any names which conflict with Jekyll (beginning with _ or .) in any case.
        # touch(joinpath(builddir, "final_site", ".nojekyll"))

        # Clean up afterwards
        clean_md_output = isnothing(settings.clean_md_output) ? deploy_decision.all_ok : settings.clean_md_output
        if clean_md_output
            @info "DocumenterVitepress: cleaning up Markdown output."
            rm(joinpath(builddir, settings.md_output_path); recursive = true)
            contents = readdir(joinpath(builddir, "final_site"))
            for item in contents
                src = joinpath(builddir, "final_site", item)
                dst = joinpath(builddir, item)
                cp(src, dst)
            end
            rm(joinpath(builddir, "final_site"); recursive = true)

            @info "DocumenterVitepress: Markdown output cleaned up.  Folder looks like:  $(readdir(doc.user.build))"
        end

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
    println(io, "\n<a id='", lstrip(Documenter.anchor_fragment(anchor), '#'), "'></a>")
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

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, docs::Documenter.DocsNode, page, doc; kwargs...)
    # @infiltrate
    open_txt = get(page.globals.meta, :CollapsedDocStrings, false) ? "" : "open"
    anchor_id = Documenter.anchor_label(docs.anchor)
    # Docstring header based on the name of the binding and it's category.
    _badge_text = """<Badge type="info" class="jlObjectType jl$(Documenter.doccat(docs.object))" text="$(Documenter.doccat(docs.object))" />"""
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
            # so clearly we should be inserting some form of HTML tag here, 
            # and defining its rendering in CSS?
            # TODO: switch to Documenter style here
            println(io, "\n", "[source]($url)", "\n")
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

function render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, contents::Documenter.ContentsNode, page, doc; kwargs...)
    for (count, path, anchor) in contents.elements
        path = mdext(path)
        header = anchor.object
        url = string(path, Documenter.anchor_fragment(anchor))
        link = Markdown.Link(anchor.id, replace(url, " " => "%20"))
        level = anchor.order
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
mime_priority(::MIME"text/markdown") = 1.0
mime_priority(::MIME"text/html") = 2.0
mime_priority(::MIME"text/latex") = 2.5
mime_priority(::MIME"image/svg+xml") = 3.0
mime_priority(::MIME"image/png") = 4.0
mime_priority(::MIME"image/webp") = 5.0
mime_priority(::MIME"image/jpeg") = 6.0
mime_priority(::MIME"image/png+lightdark") = 7.0
mime_priority(::MIME"image/jpeg+lightdark") = 8.0
mime_priority(::MIME"image/svg+xml+lightdark") = 9.0
mime_priority(::MIME"image/gif") = 10.0
mime_priority(::MIME"video/mp4") = 11.0

mime_priority(::MIME) = Inf

function render_mime(io::IO, mime::MIME, node, element, page, doc; kwargs...)
    @warn("DocumenterVitepress: Unknown MIME type $mime provided and no alternatives given.  Ignoring render!")
end

function render_mime(io::IO, mime::MIME"text/markdown", node, element, page, doc; kwargs...)
    println(io, element)
end

function render_mime(io::IO, mime::MIME"text/html", node, element, page, doc; kwargs...)
    println(io, element)
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

function render_mime(io::IO, mime::MIME"image/png", node, element, page, doc; md_output_path, kwargs...)
    filename = String(rand('a':'z', 7))
    write(joinpath(doc.user.build, md_output_path, dirname(relpath(page.build, doc.user.build)), "$(filename).png"),
        base64decode(element))
    println(io, "![]($(filename).png)")
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
    return render(io, mime, node, Markdown.Code(element), page, doc; kwargs...)
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, d::Dict{MIME, Any}, page, doc; kwargs...)

    settings_ind = findfirst(x -> x isa MarkdownVitepress, doc.user.format)
    settings = doc.user.format[settings_ind]
    md_output_path = settings.md_output_path

    available_mimes = keys(d)
    if isempty(available_mimes)
        return nothing
    end
    # Sort the available mimes by priority
    sorted_mimes = sort(collect(available_mimes), by = mime_priority)
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
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, text::MarkdownAST.Text, page, doc; kwargs...)
    print(io, escapehtml(text.text))
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
    id = string(Documenter.anchor_label(anchor))
    heading = first(node.children)
    println(io)
    print(io, "#"^(heading.element.level), " ")
    heading_iob = IOBuffer()
    render(heading_iob, mime, node, heading.children, page, doc; kwargs...)
    heading_text = rstrip(String(take!(heading_iob)))
    print(io, heading_text)
    if id != heading_text # if a custom ID is set, then use it.
        print(io, " {#$(replace(id, " " => "-"))}") # potentially use MarkdownAST.mdflatten here?
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
# Images
# Here, we are rendering images as HTML.  It is my hope that at some point we figure out how to render them in Markdown, but for now, this is also perfectly sufficient.
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, image::MarkdownAST.Image, page, doc; kwargs...)
    println()
    url = replace(image.destination, "\\" => "/")
    print(io, "<img src=\"", url, "\" alt=\"")
    render(io, mime, node, node.children, page, doc; kwargs...)
    println(io, "\">")
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
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, link::Documenter.PageLink, page, doc; kwargs...)
    # Main.@infiltrate
    path = if !isempty(link.fragment)
        "/" * replace(Documenter.pagekey(doc, link.page), ".md" => "") * "#" * string(link.fragment)
    else
        Documenter.pagekey(doc, link.page)
    end
    print(io, "[")
    render(io, mime, node, node.children, page, doc; kwargs...)
    print(io, "]($(replace(path, " " => "%20")))")
end

# Documenter.jl local links
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, link::Documenter.LocalLink, page, doc; kwargs...)
    # Main.@infiltrate
    path = isempty(link.fragment) ? link.path : "$(Documenter.pagekey(doc, page))#$(link.fragment)"
    print(io, "[")
    render(io, mime, node, node.children, page, doc; kwargs...)
    print(io, "]($(replace(path, " " => "%20")))")
end

# Documenter.jl local images
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, image::Documenter.LocalImage, page, doc; kwargs...)
    # Main.@infiltrate
    image_path = relpath(joinpath(doc.user.build, image.path), dirname(page.build))
    println(io)
    println(io, "![]($image_path)")
end

import Documenter: Documenter, Builder, Expanders, MarkdownAST

import ANSIColoredPrinters
using Base64: base64decode

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
    "*Required*: The URL of the repository to which the documentation will be deployed.  This must be the full URL, like `rafaqz.github.io/Rasters.jl` or `geo.makie.jl`."
    deploy_url::Union{String, Nothing} = nothing
    "*Required*: The full URL of the repository to which the documentation will be deployed."
    repo::String
    "*Required*: The name of the development branch, like `master` or `main`."
    devbranch::String
    "*Required*: The URL path to the development site, like `dev` or `dev-branch`."
    devurl::String # TODO: hopefully, remove this!
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
    copy_assets(doc, settings.md_output_path)
    # Handle the case where the site name has to be set...
    mime = MIME"text/plain"() # TODO: why?
    builddir = isabspath(doc.user.build) ? doc.user.build : joinpath(doc.user.root, doc.user.build)
    # First, we check what Documenter has copied for us already:
    current_build_files_or_dirs = readdir(builddir)
    # Then, we create a path to the folder where we will emit the markdown,
    mkpath(joinpath(builddir, settings.md_output_path))
    # and copy the previous build files to the new location.
    for file_or_dir in current_build_files_or_dirs
        src = joinpath(builddir, file_or_dir)
        dst = joinpath(builddir, settings.md_output_path, file_or_dir)
        cp(src, dst)
        rm(src; recursive = true)
    end
    # Documenter.jl wants assets in `assets/`, but Vitepress likes them in `public/`,
    # so we rename the folder.
    if isdir(joinpath(builddir, settings.md_output_path, "assets")) && !isdir(joinpath(builddir, settings.md_output_path, "public"))
        mv(joinpath(builddir, settings.md_output_path, "assets"), joinpath(builddir, settings.md_output_path, "public"))
    end
    # Main.@infiltrate
    # Iterate over the pages, render each page separately
    for (src, page) in doc.blueprint.pages
        # This is where you can operate on a per-page level.
        open(docpath(page.build, builddir, settings.md_output_path), "w") do io
            for node in page.mdast.children
                render(io, mime, node, page, doc)
            end
        end
    end

    # We manually obtain the Documenter deploy configuration,
    # so we can use it to set Vitepress's settings.
    # TODO: make it so that the user does not have to provide a repo url!
    deploy_config = Documenter.auto_detect_deploy_system()
    deploy_decision = Documenter.deploy_folder(
        deploy_config;
        repo = settings.repo, # this must be the full URL!
        devbranch = settings.devbranch,
        devurl = settings.devurl,
        push_preview=true,
    )
    
    # from `vitepress_config.jl`
    modify_config_file(doc, settings, deploy_decision)

    # Now that the Markdown files are written, we can build the Vitepress site if required.
    if settings.build_vitepress
        @info "DocumenterVitepress: building Vitepress site."
        # Build the docs using `npm`
        should_remove_package_json = false
        try
            if !isfile(joinpath(dirname(builddir), "package.json"))
                @warn "DocumenterVitepress: Did not find `docs/package.json` in your repository.  Substituting default for now."
                cp(joinpath(dirname(@__DIR__), "docs", "package.json"), joinpath(dirname(builddir), "package.json"))
                cp(joinpath(dirname(@__DIR__), "docs", "package-lock.json"), joinpath(dirname(builddir), "package-lock.json"))
                should_remove_package_json = true
            end

            cd(dirname(builddir)) do
                if settings.install_npm || should_remove_package_json 
                    run(`$(npm) install`)
                end
                run(`$(npm) run docs:build`)
            end
        catch e
            rethrow(e)
        finally
            if should_remove_package_json
                rm(joinpath(dirname(builddir), "package.json"))
                rm(joinpath(dirname(builddir), "package-lock.json"))
            end
        end
        touch(joinpath(builddir, "final_site", ".nojekyll"))

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
    anchor_id = Documenter.anchor_label(docs.anchor)
    # Docstring header based on the name of the binding and it's category.
    println(io,
        "<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>")
    anchor = "<a id='$(anchor_id)' href='#$(anchor_id)'>#</a>"
    header = "&nbsp;<b><u>$(docs.object.binding)</u></b> &mdash; <i>$(Documenter.doccat(docs.object))</i>."
    println(io, anchor, header, "\n\n")
    # Body. May contain several concatenated docstrings.
    renderdoc(io, mime, node, page, doc; kwargs...)
    return println(io, "</div>\n<br>")
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
        println(io, "- [`", object.binding, "`](", url, ")")
    end
    return println(io)
end

function render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, contents::Documenter.ContentsNode, page, doc; kwargs...)
    for (count, path, anchor) in contents.elements
        path = mdext(path)
        header = anchor.object
        url = string(path, Documenter.anchor_fragment(anchor))
        link = Markdown.Link(anchor.id, url)
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
    if lang == "ansi"
        "julia"
    elseif lang == "documenter-ansi"
        "ansi"
    else
        lang
    end
end

function join_multiblock(mcb::Documenter.MultiCodeBlock)
    if mcb.language == "ansi"
        # Return a vector of Markdown code blocks
        # where each block is a single line of the output or input.
        # Basically, we iterate through the code,
        # and whenever the language changes, we
        # start a new code block and push the old one to the array!
        codes = Markdown.Code[]
        current_language = first(mcb.content).language
        current_string = ""
        for thing in mcb.content
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

    end
    # else
        io = IOBuffer()
        for (i, thing) in enumerate(mcb.content)
            print(io, thing.code)
            if i != length(mcb.content)
                println(io)
                if findnext(x -> x.language == mcb.language, mcb.content, i + 1) == i + 1
                    println(io)
                end
            end
        end
        return Markdown.Code(mcb.language, String(take!(io)))
    # end
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, mcb::Documenter.MultiCodeBlock, page, doc; kwargs...)
    return render(io, mime, node, join_multiblock(mcb), page, doc; kwargs...)
end


function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, d::Documenter.MultiOutput, page, doc; kwargs...)
    # @infiltrate
    return render(io, mime, node, node.children, page, doc; kwargs...)
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, d::Documenter.MultiOutputElement, page, doc; kwargs...)
    return render(io, mime, node, d.element, page, doc; kwargs...)
end

# Select the "best" rendering MIME for markdown output!
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, d::Dict{MIME, Any}, page, doc; kwargs...)
    filename = String(rand('a':'z', 7))
    if haskey(d, MIME"text/markdown"())
        println(io, d[MIME"text/markdown"()])
    elseif haskey(d, MIME"text/html"())
        println(io, d[MIME"text/html"()])
    elseif haskey(d, MIME"image/svg+xml"())
        # NOTE: It seems that we can't simply save the SVG images as a file and include them
        # as browsers seem to need to have the xmlns attribute set in the <svg> tag if you
        # want to include it with <img>. However, setting that attribute is up to the code
        # creating the SVG image.
        image_text = d[MIME"image/svg+xml"()]
        # Additionally, Vitepress complains about the XML version and encoding string below,
        # so we just remove this bad hombre!
        bad_hombre_string = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" |> lowercase
        location = findfirst(bad_hombre_string, lowercase(image_text))    
        if !isnothing(location)
            image_text = replace(image_text, image_text[location] => "")
        end
        println(io, image_text)
    elseif haskey(d, MIME"image/png"())
        write(joinpath(dirname(page.build), "$(filename).png"),
            base64decode(d[MIME"image/png"()]))
        println(io,
            """
    ![]($(filename).png)
    """)
    elseif haskey(d, MIME"image/webp"())
        write(joinpath(dirname(page.build), "$(filename).webp"),
            base64decode(d[MIME"image/webp"()]))
        println(io,
            """
    ![]($(filename).webp)
    """)
    elseif haskey(d, MIME"image/jpeg"())
        write(joinpath(dirname(page.build), "$(filename).jpeg"),
            base64decode(d[MIME"image/jpeg"()]))
        println(io,
            """
    ![]($(filename).jpeg)
    """)
    elseif haskey(d, MIME"image/gif"())
        write(joinpath(dirname(page.build), "$(filename).gif"),
            base64decode(d[MIME"image/gif"()]))
        println(io,
            """
    ![]($(filename).gif)
    """)
    elseif haskey(d, MIME"video/mp4"())
        write(joinpath(dirname(page.build), "$(filename).gif"),
            base64decode(d[MIME"image/gif"()]))
        println(io,
            """
    <video src="$filename.mp4" controls="controls" autoplay="autoplay"></video>)
    """)
    elseif haskey(d, MIME"text/plain"())
        text = d[MIME"text/plain"()]
        out = repr(MIME"text/plain"(), ANSIColoredPrinters.PlainTextPrinter(IOBuffer(text)))
        render(io, mime, node, Markdown.Code(out), page, doc; kwargs...)
    else
        error("this should never happen.")
    end
    return nothing
end

## Basic Nodes. AKA: any other content that hasn't been handled yet.

function render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, other, page, doc; kwargs...)
    println(io)
    linkfix = ".md#"
    return println(io, replace(Markdown.plain(other), linkfix => "#"))
end

render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, str::AbstractString, page, doc; kwargs...) = print(io, str)

# Metadata Nodes get dropped from the final output for every format but are needed throughout
# the rest of the build, and so we just leave them in place and print a blank line in their place.
render(io::IO, ::MIME"text/plain", n::Documenter.MarkdownAST.Node, node::Documenter.MetaNode, page, doc; kwargs...) = println(io, "\n")
# In the original AST, SetupNodes were just mapped to empty Markdown.MD() objects.
render(io, mime, node::MarkdownAST.Node, ::Documenter.SetupNode, page, doc; kwargs...) = nothing


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
    print(io, text.text)
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
    print(io, "]($(link.destination))")
end
# Code blocks
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, code::MarkdownAST.CodeBlock, page, doc; kwargs...)
    info = code.info
    if info == "julia-repl"
        info = "julia"
    end
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
    # @infiltrate
    heading = first(node.children)
    println(io)
    print(io, "#"^(heading.element.level), " ")
    render(io, mime, node, heading.children, page, doc; kwargs...)
    print(io, " {#$id}")
    println(io)
end
# Admonitions
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, admonition::MarkdownAST.Admonition, page, doc; kwargs...)
    # Main.@infiltrate
    println(io, "\n::: $(admonition.category) $(admonition.title)")
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
    bullet = list.type === :ordered ? "1. " : "- "
    iob = IOBuffer()
    for item in node.children
        render(iob, mime, item, item.children, page, doc; prenewline = false, kwargs...)
        eachline = split(String(take!(iob)), '\n')
        eachline[2:end] .= "  " .* eachline[2:end]
        print(io, bullet)
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
    println(io, value.ref)
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
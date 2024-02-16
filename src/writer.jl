import Documenter: Documenter, Builder, Expanders, MarkdownAST

import ANSIColoredPrinters
using Base64: base64decode

# import Markdown as Markdown
import Markdown
struct MarkdownVitepress <: Documenter.Writer
end

# return the same file with the extension changed to .md
mdext(f) = string(splitext(f)[1], ".md")

"""
    render(args...)

This is the main entry point and recursive function to render a Documenter document to 
Markdown in the Vitepress flavour.  It is called by `Documenter.build` and should not be
called directly.

## Methods

To extend this function, the general signature is:
```julia
render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, element::Eltype, page, doc)
```
where `Eltype` is the type of the `element` field of the `node` object which you care about.
"""
function render(doc::Documenter.Document, settings::MarkdownVitepress=MarkdownVitepress())
    @info "DocumenterMarkdownVitepress: rendering MarkdownVitepress pages."
    copy_assets(doc)
    mime = MIME"text/plain"() # TODO why?
    # @infiltrate
    # Iterate over the pages, render each page separately
    for (src, page) in doc.blueprint.pages
        open(mdext(page.build), "w") do io
            for node in page.mdast.children
                render(io, mime, node, page, doc)
            end
        end
    end
end

# This function catches all nodes and decomposes them to their elements.
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, page, doc)
    render(io, mime, node, node.element, page, doc)
end

# This function catches nodes dispatched with their children, and renders each child.
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, children::Documenter.MarkdownAST.NodeChildren{<: Documenter.MarkdownAST.Node}, page, doc)
    for child in children
        render(io, mime, child, child.element, page, doc)
    end
end

function copy_assets(doc::Documenter.Document)
    @debug "copying assets to build directory."
    assets = ASSETS
    if isdir(assets)
        builddir = joinpath(doc.user.build, "assets")
        isdir(builddir) || mkdir(builddir)
        for each in readdir(assets)
            src = joinpath(assets, each)
            dst = joinpath(builddir, each)
            ispath(dst) && @warn "DocumenterMarkdownVitepress: overwriting '$dst'."
            cp(src, dst; force=true)
        end
    else
        @warn "DocumenterMarkdownVitepress: no assets directory found."
    end
end

function render(io::IO, mime::MIME"text/plain", vec::Vector, page, doc)
    for each in vec
        render(io, mime, each, page, doc)
    end
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, anchor::Documenter.Anchor, page, doc)
    println(io, "\n<a id='", lstrip(Documenter.anchor_fragment(anchor), '#'), "'></a>")
    return render(io, mime, node, anchor.object, page, doc)
end


## Documentation Nodes.

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, docblock::Documenter.DocsNodesBlock, page, doc)
    render(io, mime, node, node.children, page, doc)
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, docs::Documenter.DocsNodes, page, doc)
    for docstr in docs.docs
        render(io, mime, docstr, page, doc)
    end
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, docs::Documenter.DocsNode, page, doc)
    # @infiltrate
    anchor_id = Documenter.anchor_label(docs.anchor)
    # Docstring header based on the name of the binding and it's category.
    println(io,
        "<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>")
    anchor = "<a id='$(anchor_id)' href='#$(anchor_id)'>#</a>"
    header = "&nbsp;<b><u>$(docs.object.binding)</u></b> &mdash; <i>$(Documenter.doccat(docs.object))</i>."
    println(io, anchor, header, "\n\n")
    # Body. May contain several concatenated docstrings.
    renderdoc(io, mime, node, page, doc)
    return println(io, "</div>\n<br>")
end

function renderdoc(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, page, doc)
    @assert node.element isa Documenter.DocsNode
    # The `:results` field contains a vector of `Docs.DocStr` objects associated with
    # each markdown object. The `DocStr` contains data such as file and line info that
    # we need for generating correct source links.
    for (docstringast, result) in zip(node.element.mdasts, node.element.results)
        println(io)
        render(io, mime, docstringast, docstringast.children, page, doc)
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

function renderdoc(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, other, page, doc)
    # TODO: properly support non-markdown docstrings at some point.
    return render(io, mime, other, page, doc)
end

## Index, Contents, and Eval Nodes.

function render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, index::Documenter.IndexNode, page, doc)
    for (object, _, page, mod, cat) in index.elements
        page = mdext(page)
        url = string("#", Documenter.slugify(object))
        println(io, "- [`", object.binding, "`](", url, ")")
    end
    return println(io)
end

function render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, contents::Documenter.ContentsNode, page, doc)
    for (count, path, anchor) in contents.elements
        path = mdext(path)
        header = anchor.object
        url = string(path, Documenter.anchor_fragment(anchor))
        link = Markdown.Link(header.text, url)
        level = Documenter.header_level(header)
        print(io, "    "^(level - 1), "- ")
        linkfix = ".md#"
        println(io, replace(Markdown.plaininline(link), linkfix => "#"))
    end
    return println(io)
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, evalnode::Documenter.EvalNode, page, doc)
    return evalnode.result === nothing ? nothing : render(io, mime, node, evalnode.result, page, doc)
end

function join_multiblock(mcb::Documenter.MultiCodeBlock)
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
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, mcb::Documenter.MultiCodeBlock, page, doc)
    return render(io, mime, node, join_multiblock(mcb), page, doc)
end


function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, d::Documenter.MultiOutput, page, doc)
    # @infiltrate
    return render(io, mime, node, node.children, page, doc)
end

function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, d::Documenter.MultiOutputElement, page, doc)
    return render(io, mime, node, d.element, page, doc)
end

# Select the "best" rendering MIME for markdown output!
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, d::Dict{MIME, Any}, page, doc)
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
        println(io, d[MIME"image/svg+xml"()])
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
        render(io, mime, node, Markdown.Code(out), page, doc)
    else
        error("this should never happen.")
    end
    return nothing
end

## Basic Nodes. AKA: any other content that hasn't been handled yet.

function render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, other, page, doc)
    println(io)
    linkfix = ".md#"
    return println(io, replace(Markdown.plain(other), linkfix => "#"))
end

render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, str::AbstractString, page, doc) = print(io, str)

# Metadata Nodes get dropped from the final output for every format but are needed throughout
# the rest of the build, and so we just leave them in place and print a blank line in their place.
render(io::IO, ::MIME"text/plain", n::Documenter.MarkdownAST.Node, node::Documenter.MetaNode, page, doc) = println(io, "\n")
# In the original AST, SetupNodes were just mapped to empty Markdown.MD() objects.
render(io, mime, node::MarkdownAST.Node, ::Documenter.SetupNode, page, doc) = nothing


# Raw nodes are used to insert raw HTML into the output. We just print it as is.
# TODO: what if the `raw` is not HTML?
function render(io::IO, ::MIME"text/plain", node::Documenter.MarkdownAST.Node, raw::Documenter.RawNode, page, doc)
    return raw.name === :html ? println(io, raw.text, "\n") : nothing
end

# This is straight Markdown to Markdown, so no issues for most of these!

# Paragraphs - they have special regions _and_ plain text
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, ::MarkdownAST.Paragraph, page, doc)
    # println(io)
    render(io, mime, node, node.children, page, doc)
    println(io)
end
# Plain text
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, text::MarkdownAST.Text, page, doc)
    print(io, text.text)
end
# Bold text (strong)
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, strong::MarkdownAST.Strong, page, doc)
    # @infiltrate
    print(io, "**")
    render(io, mime, node, node.children, page, doc)
    print(io, "**")
end
# Italic text (emph)
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, emph::MarkdownAST.Emph, page, doc)
    print(io, "_")
    render(io, mime, node, node.children, page, doc)
    print(io, "_")
end
# Links
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, link::MarkdownAST.Link, page, doc)
    # @infiltrate
    print(io, "<a href=\"$(link.destination)\">")
    render(io, mime, node, node.children, page, doc)
    print(io, "</a>")
end
# Code blocks
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, code::MarkdownAST.CodeBlock, page, doc)
    render(io, mime, node, Markdown.Code(code.info, code.code), page, doc)
end
# Inline code
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, code::MarkdownAST.Code, page, doc)
    print(io, "`", code.code, "`")
end
# Headers
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, header::Documenter.AnchoredHeader, page, doc)
    anchor = header.anchor
    id = string(hash(Documenter.anchor_label(anchor)))
    # @infiltrate
    heading = first(node.children)
    println(io)
    print(io, "#"^(heading.element.level), " ")
    render(io, mime, node, heading.children, page, doc)
    print(io, " {#$id}")
    println(io)
end
# Admonitions
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, admonition::MarkdownAST.Admonition, page, doc)
    # @infiltrate
    println(io, "\n::: $(admonition.category) $(admonition.title)")
    render(io, mime, node, node.children, page, doc)
    println(io, "\n:::")
end
# Lists

# function latex(io::Context, node::Node, list::MarkdownAST.List)
#     # TODO: MarkdownAST doesn't support lists starting at arbitrary numbers
#     isordered = (list.type === :ordered)
#     ordered = (list.type === :bullet) ? -1 : 1
#     # `\begin{itemize}` is used here for both ordered and unordered lists since providing
#     # custom starting numbers for enumerated lists is simpler to do by manually assigning
#     # each number to `\item` ourselves rather than using `\setcounter{enumi}{<start>}`.
#     #
#     # For an ordered list starting at 5 the following will be generated:
#     #
#     # \begin{itemize}
#     #   \item[5. ] ...
#     #   \item[6. ] ...
#     #   ...
#     # \end{itemize}
#     #
#     pad = ndigits(ordered + length(node.children)) + 2
#     fmt = n -> (isordered ? "[$(rpad("$(n + ordered - 1).", pad))]" : "")
#     wrapblock(io, "itemize") do
#         for (n, item) in enumerate(node.children)
#             _print(io, "\\item$(fmt(n)) ")
#             latex(io, item.children)
#             n < length(node.children) && _println(io)
#         end
#     end
# end


function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, list::MarkdownAST.List, page, doc)
    # @infiltrate
    if list.type === :ordered
        println(io)
        for (i, item) in enumerate(node.children)
            print(io, "$(i). ")
            render(io, mime, item, item.children, page, doc)
            print(io, "\n")
        end
    else
        for item in node.children
            print(io, "- ")
            render(io, mime, item, item.children, page, doc)
            print(io, "\n")
        end
    end
end
# Images
function render(io::IO, mime::MIME"text/plain", node::Documenter.MarkdownAST.Node, image::MarkdownAST.Image, page, doc)
    println()
    url = replace(image.destination, "\\" => "/")
    print(io, "<img src=\"", url, "\" alt=\"")
    render(io, mime, node, node.children, page, doc)
    println(io, "\">")
end
# Interpolated Julia values
function render(io::IO, mime::MIME"text/plain", node::MarkdownAST.Node, value::MarkdownAST.JuliaValue, page, doc)
    @warn("""
    Unexpected Julia interpolation in the Markdown. This probably means that you
    have an unbalanced or un-escaped \$ in the text.

    To write the dollar sign, escape it with `\\\$`

    We don't have the file or line number available, but we got given the value:

    `$(value.ref)` which is of type `$(typeof(value.ref))`
    """)
    println(io, value.ref)
end
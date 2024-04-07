module DocumenterVitepressDocumenterCitationsExt

using DocumenterCitations, DocumenterVitepress

import DocumenterVitepress as DV

# TODO: 
# - List style (rendered vs unrendered)
# - Loose vs tight lists
function DV.render(io::IO, mime::MIME"text/plain", node, bibliography::DocumenterCitation.BibliographyNode, page, doc; kwargs...)

    println(io)
    println(io, "***")
    println(io, "# Bibliography")
    println(io)

    # Generate a `Markdown.List` which can be rendered by the Vitepress renderer
    items = String[]
    iob = IOBuffer()
    for item in bibliography.items
        render(iob, mime, node, item.reference.children, page, doc; kwargs...)\\
        push!(items, String(take!(iob)))
    end

    # Render that list via the Markdown stdlib, so we don't have to worry about the fiddly bits
    return DV.render(io, mime, node, Markdown.List(items, bibliography_style == :ol ? 1 : 0, false), page, doc; kwargs...)
end

#=
function Documenter.LaTeXWriter.latex(
    lctx::Documenter.LaTeXWriter.Context,
    node::MarkdownAST.Node,
    bibliography::BibliographyNode
)

    if bibliography.list_style == :ol
        texenv = "enumerate"
    elseif bibliography.list_style == :ul
        if _LATEX_OPTIONS[:ul_as_hanging]
            texenv = nothing
        else
            texenv = "itemize"
        end
    else
        @assert bibliography.list_style == :dl
        # We emulate a definition list manually with hangindent and labelwidth
        texenv = nothing
    end

    io = lctx.io

    function tex_item(n, item)
        if bibliography.list_style == :ul
            if _LATEX_OPTIONS[:ul_as_hanging]
                print(io, "\\hangindent=$(_LATEX_OPTIONS[:ul_hangindent]) ")
            else
                print(io, "\\item ")
            end
        elseif bibliography.list_style == :ol  # enumerate
            print(io, "\\item ")
        else
            @assert bibliography.list_style == :dl
            print(io, "\\hangindent=$(_LATEX_OPTIONS[:dl_hangindent]) {")
            _labelbox(io; width=_LATEX_OPTIONS[:dl_labelwidth]) do
                Documenter.LaTeXWriter.latex(lctx, item.label.children)
            end
            print(io, "}")
        end
    end

    println(io, "{$(_LATEX_OPTIONS[:bib_blockformat])% @bibliography\n")
    _wrapblock(io, texenv) do
        for (n, item) in enumerate(bibliography.items)
            tex_item(n, item)
            if !isnothing(item.anchor_key)
                id = _hash(item.anchor_key)
                print(io, "\\hypertarget{", id, "}{}")
            end
            Documenter.LaTeXWriter.latex(lctx, item.reference.children)
            print(io, "\n\n")
        end
    end
    println(io, "}% end @bibliography")

end

=#

end
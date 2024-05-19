module DocumenterVitepressDocumenterCitationsExt

using DocumenterCitations, DocumenterVitepress

import DocumenterVitepress as DV
using Documenter: MarkdownAST

# TODO: 
# - List style (rendered vs unrendered)
# - Loose vs tight lists
# - handle :dl properly, we cannot use Markdown for this, since it cannot be represented
#   using pure Markdown. We need to insert HTML directly.
#   At the moment, we treat :dl as :ol
function DV.render(io::IO, mime::MIME"text/plain", node::DV.MarkdownAST.Node, bibliography::DocumenterCitations.BibliographyNode, page, doc; kwargs...)

    println(io)
    println(io, "***")
    println(io, "# Bibliography")
    println(io)

    # Turn the list into a proper MarkdownAST.node
    bibnode = _bibliography_to_list(bibliography)

    return DV.render(io, mime, bibnode, bibnode.element, page, doc; kwargs...)
end

function _bibliography_to_list(bib::DocumenterCitations.BibliographyNode)
  # Construct a MarkdownAST.Node containing this list
  list = MarkdownAST.List(bib.list_style in [:ol, :dl] ? :ordered : :bullet, false)
  node = MarkdownAST.Node(list)
  for item in bib.items
    newitem = MarkdownAST.Node(MarkdownAST.Item())
    push!(newitem.children, item.reference)
    push!(node.children, newitem)
  end
  node
end

# Below is the code intended for LaTeXWriter.
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

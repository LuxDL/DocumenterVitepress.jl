module DocumenterVitepressDocumenterCitationsExt

using DocumenterCitations, DocumenterVitepress

import DocumenterVitepress as DV
using Documenter: Documenter, MarkdownAST
using .MarkdownAST: @ast


# CitationSiteNode is an HTML-only wrapper whose child is the actual
# citation link. For VitePress/Markdown it should be transparent.
function DV.render(
    io::IO,
    ::MIME"text/plain",
    node::MarkdownAST.Node,
    ::DocumenterCitations.CitationSiteNode,
    page,
    doc;
    kwargs...
)
    return DV.render(
        io,
        MIME"text/plain"(),
        node,
        node.children,
        page,
        doc;
        kwargs...
    )
end


# BibliographyNode needs to be converted to a Markdown list for VitePress.
function DV.render(
    io::IO,
    ::MIME"text/plain",
    node::MarkdownAST.Node,
    bibliography::DocumenterCitations.BibliographyNode,
    page,
    doc;
    kwargs...
)
    bibnode = _bibliography_to_list(bibliography)

    return DV.render(
        io,
        MIME"text/plain"(),
        bibnode,
        bibnode.element,
        page,
        doc;
        kwargs...
    )
end


function _bibliography_to_list(
    bib::DocumenterCitations.BibliographyNode,
)
    list = MarkdownAST.List(
        bib.list_style in (:ol, :dl) ? :ordered : :bullet,
        false,
    )

    node = MarkdownAST.Node(list)

    for item in bib.items
        newitem = MarkdownAST.Node(MarkdownAST.Item())

        # Do not add the anchor here. DocumenterCitations 1.5.0
        # manages citation-site anchors/backlinks itself.
        push!(newitem.children, item.reference)

        push!(node.children, newitem)
    end

    return node
end

end

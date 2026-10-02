module DocumenterVitepressDocumenterCitationsExt

using DocumenterCitations, DocumenterVitepress

import DocumenterVitepress as DV
using Documenter: Documenter, MarkdownAST
using .MarkdownAST: @ast


# Register CitationPreview Vue component when show_hover is enabled on CitationBibliography
function DV.vitepress_components(bib::DocumenterCitations.CitationBibliography)
    if bib.show_hover
        return [
            (name = "CitationPreview", import_path = "@/CitationPreview.vue")
        ]
    end
    return @NamedTuple{name::String, import_path::String}[]
end


# CitationSiteNode is an AST node that wraps citation links at a citation site.
# We render the target anchor for backlinks (if any) and render the children,
# wrapping in <CitationPreview> if hover preview is enabled.
function DV.render(
    io::IO,
    ::MIME"text/plain",
    node::MarkdownAST.Node,
    citation_site::DocumenterCitations.CitationSiteNode,
    page,
    doc;
    kwargs...
)
    bib = try
        Documenter.getplugin(doc, DocumenterCitations.CitationBibliography)
    catch
        nothing
    end
    show_hover = (bib !== nothing && bib.show_hover)

    if show_hover
        print(io, "<CitationPreview>")
    end

    if !isempty(citation_site.id)
        print(io, "<a id='", citation_site.id, "'></a>")
    end

    res = DV.render(
        io,
        MIME"text/plain"(),
        node,
        node.children,
        page,
        doc;
        kwargs...
    )

    if show_hover
        print(io, "</CitationPreview>")
    end

    return res
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
        reference = item.reference

        if item.anchor_key !== nothing
            pushfirst!(
                reference.children,
                @ast MarkdownAST.HTMLInline(
                    join(["<a id='", item.anchor_key, "'></a>"])
                )
            )
        end

        push!(newitem.children, reference)
        push!(node.children, newitem)
    end

    return node
end

end

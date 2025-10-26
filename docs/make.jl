using Documenter
using DocumenterVitepress
using DocumenterCitations
using DocumenterInterLinks
using LaTeXStrings

struct DecomposeInSidebar
    path::String
    pages::Any
end

# So you can only really pull this trick once in a Julia session
# But because doc.user.pages is a Vector{Any}, we can't really do anything about it.
function DocumenterVitepress.pagelist2str(doc, ds::Vector{<: Any}, ::Val{:sidebar})
    println("Hello World!!!")
    if !all(x -> x isa DecomposeInSidebar, ds)
        # if this is false, invoke the default method.
        return invoke(pagelist2str, Tuple{Any, Any, Val{:sidebar}}, doc, ds, Val(:sidebar))
    end
    contents = DocumenterVitepress.pagelist2str.((doc,), ds, (Val(:sidebar),))
    ret = "{\n" * join(contents, ",\n") * "\n}"
    println(ret)
    return ret
end

function DocumenterVitepress.pagelist2str(doc, ds::DecomposeInSidebar, ::Val{:sidebar})
    raw_contents = DocumenterVitepress.pagelist2str(doc, ds.pages, Val(:sidebar))
    contents = if raw_contents isa String
        raw_contents
    else
        join(raw_contents, ",\n")
    end

    return "\"/$(ds.path)/\": {\n$(contents)\n}"
end

function DocumenterVitepress.pagelist2str(doc, ds::DecomposeInSidebar, ::Val{:navbar})
    return DocumenterVitepress.pagelist2str(doc, ds.pages, Val(:sidebar))
end

function Documenter.walk_navpages(ds::DecomposeInSidebar, parent, doc)
    return Documenter.walk_navpages(ds.pages, parent, doc)
end


# Handle DocumenterCitations integration - if you're running this, then you don't need anything here!!
documenter_citations_dir = dirname(dirname(pathof(DocumenterCitations)))
documenter_citations_docs_dir = joinpath(documenter_citations_dir, "docs")
# Copy over the DocumenterCitations docs
# At this point, we can't copy them over, since there are a lot of `@ref`s that are
# internal to the DC documentation.
# cp(joinpath(documenter_citations_docs_dir, "src", "refs.bib"), joinpath(@__DIR__, "src", "refs.bib"))
# if !occursin("Gallery", read(joinpath(@__DIR__, "src", "citations.md"), String))
#     open(joinpath(@__DIR__, "src", "citations.md"); append = true, write = true) do io
#         write(io, read(joinpath(documenter_citations_docs_dir, "src", "gallery.md"), String))
#     end
# end
include(joinpath(documenter_citations_docs_dir, "custom_styles", "enumauthoryear.jl"))
include(joinpath(documenter_citations_docs_dir, "custom_styles", "keylabels.jl"))
# End DocumenterCitation integration code.  Below is what you need to actually run DC.


bib = CitationBibliography(
    joinpath(@__DIR__, "src", "refs.bib");
    style=:numeric  # default
)

# Handle DocumenterInterLinks integration
links = InterLinks(
    "sphinx" => "https://www.sphinx-doc.org/en/master/",
    "Documenter" => (
        "https://documenter.juliadocs.org/stable/",
        "https://documenter.juliadocs.org/stable/objects.inv",
    ),
);


# dev local

makedocs(; 
    sitename = "DocumenterVitepress", 
    authors = "LuxDL et al.",
    modules = [DocumenterVitepress],
    warnonly = true,
    checkdocs=:all,
    format=DocumenterVitepress.MarkdownVitepress(
        repo = "github.com/LuxDL/DocumenterVitepress.jl", # this must be the full URL!
        devbranch = "master",
        devurl = "dev";
    ),
    draft = false,
    source = "src",
    build = "build",
    pages = [
        DecomposeInSidebar("manual", "Manual" => [
            "Get Started" => "manual/get_started.md",
            "Updating to DocumenterVitepress" => "manual/documenter_to_vitepress_docs_example.md",
            "Code" => "manual/code_example.md",
            "Markdown" => "manual/markdown-examples.md",
            "MIME output" => "manual/mime_examples.md",
            "DocumenterCitations integration" => "manual/citations.md",
            "CSS Styling" => "manual/style_css.md",
            "Authors' badge" => "manual/author_badge.md",
            "GitHub Icon with Stars" => "manual/repo_stars.md",
        ]),
        DecomposeInSidebar("devs", "Developers' documentation" => [
            "The rendering process" => "devs/render_pipeline.md",
            "Internal API" => "devs/internal_api.md",
        ]),
    ],
    plugins = [bib, links],
)

DocumenterVitepress.deploydocs(;
    repo = "github.com/LuxDL/DocumenterVitepress.jl", # this must be the full URL!
    devbranch = "master",
    push_preview = true,
)

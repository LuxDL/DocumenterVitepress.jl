using Documenter
using DocumenterVitepress
using DocumenterCitations

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

makedocs(; 
    sitename = "DocumenterVitepress", 
    authors = "LuxDL et al.",
    modules = [DocumenterVitepress],
    warnonly = true,
    checkdocs=:all,
    format=DocumenterVitepress.MarkdownVitepress(
        repo = "github.com/LuxDL/DocumenterVitepress.jl", # this must be the full URL!
        devbranch = "master",
        devurl = "dev",
    ),
    draft = false,
    source = "src",
    build = "build",
    pages = [
        "Home" => "index.md",
        "Getting started" => "getting_started.md",
        "Examples" => [
            "Code" => "code_example.md",
            "Markdown" => "markdown-examples.md",
            "MIME output" => "mime_examples.md",
            "Updating to DocumenterVitepress" => "documenter_to_vitepress_docs_example.md",
            "DocumenterCitations integration" => "citations.md",

        ],
        "Developers' documentation" => [
            "The rendering process" => "render_pipeline.md",
        ],
        "api.md",
    ],
    plugins = [bib,],
)


deploydocs(; 
    repo = "github.com/LuxDL/DocumenterVitepress.jl", # this must be the full URL!
    target = "build", # this is where Vitepress stores its output
    branch = "gh-pages",
    devbranch = "master",
    push_preview = true
)

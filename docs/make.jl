using Documenter
using DocumenterVitepress
using DocumenterVitepress: DecomposeInSidebar
using DocumenterCitations
using DocumenterInterLinks
using LaTeXStrings

# Include custom styles for `citations.md` here instead of inside 
# the markdown file to avoid Documenter world-age method errors.
documenter_citations_dir = pkgdir(DocumenterCitations)
documenter_citations_docs_dir = joinpath(documenter_citations_dir, "docs")

include(joinpath(documenter_citations_docs_dir, "custom_styles", "enumauthoryear.jl"))
include(joinpath(documenter_citations_docs_dir, "custom_styles", "keylabels.jl"))
# End DocumenterCitations custom styles integration.


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
        devbranch = "main",
        devurl = "dev",
        sidebar_drawer = true;
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
            "Video Embedding" => "manual/video_embedding.md",
            "DocumenterCitations integration" => "manual/citations.md",
            "CSS Styling" => "manual/style_css.md",
            "Authors' badge" => "manual/author_badge.md",
            "GitHub Icon with Stars" => "manual/repo_stars.md",
        ]),
        "Developers' documentation" => [
            "The rendering process" => "devs/render_pipeline.md",
            "Internal API" => "devs/internal_api.md",
        ],
        "api.md",
    ],
    plugins = [bib, links],
)

DocumenterVitepress.deploydocs(;
    repo = "github.com/LuxDL/DocumenterVitepress.jl", # this must be the full URL!
    devbranch = "main",
    push_preview = true,
)

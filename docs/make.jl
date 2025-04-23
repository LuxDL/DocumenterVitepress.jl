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
# dev local

makedocs(; 
    sitename = "DocumenterVitepress", 
    authors = "LuxDL et al.",
    modules = [DocumenterVitepress],
    warnonly = true,
    checkdocs=:all,
    format=DocumenterVitepress.MarkdownVitepress(
        repo = "github.com/jkrumbiegel/DocumenterVitepress.jl", # this must be the full URL!
        devbranch = "master",
        devurl = "dev";
    ),
    draft = false,
    source = "src",
    build = "build",
    pages = [
        "Manual" => [
            "Get Started" => "manual/get_started.md",
            "Updating to DocumenterVitepress" => "manual/documenter_to_vitepress_docs_example.md",
            "Code" => "manual/code_example.md",
            "Markdown" => "manual/markdown-examples.md",
            "MIME output" => "manual/mime_examples.md",
            "DocumenterCitations integration" => "manual/citations.md",
            "CSS Styling" => "manual/style_css.md",
            "Authors' badge" => "manual/author_badge.md",
            "GitHub Icon with Stars" => "manual/repo_stars.md",
        ],
        "Developers' documentation" => [
            "The rendering process" => "devs/render_pipeline.md",
            "Internal API" => "devs/internal_api.md",
        ],
        "api.md",
    ],
    plugins = [bib,],
)

# if we actually deploy then the builds will have moved from final_sites into build.
# we could also deploy all versions at once but `deploydocs` is written for just one
# folder, so let's loop for now
for dir in readdir(joinpath(@__DIR__, "build"), join = true)
    isdir(dir) || continue
    deploydocs(; 
        repo = "github.com/jkrumbiegel/DocumenterVitepress.jl", # this must be the full URL!
        target = dir, # each version built has its own dir
        branch = "gh-pages",
        devbranch = "master",
        push_preview = true,
        versions = nothing, # we handle this ourselves using the multiple folders
    )
end

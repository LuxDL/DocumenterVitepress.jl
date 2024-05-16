using Documenter
using DocumenterVitepress

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
        "Home" => "index.md",
        "Getting started" => "getting_started.md",
        "Examples" => [
            "Code" => "code_example.md",
            "Markdown" => "markdown-examples.md",
            "MIME output" => "mime_examples.md",
            "Updating to DocumenterVitepress" => "documenter_to_vitepress_docs_example.md"

        ],
        "For Developers" => "render_pipeline.md",
        "api.md",
    ]
)


deploydocs(; 
    repo = "github.com/LuxDL/DocumenterVitepress.jl", # this must be the full URL!
    target = "build", # this is where Vitepress stores its output
    branch = "gh-pages",
    devbranch = "master",
    push_preview = true
)

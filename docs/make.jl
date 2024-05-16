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
        devurl = "dev",
        redirect_trailing_slash = true;
    ),
    draft = false,
    source = "src",
    build = "build",
    pages = [
        "DocumenterVitepress.jl" => "index.md",
        "Getting started" => "getting_started.md",
        "api.md",
        "Examples" => [
            "Code examples" => "code_example.md",
            "Markdown examples" => "markdown-examples.md",
            "MIME output examples" => "mime_examples.md"
        ],
        "Developers' documentation" => "render_pipeline.md",
    ]
)


deploydocs(; 
    repo = "github.com/LuxDL/DocumenterVitepress.jl", # this must be the full URL!
    target = "build", # this is where Vitepress stores its output
    branch = "gh-pages",
    devbranch = "master",
    push_preview = true
)

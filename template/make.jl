using Documenter, DocumenterVitepress

using YourPackage

makedocs(;
    modules=[YourPackage],
    authors="Your Name Here",
    repo="https://github.com/YourGithubUsername/YourPackage.jl",
    sitename="Chairmarks.jl",
    format=DocumenterVitepress.MarkdownVitepress(
        repo = "https://github.com/YourGithubUsername/YourPackage.jl",
        devurl = "dev",
        deploy_url = "yourgithubusername.github.io/YourPackage.jl",
    ),
    pages=[
        "Home" => "index.md",
    ],
    warnonly = true,
)

deploydocs(;
    repo="github.com/YourGithubUsername/YourPackage.jl",
    push_preview=true,
)

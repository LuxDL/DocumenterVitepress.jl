using DocumenterCitations

@testset "citation previews in rendered pages" begin
    mktempdir() do root
        mkpath(joinpath(root, "src"))
        write(joinpath(root, "src", "refs.bib"), """
        @article{Example2024,
            author = {Example, Alice},
            title = {A reference for testing citation previews},
            year = {2024},
            journal = {Example Journal}
        }
        """)
        write(joinpath(root, "src", "index.md"), """
        # Citations

        Inline [Example2024](@cite).

        - [Custom citation text](@cite Example2024)

        1. [Example2024](@citet)
        """)
        write(joinpath(root, "src", "references.md"), """
        # References

        Same-page citation: [Example2024](@cite).

        ```@bibliography
        ```
        """)
        bib = CitationBibliography(joinpath(root, "src", "refs.bib"); style = :authoryear)
        makedocs(;
            root,
            sitename = "Citation previews",
            remotes = nothing,
            format = DocumenterVitepress.MarkdownVitepress(;
                repo = "github.com/LuxDL/DocumenterVitepress.jl",
                devbranch = "main",
            ),
            pages = ["index.md", "references.md"],
            plugins = [bib],
        )
        html = read(joinpath(root, "build", "1", "index.html"), String)
        references = read(joinpath(root, "build", "1", "references.html"), String)
        # Each citation must be an actual link, including the direct citation at the
        # start of a list item. Without inlineTags, that item's Markdown stays literal.
        @test length(collect(eachmatch(r"href=\"[^\"]*references(?:\.html)?#Example2024\"", html))) == 3
        @test !occursin("](/references#Example2024)", html)
        @test occursin("Custom citation text</a>", html)
        @test length(collect(eachmatch(r"class=\"dv-citation-wrapper\"", html))) == 3
        @test occursin("id=\"Example2024\"", references)
    end
end

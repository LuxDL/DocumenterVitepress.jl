using Documenter, DocumenterVitepress

makedocs(
    sitename = "DocumenterVitepress Test Site",
    modules = [DocumenterVitepress],
    format = MarkdownVitepress(;
        repo = "https://github.com/JuliaDocs/DocumenterVitepress.jl",
        build_vitepress = true,
        clean_md_output = false,
        inventory_version = "0.1.0",
    ),
    pages = [
        "Home" => "index.md",
        "API" => "api.md"
    ],
    root = joinpath(@__DIR__, "sites"),
    source = "inventory",
    build = "build_inventory",
    warnonly = true,
)

using Gumbo, Cascadia, DocInventories

inv = Inventory(joinpath(@__DIR__, "sites", "build_inventory", "final_site", "objects.inv"))
index_h = Gumbo.parsehtml(read(joinpath(@__DIR__, "sites", "build_inventory", "final_site", "index.html"), String))
api_h = Gumbo.parsehtml(read(joinpath(@__DIR__, "sites", "build_inventory", "final_site", "api.html"), String))
using Test
# TODO: links to APIs fail in DocInventories,
# but they work fine in the browser...
for item in getindex.((inv,), 3:length(inv))
    uri = DocInventories.uri(item)
    @testset let uri = uri
        if startswith(uri, "index")
            uri == "index" && continue
            @test length(eachmatch(Selector(uri[length("index") + 1:end]), index_h.root)) == 1
        elseif startswith(item.uri, "api")
            uri == "api" && continue
            @test length(eachmatch(Selector(uri[length("api") + 1:end]), api_h.root)) == 1
        end
    end
end
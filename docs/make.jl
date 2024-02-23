using Documenter
using DocumenterVitepress

makedocs(; sitename="DocumenterVitepress", 
    authors="LuxDL et al.",
    modules=[DocumenterVitepress],
    warnonly = true,
    checkdocs=:all,
    format=DocumenterVitepress.MarkdownVitepress(
        repo = "github.com/LuxDL/DocumenterVitepress.jl", # this must be the full URL!
        devbranch = "master",
        devurl = "dev",
    ),
    draft=false,
    source="src",
    build=joinpath(@__DIR__, "build")
    )

# To edit the sidebar, you must edit `docs/src/.vitepress/config.mts`.


# println("Deploying to $folder")
# vitepress_config_file = joinpath(@__DIR__, "build", ".vitepress", "config.mts")
# config = read(vitepress_config_file, String)
# new_config = replace(
#     config, 
#     "base: 'REPLACE_ME_WITH_DOCUMENTER_VITEPRESS_BASE_URL_WITH_TRAILING_SLASH'" => "base: '/DocumenterVitepress.jl/$(folder)$(isempty(folder) ? "" : "/")'"
# )
# write(vitepress_config_file, new_config)

# # Build the docs using `npm` - we are assuming it's installed here!
# haskey(ENV, "CI") && begin
#     cd(@__DIR__) do
#         run(`npm run docs:build`)
#     end
#     touch(joinpath(@__DIR__, "build", ".vitepress", "dist", ".nojekyll"))
# end

deploydocs(; 
    repo="github.com/LuxDL/DocumenterVitepress.jl", # this must be the full URL!
    target="build/.vitepress/dist", # this is where Vitepress stores its output
    branch = "gh-pages",
    devbranch="master",
    push_preview = true
)
# Upgrading docs from Documenter.jl to DocumenterVitepress.jl

Assuming that your current documentation is based on Documenter.jl, you can upgrade to DocumenterVitepress.jl by following these steps:

1. Install DocumenterVitepress.jl using the following julia command in your package's environment:

```julia
using Pkg
Pkg.add("DocumenterVitepress")
```

2. Now go the the `make.jl` file in your `docs` folder and do the following necessary changes to upgrade to DocumenterVitepress.jl :


   a. The `make.jl` file with `Documenter,jl` look like this:

```julia
using OMOPCDMPathways
using Documenter

DocMeta.setdocmeta!(test, :DocTestSetup, :(using test); recursive=true)

makedocs(;
    modules=[test],
    authors="jay-sanjay <landgejay124@gmail.com> and contributors",
    sitename="OMOPCDMPathways.jl",
    format=Documenter.HTML(;
        canonical="https://jay-sanjay.github.io/OMOPCDMPathways.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Tutorials" => "tutorials.md",
        "Api" => "api.md",
        "Contributing" => "contributing.md"
    ],
)

deploydocs(;
    repo="github.com/jay-sanjay/OMOPCDMPathways.jl",
    devbranch="main",
)

``` 



  b. The same `make.jl` file with `DocumenterVitepress.jl` will look like this:

```julia
using OMOPCDMPathways
using Documenter
using DocumenterVitepress

DocMeta.setdocmeta!(OMOPCDMPathways, :DocTestSetup, :(using OMOPCDMPathways); recursive=true)

pgs=[
    "Home" => "index.md",
    "Tutorials" => "tutorials.md",
    "Api" => "api.md",
    "Contributing" => "contributing.md"
]

fmt  = DocumenterVitepress.MarkdownVitepress(
    repo="https://github.com/JuliaHealth/OMOPCDMPathways.jl",
    devbranch = "main",
    devurl = "dev"
)

makedocs(;
    modules = [OMOPCDMPathways],
    repo = Remotes.GitHub("JuliaHealth", "OMOPCDMPathways.jl"),
    authors = "Jay-sanjay <landgejay124@gmail.com>, and contributors",
    sitename = "OMOPCDMPathways.jl",
    format = fmt,
    pages = pgs,
    warnonly = true,
    draft = false,
    source = "src",
    build = "build",
    checkdocs=:all
)

deploydocs(;
    repo="github.com/JuliaHealth/OMOPCDMPathways.jl",
    target="build", # this is where Vitepress stores its output
    devbranch = "main",
    branch = "gh-pages",
    push_preview = true
)

```
3. Then run the following julia command to generate the template to populate all of the files which Vitepress requires:

```julia
DocumenterVitepress.generate_template("/path/to/YourPackage/docs", "YourPackage.jl")
```

4. Finally in order to see the live preview of your documentation, run the following two bash commands in the docs folder:

```julia
npm i
```
The above command shall create a folder named `node_modules` and `package-lock.json` in your docs folder.


```julia
npm run docs:dev
```
5. Now you can see the live preview of your documentation at `hhttp://localhost:5173/YourPackage.jl/` in your browser.

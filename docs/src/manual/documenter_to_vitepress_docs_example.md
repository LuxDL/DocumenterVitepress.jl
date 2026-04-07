# Upgrading from Documenter.jl to DocumenterVitepress.jl

**Migrate your existing Documenter.jl documentation to DocumenterVitepress.jl in a few steps.**

Assuming you're working on a package named `Example.jl` in the `ExampleOrg` organization:

## 1. Update `make.jl`

:::tabs

== From Documenter.jl

The `make.jl` file with `Documenter.jl` should look like this:

```julia
using Example
using Documenter

DocMeta.setdocmeta!(Example, :DocTestSetup, :(using Example); recursive=true)

makedocs(;
    modules = [Example],
    authors = "Author Name",
    sitename = "Example.jl",
    format = Documenter.HTML(;
        canonical = "https://github.com/ExampleOrg/Example.jl",
        edit_link = "main",
    ),
    pages = [
        "Home" => "index.md",
        "API" => "api.md",
    ],
)

deploydocs(;
    repo = "github.com/ExampleOrg/Example.jl",
    devbranch = "main",
)
```

== To DocumenterVitepress.jl

The same `make.jl` file with `DocumenterVitepress.jl` will look like this:

```julia
using Example
using Documenter
using DocumenterVitepress

DocMeta.setdocmeta!(Example, :DocTestSetup, :(using Example); recursive=true)

makedocs(;
    modules = [Example],
    authors = "Author Name",
    sitename = "Example.jl",
    format = DocumenterVitepress.MarkdownVitepress(
        repo = "github.com/ExampleOrg/Example.jl",
        devbranch = "main",
        devurl = "dev",
    ),
    pages = [
        "Home" => "index.md",
        "API" => "api.md",
    ],
)

DocumenterVitepress.deploydocs(;
    repo = "github.com/ExampleOrg/Example.jl",
    target = joinpath(@__DIR__, "build"),
    branch = "gh-pages",
    devbranch = "main",
    push_preview = true,
)
```

:::


## 2. Install DocumenterVitepress

```sh
$ cd docs
docs $ julia
julia> ]
pkg> activate .
pkg> add DocumenterVitepress Documenter
```

## 3. Build and View

Build your documentation:
```julia
julia> include("make.jl")
```

View locally with `LiveServer`:
```julia
using LiveServer
LiveServer.serve(dir = "build/1")
```

Open your browser typically at `http://localhost:8000/`, your should see the address in the terminal.

::: details Using Vitepress dev server instead

If you prefer Vitepress's hot-reload server:

1. Add a `package.json` to your `docs` folder ([example here](https://github.com/LuxDL/DocumenterVitepress.jl/blob/main/docs/package.json))
2. Install dependencies: `npm install`
3. Run: `npm run docs:dev`

Stop the server when needed:
```julia
try run(`pkill -f vitepress`) catch end
```

:::

## 4. Remove Symlinks from gh-pages

> [!CAUTION]
> Before deploying, delete any symlinks on your `gh-pages` branch (e.g., `stable`, `v1`). DocumenterVitepress cannot write to symlinks.
> 
> Delete them via GitHub's web interface at `https://github.com/ExampleOrg/Example.jl/tree/gh-pages`

## 5. Deploy

Push your changes. Your CI will now deploy using DocumenterVitepress.

For more details, see [Get Started](./get_started.md).
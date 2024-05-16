# Upgrading docs from Documenter.jl to DocumenterVitepress.jl

 **Assuming that your current documentation is based on Documenter.jl, you can upgrade to DocumenterVitepress.jl by following these steps:**

Let us suppose that you are working on a package named `Example.jl` that is part of a GitHub organization named `ExampleOrg`.

Then the very first step here is to update the `make.jl` file to follow the DocumenterVitepress.jl format.

1. Go the the `make.jl` file in your `docs` folder and do the following necessary changes to upgrade to DocumenterVitepress.jl :

:::tabs

== For Documenter.jl

   a. The `make.jl` file with `Documenter.jl` should look like this:

```julia
using Example
using Documenter

DocMeta.setdocmeta!(test, :DocTestSetup, :(using test); recursive=true)

makedocs(;
    modules = [test],
    authors = "jay-sanjay <landgejay124@gmail.com> and contributors",
    sitename = "Example.jl",
    format = Documenter.HTML(;
        canonical = "https://jay-sanjay.github.io/Example.jl",
        edit_link = "main",
        assets = String[],
    ),
    pages=[
        "Home" => "index.md",
        "Tutorials" => "tutorials.md",
        "Api" => "api.md",
        "Contributing" => "contributing.md"
    ],
)

deploydocs(;
    repo = "github.com/jay-sanjay/Example.jl",
    devbranch = "main",
)

``` 

== For DocumenterVitepress.jl

  b. The same `make.jl` file with `DocumenterVitepress.jl` will look like this:

```julia
using Example
using Documenter
using DocumenterVitepress

DocMeta.setdocmeta!(Example, :DocTestSetup, :(using Example); recursive=true)


makedocs(;
    modules = [Example],
    repo = Remotes.GitHub("ExampleOrg", "Example.jl"),
    authors = "Jay-sanjay <landgejay124@gmail.com>, and contributors",
    sitename = "Example.jl",
    format = DocumenterVitepress.MarkdownVitepress(
        repo="https://github.com/ExampleOrg/Example.jl",
    ),
    pages = [
        "Home" => "index.md",
        "Tutorials" => "tutorials.md",
        "Api" => "api.md",
        "Contributing" => "contributing.md"
    ],
)

deploydocs(;
    repo = "github.com/ExampleOrg/Example.jl",
    target = "build", # this is where Vitepress stores its output
    devbranch = "main",
    branch = "gh-pages",
    push_preview = true
)

```

:::

2. Next to build new docs from docs/src 
```sh
$ cd docs
docs $
```
3. Then, in docs start a julia session and activate a new environment.
```sh
docs $ julia
julia> ]
pkg> activate .
```
4. Add packages as necessary. Here, we will need

```julia
pkg> add DocumenterVitepress, Documenter
```

5. Then run the `make.jl` file to build the documentation.

```julia
julia> include("make.jl")
```

6. Finally hit ;  to enter in the shell mode and run:

```sh
shell> npm i
```
The above command shall create a folder named `node_modules` and `package-lock.json` in your docs folder.

7. Next hit 'Backspace' to get back to the julia REPL and run:
```julia
juila> DocumenterVitepress.dev_docs("docs/build")
```
8. Finally the live preview of your documentation at `hhttp://localhost:5173/Example.jl/` in your browser.

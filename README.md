# DocumenterVitepress.jl

> [!TIP]
> Visit at https://luxdl.github.io/DocumenterVitepress.jl/

This package provides a Markdown / MkDocs backend to [Documenter.jl](https://documenter.juliadocs.org/stable/).

## Installation

The package can be added using the Julia package manager. From the Julia REPL, type `]` to enter the Pkg REPL mode and run

```shell
pkg> add DocumenterVitepress
```

## Usage

To enable the backend:
1. Add the `docs/src/.vitepress` folder from this repository to your own,
2. Import the package in `make.jl`,
3. Pass `format = DocumenterVitepress.MarkdownVitepress(...)` to `makedocs` like so:

```julia
using Documenter
using DocumenterVitepress
makedocs(;
    format=DocumenterVitepress.MarkdownVitepress(repo = "...", devbranch = "...", devurl = "dev"),
    )
```
and enjoy the fruits of your labour!

# Run locally

Because this is based on the Vitepress static site generator, you have to use NodeJS to view this site locally:

## Install npm dependencies

```shell
docs > npm i
```

## run docs locally

```shell
docs> npm run docs:dev 
```
and edit your `make.jl` file to add `build_vitepress = false` as a keyword argument to the `MarkdownVitepress` config, in order to save time.  If you keep this running, perhaps in a separate Terminal window, it will automatically rebuild whenever you run `make.jl`.

***

The documentation needs documentation.

-a Bellevue Linux Users Group member, 2005-
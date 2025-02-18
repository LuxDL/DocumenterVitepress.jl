# DocumenterVitepress.jl
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://luxdl.github.io/DocumenterVitepress.jl/stable/)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://luxdl.github.io/DocumenterVitepress.jl/dev/)
[![Downloads](https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Fmonthly_downloads%2FDocumenterVitepress&query=total_requests&suffix=%2Fmonth&label=Downloads)](https://juliapkgstats.com/pkg/DocumenterVitepress)
[![Downloads](https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Ftotal_downloads%2FDocumenterVitepress&query=total_requests&&label=Total%20Downloads)](https://juliapkgstats.com/pkg/DocumenterVitepress)
[![CI Documenter](https://github.com/LuxDL/DocumenterVitepress.jl/actions/workflows/Documenter.yml/badge.svg)](https://github.com/LuxDL/DocumenterVitepress.jl/actions/workflows/Documenter.yml)

<img src="https://luxdl.github.io/DocumenterVitepress.jl/stable/logo.png" align="right" style="padding-left:10px;" width="180"/>

> [!TIP]
> Visit at https://luxdl.github.io/DocumenterVitepress.jl/dev/

This package provides a Markdown / MkDocs backend to [Documenter.jl](https://documenter.juliadocs.org/stable/).

## Installation

The package can be added using the Julia package manager. From the Julia REPL, type `]` to enter the Pkg REPL mode and run

```shell
pkg> add DocumenterVitepress
```

## Usage

To enable the backend:
1. Import the package in `make.jl`,
2. Pass `format = DocumenterVitepress.MarkdownVitepress(...)` to `makedocs` like so, replacing e.g. `format = HTML(...)`:

```julia
using Documenter
using DocumenterVitepress
makedocs(;
    format=DocumenterVitepress.MarkdownVitepress(repo = "...", devbranch = "...", devurl = "dev"),
    )
```
and enjoy the fruits of your labour!

If you wish to fully customize your documentation with all of the capabilities of [Vitepress](https://vitepress.dev), 
then you can use our template generator.  But be warned that you may have to update that template to keep pace with 
DocumenterVitepress changes!

> [!TIP]
> To get a fully customizable build, run 
> ```julia 
> DocumenterVitepress.generate_template("/path/to/YourPackage/docs", "YourPackage")
> ```
> to populate all of the files which Vitepress requires.

And keep an eye for custom domains.

> [!CAUTION]  
> If you are deploying from a custom URL, like `geo.makie.org`, 
> please provide the entire URL to the `deploy_url = "geo.makie.org"` keyword argument 
> of `MarkdownVitepress`!  
> 
> Otherwise, the documentation will not render correctly.

## Run locally

Because this is based on the Vitepress static site generator, you have to use NodeJS to view this site locally:

```julia
using DocumenterVitepress
DocumenterVitepress.dev_docs()
```
and edit your `make.jl` file to add `build_vitepress = false` as a keyword argument to the `MarkdownVitepress` config, to save time.  If you keep this running, perhaps in a separate Terminal window, it will automatically rebuild whenever you run `make.jl`.

***

The documentation needs documentation.

-a Bellevue Linux Users Group member, 2005-

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

To enable the backend import the package in `make.jl` and then just pass `format = DocumenterVitepress.MarkdownVitepress()` to makedocs:

```shell
using Documenter
using DocumenterVitepress
makedocs(;
    format=DocumenterVitepress.MarkdownVitepress(),
    )
```

# Run locally

## npm dependencies

```shell
docs > npm i
```

## run docs locally

```shell
docs> npm run docs:dev 
```

The documentation needs documentation.
-a Bellevue Linux Users Group member, 2005-
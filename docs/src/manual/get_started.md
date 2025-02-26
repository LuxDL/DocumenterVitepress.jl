# Get Started

## Simple method

You can simply add `using DocumenterVitepress` to your `make.jl` file, and replace `format = HTML(...)` in `makedocs` with:

```julia
makedocs(...,
    format = MarkdownVitepress(
        repo = "<url_to_your_repo>",
    )
)
```

and that should be it!

::: details stop any vitepress session

```julia
# you might need to stop the Vitepress server if it's running before
# updating or creating new files
try run(`pkill -f vitepress`) catch end # [!code error]
```

:::

The section [Advanced method](@ref) describes how to get more control over your Vitepress build.

### Preview Documentation Development Instantly

You can preview your documentation development changes locally, instantly by adding [LiveServer.jl](https://github.com/tlienart/LiveServer.jl) into your `docs` environment and making a few tweaks to your `make.jl` configuration.

!!! note 
    As of now, these tweaks **must** be removed from your `make.jl` before you deploy your documentation to whatever deployment service you use or **your deployment will fail**.

Here are the tweaks to add:

1. Navigate into your `docs` directory and add `LiveServer.jl` with `(docs)> add LiveServer`

2. Within the `MarkdownVitepress` configuration of your `make.jl` file, pass the following two key word arguments and their values:

   i. `md_output_path = "."`

   ii. `build_vitepress = false`

3. Within the `makedocs` command within your `make.jl` file, pass the following key word argument:

   i. `clean = false`

Then, to preview changes live, open two separate Julia instances both within the `docs` folder and activate the `docs` environment in both sessions.
Within one session run `using LiveServer; servedocs(foldername="/path/to/your/docs/folder")` (this could be something like `servedocs(foldername="docs/")` or `servedocs(foldername=pwd())`).
In the other session run `DocumenterVitepress.dev_docs("build", md_output_path = "")`.

Now, with both these instances running, you can add your changes into your documentation and should see `servedocs` trigger a rebuild and `dev_docs` update as well which then leads to finally your browser being updated in real time.

!!! note
    For some user set-ups, you may see your browser instead direct you to a page mentioning `REPLACE_ME_DOCUMENTER_VITEPRESS` and the output from `dev_docs` mentioning that page as well. 
    If this happens to you, that is due to `DocumenterVitepress` not picking up `servedocs` changes fast enough (this comes from a quirk of the underlying JS `vitepress` library).
    To get around this, within your documentation, add a small sleep delay like so:
    ``````julia
    ```@example
    sleep(0.1)
    ```
    ``````
    Generally, `0.1` seconds should be enough but you may need to adjust that delay timer if you still have the issue.

## Advanced method

If you want to customize your Vitepress build, including CSS etc., you will want to add the necessary Vitepress files to your `docs/src/.vitepress` folder.

As a tutorial, we will go through and explain the folder and files structure used to generate this website. You could use this as a template for your project's documentation.

!!! tip "Quick start"
    In general, you can copy the `template` folder to your `docs` folder and the `.github/Documenter.yml` action file from [DocumenterVitepress.jl](https://github.com/LuxDL/DocumenterVitepress.jl) to your repo, and be pretty much good to go and edit docs as usual!


Since we're concerned only with documentation, we'll specifically look at the `docs` folder of your Julia project or package here.

For more information on how to structure this, see the [Documenter.jl guide](https://documenter.juliadocs.org/stable/man/guide/)!  In this quick start, we will focus solely on how to set up DocumenterVitepress assuming you already have some basic docs (even just an `index.md` will do).

## Project structure

In order to start as quickly as possible, we recommend you copy the `Project.toml`, `make.jl`, `package.json`, and `src` folders to your own documentation.

```
DocumenterVitepress/docs
├── Project.toml
├── make.jl
├── package-lock.json
├── package.json
└── src
    ├── getting_started.md
    ├── index.md
    └── assets
        └── favicon.ico
        └── logo_dark.png
    └── .vitepress
        ├── config.mts
        └── theme
            └── index.ts
            └── style.css
```

You can ignore the rest of the files which are actually in `DocumenterVitepress/docs/src` for now - those show how to use advanced APIs, like


## VitePress Installation

Start at the `docs` level:

```sh
docs $
```

### Prerequisites

DocumenterVitepress.jl is completely self-contained and installs all of its dependencies (including its own isolated version of `npm`) automatically.

However, to view your documentation live when developing locally, you will need to install `npm` and instantiate the

VitePress can be used on its own, or be installed into an existing project. In both cases, you can install it with:

::: code-group

```sh [npm]
npm add -D vitepress
```

```sh [pnpm]
pnpm add -D vitepress
```

```sh [yarn]
yarn add -D vitepress
```

```sh [bun]
bun add -D vitepress
```

:::

## Build new docs from docs/src

To start working on your docs do the following steps:

```sh
$ cd docs
docs $
```

Then, in `docs` start a julia session and activate a new environment.

```sh
docs $ julia
julia> ]
pkg> activate .
```

Add packages as necessary. Here, we will need


```julia-repl
pkg> add DocumenterVitepress, Documenter
```
These packages will be used in the `make.jl` file.

## Setting up the Folder Structure
The files for this page in the `docs` folder have the following structure:

```
docs/
├── Project.toml
├── make.jl
├── package-lock.json
├── package.json
└── src
    ├── getting_started.md
    ├── index.md
    └── assets
        └── favicon.ico
        └── logo_dark.png
    └── .vitepress
        ├── config.mts
        └── theme
            └── index.ts
            └── style.css
```

Then, run `docs/make.jl`, and in another terminal in the `docs` directory, run:

```sh
docs $ npm run docs:dev
```

This will deploy your documentation locally on a webserver.  See [here](https://vitepress.dev/guide/getting-started#up-and-running) to know more.

If you want to know more about the rendering, go to the [rendering process](../devs/render_pipeline.md) section. And for ways of using `markdown`, visit the [tabs](./markdown-examples#tabs) or the [Code](./code_example.md) sections for examples.
# Getting started

As a tutorial, we will go through and explain the folder and files structure used to generate this website. You could use this as a template for your project's documentation.

!!! tip "Quick start"
    In general, you can copy the `docs` folder and the `.github/Documenter.yml` action file from [DocumenterVitepress.jl](https://github.com/LuxDL/DocumenterVitepress.jl) to your repo, and be pretty much good to go and edit docs as usual! 
    
    Just remember to edit the sidebar in `docs/src/.vitepress/config.mts`.

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
        └── .vitepress
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

```shell
$ cd docs
docs $
```

Then, in `docs` start a julia session and activate a new environment.

```shell
docs> julia
julia> ]
pkg> activate .
```

Add packages as necessary. Here, we will need


```shell
pkg>  add DocumenterVitepress, Documenter
```
These packages will be used on the `make.jl` file.

## Setting up the Folder Structure
The files for this page in the `docs` folder have the following structure:

::: info

To edit the sidebar, you must edit `docs/src/.vitepress/config.mts`.

:::

```
docs/
├── src/
    ├── .vitepress/
        ├── theme/
            └─ index.ts
            └─ style.css
        └─ config.mts
    ├── assets/
       └─ logo-dark.svg
    └─ index.md
    └─ getting_started.md
    └─ api.md
└─ make.jl
└─ package.json
└─ Project.toml
```

Then, running first `make.jl` and then in the `docs` folder type

```shell
npm run docs:dev
```


This should do a local deploy for your docs. See [here](https://vitepress.dev/guide/getting-started#up-and-running) to know more.

# Structure of this Package

As a tutorial we will explain the folders and files structure used to generate this website. Actually, you could use this a template for your documentation project.

Starting at the top level, this project is organised as follows:


```
DocumenterVitepress/
├── docs/
├── src/
└─ .gitignore
└─ LICENSE
└─ Project.toml
└─ README.md
```

## Installation

### Prerequisites

From the [VitePress manual](https://vitepress.dev/guide/getting-started#installation).

- [Node.js](https://nodejs.org/en) version 18 or higher.
- Terminal for accessing VitePress via its command line interface (CLI).
- Text Editor with Markdown syntax support.
    - [VSCode](https://code.visualstudio.com) is recommended, along with the official [Vue extension](https://marketplace.visualstudio.com/items?itemName=Vue.volar).

VitePress can be used on its own, or be installed into an existing project. In both cases, you can install it with:

::: code-group

```sh [npm]
$ npm add -D vitepress
```

```sh [pnpm]
$ pnpm add -D vitepress
```

```sh [yarn]
$ yarn add -D vitepress
```

```sh [bun]
$ bun add -D vitepress
```

:::


Then, to start working on your docs do the following steps:

```shell
DocumenterVitepress> cd docs
docs>
```

Then, here in `docs` start a julia session and activate a new environment.

```shell
docs> julia
julia> ]
pkg> activate .
```

Add packages as necessary. Here, we will need


```shell
pkg>  add DocumenterVitepress, Documenter
```
These packages will be used on the `make.jl` file shown later on the following section.

## Setting up the Folder Structure
The files for this page in the `docs` folder are arrange into the following structure: 

```
docs/
├── src/
    ├── .vitepress/
        ├── theme/
            └─ index.ts
            └─ style.css
        └─ config.mts
    ├── public/
       └─ logo-dark.svg
    └─ index.md
    └─ getting_started.md
└─ make.jl
└─ package.json
└─ Project.toml
```

Then, running first `make.jl` and then in the `docs` folder type

```shell
npm run docs:dev
```

This should do a local deploy for your docs. See [here](https://vitepress.dev/guide/getting-started#up-and-running) to know more.
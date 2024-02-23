# Getting started

As a tutorial, we will go through and explain the folder and files structure used to generate this website. You could use this as a template for your project's documentation.

!!! tip
    In general, you can copy the `docs` folder and the `.github/Documenter.yml` action file from [DocumenterVitepress.jl](https://github.com/LuxDL/DocumenterVitepress.jl) to your repo, and be pretty much good to go and edit docs as usual! 
    
    Just remember to edit the sidebar in `docs/src/.vitepress/config.mts`.

Starting at the top level, this project is organised as follows:

## Project structure

```
DocumenterVitepress/
├── docs/
├── src/
└─ .gitignore
└─ LICENSE
└─ Project.toml
└─ README.md
```

## VitePress Installation

Start at the `docs` level

```sh
docs $
```

### Prerequisites

From the [VitePress manual](https://vitepress.dev/guide/getting-started#installation).

- [Node.js](https://nodejs.org/en) version 20 or higher.
- Terminal for accessing VitePress via its command line interface (CLI).
- Text Editor with Markdown syntax support.
    - [VSCode](https://code.visualstudio.com) is recommended, along with the official [Vue extension](https://marketplace.visualstudio.com/items?itemName=Vue.volar).

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


This will create a `package.json` and `package-lock.json` file, necessary for vitepress to know from where start building your docs. Set it to `build`. Your `.json` file should look like:

```
{
  "devDependencies": {
    "vitepress": "^1.0.0-rc.43",
  }
}
```


Also, install [vitetest](https://vitest.dev/guide/#adding-vitest-to-your-project) with

```sh [vitetest]
npm install -D vitest
```

this will update your `*.json` files with new dependencies. 

```
{
  "name": "docs",
  "lockfileVersion": 3,
  "requires": true,
  "packages": {...
    }
}
```

For `tabs` and `math` install the following packages.

### Tabs and Math

```sh
npm i -D vitepress-plugin-tabs
```

```sh
npm add -D markdown-it markdown-it-mathjax3
```

Note that also the `package.json` file has been updated.

```
{
  "devDependencies": {
    "markdown-it": "^14.0.0",
    "markdown-it-mathjax3": "^4.3.2",
    "vitepress": "^1.0.0-rc.43",
    "vitest": "^1.3.0"
  },
  "scripts": {
    "docs:dev": "vitepress dev build",
    "docs:build": "vitepress build build",
    "docs:preview": "vitepress preview build"
  }
}
```


## Generate docs template

```sh [vitepress]
npx vitepress init
```

## Preview docs

```shell
npm run docs:dev
```

This shows you the default generated template in `build`. For more generated content see the next section. 

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
    ├── public/
       └─ logo-dark.svg
    └─ index.md
    └─ getting_started.md
└─ make.jl
└─ package.json
└─ package-lock.json
└─ Project.toml
```

Then, running first `make.jl` and then in the `docs` folder type

```shell
npm run docs:dev
```


This should do a local deploy for your docs. See [here](https://vitepress.dev/guide/getting-started#up-and-running) to know more.

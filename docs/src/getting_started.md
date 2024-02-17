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

## VitePress Installation

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

## Generate docs template

### `package.json`

```sh [vitepress]
npx vitepress init
```

This will create a `package.json` file, necessary for vitepress to know from where start building your docs. Set it to `build`. Your `.json` file should look like:

```
{
  "scripts": {
    "docs:dev": "vitepress dev build",
    "docs:build": "vitepress build build",
    "docs:preview": "vitepress preview build"
  }
}
```


### `package-lock.json`

Also, install [vitetest](https://vitest.dev/guide/#adding-vitest-to-your-project) with

```sh [vitetest]
npm install -D vitest
```

this will generate the `package-lock.json` necessary to install dependencies later on. 

```
{
  "name": "DocumenterVitepress.jl",
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

Note that also `package.json` as been updated.

```
{
  "scripts": {
    "docs:dev": "vitepress dev build",
    "docs:build": "vitepress build build",
    "docs:preview": "vitepress preview build"
  },
  "devDependencies": {
    "markdown-it": "^14.0.0",
    "markdown-it-mathjax3": "^4.3.2",
    "vitepress": "^1.0.0-rc.41",
    "vitepress-plugin-tabs": "^0.5.0",
    "vitest": "^1.2.0"
  }
}
```

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
└─ package-lock.json
└─ Project.toml
```

Then, running first `make.jl` and then in the `docs` folder type

```shell
npm run docs:dev
```

This should do a local deploy for your docs. See [here](https://vitepress.dev/guide/getting-started#up-and-running) to know more.
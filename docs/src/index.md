```@raw html
---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "DocumenterVitepress.jl"
  text: "Document your code"
  tagline: A Markdown backend designed to work with VitePress and Documenter.jl
  image:
    src: /logo.png
    alt: DocumenterVitepress
  actions:
    - theme: brand
      text: Get Started
      link: /manual/get_started
    - theme: alt
      text: View on Github
      link: https://github.com/LuxDL/DocumenterVitepress.jl
    - theme: alt
      text: API
      link: /api


features:
  - icon: <img width="64" height="64" src="https://img.icons8.com/arcade/64/markdown.png" alt="markdown"/>
    title: Markdown
    details: Write in standard markdown syntax
    link: /manual/markdown-examples
  - icon: <img width="64" height="64" src="https://fredrikekre.github.io/Literate.jl/v2/assets/logo.png" />
    title: Literate.jl
    details: Parse scripts into markdown via Literate.jl
    link: https://github.com/fredrikekre/Literate.jl
  - icon: <svg xmlns="http://www.w3.org/2000/svg" width="30" viewBox="0 0 256 256.32"><defs><linearGradient id="a" x1="-.828%" x2="57.636%" y1="7.652%" y2="78.411%"><stop offset="0%" stop-color="#41D1FF"/><stop offset="100%" stop-color="#BD34FE"/></linearGradient><linearGradient id="b" x1="43.376%" x2="50.316%" y1="2.242%" y2="89.03%"><stop offset="0%" stop-color="#FFEA83"/><stop offset="8.333%" stop-color="#FFDD35"/><stop offset="100%" stop-color="#FFA800"/></linearGradient></defs><path fill="url(#a)" d="M255.153 37.938 134.897 252.976c-2.483 4.44-8.862 4.466-11.382.048L.875 37.958c-2.746-4.814 1.371-10.646 6.827-9.67l120.385 21.517a6.537 6.537 0 0 0 2.322-.004l117.867-21.483c5.438-.991 9.574 4.796 6.877 9.62Z"/><path fill="url(#b)" d="M185.432.063 96.44 17.501a3.268 3.268 0 0 0-2.634 3.014l-5.474 92.456a3.268 3.268 0 0 0 3.997 3.378l24.777-5.718c2.318-.535 4.413 1.507 3.936 3.838l-7.361 36.047c-.495 2.426 1.782 4.5 4.151 3.78l15.304-4.649c2.372-.72 4.652 1.36 4.15 3.788l-11.698 56.621c-.732 3.542 3.979 5.473 5.943 2.437l1.313-2.028 72.516-144.72c1.215-2.423-.88-5.186-3.54-4.672l-25.505 4.922c-2.396.462-4.435-1.77-3.759-4.114l16.646-57.705c.677-2.35-1.37-4.583-3.769-4.113Z"/></svg>
    title: VUE components
    details: Explore the possibilities with VUE components
    link: https://vuejs.org/guide/essentials/component-basics
---
```

````@raw html
<p style="margin-bottom:2cm"></p>

<div class="vp-doc" style="width:80%; margin:auto">

<h1> What is DocumenterVitepress.jl? </h1>

DocumenterVitepress is a Markdown backend for Documenter.jl which is designed to work with the [`VitePress`](https://vitepress.dev/) site generator, which is built off `Vue.js`.

It is meant to be used in conjunction with the `vitepress` Node.js package, which is why so much customization is required!

<h2> Basic usage </h2>


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

For more customizations, you can copy over some files like `src/.vitepress/theme/style.css` from the `template` directory of this repo to your `docs` folder, and experiment!


</div>
````

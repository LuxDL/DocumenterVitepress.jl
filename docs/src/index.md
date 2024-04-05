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
      text: Getting Started
      link: /getting_started
    - theme: alt
      text: View on Github
      link: https://github.com/LuxDL/DocumenterVitepress.jl
    - theme: alt
      text: API Examples
      link: /api
      

features:
  - title: Markdown
    details: Write in standard markdown syntax
    link: /markdown-examples
  - title: Literate.jl
    details: Parse scripts into markdown via Literate.jl
    link: https://github.com/fredrikekre/Literate.jl
  - title: VUE components
    details: Explore the possibilities with VUE components
    link: https://vuejs.org/guide/essentials/component-basics
---
```

```@raw html
<p style="margin-bottom:2cm"></p>

<div class="vp-doc" style="width:80%; margin:auto">

<h1> What is DocumenterVitepress.jl? </h1>

DocumenterVitepress is a Markdown backend for Documenter.jl which is designed to work with the [`VitePress`](https://vitepress.dev/) site generator, which is built off `Vue.js`.  

It is meant to be used in conjunction with the `vitepress` Node.js package, which is why so much customization is required!

<h2> Basic usage </h2>

If you copy the contents of the `template/` directory into your `docs/` and the `.github/Documenter.yml` file to your repo, you should be good to go and edit docs as usual! 

Just remember to edit the navbar in `docs/src/.vitepress/config.mts`, if you want it to be different from the sidebar.

To install a logo or favicon, you can put `logo.png` and `favicon.ico` in `docs/src/assets`, and they will be automatically detected.

</div>
```
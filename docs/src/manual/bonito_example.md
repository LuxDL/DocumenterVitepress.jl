# Bonito interactivity

[Bonito.jl](https://github.com/SimonDanisch/Bonito.jl) renders interactive apps and widgets
(it also powers WGLMakie figures) as `text/html` output. DocumenterVitepress executes the
`<script>` tags such output contains on the client, both on first load and after
client-side navigation, so Bonito apps work without a hard page reload.

Add `DocumenterVitepress.BonitoPlugin()` to `makedocs(plugins = [...])` to have Bonito's
JS/CSS bundle shipped once through the site's `public/` folder instead of being
re-embedded inline on every figure. `Page()` still goes at the top of the page exactly as
[Bonito's own docs](https://github.com/SimonDanisch/Bonito.jl/blob/master/docs/src/deployment.md#documenter)
describe; nothing else about writing a Bonito app changes.

```@setup bonito
using Bonito
Page()
```

A counter that keeps working after the page is exported to static HTML: the click handler
updates the counter's own DOM node directly in JavaScript, so no running Julia session is
needed once deployed (see Bonito's
[static-export notes](https://github.com/SimonDanisch/Bonito.jl/blob/master/docs/src/interactions.md#creating-interactive-examples)).

```@example bonito
App() do session
    count = DOM.span("0")
    button = Button("Click me!")
    onjs(session, button.value, js"""
        function (clicked) {
            const el = $(count)
            el.textContent = String(parseInt(el.textContent, 10) + 1)
        }
        """)
    return DOM.div(button, DOM.p("Clicks: ", count))
end
```

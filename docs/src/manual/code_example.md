# Julia code examples

**Fonts**

This package uses the JuliaMono font by default, but you can override this in CSS.

This is what some common symbols look like:

```julia
] [ = $ ; ( @ { " ) ? . } ⊽ ⊼ ⊻ ⊋ ⊊ ⊉ ⊈ ⊇ ⊆ ≥ ≤ ≢ ≡ ≠ ≉ ≈ ∪ ∩ ∜ ∛ √ ∘ ∌
|> /> ^ % ` ∈
```

## @example
The `Julia` code used here is done using the following packages versions:

**Input**
````
```@example version
using Pkg
Pkg.status()
```
````
**Output**

```@example version
using Pkg
Pkg.status()
```

And a simple sum:

**Input**
````
```@example simple_sum
2 + 2
```
````
**Output**

```@example simple_sum
2 + 2
```

## @ansi
**Input**
````
```@ansi
printstyled("this is my color"; color = :red)
```
````
**Output**

```@ansi
printstyled("this is my color"; color = :red)
```

A more colorful example from [documenter](https://documenter.juliadocs.org/stable/showcase/#Raw-ANSI-code-output):

**Input**
````
```@ansi
for color in 0:15
    print("\e[38;5;$color;48;5;$(color)m  ")
    print("\e[49m", lpad(color, 3), " ")
    color % 8 == 7 && println() # ‎[!code highlight]
end
```
````
**Output**

```@ansi
for color in 0:15
    print("\e[38;5;$color;48;5;$(color)m  ")
    print("\e[49m", lpad(color, 3), " ")
    color % 8 == 7 && println() # [!code highlight]
end
```

## @eval
From [Julia's documentation](https://docs.julialang.org/en/v1/) landing page.

**Input**
````
```@eval
io = IOBuffer()
release = isempty(VERSION.prerelease)
v = "$(VERSION.major).$(VERSION.minor)"
!release && (v = v*"-$(first(VERSION.prerelease))")
print(io, """
    # Julia $(v) Documentation

    Welcome to the documentation for Julia $(v).

    """)
if true # !release
    print(io,"""
        !!! warning "Work in progress!"
            This documentation is for an unreleased, in-development, version of Julia.
        """)
end
import Markdown
Markdown.parse(String(take!(io)))
```

```@eval
file = "julia-1.10.2.pdf"
url = "https://raw.githubusercontent.com/JuliaLang/docs.julialang.org/assets/$(file)"
import Markdown
Markdown.parse("""
!!! note
    The documentation is also available in PDF format: [$file]($url).
""")
```
````

**Output**
```@eval
io = IOBuffer()
release = isempty(VERSION.prerelease)
v = "$(VERSION.major).$(VERSION.minor)"
!release && (v = v*"-$(first(VERSION.prerelease))")
print(io, """
    # Julia $(v) Documentation

    Welcome to the documentation for Julia $(v).

    """)
if true # !release
    print(io,"""
        !!! warning "Work in progress!"
            This documentation is for an unreleased, in-development, version of Julia.
        """)
end
import Markdown
Markdown.parse(String(take!(io)))
```

```@eval
file = "julia-1.10.2.pdf"
url = "https://raw.githubusercontent.com/JuliaLang/docs.julialang.org/assets/$(file)"
import Markdown
Markdown.parse("""
!!! note
    The documentation is also available in PDF format: [$file]($url).
""")
```

## @repl

**Input**

````
```@repl
a = 1;
b = 2;
a + b
```
````

**Output**

```@repl
a = 1;
b = 2;
a + b
```

**Input**

````
```@repl
a = 1;
b = 2; # [!code focus] # hide
a + b
```
````

**Output**

```@repl
a = 1;
b = 2; # hide
a + b
```

## @doctest
**Input**
````
```@doctest
julia> 1 + 1
2

```
````
**Output**
```@doctest
julia> 1 + 1
2

```

## @meta

Supported meta tags:

  - `CollapsedDocStrings`: works similar to Documenter.jl. If provided, the docstrings in
    that page will be collapsed by default. Defaults to `false`. See the
    [Internal API](@ref internal_api) page for how the docstrings are displayed when this
    is set to `true`. Example usage:

**Input**

````
```@meta
CollapsedDocStrings = true
```
````

## @contents

Use this to create a list of content.

**Input**
````
```@contents
Pages = [
    "get_started.md",
    "documenter_to_vitepress_docs_example.md",
    "style_css.md",
    "code_example.md",
    "markdown-examples.md",
    "mime_examples.md",
    "citations.md",
    "style_css.md",
    "author_badge.md",
    "repo_stars.md",
    "../devs/render_pipeline.md",
    "../devs/internal_api.md",
    "../api.md"
    ]
Depth = 3
```
````

**Output**

```@contents
Pages = [
    "get_started.md",
    "documenter_to_vitepress_docs_example.md",
    "style_css.md",
    "code_example.md",
    "markdown-examples.md",
    "mime_examples.md",
    "citations.md",
    "style_css.md",
    "author_badge.md",
    "repo_stars.md",
    "../devs/render_pipeline.md",
    "../devs/internal_api.md",
    "../api.md"
    ]
Depth = 3
```
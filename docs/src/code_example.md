# Julia code example

The `Julia` code used here is done using the following packages versions:

````@example version
using Pkg
Pkg.status()
````

And a simple task:

````@example simple_sum
2 + 2
````

## ANSI example

````@ansi
printstyled("this is my color"; color = :red)
````

A more colorful example for [documenter](https://documenter.juliadocs.org/stable/showcase/#Raw-ANSI-code-output):

````@ansi
for color in 0:15
    print("\e[38;5;$color;48;5;$(color)m  ")
    print("\e[49m", lpad(color, 3), " ")
    color % 8 == 7 && println()
end
````

## Font

This package uses the JuliaMono font by default, but you can override this in CSS.  

This is what some common symbols look like:

```julia
] [ = $ ; ( @ { " ) ? . } ⊽ ⊼ ⊻ ⊋ ⊊ ⊉ ⊈ ⊇ ⊆ ≥ ≤ ≢ ≡ ≠ ≉ ≈ ∪ ∩ ∜ ∛ √ ∘ ∌
|> /> ^ % ` ∈ 
```

## Eval example
From [Julia's documentation](https://docs.julialang.org/en/v1/).

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
# Markdown Extension Examples

This page demonstrates some of the built-in markdown extensions provided by VitePress.

## Syntax Highlighting

VitePress provides Syntax Highlighting powered by [Shiki](https://github.com/shikijs/shiki), with additional features like line-highlighting:

### Line Highlight

**Input**

Code snippets from [gnuplot-examples](https://lazarusa.github.io/gnuplot-examples/).

````
```julia
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set grid"
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgb '#E69F00'" # ‎[!code highlight]
```
````

**Output**

```julia
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set grid"
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgb '#E69F00'" # [!code highlight]
```

### Highlight multiple lines

**Input**

````
```julia
# ‎[!code highlight:3]
# up to 3 in order to highlight the previous 2 lines
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set grid"
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgb '#E69F00'" # ‎[!code highlight]
```
````

**Output**

```julia
# [!code highlight:3]
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set grid"
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgb '#E69F00'" # [!code highlight]
```
Note the combination with `[!code highlight]`.

### Focus a line

**Input**
````
```julia
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set grid"
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgb '#E69F00'" # ‎[!code focus]
```
````

**Output**
```julia
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set grid"
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgb '#E69F00'" # [!code focus]
```

### Focus multiple lines

**Input**
````
```julia
# ‎[!code focus:3]
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set grid"
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgb '#E69F00'" # ‎[!code focus] # ‎[!code highlight]
```
````

**Output**
```julia
# [!code focus:3]
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set grid"
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgb '#E69F00'" # [!code focus] # [!code highlight]
```
Note the combination with `[!code focus]` and `[!code highlight]`.

### Added and removed lines

**Input**
````
```julia
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set grid" # ‎ [!code --]
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgb '#E69F00'" # ‎[!code ++] # ‎[!code focus]
```
````

**Output**
```julia
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set grid" # [!code --]
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgb '#E69F00'" # [!code ++] # [!code focus]
```
Note the combination with `[!code focus]`.

### Code error, code warning

**Input**
````
```julia
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set gridss" # ‎ [!code error]
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgba '#E69F00'" # ‎[!code warning]
```
````

**Output**

```julia
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set gridss" # [!code error]
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgba '#E69F00'" # [!code warning]
```

### Code groups

**Input**
````
::: code-group

```julia [one line]
using Gnuplot
t = 0:0.001:1
@gp t sin.(10π*t) "w l tit 'sin' lc 'gray'"
```

```julia [two lines]
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set grid"
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgb '#E69F00'"
```

:::
````
**Output**

::: code-group

```julia [one line]
using Gnuplot
t = 0:0.001:1
@gp t sin.(10π*t) "w l tit 'sin' lc 'gray'"
```

```julia [two lines]
using Gnuplot
x = -2π:0.001:2π
@gp x sin.(x) "w l t 'sin' lw 2 lc '#56B4E9'" "set grid"
@gp :- xrange = (-2π - 0.3, 2π + 0.3) yrange = (-1.1,1.1)
@gp :- x cos.(x) "w l t 'cos' lw 2 lc rgb '#E69F00'"
```

:::


### Lists

**Input**

````
1. a
1. b
    1. c
        1. d
1. e
````

**Output**

1. a
1. b
    1. c
        1. d
1. e

## Custom Containers

**Input**

```md
::: info

This is an info box.

:::

::: tip

This is a tip.

:::

::: warning

This is a warning.

:::

::: danger

This is a dangerous warning.

:::

::: details

This is a details block.

:::
```

**Output**

::: info

This is an info box.

:::

::: tip

This is a tip.

:::

::: warning

This is a warning.

:::

::: danger

This is a dangerous warning.

:::

::: details

This is a details block.

:::

## Tabs

**Input**

````
:::tabs

== tab a

a content

== tab b

b content

:::

:::tabs

== tab a

a content 2

== tab b

b content 2

:::
````

**Output**

:::tabs

== tab a

a content

== tab b

b content

:::

:::tabs

== tab a

a content 2

== tab b

b content 2

:::

## Nested Tabs

**Input**
````
::::tabs

=== first one

:::tabs

== tab a

a content

== tab b

b content

:::

=== second one

:::tabs

== tab c

c content 2

== tab d

d content 2

:::

::::
````

**Output**

::::tabs

=== first one

:::tabs

== tab a

a content

== tab b

b content

:::

=== second one

:::tabs

== tab c

c content 2

== tab d

d content 2

:::

::::


## GitHub-flavored Alerts
See [github-flavored-alerts](https://vitepress.dev/guide/markdown#github-flavored-alerts)

**Input**
````
> [!WARNING]
> Critical content.
````

**Output**

> [!WARNING]
> Critical content.

## Tables
See [github-style-tables](https://vitepress.dev/guide/markdown#github-style-tables)

**Input**
````
| Tables        |      Are      |  Cool |
| ------------- | :-----------: | ----: |
| col 3 is      | right-aligned | \$1600 |
| col 2 is      |   centered    |   \$12 |
| zebra stripes |   are neat    |    \$1 |
````

**Output**

| Tables        |      Are      |  Cool |
| ------------- | :-----------: | ----: |
| col 3 is      | right-aligned | \$1600 |
| col 2 is      |   centered    |   \$12 |
| zebra stripes |   are neat    |    \$1 |

## Equations
**Input**
````
When ``a \ne 0``, there are two solutions to ``ax^2 + bx + c = 0`` and they are

$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$

Don't type anything after the last double dollar sign, and make sure there are no spaces after the opening double dollar sign in the display math!

You can also use fenced code blocks with the `math` tag for equations!

```math
\nabla^2 \Phi = \rho
```
````

**Output**

When ``a \ne 0``, there are two solutions to ``ax^2 + bx + c = 0`` and they are

$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$

Don't type anything after the last double dollar sign, and make sure there are no spaces after the opening double dollar sign in the display math!

You can also use fenced code blocks with the `math` tag for equations!

```math
\nabla^2 \Phi = \rho
```

## [Latex Symbols $\Lambda_\theta$ and $\bf Z$](@id latex_symbols_in_headings)

::: tip

If you want latex symbols in headings better use `Documenter's ID interface` for proper rendering.

:::

**Input**

````
## [Latex Symbols $\Lambda_\theta$ and $\bf Z$](@id latex_symbols_in_headings)
````

The previous heading is the output from this input. Also, note that the `@id`'s name would show up in the `@contents` listing.


## Footnotes (citation-style)

**Input**
````
Here is the link for the paper of Babushka[^1]
````
````
[^1]: This is Babushka's footnote!
````

**Output**

Here is the link for the paper of Babushka[^1]

## Escaping characters

**Input**

```md
< `less` and `greater` > than, and the backtick \`.
```

**Output**

< `less` and `greater` > than, and the backtick \`.


And also, this <was> an <issue> before.

Let's see if this one works:

````
```
sshflags=`-i <keyfile>`
```
````
it does,
```
sshflags=`-i <keyfile>`
```
but within inline text it does not. Ideas for the escaping sequence?

This is the expected sequence by vitepress:

````
<code> sshflags= `` `-i <keyfile> ` `` </code>
````

## [Heading with a link](https://github.com/LuxDL/DocumenterVitepress.jl) and *italic* font

This was previously breaking due to special markdown characters in the slug.

## More

Check out the documentation for the [full list of markdown extensions](https://vitepress.dev/guide/markdown).


[^1]: This is Babushka's footnote!

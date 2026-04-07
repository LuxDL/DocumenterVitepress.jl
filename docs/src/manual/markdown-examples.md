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

!!! note
    Inline `$$` delimiters like `$$x=1+2$$` will render as inline math when written within a paragraph. For display/block math, place the `$$` delimiters on their own lines.

    $$f(x, y) = 2y$$

Alternatively, use fenced code blocks:

```math
\nabla^2 \Phi = \rho
```
````

**Output**

When ``a \ne 0``, there are two solutions to ``ax^2 + bx + c = 0`` and they are

$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$

Don't type anything after the last double dollar sign, and make sure there are no spaces after the opening double dollar sign in the display math!

You can also use fenced code blocks with the `math` tag for equations!

!!! note
    Inline `$$` delimiters like `$$x=1+2$$` will render as inline math when written within a paragraph. For display/block math, place the `$$` delimiters on their own lines.

    $$f(x, y) = 2y$$

Alternatively, use fenced code blocks:

```math
\nabla^2 \Phi = \rho
```

### labels and `eqref`
You can label equations inside math environments and reference them later using `\eqref{...}` (or `\ref{...}` if you only want the equation number). This works for single equations as well as multi-line environments such as `align`.

#### Single equation

**Input**
````
This is a simple equation

```math
\begin{equation}
x=0 \label{eq:a}
\end{equation}
```
and now we can reference this as Eq. ``\eqref{eq:a}``.
````

**Output**

This is a simple equation

```math
\begin{equation}
x=0 \label{eq:a}
\end{equation}
```

and now we can reference this as Eq. ``\eqref{eq:a}``.

#### `align` environment with a single label
Labels can also be used inside an `align` environment.

**Input**
````
This also works

```math
\begin{align}
\label{eq:b}
a = 1
\end{align}
```

see Eq. $\eqref{eq:b}$.
````

**Output**

This also works

```math
\begin{align}
\label{eq:b}
a = 1
\end{align}
```

see Eq. $\eqref{eq:b}$.

#### Multi-line align with labeled lines

**Input**
````
```math
\begin{align}
\nabla\cdot\mathbf{E}  &= 4 \pi \rho \label{eq:c} \\
\nabla\cdot\mathbf{B}  &= 2 \\
\nabla\times\mathbf{E} &= - \frac{1}{c} \frac{\partial\mathbf{B}}{\partial t} \label{eq:d} \\
\nabla\times\mathbf{B} &= - \frac{1}{c}
\left(4 \pi \mathbf{J} + \frac{\partial\mathbf{E}}{\partial t}\right)
\end{align}
```

See $\eqref{eq:c}$? And what about $\ref{eq:d}$? Or simply typed as \eqref{eq:c} and \ref{eq:d}!

Also works using $$\ref{eq:c}$$ or without spaces: equation\eqref{eq:d}goes here!
````

**Output**

```math
\begin{align}
\nabla\cdot\mathbf{E}  &= 4 \pi \rho \label{eq:c} \\
\nabla\cdot\mathbf{B}  &= 2 \\
\nabla\times\mathbf{E} &= - \frac{1}{c} \frac{\partial\mathbf{B}}{\partial t} \label{eq:d}\\
\nabla\times\mathbf{B} &= - \frac{1}{c}
\left(4 \pi \mathbf{J} + \frac{\partial\mathbf{E}}{\partial t}\right)
\end{align}
```

See $\eqref{eq:c}$? And what about $\ref{eq:d}$? Or simply typed as \eqref{eq:c} and \ref{eq:d}!

Also works using $$\ref{eq:c}$$ or without spaces: equation\eqref{eq:d}goes here!

::: tip
- Use `\eqref{...}` to automatically include parentheses around the equation number.
- Use `\ref{...}` if you only need the raw number.
- Labels must be unique within a document.
- In multi-line environments, place `\label{}` on the specific line you want to reference.
:::

### NewCM Fonts

The NewCM fonts provide excellent support for mathematical typography. Here are some examples demonstrating various features.

!!! warning
    This section demonstrates the typographical capabilities of the NewCM fonts for complex mathematical notation. While care has been taken to ensure accuracy, users should verify equations against authoritative sources before using them in academic or professional contexts. The equations are illustrative and may not reflect all conventions or edge cases.


#### Basic Mathematical Notation

Inline math works seamlessly: $\oiint \mathbb{R}^3 \boldsymbol{\alpha} \widehat{AB}$ can be embedded directly in text.

**Input**
````
Display math for triple integrals:
```math
\oiiint_{\Omega} f(x,y,z) \, dx\,dy\,dz
```
````

**Output**

Display math for triple integrals:
```math
\oiiint_{\Omega} f(x,y,z) \, dx\,dy\,dz
```

#### General Relativity

Einstein's field equations describe how matter and energy curve spacetime. The metric tensor $g_{\mu\nu}$ defines distances on the manifold $\mathcal{M}$.

```@raw html

**Input** <Badge type="info">[Einstein 1915](https://en.wikipedia.org/wiki/Einstein_field_equations)</Badge>
```

````
```math
\begin{equation}
R_{\mu\nu} - \frac{1}{2}Rg_{\mu\nu} + \Lambda g_{\mu\nu} = \frac{8\pi G}{c^4}T_{\mu\nu} \label{eq:einstein}
\end{equation}
```
````

**Output**

```math
\begin{equation}
R_{\mu\nu} - \frac{1}{2}Rg_{\mu\nu} + \Lambda g_{\mu\nu} = \frac{8\pi G}{c^4}T_{\mu\nu} \label{eq:einstein}
\end{equation}
```

**Input**
````
The stress-energy tensor $T_{\mu\nu}$ must satisfy the conservation law with covariant derivative:
```math
\begin{equation}
\nabla_\mu T^{\mu\nu} = 0 \implies \partial_\mu (\sqrt{-g}T^{\mu\nu}) + \Gamma^\nu_{\mu\lambda}\sqrt{-g}T^{\mu\lambda} = 0 \label{eq:conservation}
\end{equation}
```
````

**Output**

The stress-energy tensor $T_{\mu\nu}$ must satisfy the conservation law with covariant derivative:
```math
\begin{equation}
\nabla_\mu T^{\mu\nu} = 0 \implies \partial_\mu (\sqrt{-g}T^{\mu\nu}) + \Gamma^\nu_{\mu\lambda}\sqrt{-g}T^{\mu\lambda} = 0 \label{eq:conservation}
\end{equation}
```

#### Quantum Electrodynamics

The QED Lagrangian combines the electromagnetic field tensor with the Dirac equation for fermions.

```@raw html

**Input** <Badge type="info">[Feynman QED](https://en.wikipedia.org/wiki/Quantum_electrodynamics)</Badge>
```

````
```math
\begin{equation}
\mathcal{L} = -\frac{1}{4}F_{\mu\nu}F^{\mu\nu} + \bar{\psi}(i\hbar c\gamma^\mu D_\mu - mc^2)\psi \label{eq:qed-lagrangian}
\end{equation}
```
````

**Output**

```math
\begin{equation}
\mathcal{L} = -\frac{1}{4}F_{\mu\nu}F^{\mu\nu} + \bar{\psi}(i\hbar c\gamma^\mu D_\mu - mc^2)\psi \label{eq:qed-lagrangian}
\end{equation}
```

**Input**
````
A typical Feynman amplitude for electron-photon vertex involves the coupling to the electromagnetic field:
```math
\begin{equation}
\mathscr{A}_{\text{vertex}} = -ie\bar{u}(p')\gamma^\mu u(p) A_\mu(q) \label{eq:feynman-amplitude}
\end{equation}
```
````

**Output**

A typical Feynman amplitude for electron-photon vertex involves the coupling to the electromagnetic field:
```math
\begin{equation}
\mathscr{A}_{\text{vertex}} = -ie\bar{u}(p')\gamma^\mu u(p) A_\mu(q) \label{eq:feynman-amplitude}
\end{equation}
```

#### Gauge Theory and Lie Algebras

The Standard Model gauge group is a direct product of Lie groups with corresponding Lie algebra structure.

```@raw html

**Input** <Badge type="info">[Standard Model](https://en.wikipedia.org/wiki/Standard_Model)</Badge>
```

````
```math
\begin{equation}
G_{\text{SM}} = \text{SU}(3)_C \times \text{SU}(2)_L \times \text{U}(1)_Y \quad \text{with algebra } \mathfrak{g}_{\text{SM}} = \mathfrak{su}(3) \oplus \mathfrak{su}(2) \oplus \mathfrak{u}(1) \label{eq:gauge-group}
\end{equation}
```
````

**Output**

```math
\begin{equation}
G_{\text{SM}} = \text{SU}(3)_C \times \text{SU}(2)_L \times \text{U}(1)_Y \quad \text{with algebra } \mathfrak{g}_{\text{SM}} = \mathfrak{su}(3) \oplus \mathfrak{su}(2) \oplus \mathfrak{u}(1) \label{eq:gauge-group}
\end{equation}
```

#### Differential Geometry

Stokes' theorem relates integrals over a manifold to integrals over its boundary.

```@raw html

**Input** <Badge type="info">[Stokes' Theorem](https://en.wikipedia.org/wiki/Stokes%27_theorem)</Badge>
```

````
For any differential form $\boldsymbol{\omega}$ on a surface $\Sigma$ in the tangent space $\mathscr{T}(\mathcal{M})$:
```math
\begin{equation}
\oint_{\partial \Sigma} \boldsymbol{\omega} = \iint_{\Sigma} d\boldsymbol{\omega} \quad \forall \, \Sigma \in \mathscr{T}(\mathcal{M}) \label{eq:stokes}
\end{equation}
```
````

**Output**

For any differential form $\boldsymbol{\omega}$ on a surface $\Sigma$ in the tangent space $\mathscr{T}(\mathcal{M})$:
```math
\begin{equation}
\oint_{\partial \Sigma} \boldsymbol{\omega} = \iint_{\Sigma} d\boldsymbol{\omega} \quad \forall \, \Sigma \in \mathscr{T}(\mathcal{M}) \label{eq:stokes}
\end{equation}
```

#### Quantum Mechanics

The expectation value of the Hamiltonian operator in quantum mechanics can be expressed as a sum over energy eigenstates.

```@raw html

**Input** <Badge type="info">[Expectation Values](https://en.wikipedia.org/wiki/Expectation_value_(quantum_mechanics))</Badge>
```

````
```math
\begin{equation}
\langle \Psi | \hat{H} | \Psi \rangle = \sum_{n=0}^{\infty} E_n |\langle \phi_n | \Psi \rangle|^2 = \int_{\mathbb{R}^3} \Psi^*(x) \hat{H} \Psi(x) \, d^3x \label{eq:expectation}
\end{equation}
```
````

**Output**

```math
\begin{equation}
\langle \Psi | \hat{H} | \Psi \rangle = \sum_{n=0}^{\infty} E_n |\langle \phi_n | \Psi \rangle|^2 = \int_{\mathbb{R}^3} \Psi^*(x) \hat{H} \Psi(x) \, d^3x \label{eq:expectation}
\end{equation}
```

#### Topology and Set Theory

Fiber bundles appear throughout modern physics. The famous Hopf fibration shows how the 3-sphere fibers over the 2-sphere.

```@raw html

**Input** <Badge type="info">[Fiber Bundles](https://en.wikipedia.org/wiki/Fiber_bundle) & [Cardinal Numbers](https://en.wikipedia.org/wiki/Cardinal_number)</Badge>
```

````
```math
\begin{equation}
\mathbb{S}^1 \hookrightarrow \mathbb{S}^3 \xrightarrow[\text{Hopf fibration}]{\pi} \mathbb{S}^2 \cong \mathbb{CP}^1 \label{eq:fiber-bundle}
\end{equation}
```
````

**Output**

```math
\begin{equation}
\mathbb{S}^1 \hookrightarrow \mathbb{S}^3 \xrightarrow[\text{Hopf fibration}]{\pi} \mathbb{S}^2 \cong \mathbb{CP}^1 \label{eq:fiber-bundle}
\end{equation}
```

**Input**
````
The cardinality of the power set of natural numbers equals the continuum:
```math
\begin{equation}
\wp(\aleph_0) \cong 2^{\aleph_0} = \mathfrak{c} \label{eq:cardinality}
\end{equation}
```
````

**Output**

The cardinality of the power set of natural numbers equals the continuum:
```math
\begin{equation}
\wp(\aleph_0) \cong 2^{\aleph_0} = \mathfrak{c} \label{eq:cardinality}
\end{equation}
```

#### Comprehensive Example

Bringing together various mathematical styles and symbols in one expression.

**Input**
````
```math
\begin{align}
\mathcal{M} &: \text{Spacetime manifold} \label{eq:manifold} \\
\bigoplus_{i \in I} \mathcal{V}_i &\subseteq \prod_{j=1}^{\infty} \mathbb{K}_j \quad \text{(direct sum of vector spaces)} \label{eq:direct-sum} \\
\mathfrak{L}[\phi] &= \int_{\mathcal{M}} \mathscr{L}(\phi, \partial_\mu \phi) \sqrt{-g} \, d^4x \label{eq:action} \\
\boldsymbol{\nabla} \times \boldsymbol{B} &= \mu_0\left(\boldsymbol{J} + \varepsilon_0\frac{\partial \boldsymbol{E}}{\partial t}\right) \label{eq:ampere-maxwell} \\
\widehat{\mathbb{Q}}_p &\curvearrowright \mathfrak{gl}_n(\mathbb{C}) \rightrightarrows \text{Aut}(\mathcal{H}) \label{eq:group-action}
\end{align}
```
````

**Output**

```math
\begin{align}
\mathcal{M} &: \text{Spacetime manifold} \label{eq:manifold} \\
\bigoplus_{i \in I} \mathcal{V}_i &\subseteq \prod_{j=1}^{\infty} \mathbb{K}_j \quad \text{(direct sum of vector spaces)} \label{eq:direct-sum} \\
\mathfrak{L}[\phi] &= \int_{\mathcal{M}} \mathscr{L}(\phi, \partial_\mu \phi) \sqrt{-g} \, d^4x \label{eq:action} \\
\boldsymbol{\nabla} \times \boldsymbol{B} &= \mu_0\left(\boldsymbol{J} + \varepsilon_0\frac{\partial \boldsymbol{E}}{\partial t}\right) \label{eq:ampere-maxwell} \\
\widehat{\mathbb{Q}}_p &\curvearrowright \mathfrak{gl}_n(\mathbb{C}) \rightrightarrows \text{Aut}(\mathcal{H}) \label{eq:group-action}
\end{align}
```

This demonstrates the rich typographical capabilities of NewCM fonts for complex mathematical notation.

## LaTeXStrings

:::tabs

== text string

```@example
using LaTeXStrings
L"an equation: $\alpha^2$"
```

== text/latex display

```@example
using LaTeXStrings
LaTeXString("an equation: \$\\alpha^2\$")
```

:::

## DataFrame

```@example
using DataFrames
DataFrame(A=1:3, B=5:7, fixed=1)
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

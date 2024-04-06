# Markdown Extension Examples

This page demonstrates some of the built-in markdown extensions provided by VitePress.

## Syntax Highlighting

VitePress provides Syntax Highlighting powered by [Shiki](https://github.com/shikijs/shiki), with additional features like line-highlighting:

**Input**

Examples from [BeautifulAlgorithms.jl](https://github.com/mossr/BeautifulAlgorithms.jl/)

````
```julia{5}
using Statistics, LinearAlgebra
function gradient_descent(𝒟train, φ, ∇loss; η=0.1, T=100)
    𝐰 = zeros(length(φ(𝒟train[1][1])))
    for t in 1:T
        𝐰 = 𝐰 .- η*mean(∇loss(x, y, 𝐰, φ) for (x,y) ∈ 𝒟train)
    end
    return 𝐰
end
```
````

**Output**

```julia{5}
using Statistics, LinearAlgebra
function gradient_descent(𝒟train, φ, ∇loss; η=0.1, T=100)
    𝐰 = zeros(length(φ(𝒟train[1][1])))
    for t in 1:T
        𝐰 = 𝐰 .- η*mean(∇loss(x, y, 𝐰, φ) for (x,y) ∈ 𝒟train)
    end
    return 𝐰
end
```

### Code groups

**Input**
````
::: code-group

```julia [neural network]
using LinearAlgebra
ReLU(z) = max(z, 0)
function neural_network(x, 𝐕, 𝐰, φ, g=ReLU)
    𝐡 = map(𝐯ⱼ -> g(𝐯ⱼ ⋅ φ(x)), 𝐕)
    𝐰 ⋅ 𝐡
end
```

```julia [one-liner]
neural_network(x, 𝐕, 𝐰, φ, g) = 𝐰 ⋅ map(𝐯ⱼ -> g(𝐯ⱼ ⋅ φ(x)), 𝐕)
```

:::
````
**Output**

::: code-group

```julia [neural network]
using LinearAlgebra
ReLU(z) = max(z, 0)
function neural_network(x, 𝐕, 𝐰, φ, g=ReLU)
    𝐡 = map(𝐯ⱼ -> g(𝐯ⱼ ⋅ φ(x)), 𝐕)
    𝐰 ⋅ 𝐡
end
```

```julia [one-liner]
neural_network(x, 𝐕, 𝐰, φ, g) = 𝐰 ⋅ map(𝐯ⱼ -> g(𝐯ⱼ ⋅ φ(x)), 𝐕)
```

:::

### Code focus
**Input**
````
```julia
using LinearAlgebra
function stochastic_gradient_descent(𝒟train, φ, ∇loss; η=0.1, T=100)
    𝐰 = zeros(length(φ(𝒟train[1][1])))
    for t in 1:T
        for (x, y) ∈ 𝒟train
            𝐰 = 𝐰 .- η*∇loss(x, y, 𝐰, φ) # ‎[!code focus]
        end
    end
    return 𝐰
end
```
````

**Output**
```julia
using LinearAlgebra
function stochastic_gradient_descent(𝒟train, φ, ∇loss; η=0.1, T=100)
    𝐰 = zeros(length(φ(𝒟train[1][1])))
    for t in 1:T
        for (x, y) ∈ 𝒟train
            𝐰 = 𝐰 .- η*∇loss(x, y, 𝐰, φ) # [!code focus]
        end
    end
    return 𝐰
end
```

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
See: https://vitepress.dev/guide/markdown#github-flavored-alerts

**Input**
````
> [!WARNING]
> Critical content.
````

**Output**

> [!WARNING]
> Critical content.

## Tables
See: https://vitepress.dev/guide/markdown#github-style-tables

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
````

**Output**

When ``a \ne 0``, there are two solutions to ``ax^2 + bx + c = 0`` and they are

$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$

Don't type anything after the last double dollar sign, and make sure there are no spaces after the opening double dollar sign in the display math!

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


## More

Check out the documentation for the [full list of markdown extensions](https://vitepress.dev/guide/markdown).


[^1]: This is Babushka's footnote!

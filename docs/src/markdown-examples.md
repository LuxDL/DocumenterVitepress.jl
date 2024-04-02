# Markdown Extension Examples

This page demonstrates some of the built-in markdown extensions provided by VitePress.

## Syntax Highlighting

VitePress provides Syntax Highlighting powered by [Shiki](https://github.com/shikijs/shiki), with additional features like line-highlighting:

**Input**

````
```js{4}
export default {
  data () {
    return {
      msg: 'Highlighted!'
    }
  }
}
```
````

**Output**

```js{4}
export default {
  data () {
    return {
      msg: 'Highlighted!'
    }
  }
}
```

### Code groups

::: code-group

```js [config.js]
/**
 * @type {import('vitepress').UserConfig}
 */
const config = {
  // ...
}

export default config
```

```ts [config.ts]
import type { UserConfig } from 'vitepress'

const config: UserConfig = {
  // ...
}

export default config
```

:::

### Code focus

```js
export default {
  data () {
    return {
      msg: 'Focused!' // [!code focus]
    }
  }
}
```
### Lists

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

> [!WARNING]
> Critical content.

## Tables
See: https://vitepress.dev/guide/markdown#github-style-tables

| Tables        |      Are      |  Cool |
| ------------- | :-----------: | ----: |
| col 3 is      | right-aligned | \$1600 |
| col 2 is      |   centered    |   \$12 |
| zebra stripes |   are neat    |    \$1 |

## Equations

When ``a \ne 0``, there are two solutions to ``ax^2 + bx + c = 0`` and they are

$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$

Don't type anything after the last double dollar sign, and make sure there are no spaces after the opening double dollar sign in the display math!

## Footnotes (citation-style)

Here is the link for the paper of Babushka[^1]

## Escaping characters

The following example:

```md
< `less` and `greater` > than, and the backtick \`.
```
outputs:

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

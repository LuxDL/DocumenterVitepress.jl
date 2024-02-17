This is currently broken: 

:cold_face: :100:

## GitHub-flavored Alerts don't work
See: https://vitepress.dev/guide/markdown#github-flavored-alerts

> [!WARNING]
> Critical content.

## Tables don't work
See: https://vitepress.dev/guide/markdown#github-style-tables

| Tables        |      Are      |  Cool |
| ------------- | :-----------: | ----: |
| col 3 is      | right-aligned | \$1600 |
| col 2 is      |   centered    |   \$12 |
| zebra stripes |   are neat    |    $1 |

## Equations work

When \$a \ne 0\$, there are two solutions to \$(ax^2 + bx + c = 0)\$ and they are

\$\$ x = {-b \pm \sqrt{b^2-4ac} \over 2a} \$\$

Don't type anything after the last doulbe dollar sign.

## Code groups work

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

## code focus

```js
export default {
  data () {
    return {
      msg: 'Focused!' // [!code focus]
    }
  }
}
```
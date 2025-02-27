
## GitHub Icon with Stars

If you want to change the GitHub icon to a different one that includes _repository stars_, you will need the [`stargazers.data.ts`](https://github.com/LuxDL/DocumenterVitepress.jl/blob/master/docs/src/components/stargazers.data.ts) and [`StarUs.vue`](https://github.com/LuxDL/DocumenterVitepress.jl/blob/master/docs/src/components/StarUs.vue) files, along with some changes to your [`index.ts`](https://github.com/LuxDL/DocumenterVitepress.jl/blob/master/docs/src/.vitepress/theme/index.ts) and [`package.json`](https://github.com/LuxDL/DocumenterVitepress.jl/blob/master/docs/package.json) files.

::: tip Change repository information

```ts
# stargazers.data.ts
const REPO = "LuxDL/DocumenterVitepress.jl"; # change to "u/repo"
```
and here

```vue
# StarUs.vue
const props = defineProps({
  repoUrl: {
    type: String,
    default: "https://github.com/LuxDL/DocumenterVitepress.jl" # change to "url repo"
  }
});
```


:::

And make sure you have the following highlighted elements:

::: code-group

```ts [index.ts]
// .vitepress/theme/index.ts
import { h } from 'vue'
import type { Theme } from 'vitepress'
import DefaultTheme from 'vitepress/theme'
import VersionPicker from "../../components/VersionPicker.vue"
import StarUs from '../../components/StarUs.vue' // [!code focus]
import AuthorBadge from '../../components/AuthorBadge.vue'
import Authors from '../../components/Authors.vue'
import { enhanceAppWithTabs } from 'vitepress-plugin-tabs/client'
import './style.css'

export default {
  extends: DefaultTheme,
  Layout() {
    return h(DefaultTheme.Layout, null, {
      'nav-bar-content-after': () => h(StarUs), // [!code focus]
    })
  },
  enhanceApp({ app, router, siteData }) {
    enhanceAppWithTabs(app);
    app.component('VersionPicker', VersionPicker);
    app.component('AuthorBadge', AuthorBadge)
    app.component('Authors', Authors)
  }
} satisfies Theme
```

```json [package.json]
{
  "devDependencies": {
    "@types/d3-format": "^3.0.4", // [!code focus]
    "@types/node": "^22.10.5", // [!code focus]
    "markdown-it": "^14.1.0",
    "markdown-it-mathjax3": "^4.3.2",
    "vitepress": "^1.5.0",
    "vitepress-plugin-tabs": "^0.5.0"
  },
  "scripts": {
    "docs:dev": "vitepress dev build/.documenter",
    "docs:build": "vitepress build build/.documenter",
    "docs:preview": "vitepress preview build/.documenter"
  },
  "dependencies": {
    "d3-format": "^3.1.0", // [!code focus]
    "markdown-it-footnote": "^4.0.0"
  }
}

```

:::
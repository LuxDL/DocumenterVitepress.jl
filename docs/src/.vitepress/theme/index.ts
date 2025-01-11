// .vitepress/theme/index.ts
import { h } from 'vue'
import type { Theme } from 'vitepress'
import DefaultTheme from 'vitepress/theme'
import AsideTrustees from '../../components/AsideTrustees.vue'
import VersionPicker from "../../components/VersionPicker.vue"
import StarUs from '../../components/StarUs.vue'
import AuthorBadge from '../../components/AuthorBadge.vue'
import Authors from '../../components/Authors.vue'
import { enhanceAppWithTabs } from 'vitepress-plugin-tabs/client'
import './style.css'

export default {
  extends: DefaultTheme,
  Layout() {
    return h(DefaultTheme.Layout, null, {
      'aside-ads-before': () => h(AsideTrustees),
      'nav-bar-content-after': () => h(StarUs),
    })
  },
  enhanceApp({ app, router, siteData }) {
    enhanceAppWithTabs(app);
    app.component('VersionPicker', VersionPicker);
    app.component('AuthorBadge', AuthorBadge)
    app.component('Authors', Authors)
  }
} satisfies Theme
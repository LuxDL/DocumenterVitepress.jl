// .vitepress/theme/index.ts
import { h } from 'vue'
import DefaultTheme from 'vitepress/theme'
import { withBase, type Theme as ThemeConfig } from 'vitepress'
import 'virtual:mathjax-styles.css';

import {
  NolebaseEnhancedReadabilitiesMenu,
  NolebaseEnhancedReadabilitiesScreenMenu,
} from '@nolebase/vitepress-plugin-enhanced-readabilities/client'

import AsideTrustees from '@/AsideTrustees.vue'
import VersionPicker from "@/VersionPicker.vue"
import StarUs from '@/StarUs.vue'
import AuthorBadge from '@/AuthorBadge.vue'
import Authors from '@/Authors.vue'
import SidebarDrawerToggle from '@/SidebarDrawerToggle.vue'
// __DV_PLUGIN_COMPONENT_IMPORTS__

import { enhanceAppWithTabs } from 'vitepress-plugin-tabs/client'

import '@nolebase/vitepress-plugin-enhanced-readabilities/client/style.css'
import './style.css' // You could setup your own, or else a default will be copied.
import './docstrings.css' // You could setup your own, or else a default will be copied.

import { runPluginScriptHooks } from './plugin-hooks'

// Root-relative URLs inside `v-html` content bypass Vite's own base
// resolution, so this adds it by hand; already-absolute URLs are untouched.
// Exported for plugin-hooks.ts, whose injected content may need to rebase a URL.
export function rebase(url: string): string {
  return url.startsWith('/') && !url.startsWith('//') ? withBase(url) : url
}

// `v-exec-scripts` runs the <script> tags inside a `v-html`'d block: innerHTML never executes
// scripts, so we re-create each one. `src` scripts are awaited so order holds (bundle before
// its callers). Used on interactive text/html output (WGLMakie/Bonito, Plotly) which the writer
// wraps in <ClientOnly> + this directive.
async function activateScripts(container: Element): Promise<void> {
  for (const old of Array.from(container.querySelectorAll('script'))) {
    await runPluginScriptHooks()
    const fresh = document.createElement('script')
    for (const attr of Array.from(old.attributes)) {
      const value = attr.name === 'src' ? rebase(attr.value) : attr.value
      fresh.setAttribute(attr.name, value)
    }
    fresh.textContent = old.textContent
    const hasSrc = old.hasAttribute('src')
    const ran = hasSrc
      ? new Promise<void>((resolve) => {
          fresh.addEventListener('load', () => resolve(), { once: true })
          fresh.addEventListener('error', () => resolve(), { once: true })
        })
      : Promise.resolve()
    old.replaceWith(fresh) // inserting is what runs it; inline scripts run synchronously
    await ran
  }
}

export const Theme: ThemeConfig = {
  extends: DefaultTheme,
  Layout() {
    return h(DefaultTheme.Layout, null, {
      'aside-ads-before': () => h(AsideTrustees),
      'nav-bar-content-after': () => [
        h(StarUs),
        h(NolebaseEnhancedReadabilitiesMenu), // Enhanced Readabilities menu
      ],
      // A enhanced readabilities menu for narrower screens (usually smaller than iPad Mini)
      'nav-screen-content-after': () => h(NolebaseEnhancedReadabilitiesScreenMenu),
      // Sidebar drawer toggle button (to the left of search bar)
      'nav-bar-content-before': () => h(SidebarDrawerToggle),
    })
  },
  enhanceApp({ app, router, siteData }) {
    enhanceAppWithTabs(app);
    app.component('VersionPicker', VersionPicker);
    app.component('AuthorBadge', AuthorBadge)
    app.component('Authors', Authors)

    // Execute the scripts inside interactive `text/html` outputs (WGLMakie/Bonito, Plotly, …)
    // once their `<ClientOnly>` wrapper has mounted on the client. `mounted` fires on the
    // initial client render and again whenever the page component is remounted by a
    // client-side navigation, so figures initialise instead of staying blank.
    app.directive('exec-scripts', {
      mounted(el: HTMLElement) {
        activateScripts(el)
      },
    })
    // __DV_PLUGIN_COMPONENT_REGISTRATIONS__
  }
}
export default Theme

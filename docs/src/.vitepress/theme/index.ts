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

// A root-relative `src`/`href` (e.g. from a plugin shipping static files into
// `public/`, such as the Bonito asset bundle) needs the deploy `base` prepended.
// Content injected via `v-html` bypasses Vite's own asset resolution (which does this
// automatically for links it compiles itself), so it's done by hand here. Left alone
// if already absolute (`//host/...`, `https://...`) or already base-relative.
function rebase(url: string): string {
  return url.startsWith('/') && !url.startsWith('//') ? withBase(url) : url
}

// Bonito's own client runtime (`window.Bonito.fetch_binary`/`load_script`) fetches
// root-relative URLs baked into its *inline* bootstrap script (`Bonito.init_session(id,
// Bonito.fetch_binary('/bonito/bin/…'), …)`) — text content `rebase()` above can't reach,
// since rewriting arbitrary script text would risk mangling unrelated string literals.
// Patched once, as soon as the Bonito bundle defines `window.Bonito` (its first script),
// so the very next inline script's `fetch_binary` call already resolves correctly.
function patchBonitoFetchUrls(): void {
  const B = (window as any).Bonito
  if (!B || B.__dvRebased) return
  B.__dvRebased = true
  for (const name of ['fetch_binary', 'load_script']) {
    const orig = B[name]
    if (typeof orig === 'function') {
      B[name] = (url: string, ...rest: unknown[]) => orig(rebase(url), ...rest)
    }
  }
}

// `v-exec-scripts` runs the <script> tags inside a `v-html`'d block: innerHTML never executes
// scripts, so we re-create each one. `src` scripts are awaited so order holds (bundle before
// its callers). Used on interactive text/html output (WGLMakie/Bonito, Plotly) which the writer
// wraps in <ClientOnly> + this directive.
async function activateScripts(container: Element): Promise<void> {
  for (const old of Array.from(container.querySelectorAll('script'))) {
    patchBonitoFetchUrls()
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

// .vitepress/theme/index.ts
import { h, nextTick } from 'vue'
import DefaultTheme from 'vitepress/theme'
import type { Theme as ThemeConfig } from 'vitepress'
import 'virtual:mathjax-styles.css';

import { 
  NolebaseEnhancedReadabilitiesMenu, 
  NolebaseEnhancedReadabilitiesScreenMenu, 
} from '@nolebase/vitepress-plugin-enhanced-readabilities/client'

import VersionPicker from "@/VersionPicker.vue"
import AuthorBadge from '@/AuthorBadge.vue'
import Authors from '@/Authors.vue'
import SidebarDrawerToggle from '@/SidebarDrawerToggle.vue'

import { enhanceAppWithTabs } from 'vitepress-plugin-tabs/client'

import '@nolebase/vitepress-plugin-enhanced-readabilities/client/style.css'
import './style.css' // You could setup your own, or else a default will be copied.
import './docstrings.css' // You could setup your own, or else a default will be copied.

// ---------------------------------------------------------------------------
// Re-execute <script> tags in `text/html` show-output blocks after client-side
// navigation.
//
// DocumenterVitepress renders `Base.show(::IO, ::MIME"text/html", x)` output via
// Vue's `v-html` (see `render_mime(::MIME"text/html")` in `src/writer.jl`), tagging
// the wrapper with the `vp-raw-html` class.  `v-html` compiles to `el.innerHTML = …`,
// and the browser never executes `<script>` elements inserted via `innerHTML`.
//
// On a hard page load this is invisible, because VitePress server-renders the markup
// and the browser's HTML parser runs the baked-in scripts.  But VitePress is a SPA:
// on client-side navigation the page is mounted on the client, `innerHTML` is set, and
// the scripts never run.  Interactive outputs that bootstrap from `<script>` tags —
// most notably WGLMakie/Bonito figures — therefore silently fail to appear (you just
// see the Bonito loading spinner) until the page is hard-reloaded.
//
// `reactivateRawHtml` walks every `.vp-raw-html` block and replaces its `<script>`
// elements with freshly-created, executable copies, preserving document order (it waits
// for `src` scripts to load before running the next, so ordering dependencies such as
// "load the bundle before calling into it" are respected).
function activateScripts(container: Element): void {
  const scripts = Array.from(container.querySelectorAll('script'))
  // Run sequentially to preserve execution order (bundle before init, etc.).
  let chain: Promise<void> = Promise.resolve()
  for (const old of scripts) {
    chain = chain.then(
      () =>
        new Promise<void>((resolve) => {
          const fresh = document.createElement('script')
          for (const attr of Array.from(old.attributes)) {
            fresh.setAttribute(attr.name, attr.value)
          }
          fresh.textContent = old.textContent
          const hasSrc = old.hasAttribute('src')
          if (hasSrc) {
            const done = () => resolve()
            fresh.addEventListener('load', done, { once: true })
            fresh.addEventListener('error', done, { once: true })
          }
          // Inserting the fresh element is what actually makes the browser run it.
          old.replaceWith(fresh)
          // Inline scripts execute synchronously on insertion; src scripts resolve on load.
          if (!hasSrc) resolve()
        }),
    )
  }
}

function reactivateRawHtml(): void {
  if (typeof document === 'undefined') return
  document.querySelectorAll('.vp-raw-html').forEach((el) => activateScripts(el))
}

export const Theme: ThemeConfig = {
  extends: DefaultTheme,
  Layout() {
    return h(DefaultTheme.Layout, null, {
      'nav-bar-content-after': () => [
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

    // After a client-side navigation, re-run the scripts in `text/html` outputs so that
    // interactive figures (WGLMakie/Bonito, Plotly, …) initialise instead of staying blank.
    // We deliberately only do this on navigation, not on the initial load: on the initial
    // load the scripts are already executed by the browser's HTML parser, so re-running them
    // would render the figure twice.
    if (!import.meta.env.SSR) {
      const previous = router.onAfterRouteChanged
      router.onAfterRouteChanged = (to: string) => {
        previous?.(to)
        // Wait for the freshly-navigated page (including its `v-html` content) to be in the
        // DOM before re-activating the scripts.
        nextTick(() => requestAnimationFrame(reactivateRawHtml))
      }
    }
  }
}
export default Theme
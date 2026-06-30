// .vitepress/theme/index.ts
import { h } from 'vue'
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
// Execute <script> tags in interactive `text/html` show-output blocks.
//
// DocumenterVitepress renders `Base.show(::IO, ::MIME"text/html", x)` output via Vue's
// `v-html` (see `render_mime(::MIME"text/html")` in `src/writer.jl`). `v-html` compiles to
// `el.innerHTML = …`, and the browser never executes `<script>` elements inserted via
// `innerHTML`. Interactive outputs that bootstrap from `<script>` tags — most notably
// WGLMakie/Bonito figures — therefore fail to appear (you just see a loading spinner).
//
// For such output the writer wraps the block in `<ClientOnly>` (so it is not server-rendered)
// and tags it with `v-exec-scripts`. This directive runs after the element mounts on the
// client — on the initial render *and* on every client-side navigation (each navigation
// remounts the page component) — and replaces every `<script>` with a freshly-created,
// executable copy, preserving document order (it waits for `src` scripts to load before
// running the next, so "load the bundle before calling into it" ordering holds).
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

    // Execute the scripts inside interactive `text/html` outputs (WGLMakie/Bonito, Plotly, …)
    // once their `<ClientOnly>` wrapper has mounted on the client. `mounted` fires on the
    // initial client render and again whenever the page component is remounted by a
    // client-side navigation, so figures initialise instead of staying blank.
    app.directive('exec-scripts', {
      mounted(el: HTMLElement) {
        activateScripts(el)
      },
    })
  }
}
export default Theme
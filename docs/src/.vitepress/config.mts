import { defineConfig } from 'vitepress'
import { tabsMarkdownPlugin } from 'vitepress-plugin-tabs'
import mathjax3 from "markdown-it-mathjax3";
import footnote from "markdown-it-footnote";

// https://vitepress.dev/reference/site-config
export default defineConfig({
  base: 'REPLACE_ME_WITH_DOCUMENTER_VITEPRESS_BASE_URL_WITH_TRAILING_SLASH',
  title: "DocumenterVitepress",
  description: "A VitePress Site",
  lastUpdated: true,
  cleanUrls: true,
  head: [['link', { rel: 'icon', href: '/base/favicon.ico' }]],
  
  markdown: {
    math: true,
    config(md) {
      md.use(tabsMarkdownPlugin),
      md.use(mathjax3),
      md.use(footnote)
    },
    theme: {
      light: "github-light",
      dark: "github-dark"}
  },
  themeConfig: {
    outline: 'deep',
    // https://vitepress.dev/reference/default-theme-config
    logo: { src: '/logo_dark.png', width: 24, height: 24 },
    search: {
      provider: 'local',
      options: {
        detailedView: true
      }
    },
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Getting Started', link: '/getting_started' },
      { text: 'Markdown', link: '/markdown-examples' },
      { text: 'Code', link: '/code_example' },
      { text: 'API', link: '/api-examples' }
    ],

    sidebar: [
      {
        text: 'Examples',
        items: [
          { text: 'Getting Started', link: '/getting_started' },
          { text: 'Markdown Examples', link: '/markdown-examples' },
          { text: 'Code Examples', link: '/code_example' },
          { text: 'API', link: '/api-examples' }
        ]
      }
    ],
    editLink: {
      pattern: 'https://github.com/LuxDL/DocumenterVitepress.jl/edit/main/docs/src/:path'
    },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/LuxDL/DocumenterVitepress.jl' }
    ],
    footer: {
      message: 'Made with <a href="https://documenter.juliadocs.org/stable/" target="_blank"><strong>Documenter.jl</strong></a> & <a href="https://vitepress.dev" target="_blank"><strong>VitePress</strong></a> <br>',
      copyright: `© Copyright ${new Date().getUTCFullYear()}. Released under the MIT License.`
    }
  }
})

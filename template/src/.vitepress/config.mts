import { defineConfig, DefaultTheme } from 'vitepress'
import { tabsMarkdownPlugin } from 'vitepress-plugin-tabs'
import mathjax3 from "markdown-it-mathjax3";
import footnote from "markdown-it-footnote";
import path from 'path'

function getBaseRepository(base: string): string {
  if (!base || base === '/') return '/';
  const parts = base.split('/').filter(Boolean);
  return parts.length > 0 ? `/${parts[0]}/` : '/';
}

type DocumenterOptions = {
  base: string;
  deployAbspath: string;
  description: string;
  editLink?: DefaultTheme.EditLink;
  favicon?: string;
  githubLink: string;
  logo: string;
  outDir: string;
  nav: Array<any>;
  sidebar?: DefaultTheme.Sidebar;
  title: string;
}

// this will be filled in by DocumenterVitepress at render time
const DOCUMENTER = {} as DocumenterOptions;

const faviconConfig: HeadConfig = ['link', { rel: 'icon', href: `${DOCUMENTER.base}${DOCUMENTER.favicon}` }]

// https://vitepress.dev/reference/site-config
export default defineConfig({
  base: DOCUMENTER.base,
  title: DOCUMENTER.title,
  description: DOCUMENTER.description,
  lastUpdated: true,
  cleanUrls: true,
  outDir: DOCUMENTER.outDir,
  head: [
    ...(DOCUMENTER.favicon ? [faviconConfig] : []),
    ['script', {src: `${getBaseRepository(DOCUMENTER.base)}versions.js`}],
    ['script', {src: `${DOCUMENTER.base}siteinfo.js`}]
  ],
  
  vite: {
    define: {
      __DEPLOY_ABSPATH__: JSON.stringify(DOCUMENTER.deployAbspath),
    },
    resolve: {
      alias: {
        '@': path.resolve(__dirname, '../components')
      }
    },
    optimizeDeps: {
      exclude: [ 
        '@nolebase/vitepress-plugin-enhanced-readabilities/client',
        'vitepress',
        '@nolebase/ui',
      ], 
    }, 
    ssr: { 
      noExternal: [ 
        // If there are other packages that need to be processed by Vite, you can add them here.
        '@nolebase/vitepress-plugin-enhanced-readabilities',
        '@nolebase/ui',
      ], 
    },
  },
  markdown: {
    math: true,
    config(md) {
      md.use(tabsMarkdownPlugin),
      md.use(mathjax3),
      md.use(footnote)
    },
    theme: {
      light: "github-light",
      dark: "github-dark"
    },
  },
  themeConfig: {
    outline: 'deep',
    ...(DOCUMENTER.logo ? { src: DOCUMENTER.logo, width: 24, height: 24} : {}),
    search: {
      provider: 'local',
      options: {
        detailedView: true
      }
    },
    nav: [
      ...DOCUMENTER.nav,
      {
        component: 'VersionPicker'
      }
    ],
    sidebar: DOCUMENTER.sidebar,
    editLink: DOCUMENTER.editLink,
    socialLinks: [
      { icon: 'github', link: DOCUMENTER.githubLink }
    ],
    footer: {
      message: 'Made with <a href="https://luxdl.github.io/DocumenterVitepress.jl/dev/" target="_blank"><strong>DocumenterVitepress.jl</strong></a><br>',
      copyright: `© Copyright ${new Date().getUTCFullYear()}.`
    }
  }
})

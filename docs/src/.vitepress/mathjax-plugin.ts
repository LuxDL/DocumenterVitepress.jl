// mathjax-plugin.ts
// @ts-ignore
import MathJax from '@mathjax/src'
import type { Plugin as VitePlugin } from 'vite'
import type MarkdownIt from 'markdown-it'
import { tex as mdTex } from '@mdit/plugin-tex'

const mathjaxStyleModuleID = 'virtual:mathjax-styles.css'

type OutputFormat = 'svg' | 'chtml'

interface MathJaxOptions {
  output?: OutputFormat
  font?: string
}

// Initialize MathJax
async function initializeMathJax(options: MathJaxOptions = {}) {
  const outputFormat = options.output || 'svg'
  const font = options.font || 'mathjax-newcm'

  const config: any = {
    loader: {
      load: ['input/tex', `output/${outputFormat}`, '[tex]/boldsymbol', '[tex]/braket', '[tex]/mathtools'],
    },
    tex: {
      tags: 'ams',
      packages: {
        '[+]': ['boldsymbol', 'braket', 'mathtools']
      }
    },
  }

  if (outputFormat === 'svg') {
    config.output = {
      font: font,
      displayOverflow: 'linebreak',
      mtextInheritFont: true,
    }
    config.svg = {
      fontCache: 'none', // must have, fully avoids dynamic loads
    }
  } else {
    config.output = {
      font: font,
      displayOverflow: 'scroll',
      mtextInheritFont: true,
    }
    config.chtml = {
      fontURL: `@mathjax/mathjax-${font}-font/chtml/woff2`,
    }
  }

  await MathJax.init(config)

  // Pre-load all dynamic font files
  const fontData = MathJax.config[outputFormat].fontData
  if (fontData?.dynamicFiles) {
    const dynamicFiles = fontData.dynamicFiles
    const dynamicFileNames = Object.keys(dynamicFiles)
    const dynamicPrefix: string = fontData.OPTIONS?.dynamicPrefix || fontData.options?.dynamicPrefix

    if (dynamicPrefix) {
      await Promise.all(
        dynamicFileNames.map(async (name) => {
          try {
            await import(/* @vite-ignore */ dynamicPrefix + '/' + name + '.js')
            if (dynamicFiles[name]?.setup) {
              dynamicFiles[name].setup(MathJax.startup.output.font)
            }
          } catch {
            // Silently ignore missing dynamic files
          }
        })
      )
    }
  }
}

export function mathjaxPlugin(options: MathJaxOptions = {}) {
  const outputFormat = options.output || 'svg'
  let adaptor: any
  let initialized = false

  async function ensureInitialized() {
    if (!initialized) {
      await initializeMathJax(options)
      adaptor = MathJax.startup.adaptor
      initialized = true
    }
  }

  function renderMath(content: string, displayMode: boolean): string {
    if (!initialized) {
      throw new Error('MathJax not initialized')
    }

    const convertFunc = outputFormat === 'svg' ? MathJax.tex2svg : MathJax.tex2chtml
    const node = convertFunc(content, { display: displayMode })
    
    // Use adaptor API to add v-pre attribute
    adaptor.setAttribute(node, 'v-pre', '')
    
    // Get HTML
    let html = adaptor.outerHTML(node)
    
    // Only for SVG: handle mjx-break spacing
    if (outputFormat === 'svg') {
      html = html.replace(
        /<mjx-break(.*?)>(.*?)<\/mjx-break>/g,
        (_: string, attr: string, inner: string) =>
          `<mjx-break${attr}>${inner.replace(/ /g, '&nbsp;')}</mjx-break>`
      )
    }
    
    return html
  }

  function getMathJaxStyles(): string {
    if (!initialized) {
      return ''
    }
    const stylesheetFunc = outputFormat === 'svg' ? MathJax.svgStylesheet : MathJax.chtmlStylesheet
    let style = adaptor.textContent(stylesheetFunc()) || ''
    
    // Fix sqrt top border for CHTML
    if (outputFormat === 'chtml') {
      style += `
mjx-sqrt > mjx-box {
  border-top-style: solid !important;
}
`
    }
    
    return style
  }

  function resetMathJax(): void {
    if (!initialized) return
    MathJax.texReset()
    MathJax.typesetClear()
  }

  function viteMathJax(): VitePlugin {
    const virtualModuleID = '\0' + mathjaxStyleModuleID
    return {
      name: 'mathjax-styles',
      resolveId(id) {
        if (id === mathjaxStyleModuleID) {
          return virtualModuleID
        }
      },
      async load(id) {
        if (id === virtualModuleID) {
          await ensureInitialized()
          return getMathJaxStyles()
        }
      },
    }
  }

  function mdMathJax(md: MarkdownIt): void {
    mdTex(md, {
      render: renderMath,
    })
    
    // Reset MathJax between renders
    const orig = md.render
    md.render = function (...args) {
      resetMathJax()
      return orig.apply(this, args)
    }
  }

  const initPromise = ensureInitialized()

  return {
    vitePlugin: viteMathJax(),
    markdownConfig: mdMathJax,
    styleModuleID: mathjaxStyleModuleID,
    init: initPromise,
  }
}
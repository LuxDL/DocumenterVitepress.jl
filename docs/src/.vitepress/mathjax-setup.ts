// adapted from https://github.com/orgs/vuepress-theme-hope/discussions/5178#discussion-9331015

// @ts-ignore
import MathJax from '@mathjax/src';

await MathJax.init({
  loader: {
    load: ['input/tex', 'output/svg', '[tex]/boldsymbol', '[tex]/braket'],
  },
  output: {
    font: 'mathjax-newcm',
    displayOverflow: 'linebreak',
    mtextInheritFont: true,
  },
  tex: {
    tags: 'ams',
    packages: {
      '[+]': ['boldsymbol', 'braket']
    }
  },
  svg: {
    fontCache: 'none', // a must, fully avoids dynamic loads.
  },
});

const adaptor = MathJax.startup.adaptor;

// Pre-load all dynamic font files
async function loadDynamicFiles() {
  const fontData = MathJax.config.svg.fontData;
  const dynamicFiles = fontData.dynamicFiles;
  const dynamicFileNames = Object.keys(dynamicFiles);
  const dynamicPrefix: string = fontData.OPTIONS.dynamicPrefix;
  await Promise.all(
    dynamicFileNames.map(async (name) => {
      try {
        await import(dynamicPrefix + '/' + name + '.js');
        fontData.dynamicFiles[name].setup(MathJax.startup.output.font);
      } catch {}
    })
  );
}

await loadDynamicFiles();

// Export renderer function
export function renderMath(content: string, displayMode: boolean): string {
  const node = MathJax.tex2svg(content, { display: displayMode });
  const html = adaptor
    .outerHTML(node)
    .replace(
      /<mjx-container/g,
      '<mjx-container v-pre'
    )
    .replace(
      /<mjx-break(.*?)>(.*?)<\/mjx-break>/g,
      (_: string, attr: string, inner: string) =>
        `<mjx-break${attr}>${inner.replace(/ /g, '&nbsp;')}</mjx-break>`
    );
  return html;
}

export function getMathJaxStyles(): string {
  return adaptor.textContent(MathJax.svgStylesheet()) || '';
}

export function resetMathJax(): void {
  MathJax.texReset();
  MathJax.typesetClear();
}
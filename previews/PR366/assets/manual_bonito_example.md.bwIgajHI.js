import{_ as a,C as n,ap as e,o,c as l,al as p,E as d,w as r,a2 as h,j as c}from"./chunks/framework.D6HxoCvB.js";const x=JSON.parse('{"title":"Bonito interactivity","description":"","frontmatter":{},"headers":[],"relativePath":"manual/bonito_example.md","filePath":"manual/bonito_example.md","lastUpdated":null}'),k={name:"manual/bonito_example.md"},g={class:"vp-raw-html",innerHTML:`<div><div class="bonito-fragment" id="19310dd5-8037-4135-a291-0d3840dc9ff1" data-jscall-id="root" style="display:contents"><div style="display:contents"><script src="/bonito/js/Bonito.bundled1018692352274101644.js" type="module"><\/script><style></style><style>@media (prefers-color-scheme: light) {
  :root {
    --bonito-widget-fg: #1a1a1a;
    --bonito-widget-accent: #3182bb;
    --bonito-widget-bg: #ffffff;
    --bonito-widget-border: #9ca3af;
    --bonito-widget-hover-bg: #f3f4f6;
    --bonito-widget-muted-bg: #f3f4f6;
    accent-color: #3182bb;
    color-scheme: light;
  }
}
@media (prefers-color-scheme: dark) {
  :root {
    --bonito-widget-fg: #e8e8ea;
    --bonito-widget-accent: #6ea8e0;
    --bonito-widget-bg: #2a2a2e;
    --bonito-widget-border: #52525b;
    --bonito-widget-hover-bg: #3a3a40;
    --bonito-widget-muted-bg: #36363c;
    accent-color: #6ea8e0;
    color-scheme: dark;
  }
}
html .noUi-target {
  border-color: var(--bonito-widget-border, #d3d3d3);
  box-shadow: none;
  background: var(--bonito-widget-muted-bg, #fafafa);
}
html .noUi-connects {
  background: var(--bonito-widget-muted-bg, #fafafa);
}
html .noUi-connect {
  background: var(--bonito-widget-accent, #3182bb);
}
html .noUi-handle {
  border-color: var(--bonito-widget-border, #d3d3d3);
  box-shadow: none;
  background: var(--bonito-widget-bg, #fff);
}
html .noUi-handle::before {
  background: var(--bonito-widget-border, #d3d3d3);
}
html .noUi-handle::after {
  background: var(--bonito-widget-border, #d3d3d3);
}
html .noUi-tooltip {
  border-color: var(--bonito-widget-border, #d3d3d3);
  color: var(--bonito-widget-fg, #000);
  background: var(--bonito-widget-bg, #fff);
}
html .noUi-marker {
  background: var(--bonito-widget-border, #ccc);
}
html .noUi-value {
  color: var(--bonito-widget-fg, inherit);
}
</style></div><div style="display:contents"><script type="module">Bonito.init_session("19310dd5-8037-4135-a291-0d3840dc9ff1", Bonito.fetch_binary('/bonito/bin/ada2470696f3e3340787c90e3ba9eb566bc40f15-14505845153022441360.bin'), "root", false);
<\/script><div></div></div></div><div class="bonito-fragment" id="59473d61-9e1f-4b70-986c-dd077a890b16" data-jscall-id="subsession-application-dom" style="display:contents"><div style="display:contents"><style>.style_2 {
  min-width: 8rem;
  font-weight: 600;
  padding-right: 0.75rem;
  border-color: var(--bonito-widget-border, #9CA3AF);
  padding-bottom: 0.25rem;
  box-shadow: rgba(0, 0, 0, 0) 0px 0px 0px 0px, rgba(0, 0, 0, 0) 0px 0px 0px 0px, rgba(0, 0, 0, 0.1) 0px 1px 3px 0px, rgba(0, 0, 0, 0.1) 0px 1px 2px -1px;
  border-radius: 0.25rem;
  font-size: 1rem;
  background-color: var(--bonito-widget-bg, white);
  border-width: 1px;
  padding-left: 0.75rem;
  padding-top: 0.25rem;
  cursor: pointer;
  color: var(--bonito-widget-fg, inherit);
  margin: 0.25rem;
}
.style_3:hover {
  background-color: var(--bonito-widget-hover-bg, #F9FAFB);
  box-shadow: rgba(0, 0, 0, 0) 0px 0px 0px 0px, rgba(0, 0, 0, 0) 0px 0px 0px 0px, rgba(0, 0, 0, 0.1) 0px 1px 3px 0px, rgba(0, 0, 0, 0.1) 0px 1px 2px -1px;
}
.style_4:focus {
  outline-offset: 1px;
  box-shadow: rgba(66, 153, 225, 0.5) 0px 0px 0px 1px;
  outline: 1px solid transparent;
}
</style></div><div style="display:contents"><script type="module">Bonito.init_session("59473d61-9e1f-4b70-986c-dd077a890b16", Bonito.fetch_binary('/bonito/bin/88df06e4550b58107c932b6593df2888633405c7-7578720233822455407.bin'), "sub", false);
<\/script><div data-jscall-id="2"><button onclick="" class=" style_2 style_3 style_4" style="" data-jscall-id="3">Click me&#33;</button><p data-jscall-id="4">Clicks: <span data-jscall-id="1">0</span></p></div></div></div></div>`};function b(u,s,E,y,m,f){const i=n("ClientOnly"),t=e("exec-scripts");return o(),l("div",null,[s[0]||(s[0]=p(`<h1 id="Bonito-interactivity" tabindex="-1">Bonito interactivity <a class="header-anchor" href="#Bonito-interactivity" aria-label="Permalink to &quot;Bonito interactivity {#Bonito-interactivity}&quot;">​</a></h1><p><a href="https://github.com/SimonDanisch/Bonito.jl" target="_blank" rel="noreferrer">Bonito.jl</a> renders interactive apps and widgets (it also powers WGLMakie figures) as <code>text/html</code> output. DocumenterVitepress executes the <code>&lt;script&gt;</code> tags such output contains on the client, both on first load and after client-side navigation, so Bonito apps work without a hard page reload.</p><p>Add <code>DocumenterVitepress.BonitoPlugin()</code> to <code>makedocs(plugins = [...])</code> to have Bonito&#39;s JS/CSS bundle shipped once through the site&#39;s <code>public/</code> folder instead of being re-embedded inline on every figure. <code>Page()</code> still goes at the top of the page exactly as <a href="https://github.com/SimonDanisch/Bonito.jl/blob/master/docs/src/deployment.md#documenter" target="_blank" rel="noreferrer">Bonito&#39;s own docs</a> describe; nothing else about writing a Bonito app changes.</p><p>A counter that keeps working after the page is exported to static HTML: the click handler updates the counter&#39;s own DOM node directly in JavaScript, so no running Julia session is needed once deployed (see Bonito&#39;s <a href="https://github.com/SimonDanisch/Bonito.jl/blob/master/docs/src/interactions.md#creating-interactive-examples" target="_blank" rel="noreferrer">static-export notes</a>).</p><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@example bonito</span></span>
<span class="line"><span>App() do session</span></span>
<span class="line"><span>    count = DOM.span(&quot;0&quot;)</span></span>
<span class="line"><span>    button = Button(&quot;Click me!&quot;)</span></span>
<span class="line"><span>    onjs(session, button.value, js&quot;&quot;&quot;</span></span>
<span class="line"><span>        function (clicked) {</span></span>
<span class="line"><span>            const el = $(count)</span></span>
<span class="line"><span>            el.textContent = String(parseInt(el.textContent, 10) + 1)</span></span>
<span class="line"><span>        }</span></span>
<span class="line"><span>        &quot;&quot;&quot;)</span></span>
<span class="line"><span>    return DOM.div(button, DOM.p(&quot;Clicks: &quot;, count))</span></span>
<span class="line"><span>end</span></span>
<span class="line"><span>\`\`\`</span></span></code></pre></div><p><strong>Output</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">App</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">do</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> session</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    count </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> DOM</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">span</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;0&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    button </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Button</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Click me!&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    onjs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(session, button</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">value, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">js</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;&quot;&quot;</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">        function</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> (</span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70;">clicked</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) {</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">            const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> el</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> $</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(count)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">            el.textContent </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">parseInt</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(el.textContent, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">10</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">+</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">        }</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">        &quot;&quot;&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    return</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> DOM</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">div</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(button, DOM</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">p</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Clicks: &quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, count))</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">end</span></span></code></pre></div>`,8)),d(i,null,{default:r(()=>[h(c("div",g,null,512),[[t]])]),_:1})])}const F=a(k,[["render",b]]);export{x as __pageData,F as default};

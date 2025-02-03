import{_ as a,c as i,o as n,al as p}from"./chunks/framework.DH_PFOSl.js";const c=JSON.parse('{"title":"Julia code examples","description":"","frontmatter":{},"headers":[],"relativePath":"code_example.md","filePath":"code_example.md","lastUpdated":null}'),e={name:"code_example.md"};function t(l,s,h,o,d,k){return n(),i("div",null,s[0]||(s[0]=[p(`<h1 id="Julia-code-examples" tabindex="-1">Julia code examples <a class="header-anchor" href="#Julia-code-examples" aria-label="Permalink to &quot;Julia code examples {#Julia-code-examples}&quot;">​</a></h1><p><strong>Fonts</strong></p><p>This package uses the JuliaMono font by default, but you can override this in CSS.</p><p>This is what some common symbols look like:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">] [ </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> $</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> ; ( @ { </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot; ) ? . } ⊽ ⊼ ⊻ ⊋ ⊊ ⊉ ⊈ ⊇ ⊆ ≥ ≤ ≢ ≡ ≠ ≉ ≈ ∪ ∩ ∜ ∛ √ ∘ ∌</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">|&gt; /&gt; ^ % \` ∈</span></span></code></pre></div><h2 id="example" tabindex="-1">@example <a class="header-anchor" href="#example" aria-label="Permalink to &quot;@example&quot;">​</a></h2><p>The <code>Julia</code> code used here is done using the following packages versions:</p><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@example version</span></span>
<span class="line"><span>using Pkg</span></span>
<span class="line"><span>Pkg.status()</span></span>
<span class="line"><span>\`\`\`</span></span></code></pre></div><p><strong>Output</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Pkg</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Pkg</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">status</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>Status \`~/work/DocumenterVitepress.jl/DocumenterVitepress.jl/docs/Project.toml\`</span></span>
<span class="line"><span>  [e30172f5] Documenter v1.8.0</span></span>
<span class="line"><span>  [daee34ce] DocumenterCitations v1.3.5</span></span>
<span class="line"><span>  [4710194d] DocumenterVitepress v0.1.6 \`~/work/DocumenterVitepress.jl/DocumenterVitepress.jl\`</span></span></code></pre></div><p>And a simple sum:</p><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@example simple_sum</span></span>
<span class="line"><span>2 + 2</span></span>
<span class="line"><span>\`\`\`</span></span></code></pre></div><p><strong>Output</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">2</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> +</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 2</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>4</span></span></code></pre></div><h2 id="ansi" tabindex="-1">@ansi <a class="header-anchor" href="#ansi" aria-label="Permalink to &quot;@ansi&quot;">​</a></h2><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@ansi</span></span>
<span class="line"><span>printstyled(&quot;this is my color&quot;; color = :red)</span></span>
<span class="line"><span>\`\`\`</span></span></code></pre></div><p><strong>Output</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">julia</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> printstyled</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;this is my color&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">; color </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> :red</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#d73a49;--shiki-dark:#ea4a5a;">this is my color</span></span></code></pre></div><p>A more colorful example from <a href="https://documenter.juliadocs.org/stable/showcase/#Raw-ANSI-code-output" target="_blank" rel="noreferrer">documenter</a>:</p><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@ansi</span></span>
<span class="line"><span>for color in 0:15</span></span>
<span class="line"><span>    print(&quot;\\e[38;5;$color;48;5;$(color)m  &quot;)</span></span>
<span class="line"><span>    print(&quot;\\e[49m&quot;, lpad(color, 3), &quot; &quot;)</span></span>
<span class="line"><span>    color % 8 == 7 &amp;&amp; println() # ‎[!code highlight]</span></span>
<span class="line"><span>end</span></span>
<span class="line"><span>\`\`\`</span></span></code></pre></div><p><strong>Output</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark has-highlighted vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">julia</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> for</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> color </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">in</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">15</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">           print</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">\\e</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">[38;5;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">$color</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">;48;5;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">$(color)</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">m  &quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">           print</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">\\e</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">[49m&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">lpad</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(color, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">), </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot; &quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line highlighted"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">           color </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">%</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 8</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ==</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 7</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &amp;&amp;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> println</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">       end</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292e;--shiki-dark:#586069;">    0 </span><span style="--shiki-light:#d73a49;--shiki-dark:#ea4a5a;">    1 </span><span style="--shiki-light:#28a745;--shiki-dark:#34d058;">    2 </span><span style="--shiki-light:#dbab09;--shiki-dark:#ffea7f;">    3 </span><span style="--shiki-light:#0366d6;--shiki-dark:#2188ff;">    4 </span><span style="--shiki-light:#5a32a3;--shiki-dark:#b392f0;">    5 </span><span style="--shiki-light:#1b7c83;--shiki-dark:#39c5cf;">    6 </span><span style="--shiki-light:#6a737d;--shiki-dark:#d1d5da;">    7 </span></span>
<span class="line"><span style="--shiki-light:#959da5;--shiki-dark:#959da5;">    8 </span><span style="--shiki-light:#cb2431;--shiki-dark:#f97583;">    9 </span><span style="--shiki-light:#22863a;--shiki-dark:#85e89d;">   10 </span><span style="--shiki-light:#b08800;--shiki-dark:#ffea7f;">   11 </span><span style="--shiki-light:#005cc5;--shiki-dark:#79b8ff;">   12 </span><span style="--shiki-light:#5a32a3;--shiki-dark:#b392f0;">   13 </span><span style="--shiki-light:#3192aa;--shiki-dark:#56d4dd;">   14 </span><span style="--shiki-light:#d1d5da;--shiki-dark:#fafbfc;">   15</span></span></code></pre></div><h2 id="eval" tabindex="-1">@eval <a class="header-anchor" href="#eval" aria-label="Permalink to &quot;@eval&quot;">​</a></h2><p>From <a href="https://docs.julialang.org/en/v1/" target="_blank" rel="noreferrer">Julia&#39;s documentation</a> landing page.</p><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@eval</span></span>
<span class="line"><span>io = IOBuffer()</span></span>
<span class="line"><span>release = isempty(VERSION.prerelease)</span></span>
<span class="line"><span>v = &quot;$(VERSION.major).$(VERSION.minor)&quot;</span></span>
<span class="line"><span>!release &amp;&amp; (v = v*&quot;-$(first(VERSION.prerelease))&quot;)</span></span>
<span class="line"><span>print(io, &quot;&quot;&quot;</span></span>
<span class="line"><span>    # Julia $(v) Documentation</span></span>
<span class="line"><span></span></span>
<span class="line"><span>    Welcome to the documentation for Julia $(v).</span></span>
<span class="line"><span></span></span>
<span class="line"><span>    &quot;&quot;&quot;)</span></span>
<span class="line"><span>if true # !release</span></span>
<span class="line"><span>    print(io,&quot;&quot;&quot;</span></span>
<span class="line"><span>        !!! warning &quot;Work in progress!&quot;</span></span>
<span class="line"><span>            This documentation is for an unreleased, in-development, version of Julia.</span></span>
<span class="line"><span>        &quot;&quot;&quot;)</span></span>
<span class="line"><span>end</span></span>
<span class="line"><span>import Markdown</span></span>
<span class="line"><span>Markdown.parse(String(take!(io)))</span></span>
<span class="line"><span>\`\`\`</span></span>
<span class="line"><span></span></span>
<span class="line"><span>\`\`\`@eval</span></span>
<span class="line"><span>file = &quot;julia-1.10.2.pdf&quot;</span></span>
<span class="line"><span>url = &quot;https://raw.githubusercontent.com/JuliaLang/docs.julialang.org/assets/$(file)&quot;</span></span>
<span class="line"><span>import Markdown</span></span>
<span class="line"><span>Markdown.parse(&quot;&quot;&quot;</span></span>
<span class="line"><span>!!! note</span></span>
<span class="line"><span>    The documentation is also available in PDF format: [$file]($url).</span></span>
<span class="line"><span>&quot;&quot;&quot;)</span></span>
<span class="line"><span>\`\`\`</span></span></code></pre></div><p><strong>Output</strong></p><h1 id="julia-1-11-documentation" tabindex="-1">Julia 1.11 Documentation <a class="header-anchor" href="#julia-1-11-documentation" aria-label="Permalink to &quot;Julia 1.11 Documentation&quot;">​</a></h1><p>Welcome to the documentation for Julia 1.11.</p><div class="warning custom-block"><p class="custom-block-title">Work in progress!</p><p>This documentation is for an unreleased, in-development, version of Julia.</p></div><div class="tip custom-block"><p class="custom-block-title">Note</p><p>The documentation is also available in PDF format: <a href="https://raw.githubusercontent.com/JuliaLang/docs.julialang.org/assets/julia-1.10.2.pdf" target="_blank" rel="noreferrer">julia-1.10.2.pdf</a>.</p></div><h2 id="repl" tabindex="-1">@repl <a class="header-anchor" href="#repl" aria-label="Permalink to &quot;@repl&quot;">​</a></h2><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@repl</span></span>
<span class="line"><span>a = 1;</span></span>
<span class="line"><span>b = 2;</span></span>
<span class="line"><span>a + b</span></span>
<span class="line"><span>\`\`\`</span></span></code></pre></div><p><strong>Output</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">julia</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">julia</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> b </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">julia</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">+</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> b</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">3</span></span></code></pre></div><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@repl</span></span>
<span class="line"><span>a = 1;</span></span>
<span class="line"><span>b = 2; # [!code focus] # hide</span></span>
<span class="line"><span>a + b</span></span>
<span class="line"><span>\`\`\`</span></span></code></pre></div><p><strong>Output</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">julia</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">julia</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">+</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> b</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">3</span></span></code></pre></div><h2 id="doctest" tabindex="-1">@doctest <a class="header-anchor" href="#doctest" aria-label="Permalink to &quot;@doctest&quot;">​</a></h2><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@doctest</span></span>
<span class="line"><span>julia&gt; 1 + 1</span></span>
<span class="line"><span>2</span></span>
<span class="line"><span></span></span>
<span class="line"><span>\`\`\`</span></span></code></pre></div><p><strong>Output</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">julia</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> +</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">2</span></span></code></pre></div><h2 id="meta" tabindex="-1">@meta <a class="header-anchor" href="#meta" aria-label="Permalink to &quot;@meta&quot;">​</a></h2><p>Supported meta tags:</p><ul><li><code>CollapsedDocStrings</code>: works similar to Documenter.jl. If provided, the docstrings in that page will be collapsed by default. Defaults to <code>false</code>. See the <a href="/DocumenterVitepress.jl/previews/PR207/internal_api#internal_api">Internal API</a> page for how the docstrings are displayed when this is set to <code>true</code>. Example usage:</li></ul><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@meta</span></span>
<span class="line"><span>CollapsedDocStrings = true</span></span>
<span class="line"><span>\`\`\`</span></span></code></pre></div>`,58)]))}const g=a(e,[["render",t]]);export{c as __pageData,g as default};

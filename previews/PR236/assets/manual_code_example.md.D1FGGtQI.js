import{_ as a,c as i,o as n,al as e}from"./chunks/framework.CM16GmdN.js";const k=JSON.parse('{"title":"Julia code examples","description":"","frontmatter":{},"headers":[],"relativePath":"manual/code_example.md","filePath":"manual/code_example.md","lastUpdated":null}'),l={name:"manual/code_example.md"};function t(p,s,o,h,r,d){return n(),i("div",null,s[0]||(s[0]=[e(`<h1 id="Julia-code-examples" tabindex="-1">Julia code examples <a class="header-anchor" href="#Julia-code-examples" aria-label="Permalink to &quot;Julia code examples {#Julia-code-examples}&quot;">​</a></h1><p><strong>Fonts</strong></p><p>This package uses the JuliaMono font by default, but you can override this in CSS.</p><p>This is what some common symbols look like:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">] [ </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> $</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> ; ( @ { </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot; ) ? . } ⊽ ⊼ ⊻ ⊋ ⊊ ⊉ ⊈ ⊇ ⊆ ≥ ≤ ≢ ≡ ≠ ≉ ≈ ∪ ∩ ∜ ∛ √ ∘ ∌</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">|&gt; /&gt; ^ % \` ∈</span></span></code></pre></div><h2 id="example" tabindex="-1">@example <a class="header-anchor" href="#example" aria-label="Permalink to &quot;@example&quot;">​</a></h2><p>The <code>Julia</code> code used here is done using the following packages versions:</p><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@example version</span></span>
<span class="line"><span>using Pkg</span></span>
<span class="line"><span>Pkg.status()</span></span>
<span class="line"><span>\`\`\`</span></span></code></pre></div><p><strong>Output</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Pkg</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Pkg</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">status</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>Status \`~/work/DocumenterVitepress.jl/DocumenterVitepress.jl/docs/Project.toml\`</span></span>
<span class="line"><span>  [e30172f5] Documenter v1.8.1</span></span>
<span class="line"><span>  [daee34ce] DocumenterCitations v1.3.6</span></span>
<span class="line"><span>  [4710194d] DocumenterVitepress v0.1.11 \`~/work/DocumenterVitepress.jl/DocumenterVitepress.jl\`</span></span></code></pre></div><p>And a simple sum:</p><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@example simple_sum</span></span>
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
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">2</span></span></code></pre></div><h2 id="meta" tabindex="-1">@meta <a class="header-anchor" href="#meta" aria-label="Permalink to &quot;@meta&quot;">​</a></h2><p>Supported meta tags:</p><ul><li><code>CollapsedDocStrings</code>: works similar to Documenter.jl. If provided, the docstrings in that page will be collapsed by default. Defaults to <code>false</code>. See the <a href="/DocumenterVitepress.jl/previews/PR236/devs/internal_api#internal_api">Internal API</a> page for how the docstrings are displayed when this is set to <code>true</code>. Example usage:</li></ul><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@meta</span></span>
<span class="line"><span>CollapsedDocStrings = true</span></span>
<span class="line"><span>\`\`\`</span></span></code></pre></div><h2 id="contents" tabindex="-1">@contents <a class="header-anchor" href="#contents" aria-label="Permalink to &quot;@contents&quot;">​</a></h2><p>Use this to create a list of content.</p><p><strong>Input</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>\`\`\`@contents</span></span>
<span class="line"><span>Pages = [</span></span>
<span class="line"><span>    &quot;get_started.md&quot;,</span></span>
<span class="line"><span>    &quot;documenter_to_vitepress_docs_example.md&quot;,</span></span>
<span class="line"><span>    &quot;style_css.md&quot;,</span></span>
<span class="line"><span>    &quot;code_example.md&quot;,</span></span>
<span class="line"><span>    &quot;markdown-examples.md&quot;,</span></span>
<span class="line"><span>    &quot;mime_examples.md&quot;,</span></span>
<span class="line"><span>    &quot;citations.md&quot;,</span></span>
<span class="line"><span>    &quot;style_css.md&quot;,</span></span>
<span class="line"><span>    &quot;author_badge.md&quot;,</span></span>
<span class="line"><span>    &quot;repo_stars.md&quot;,</span></span>
<span class="line"><span>    &quot;../devs/render_pipeline.md&quot;,</span></span>
<span class="line"><span>    &quot;../devs/internal_api.md&quot;,</span></span>
<span class="line"><span>    &quot;../api.md&quot;</span></span>
<span class="line"><span>    ]</span></span>
<span class="line"><span>Depth = 3</span></span>
<span class="line"><span>\`\`\`</span></span></code></pre></div><p><strong>Output</strong></p><ul><li><a href="./get_started#Get-Started">Get Started</a><ul><li><a href="./get_started#Simple-method">Simple method</a><ul><li><a href="./get_started#Preview-Documentation-Development-Instantly">Preview Documentation Development Instantly</a></li></ul></li><li><a href="./get_started#Advanced-method">Advanced method</a></li><li><a href="./get_started#Project-structure">Project structure</a></li><li><a href="./get_started#VitePress-Installation">VitePress Installation</a><ul><li><a href="./get_started#prerequisites">Prerequisites</a></li></ul></li><li><a href="./get_started#Build-new-docs-from-docs/src">Build new docs from docs/src</a></li><li><a href="./get_started#Setting-up-the-Folder-Structure">Setting up the Folder Structure</a></li></ul></li><li><a href="./documenter_to_vitepress_docs_example#Upgrading-docs-from-Documenter.jl-to-DocumenterVitepress.jl">Upgrading docs from Documenter.jl to DocumenterVitepress.jl</a></li><li><a href="./code_example#Julia-code-examples">Julia code examples</a><ul><li><a href="./code_example#example">@example</a></li><li><a href="./code_example#ansi">@ansi</a></li><li><a href="./code_example#eval">@eval</a></li><li><a href="./code_example#repl">@repl</a></li><li><a href="./code_example#doctest">@doctest</a></li><li><a href="./code_example#meta">@meta</a></li><li><a href="./code_example#contents">@contents</a></li></ul></li><li><a href="./markdown-examples#Markdown-Extension-Examples">Markdown Extension Examples</a><ul><li><a href="./markdown-examples#Syntax-Highlighting">Syntax Highlighting</a><ul><li><a href="./markdown-examples#Line-Highlight">Line Highlight</a></li><li><a href="./markdown-examples#Highlight-multiple-lines">Highlight multiple lines</a></li><li><a href="./markdown-examples#Focus-a-line">Focus a line</a></li><li><a href="./markdown-examples#Focus-multiple-lines">Focus multiple lines</a></li><li><a href="./markdown-examples#Added-and-removed-lines">Added and removed lines</a></li><li><a href="./markdown-examples#Code-error,-code-warning">Code error, code warning</a></li><li><a href="./markdown-examples#Code-groups">Code groups</a></li><li><a href="./markdown-examples#lists">Lists</a></li></ul></li><li><a href="./markdown-examples#Custom-Containers">Custom Containers</a></li><li><a href="./markdown-examples#tabs">Tabs</a></li><li><a href="./markdown-examples#Nested-Tabs">Nested Tabs</a></li><li><a href="./markdown-examples#GitHub-flavored-Alerts">GitHub flavored Alerts</a></li><li><a href="./markdown-examples#tables">Tables</a></li><li><a href="./markdown-examples#equations">Equations</a></li><li><a href="./markdown-examples#latex_symbols_in_headings">latex_symbols_in_headings</a></li><li><a href="./markdown-examples#Footnotes-(citation-style)">Footnotes (citation style)</a></li><li><a href="./markdown-examples#Escaping-characters">Escaping characters</a></li><li>[<a href="https://github.com/LuxDL/DocumenterVitepress.jl" target="_blank" rel="noreferrer">Heading with a link</a> and <em>italic</em> font](markdown-examples#<a href="https://github.com/LuxDL/DocumenterVitepress.jl" target="_blank" rel="noreferrer">Heading-with-a-link</a>-and-<em>italic</em>-font)</li><li><a href="./markdown-examples#more">More</a></li></ul></li><li><a href="./mime_examples#MIME-type-examples">MIME type examples</a></li><li><a href="./citations#DocumenterCitations.jl-integration">DocumenterCitations.jl integration</a></li><li><a href="./citations#gallery">gallery</a><ul><li><a href="./citations#numeric_style">numeric_style</a></li><li><a href="./citations#author_year_style">author_year_style</a></li><li><a href="./citations#alphabetic_style">alphabetic_style</a></li><li><a href="./citations#custom_styles">custom_styles</a><ul><li><a href="./citations#Custom-style:-enumerated-author-year">Custom style: enumerated author year</a></li><li><a href="./citations#Custom-style:-Citation-key-labels">Custom style: Citation key labels</a></li></ul></li></ul></li><li><a href="./style_css#CSS-Styling">CSS Styling</a><ul><li><a href="./style_css#Layout-options">Layout options</a></li><li><a href="./style_css#All-available-space">All available space</a></li><li><a href="./style_css#more">More</a></li></ul></li><li><a href="./author_badge#AuthorBadge-and-platform-icons">AuthorBadge and platform icons</a></li><li><a href="./repo_stars#GitHub-Icon-with-Stars">GitHub Icon with Stars</a></li><li><a href="./../devs/render_pipeline#The-rendering-process">The rendering process</a><ul><li><a href="./../devs/render_pipeline#documenter-jl">Documenter.jl</a></li><li><a href="./../devs/render_pipeline#vitepress">VitePress</a></li><li><a href="./../devs/render_pipeline#finalization">Finalization</a></li></ul></li><li><a href="./../devs/internal_api#internal_api">internal_api</a></li><li><a href="./../api#Public-API">Public API</a></li></ul>`,64)]))}const u=a(l,[["render",t]]);export{k as __pageData,u as default};

import{_ as e,c as a,o as i,al as t}from"./chunks/framework.BZjtBlVN.js";const u=JSON.parse('{"title":"Get Started","description":"","frontmatter":{},"headers":[],"relativePath":"manual/get_started.md","filePath":"manual/get_started.md","lastUpdated":null}'),n={name:"manual/get_started.md"};function o(l,s,p,d,r,c){return i(),a("div",null,s[0]||(s[0]=[t(`<h1 id="Get-Started" tabindex="-1">Get Started <a class="header-anchor" href="#Get-Started" aria-label="Permalink to &quot;Get Started {#Get-Started}&quot;">​</a></h1><h2 id="Simple-method" tabindex="-1">Simple method <a class="header-anchor" href="#Simple-method" aria-label="Permalink to &quot;Simple method {#Simple-method}&quot;">​</a></h2><p>You can simply add <code>using DocumenterVitepress</code> to your <code>make.jl</code> file, and replace <code>format = HTML(...)</code> in <code>makedocs</code> with:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">makedocs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    format </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MarkdownVitepress</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">        repo </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &quot;&lt;url_to_your_repo&gt;&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    )</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>and that should be it!</p><details class="details custom-block"><summary>stop any vitepress session</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark has-highlighted vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;"># you might need to stop the Vitepress server if it&#39;s running before</span></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;"># updating or creating new files</span></span>
<span class="line highlighted error"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">try</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> run</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">\`pkill -f vitepress\`</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">catch</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> end</span></span></code></pre></div></details><p>The section <a href="/DocumenterVitepress.jl/previews/PR232/manual/get_started#Advanced-method">Advanced method</a> describes how to get more control over your Vitepress build.</p><h3 id="Preview-Documentation-Development-Instantly" tabindex="-1">Preview Documentation Development Instantly <a class="header-anchor" href="#Preview-Documentation-Development-Instantly" aria-label="Permalink to &quot;Preview Documentation Development Instantly {#Preview-Documentation-Development-Instantly}&quot;">​</a></h3><p>You can preview your documentation development changes locally, instantly by adding <a href="https://github.com/tlienart/LiveServer.jl" target="_blank" rel="noreferrer">LiveServer.jl</a> into your <code>docs</code> environment and making a few tweaks to your <code>make.jl</code> configuration.</p><div class="tip custom-block"><p class="custom-block-title">Note</p><p>As of now, these tweaks <strong>must</strong> be removed from your <code>make.jl</code> before you deploy your documentation to whatever deployment service you use or <strong>your deployment will fail</strong>.</p></div><p>Here are the tweaks to add:</p><ol><li><p>Navigate into your <code>docs</code> directory and add <code>LiveServer.jl</code> with <code>(docs)&gt; add LiveServer</code></p></li><li><p>Within the <code>MarkdownVitepress</code> configuration of your <code>make.jl</code> file, pass the following two key word arguments and their values: i. <code>md_output_path = &quot;.&quot;</code> ii. <code>build_vitepress = false</code></p></li><li><p>Within the <code>makedocs</code> command within your <code>make.jl</code> file, pass the following key word argument: i. <code>clean = false</code></p></li></ol><p>Then, to preview changes live, open two separate Julia instances both within the <code>docs</code> folder and activate the <code>docs</code> environment in both sessions. Within one session run <code>using LiveServer; servedocs(foldername=&quot;/path/to/your/docs/folder&quot;)</code> (this could be something like <code>servedocs(foldername=&quot;docs/&quot;)</code> or <code>servedocs(foldername=pwd())</code>). In the other session run <code>DocumenterVitepress.dev_docs(&quot;build&quot;, md_output_path = &quot;&quot;)</code>.</p><p>Now, with both these instances running, you can add your changes into your documentation and should see <code>servedocs</code> trigger a rebuild and <code>dev_docs</code> update as well which then leads to finally your browser being updated in real time.</p><div class="tip custom-block"><p class="custom-block-title">Note</p><p>For some user set-ups, you may see your browser instead direct you to a page mentioning <code>REPLACE_ME_DOCUMENTER_VITEPRESS</code> and the output from <code>dev_docs</code> mentioning that page as well. If this happens to you, that is due to <code>DocumenterVitepress</code> not picking up <code>servedocs</code> changes fast enough (this comes from a quirk of the underlying JS <code>vitepress</code> library). To get around this, within your documentation, add a small sleep delay like so:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">\`\`\`@example</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">sleep(0.1)</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">\`\`\`</span></span></code></pre></div><p>Generally, <code>0.1</code> seconds should be enough but you may need to adjust that delay timer if you still have the issue.</p></div><h2 id="Advanced-method" tabindex="-1">Advanced method <a class="header-anchor" href="#Advanced-method" aria-label="Permalink to &quot;Advanced method {#Advanced-method}&quot;">​</a></h2><p>If you want to customize your Vitepress build, including CSS etc., you will want to add the necessary Vitepress files to your <code>docs/src/.vitepress</code> folder.</p><p>As a tutorial, we will go through and explain the folder and files structure used to generate this website. You could use this as a template for your project&#39;s documentation.</p><div class="tip custom-block"><p class="custom-block-title">Quick start</p><p>In general, you can copy the <code>template</code> folder to your <code>docs</code> folder and the <code>.github/Documenter.yml</code> action file from <a href="https://github.com/LuxDL/DocumenterVitepress.jl" target="_blank" rel="noreferrer">DocumenterVitepress.jl</a> to your repo, and be pretty much good to go and edit docs as usual!</p></div><p>Since we&#39;re concerned only with documentation, we&#39;ll specifically look at the <code>docs</code> folder of your Julia project or package here.</p><p>For more information on how to structure this, see the <a href="https://documenter.juliadocs.org/stable/man/guide/" target="_blank" rel="noreferrer">Documenter.jl guide</a>! In this quick start, we will focus solely on how to set up DocumenterVitepress assuming you already have some basic docs (even just an <code>index.md</code> will do).</p><h2 id="Project-structure" tabindex="-1">Project structure <a class="header-anchor" href="#Project-structure" aria-label="Permalink to &quot;Project structure {#Project-structure}&quot;">​</a></h2><p>In order to start as quickly as possible, we recommend you copy the <code>Project.toml</code>, <code>make.jl</code>, <code>package.json</code>, and <code>src</code> folders to your own documentation.</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>DocumenterVitepress/docs</span></span>
<span class="line"><span>├── Project.toml</span></span>
<span class="line"><span>├── make.jl</span></span>
<span class="line"><span>├── package-lock.json</span></span>
<span class="line"><span>├── package.json</span></span>
<span class="line"><span>└── src</span></span>
<span class="line"><span>    ├── getting_started.md</span></span>
<span class="line"><span>    ├── index.md</span></span>
<span class="line"><span>    └── assets</span></span>
<span class="line"><span>        └── favicon.ico</span></span>
<span class="line"><span>        └── logo_dark.png</span></span>
<span class="line"><span>    └── .vitepress</span></span>
<span class="line"><span>        ├── config.mts</span></span>
<span class="line"><span>        └── theme</span></span>
<span class="line"><span>            └── index.ts</span></span>
<span class="line"><span>            └── style.css</span></span></code></pre></div><p>You can ignore the rest of the files which are actually in <code>DocumenterVitepress/docs/src</code> for now - those show how to use advanced APIs, like</p><h2 id="VitePress-Installation" tabindex="-1">VitePress Installation <a class="header-anchor" href="#VitePress-Installation" aria-label="Permalink to &quot;VitePress Installation {#VitePress-Installation}&quot;">​</a></h2><p>Start at the <code>docs</code> level:</p><div class="language-sh vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">sh</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">docs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> $</span></span></code></pre></div><h3 id="prerequisites" tabindex="-1">Prerequisites <a class="header-anchor" href="#prerequisites" aria-label="Permalink to &quot;Prerequisites&quot;">​</a></h3><p>DocumenterVitepress.jl is completely self-contained and installs all of its dependencies (including its own isolated version of <code>npm</code>) automatically.</p><p>However, to view your documentation live when developing locally, you will need to install <code>npm</code> and instantiate the</p><p>VitePress can be used on its own, or be installed into an existing project. In both cases, you can install it with:</p><div class="vp-code-group vp-adaptive-theme"><div class="tabs"><input type="radio" name="group-1yiCA" id="tab-3b5xdkd" checked><label data-title="npm" for="tab-3b5xdkd">npm</label><input type="radio" name="group-1yiCA" id="tab-ApTRUI1"><label data-title="pnpm" for="tab-ApTRUI1">pnpm</label><input type="radio" name="group-1yiCA" id="tab-pdN3obi"><label data-title="yarn" for="tab-pdN3obi">yarn</label><input type="radio" name="group-1yiCA" id="tab-FoxIKbD"><label data-title="bun" for="tab-FoxIKbD">bun</label></div><div class="blocks"><div class="language-sh vp-adaptive-theme active"><button title="Copy Code" class="copy"></button><span class="lang">sh</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">npm</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> add</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> -D</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> vitepress</span></span></code></pre></div><div class="language-sh vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">sh</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">pnpm</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> add</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> -D</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> vitepress</span></span></code></pre></div><div class="language-sh vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">sh</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">yarn</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> add</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> -D</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> vitepress</span></span></code></pre></div><div class="language-sh vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">sh</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">bun</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> add</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> -D</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> vitepress</span></span></code></pre></div></div></div><h2 id="Build-new-docs-from-docs/src" tabindex="-1">Build new docs from docs/src <a class="header-anchor" href="#Build-new-docs-from-docs/src" aria-label="Permalink to &quot;Build new docs from docs/src {#Build-new-docs-from-docs/src}&quot;">​</a></h2><p>To start working on your docs do the following steps:</p><div class="language-sh vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">sh</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">$</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> cd</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> docs</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">docs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> $</span></span></code></pre></div><p>Then, in <code>docs</code> start a julia session and activate a new environment.</p><div class="language-sh vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">sh</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">docs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> $ </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">julia</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">julia</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">]</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">pkg</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">activate</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> .</span></span></code></pre></div><p>Add packages as necessary. Here, we will need</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">pkg</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> add DocumenterVitepress, Documenter</span></span></code></pre></div><p>These packages will be used in the <code>make.jl</code> file.</p><h2 id="Setting-up-the-Folder-Structure" tabindex="-1">Setting up the Folder Structure <a class="header-anchor" href="#Setting-up-the-Folder-Structure" aria-label="Permalink to &quot;Setting up the Folder Structure {#Setting-up-the-Folder-Structure}&quot;">​</a></h2><p>The files for this page in the <code>docs</code> folder have the following structure:</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>docs/</span></span>
<span class="line"><span>├── Project.toml</span></span>
<span class="line"><span>├── make.jl</span></span>
<span class="line"><span>├── package-lock.json</span></span>
<span class="line"><span>├── package.json</span></span>
<span class="line"><span>└── src</span></span>
<span class="line"><span>    ├── getting_started.md</span></span>
<span class="line"><span>    ├── index.md</span></span>
<span class="line"><span>    └── assets</span></span>
<span class="line"><span>        └── favicon.ico</span></span>
<span class="line"><span>        └── logo_dark.png</span></span>
<span class="line"><span>    └── .vitepress</span></span>
<span class="line"><span>        ├── config.mts</span></span>
<span class="line"><span>        └── theme</span></span>
<span class="line"><span>            └── index.ts</span></span>
<span class="line"><span>            └── style.css</span></span></code></pre></div><p>Then, run <code>docs/make.jl</code>, and in another terminal in the <code>docs</code> directory, run:</p><div class="language-sh vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">sh</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">docs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> $ </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">npm</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> run</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> docs:dev</span></span></code></pre></div><p>This will deploy your documentation locally on a webserver. See <a href="https://vitepress.dev/guide/getting-started#up-and-running" target="_blank" rel="noreferrer">here</a> to know more.</p><p>If you want to know more about the rendering, go to the <a href="./../devs/render_pipeline">rendering process</a> section. And for ways of using <code>markdown</code>, visit the <a href="./markdown-examples#tabs">tabs</a> or the <a href="./code_example">Code</a> sections for examples.</p>`,48)]))}const k=e(n,[["render",o]]);export{u as __pageData,k as default};

import{_ as l,C as p,c as o,o as r,j as s,a as i,al as a,G as n}from"./chunks/framework.BOGymGlf.js";const F=JSON.parse('{"title":"","description":"","frontmatter":{"outline":"deep"},"headers":[],"relativePath":"devs/internal_api.md","filePath":"devs/internal_api.md","lastUpdated":null}'),d={name:"devs/internal_api.md"},h={class:"jldocstring custom-block"},c={class:"jldocstring custom-block"},u={class:"jldocstring custom-block"},k={class:"jldocstring custom-block"},g={class:"jldocstring custom-block"},m={class:"jldocstring custom-block"},y={class:"jldocstring custom-block"};function b(E,e,_,f,C,v){const t=p("Badge");return r(),o("div",null,[e[21]||(e[21]=s("h2",{id:"internal_api",tabindex:"-1"},[i("Internal API "),s("a",{class:"header-anchor",href:"#internal_api","aria-label":'Permalink to "Internal API {#internal_api}"'},"​")],-1)),e[22]||(e[22]=s("p",null,"These functions are not part of the public API, and are subject to change without notice.",-1)),s("details",h,[s("summary",null,[e[0]||(e[0]=s("a",{id:"DocumenterVitepress.build_docs-Tuple{String}",href:"#DocumenterVitepress.build_docs-Tuple{String}"},[s("span",{class:"jlbinding"},"DocumenterVitepress.build_docs")],-1)),e[1]||(e[1]=i()),n(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[2]||(e[2]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">build_docs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(builddir</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">; md_output_path </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &quot;.documenter&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Builds the Vitepress site in the given directory.</p><p>If passing a String, pass the path to the <code>builddir</code>, i.e., <code>$packagepath/docs/build</code>.</p><p><a href="https://github.com/LuxDL/DocumenterVitepress.jl/blob/8a4d3b250b3d78c7a29c16ccd84cdebf484a40c3/src/vitepress_interface.jl#L18-L24" target="_blank" rel="noreferrer">source</a></p>',4))]),s("details",c,[s("summary",null,[e[3]||(e[3]=s("a",{id:"DocumenterVitepress.dev_docs-Tuple{String}",href:"#DocumenterVitepress.dev_docs-Tuple{String}"},[s("span",{class:"jlbinding"},"DocumenterVitepress.dev_docs")],-1)),e[4]||(e[4]=i()),n(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[5]||(e[5]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dev_docs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(builddir</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">; md_output_path </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &quot;.documenter&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Runs the vitepress dev server to serve the docs built from the Markdown files (generated by <code>makedocs</code>) in the given directory.</p><p>If passing a String, pass the path to the <code>builddir</code>, i.e., <code>$packagepath/docs/build</code>.</p><p>For now, these assume that the Markdown files generated are in <code>$builddir/.documenter</code>. Work is in progress to let the user pass the config object to fix this.</p><div class="warning custom-block"><p class="custom-block-title">Warning</p><p>This does <strong>NOT</strong> run <code>makedocs</code> - you have to do that yourself! Think of it as the second stage of <code>LiveServer.jl</code> for DocumenterVitepress specifically.</p></div><p><a href="https://github.com/LuxDL/DocumenterVitepress.jl/blob/8a4d3b250b3d78c7a29c16ccd84cdebf484a40c3/src/vitepress_interface.jl#L1-L15" target="_blank" rel="noreferrer">source</a></p>',6))]),s("details",u,[s("summary",null,[e[6]||(e[6]=s("a",{id:"DocumenterVitepress.docpath-Tuple{Any, Any, Any}",href:"#DocumenterVitepress.docpath-Tuple{Any, Any, Any}"},[s("span",{class:"jlbinding"},"DocumenterVitepress.docpath")],-1)),e[7]||(e[7]=i()),n(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[8]||(e[8]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">docpath</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(file, mdfolder)</span></span></code></pre></div><p>This function takes the filename <code>file</code>, and returns a file path in the <code>mdfolder</code> directory which has the same tree as the <code>src</code> directory. This is used to ensure that the Markdown files are output in the correct location for Vitepress to find them.</p><p><a href="https://github.com/LuxDL/DocumenterVitepress.jl/blob/8a4d3b250b3d78c7a29c16ccd84cdebf484a40c3/src/writer.jl#L76-L81" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",k,[s("summary",null,[e[9]||(e[9]=s("a",{id:"DocumenterVitepress.generate_template",href:"#DocumenterVitepress.generate_template"},[s("span",{class:"jlbinding"},"DocumenterVitepress.generate_template")],-1)),e[10]||(e[10]=i()),n(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[11]||(e[11]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">generate_template</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(target_directory</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, package </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &quot;YourPackage&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Copies template files from <code>DocumenterVitepress.jl</code> to a target directory, replacing &quot;YourPackage&quot; with the specified package name in <code>package</code>.</p><p><code>target</code> should be the directory of your package&#39;s documentation, and not its root!</p><p>Skips existing files and only updates new ones.</p><p><strong>Arguments</strong></p><ul><li><p><code>target_directory</code>: Destination for template files.</p></li><li><p><code>package</code>: Name to replace &quot;YourPackage&quot; with, defaulting to &quot;YourPackage&quot;.</p></li></ul><p><strong>Example</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">generate_template</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;.julia/dev/MyPackage/docs&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;MyPackage&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p><a href="https://github.com/LuxDL/DocumenterVitepress.jl/blob/8a4d3b250b3d78c7a29c16ccd84cdebf484a40c3/src/DocumenterVitepress.jl#L30-L48" target="_blank" rel="noreferrer">source</a></p>',9))]),s("details",g,[s("summary",null,[e[12]||(e[12]=s("a",{id:"DocumenterVitepress.mime_priority",href:"#DocumenterVitepress.mime_priority"},[s("span",{class:"jlbinding"},"DocumenterVitepress.mime_priority")],-1)),e[13]||(e[13]=i()),n(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[14]||(e[14]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">mime_priority</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(mime</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">MIME</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Float64</span></span></code></pre></div><p>This function returns a priority for a given MIME type, which is used to select the best MIME type for rendering a given element. Priority is in ascending order, i.e., 1 has more priority than 0.</p><p><a href="https://github.com/LuxDL/DocumenterVitepress.jl/blob/8a4d3b250b3d78c7a29c16ccd84cdebf484a40c3/src/writer.jl#L498-L504" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",m,[s("summary",null,[e[15]||(e[15]=s("a",{id:"DocumenterVitepress.modify_config_file-Tuple{Any, Any, Any}",href:"#DocumenterVitepress.modify_config_file-Tuple{Any, Any, Any}"},[s("span",{class:"jlbinding"},"DocumenterVitepress.modify_config_file")],-1)),e[16]||(e[16]=i()),n(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[17]||(e[17]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">modify_config_file</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(doc, settings, deploy_decision)</span></span></code></pre></div><p>Modifies the config file located at <code>\\$builddir/\\$md_output_path/.vitepress/config.mts</code> to include attributes determined at runtime.</p><p>In general, the config file will contain various strings like <code>REPLACE_ME_DOCUMENTER_VITEPRESS</code> which this function will replace with content.</p><p><strong>Replaced config items</strong></p><p>Currently, this function replaces the following config items:</p><ul><li><p>Vitepress base path (<code>base</code>)</p></li><li><p>Vitepress output path (<code>outDir</code>)</p></li><li><p>Navbar</p></li><li><p>Sidebar</p></li><li><p>Title</p></li><li><p>Edit link</p></li><li><p>Github repo link</p></li><li><p>Logo</p></li><li><p>Favicon</p></li></ul><p><strong>Adding new config hooks</strong></p><p>Simply add more elements to the <code>replacers</code> array within this function.</p><p><a href="https://github.com/LuxDL/DocumenterVitepress.jl/blob/8a4d3b250b3d78c7a29c16ccd84cdebf484a40c3/src/vitepress_config.jl#L2-L25" target="_blank" rel="noreferrer">source</a></p>',9))]),s("details",y,[s("summary",null,[e[18]||(e[18]=s("a",{id:"DocumenterVitepress.render",href:"#DocumenterVitepress.render"},[s("span",{class:"jlbinding"},"DocumenterVitepress.render")],-1)),e[19]||(e[19]=i()),n(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[20]||(e[20]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">render</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(args</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>This is the main entry point and recursive function to render a Documenter document to Markdown in the Vitepress flavour. It is called by <code>Documenter.build</code> and should not be called directly.</p><p><strong>Methods</strong></p><p>To extend this function, the general signature is:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">render</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(io</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, mime</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">MIME&quot;text/plain&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, node</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Documenter.MarkdownAST.Node</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, element</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Eltype</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, page, doc; kwargs</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>where <code>Eltype</code> is the type of the <code>element</code> field of the <code>node</code> object which you care about.</p><p><a href="https://github.com/LuxDL/DocumenterVitepress.jl/blob/8a4d3b250b3d78c7a29c16ccd84cdebf484a40c3/src/writer.jl#L88-L102" target="_blank" rel="noreferrer">source</a></p>',7))])])}const T=l(d,[["render",b]]);export{F as __pageData,T as default};

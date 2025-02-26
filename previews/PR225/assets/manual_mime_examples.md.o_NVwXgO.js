import{_ as i,c as a,o as t,al as e}from"./chunks/framework.DXAp2aap.js";const n="/DocumenterVitepress.jl/previews/PR225/assets/flngouh.CZ_Jmq_w.png",p="/DocumenterVitepress.jl/previews/PR225/assets/qfvodam.BduoxwAJ.png",l="/DocumenterVitepress.jl/previews/PR225/assets/hkriyzr.yDDNeA3I.jpeg",h="/DocumenterVitepress.jl/previews/PR225/assets/wlcywio.Drfs-ROQ.svg",k="/DocumenterVitepress.jl/previews/PR225/assets/frjwexx.C-W3LInb.gif",F=JSON.parse('{"title":"MIME-type examples","description":"","frontmatter":{},"headers":[],"relativePath":"manual/mime_examples.md","filePath":"manual/mime_examples.md","lastUpdated":null}'),d={name:"manual/mime_examples.md"};function r(o,s,E,g,u,c){return t(),a("div",null,s[0]||(s[0]=[e(`<h1 id="MIME-type-examples" tabindex="-1">MIME-type examples <a class="header-anchor" href="#MIME-type-examples" aria-label="Permalink to &quot;MIME-type examples {#MIME-type-examples}&quot;">​</a></h1><p>This file tests the output for all available MIME-types.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;&quot;&quot;</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">    MediaOutput{MIME&quot;...&quot;}(contents::String)</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">A struct representing media output with a specific MIME type.</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"># Fields</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">- \`contents::String\`: The contents of the media output.</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;&quot;&quot;</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">struct</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> MediaOutput{MimeType}</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    contents</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Vector{UInt8}</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">end</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">MediaOutput</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">{MimeType}</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(contents</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">where</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> MimeType </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MediaOutput{MimeType}</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Vector{UInt8}</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(contents))</span></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;"># This defines the show method for the target MIME type only!</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Base</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">show</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(io, </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">MimeType</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, media</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">MediaOutput{MimeType}</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">where</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> MimeType </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(io, media</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">contents)</span></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;"># MediaOutput{MIME&quot;text/plain&quot;}(&quot;Hello there!&quot;)</span></span></code></pre></div><p>PNG images that carry pixel density metadata will be shown at the correct size. This is a plot rendered at high pixel density which does not carry dpi metadata.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> DocumenterVitepress</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">MediaOutput{MIME&quot;image/png&quot;}</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">joinpath</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">pathof</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(DocumenterVitepress) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">|&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> dirname </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">|&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> dirname, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;docs&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;src&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;assets&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;plot_without_dpi.png&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)))</span></span></code></pre></div><p><img src="`+n+`" alt="" width="832px" height="602px"></p><p>And this is the same plot but with dpi metadata embedded. DocumenterVitepress annotates the corrected size in its Markdown output.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> DocumenterVitepress</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">MediaOutput{MIME&quot;image/png&quot;}</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">joinpath</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">pathof</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(DocumenterVitepress) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">|&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> dirname </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">|&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> dirname, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;docs&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;src&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;assets&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;plot_with_dpi.png&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)))</span></span></code></pre></div><p><img src="`+p+'" alt="" width="416px" height="301px"></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">MediaOutput{MIME&quot;image/jpeg&quot;}</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">download</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Felis_silvestris_silvestris.jpg/519px-Felis_silvestris_silvestris.jpg&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)))</span></span></code></pre></div><p><img src="'+l+`" alt=""></p><p>Vite automatically inlines assets under 4KB by default, if this causes issues with your SVG files you can disable this behavior by adding the following to your vitepress configuration:</p><div class="info custom-block"><p class="custom-block-title">config.mts</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>vite: {</span></span>
<span class="line"><span>    build: {</span></span>
<span class="line"><span>        assetsInlineLimit: 0, // so we can tell whether we have created inlined images or not, we don&#39;t let vite inline them</span></span>
<span class="line"><span>    }</span></span>
<span class="line"><span>},</span></span></code></pre></div></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">MediaOutput{MIME&quot;image/svg+xml&quot;}</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;https://upload.wikimedia.org/wikipedia/commons/6/6c/SVG_Simple_Icon.svg&quot;</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> |&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> download </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">|&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> read)</span></span></code></pre></div><p><img src="`+h+'" alt=""></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">MediaOutput{MIME&quot;image/gif&quot;}</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">download</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)))</span></span></code></pre></div><p><img src="'+k+`" alt=""></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">HTML</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">raw</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;&quot;&quot;</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&lt;div style=&quot;width: 100px; height: 100px; background-color: black;&quot;</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">     onmousemove=&quot;let r = Math.round(event.offsetX / 100 * 255);</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">                  let b = Math.round((100 - event.offsetY) / 100 * 255);</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">                  this.style.backgroundColor = \`rgb(\${r}, 0, \${b})\`;&quot;&gt;</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&lt;/div&gt;</span></span>
<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;&quot;&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><div><div style="width: 100px; height: 100px; background-color: black;"
     onmousemove="let r = Math.round(event.offsetX / 100 * 255);
                  let b = Math.round((100 - event.offsetY) / 100 * 255);
                  this.style.backgroundColor = \`rgb(\${r}, 0, \${b})\`;">
</div>
</div>`,19)]))}const m=i(d,[["render",r]]);export{F as __pageData,m as default};

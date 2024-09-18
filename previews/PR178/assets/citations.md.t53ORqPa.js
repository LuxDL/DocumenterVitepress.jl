import{_ as n,c as a,a2 as r,j as t,a as o,o as i}from"./chunks/framework.CIIEPib-.js";const v=JSON.parse('{"title":"DocumenterCitations.jl integration","description":"","frontmatter":{},"headers":[],"relativePath":"citations.md","filePath":"citations.md","lastUpdated":null}'),l={name:"citations.md"},s={class:"MathJax",jax:"SVG",style:{direction:"ltr",position:"relative"}},d={style:{overflow:"visible","min-height":"1px","min-width":"1px","vertical-align":"0"},xmlns:"http://www.w3.org/2000/svg",width:"0.988ex",height:"1.887ex",role:"img",focusable:"false",viewBox:"0 -833.9 436.6 833.9","aria-hidden":"true"},p={class:"MathJax",jax:"SVG",style:{direction:"ltr",position:"relative"}},u={style:{overflow:"visible","min-height":"1px","min-width":"1px","vertical-align":"0"},xmlns:"http://www.w3.org/2000/svg",width:"0.988ex",height:"1.887ex",role:"img",focusable:"false",viewBox:"0 -833.9 436.6 833.9","aria-hidden":"true"},m={class:"MathJax",jax:"SVG",style:{direction:"ltr",position:"relative"}},c={style:{overflow:"visible","min-height":"1px","min-width":"1px","vertical-align":"0"},xmlns:"http://www.w3.org/2000/svg",width:"0.988ex",height:"1.887ex",role:"img",focusable:"false",viewBox:"0 -833.9 436.6 833.9","aria-hidden":"true"},h={class:"MathJax",jax:"SVG",style:{direction:"ltr",position:"relative"}},g={style:{overflow:"visible","min-height":"1px","min-width":"1px","vertical-align":"0"},xmlns:"http://www.w3.org/2000/svg",width:"0.988ex",height:"1.887ex",role:"img",focusable:"false",viewBox:"0 -833.9 436.6 833.9","aria-hidden":"true"},f={class:"MathJax",jax:"SVG",style:{direction:"ltr",position:"relative"}},y={style:{overflow:"visible","min-height":"1px","min-width":"1px","vertical-align":"0"},xmlns:"http://www.w3.org/2000/svg",width:"0.988ex",height:"1.887ex",role:"img",focusable:"false",viewBox:"0 -833.9 436.6 833.9","aria-hidden":"true"};function b(q,e,C,k,x,M){return i(),a("div",null,[e[46]||(e[46]=r('<h1 id="DocumenterCitations.jl-integration" tabindex="-1">DocumenterCitations.jl integration <a class="header-anchor" href="#DocumenterCitations.jl-integration" aria-label="Permalink to &quot;DocumenterCitations.jl integration {#DocumenterCitations.jl-integration}&quot;">​</a></h1><p>This page shows the DocumenterCitations.jl integration and what it looks like. You can use DocumenterCitations in DocumenterVitepress in the same way that you use them in Documenter!</p><p>This page&#39;s source was taken from the DocumenterCitations docs and rendered via DocumenterVitepress.</p><h1 id="gallery" tabindex="-1">Citation Style Gallery <a class="header-anchor" href="#gallery" aria-label="Permalink to &quot;Citation Style Gallery {#gallery}&quot;">​</a></h1><p>The citation style is determined when instantiating the <code>CitationBibliography</code>, via the <code>style</code> argument.</p><p>The built-in styles are:</p><ul><li><p><code>style=:numeric</code> (default): <a href="/DocumenterVitepress.jl/previews/PR178/citations#numeric_style">numeric style</a></p></li><li><p><code>style=:authoryear</code>: <a href="/DocumenterVitepress.jl/previews/PR178/citations#author_year_style">author-year style</a></p></li><li><p><code>style=:alpha</code>: <a href="/DocumenterVitepress.jl/previews/PR178/citations#alphabetic_style">alphabetic style</a></p></li></ul><h2 id="numeric_style" tabindex="-1">Numeric style <a class="header-anchor" href="#numeric_style" aria-label="Permalink to &quot;Numeric style {#numeric_style}&quot;">​</a></h2><p>This is the default style (<code>style=:numeric</code>) used throughout the other pages of this documentation, cf. the Syntax examples.</p><ul><li><p><code>[GoerzQ2022](@cite)</code> renders as &quot;[1]&quot;</p></li><li><p><code>[FuerstNJP2014,SolaAAMOP2018](@cite)</code> renders as &quot;[2, 3]&quot;</p></li><li><p><code>[GoerzQ2022](@citet)</code> renders as &quot;Goerz <em>et al.</em> [1]&quot;</p></li><li><p><code>[GoerzQ2022](@citep)</code> renders as &quot;[1]&quot; — <code>@citep</code> is the same as <code>@cite</code> for this style</p></li><li><p><code>[GoerzQ2022; Eq. (1)](@cite)</code> renders as &quot;[1, Eq. (1)]&quot;</p></li><li><p><code>[GoerzQ2022; Eq. (1)](@citet)</code> renders as &quot;Goerz <em>et al.</em> [1], Eq. (1)&quot;</p></li><li><p><code>[GoerzQ2022](@citet*)</code> renders as &quot;Goerz, Carrasco and Malinovsky [1]&quot;</p></li><li><p><code>[GoerzQ2022; Eq. (1)](@citet*)</code> renders as &quot;Goerz, Carrasco and Malinovsky [1], Eq. (1)&quot;</p></li><li><p><code>[WinckelIP2008](@citet)</code> renders as &quot;von Winckel and Borzì [4]&quot;</p></li><li><p><code>[WinckelIP2008](@Citet)</code> renders as &quot;Von Winckel and Borzì [4]&quot;</p></li><li><p><code>[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@cite)</code> renders as &quot;[5–8, and references therein]&quot;</p></li><li><p><code>[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@Citet)</code> renders as &quot;Brumer and Shapiro [5], Brif <em>et al.</em> [6], Shapiro and Brumer [7], Koch [8], and references therein&quot;</p></li><li><p><code>[arbitrary text](@cite GoerzQ2022)</code> renders as &quot;arbitrary text&quot;</p></li></ul><p><strong>References:</strong></p><hr><h1 id="bibliography" tabindex="-1">Bibliography <a class="header-anchor" href="#bibliography" aria-label="Permalink to &quot;Bibliography&quot;">​</a></h1>',13)),t("ol",null,[e[8]||(e[8]=r('<li><p>M. H. Goerz, S. C. Carrasco and V. S. Malinovsky. <em>Quantum Optimal Control via Semi-Automatic Differentiation</em>. <a href="https://doi.org/10.22331/q-2022-12-07-871" target="_blank" rel="noreferrer">Quantum <strong>6</strong>, 871</a> (2022).</p></li><li><p>H. A. Fürst, M. H. Goerz, U. G. Poschinger, M. Murphy, S. Montangero, T. Calarco, F. Schmidt-Kaler, K. Singer and C. P. Koch. <em>Controlling the transport of an ion: Classical and quantum mechanical solutions</em>. <a href="https://doi.org/10.1088/1367-2630/16/7/075007" target="_blank" rel="noreferrer">New J. Phys. <strong>16</strong>, 075007</a> (2014). Special issue on coherent control of complex quantum systems.</p></li><li><p>I. R. Sola, B. Y. Chang, S. A. Malinovskaya and V. S. Malinovsky. <a href="https://doi.org/10.1016/bs.aamop.2018.02.003" target="_blank" rel="noreferrer"><em>Quantum Control in Multilevel Systems</em></a>. In: <em>Advances In Atomic, Molecular, and Optical Physics</em>, Vol. 67, edited by E. Arimondo, L. F. DiMauro and S. F. Yelin (Academic Press, 2018); Chapter 3, pp. 151–256.</p></li>',3)),t("li",null,[t("p",null,[e[4]||(e[4]=o("G. von Winckel and A. Borzì. ")),t("em",null,[e[2]||(e[2]=o("Computational techniques for a quantum control problem with H")),t("mjx-container",s,[(i(),a("svg",d,e[0]||(e[0]=[r('<g stroke="currentColor" fill="currentColor" stroke-width="0" transform="scale(1,-1)"><g data-mml-node="math"><g data-mml-node="msup"><g data-mml-node="mi"></g><g data-mml-node="mn" transform="translate(33,363) scale(0.707)"><path data-c="31" d="M213 578L200 573Q186 568 160 563T102 556H83V602H102Q149 604 189 617T245 641T273 663Q275 666 285 666Q294 666 302 660V361L303 61Q310 54 315 52T339 48T401 46H427V0H416Q395 3 257 3Q121 3 100 0H88V46H114Q136 46 152 46T177 47T193 50T201 52T207 57T213 61V578Z" style="stroke-width:3;"></path></g></g></g></g>',1)]))),e[1]||(e[1]=t("mjx-assistive-mml",{unselectable:"on",display:"inline",style:{top:"0px",left:"0px",clip:"rect(1px, 1px, 1px, 1px)","-webkit-touch-callout":"none","-webkit-user-select":"none","-khtml-user-select":"none","-moz-user-select":"none","-ms-user-select":"none","user-select":"none",position:"absolute",padding:"1px 0px 0px 0px",border:"0px",display:"block",width:"auto",overflow:"hidden"}},[t("math",{xmlns:"http://www.w3.org/1998/Math/MathML"},[t("msup",null,[t("mi"),t("mn",null,"1")])])],-1))]),e[3]||(e[3]=o("-cost"))]),e[5]||(e[5]=o(". ")),e[6]||(e[6]=t("a",{href:"https://doi.org/10.1088/0266-5611/24/3/034007",target:"_blank",rel:"noreferrer"},[o("Inverse Problems "),t("strong",null,"24"),o(", 034007")],-1)),e[7]||(e[7]=o(" (2008)."))])]),e[9]||(e[9]=r('<li><p>P. Brumer and M. Shapiro. <em>Principles and Applications of the Quantum Control of Molecular Processes</em> (Wiley Interscience, 2003).</p></li><li><p>C. Brif, R. Chakrabarti and H. Rabitz. <em>Control of quantum phenomena: past, present and future</em>. <a href="https://doi.org/10.1088/1367-2630/12/7/075008" target="_blank" rel="noreferrer">New J. Phys. <strong>12</strong>, 075008</a> (2010).</p></li><li><p>M. Shapiro and P. Brumer. <a href="https://doi.org/10.1002/9783527639700" target="_blank" rel="noreferrer"><em>Quantum Control of Molecular Processes</em></a>. Second Edition (Wiley and Sons, 2012).</p></li><li><p>C. P. Koch. <em>Controlling open quantum systems: tools, achievements, and limitations</em>. <a href="https://doi.org/10.1088/0953-8984/28/21/213001" target="_blank" rel="noreferrer">J. Phys.: Condens. Matter <strong>28</strong>, 213001</a> (2016).</p></li>',4))]),e[47]||(e[47]=r('<h2 id="author_year_style" tabindex="-1">Author-year style <a class="header-anchor" href="#author_year_style" aria-label="Permalink to &quot;Author-year style {#author_year_style}&quot;">​</a></h2><p>The author-year style (<code>style=:authoryear</code>) formats citations with the author name and publication year. This is the citation style used, e.g., in <a href="https://journals.aps.org/rmp/" target="_blank" rel="noreferrer">Rev. Mod. Phys.</a> (<code>rmp</code> option in <a href="https://www.ctan.org/tex-archive/macros/latex/contrib/revtex/auguide" target="_blank" rel="noreferrer">REVTeX</a>). The bibliography is sorted alphabetically by author name. The default <code>@cite</code> command is parenthetical (<code>@cite</code> and <code>@citep</code> are equivalent) which is different from the <code>authoryear</code> style in <a href="https://mirrors.rit.edu/CTAN/macros/latex/contrib/natbib/natnotes.pdf" target="_blank" rel="noreferrer">natbib</a>.</p><ul><li><p><code>[GoerzQ2022](@cite)</code> renders as &quot;(Goerz <em>et al.</em>, 2022)&quot;</p></li><li><p><code>[FuerstNJP2014,SolaAAMOP2018](@cite)</code> renders as &quot;(Fürst <em>et al.</em>, 2014; Sola <em>et al.</em>, 2018)&quot;</p></li><li><p><code>[GoerzQ2022](@citet)</code> renders as &quot;Goerz <em>et al.</em> (2022)&quot;</p></li><li><p><code>[GoerzQ2022](@citep)</code> renders as &quot;(Goerz <em>et al.</em>, 2022)&quot; — <code>@citep</code> is the same as <code>@cite</code> for this style</p></li><li><p><code>[GoerzQ2022; Eq. (1)](@cite)</code> renders as &quot;(Goerz <em>et al.</em>, 2022; Eq. (1))&quot;</p></li><li><p><code>[GoerzQ2022; Eq. (1)](@citet)</code> renders as &quot;Goerz <em>et al.</em> (2022), Eq. (1)&quot;</p></li><li><p><code>[GoerzQ2022](@cite*)</code> renders as &quot;(Goerz, Carrasco and Malinovsky, 2022)&quot;</p></li><li><p><code>[GoerzQ2022](@citet*)</code> renders as &quot;Goerz, Carrasco and Malinovsky (2022)&quot;</p></li><li><p><code>[GoerzQ2022; Eq. (1)](@cite*)</code> renders as &quot;(Goerz, Carrasco and Malinovsky, 2022; Eq. (1))&quot;</p></li><li><p><code>[GoerzQ2022; Eq. (1)](@citet*)</code> renders as &quot;Goerz, Carrasco and Malinovsky (2022), Eq. (1)&quot;</p></li><li><p><code>[WinckelIP2008](@citet)</code> renders as &quot;von Winckel and Borzì (2008)&quot;</p></li><li><p><code>[WinckelIP2008](@Citet)</code> renders as &quot;Von Winckel and Borzì (2008)&quot;</p></li><li><p><code>[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@cite)</code> renders as &quot;(Brumer and Shapiro, 2003; Brif <em>et al.</em>, 2010; Shapiro and Brumer, 2012; Koch, 2016; and references therein)&quot;</p></li><li><p><code>[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@Citet)</code> renders as &quot;Brumer and Shapiro (2003), Brif <em>et al.</em> (2010), Shapiro and Brumer (2012), Koch (2016), and references therein&quot;</p></li><li><p><code>[arbitrary text](@cite GoerzQ2022)</code> renders as &quot;arbitrary text&quot;</p></li></ul><p><strong>References:</strong></p><hr><h1 id="bibliography-1" tabindex="-1">Bibliography <a class="header-anchor" href="#bibliography-1" aria-label="Permalink to &quot;Bibliography&quot;">​</a></h1>',6)),t("ul",null,[e[18]||(e[18]=r('<li><p>Brif, C.; Chakrabarti, R. and Rabitz, H. (2010). <em>Control of quantum phenomena: past, present and future</em>. <a href="https://doi.org/10.1088/1367-2630/12/7/075008" target="_blank" rel="noreferrer">New J. Phys. <strong>12</strong>, 075008</a>.</p></li><li><p>Brumer, P. and Shapiro, M. (2003). <em>Principles and Applications of the Quantum Control of Molecular Processes</em> (Wiley Interscience).</p></li><li><p>Fürst, H. A.; Goerz, M. H.; Poschinger, U. G.; Murphy, M.; Montangero, S.; Calarco, T.; Schmidt-Kaler, F.; Singer, K. and Koch, C. P. (2014). <em>Controlling the transport of an ion: Classical and quantum mechanical solutions</em>. <a href="https://doi.org/10.1088/1367-2630/16/7/075007" target="_blank" rel="noreferrer">New J. Phys. <strong>16</strong>, 075007</a>. Special issue on coherent control of complex quantum systems.</p></li><li><p>Goerz, M. H.; Carrasco, S. C. and Malinovsky, V. S. (2022). <em>Quantum Optimal Control via Semi-Automatic Differentiation</em>. <a href="https://doi.org/10.22331/q-2022-12-07-871" target="_blank" rel="noreferrer">Quantum <strong>6</strong>, 871</a>.</p></li><li><p>Koch, C. P. (2016). <em>Controlling open quantum systems: tools, achievements, and limitations</em>. <a href="https://doi.org/10.1088/0953-8984/28/21/213001" target="_blank" rel="noreferrer">J. Phys.: Condens. Matter <strong>28</strong>, 213001</a>.</p></li><li><p>Shapiro, M. and Brumer, P. (2012). <a href="https://doi.org/10.1002/9783527639700" target="_blank" rel="noreferrer"><em>Quantum Control of Molecular Processes</em></a>. Second Edition (Wiley and Sons).</p></li><li><p>Sola, I. R.; Chang, B. Y.; Malinovskaya, S. A. and Malinovsky, V. S. (2018). <a href="https://doi.org/10.1016/bs.aamop.2018.02.003" target="_blank" rel="noreferrer"><em>Quantum Control in Multilevel Systems</em></a>. In: <em>Advances In Atomic, Molecular, and Optical Physics</em>, Vol. 67, edited by Arimondo, E.; DiMauro, L. F. and Yelin, S. F. (Academic Press); Chapter 3, pp. 151–256.</p></li>',7)),t("li",null,[t("p",null,[e[14]||(e[14]=o("von Winckel, G. and Borzì, A. (2008). ")),t("em",null,[e[12]||(e[12]=o("Computational techniques for a quantum control problem with H")),t("mjx-container",p,[(i(),a("svg",u,e[10]||(e[10]=[r('<g stroke="currentColor" fill="currentColor" stroke-width="0" transform="scale(1,-1)"><g data-mml-node="math"><g data-mml-node="msup"><g data-mml-node="mi"></g><g data-mml-node="mn" transform="translate(33,363) scale(0.707)"><path data-c="31" d="M213 578L200 573Q186 568 160 563T102 556H83V602H102Q149 604 189 617T245 641T273 663Q275 666 285 666Q294 666 302 660V361L303 61Q310 54 315 52T339 48T401 46H427V0H416Q395 3 257 3Q121 3 100 0H88V46H114Q136 46 152 46T177 47T193 50T201 52T207 57T213 61V578Z" style="stroke-width:3;"></path></g></g></g></g>',1)]))),e[11]||(e[11]=t("mjx-assistive-mml",{unselectable:"on",display:"inline",style:{top:"0px",left:"0px",clip:"rect(1px, 1px, 1px, 1px)","-webkit-touch-callout":"none","-webkit-user-select":"none","-khtml-user-select":"none","-moz-user-select":"none","-ms-user-select":"none","user-select":"none",position:"absolute",padding:"1px 0px 0px 0px",border:"0px",display:"block",width:"auto",overflow:"hidden"}},[t("math",{xmlns:"http://www.w3.org/1998/Math/MathML"},[t("msup",null,[t("mi"),t("mn",null,"1")])])],-1))]),e[13]||(e[13]=o("-cost"))]),e[15]||(e[15]=o(". ")),e[16]||(e[16]=t("a",{href:"https://doi.org/10.1088/0266-5611/24/3/034007",target:"_blank",rel:"noreferrer"},[o("Inverse Problems "),t("strong",null,"24"),o(", 034007")],-1)),e[17]||(e[17]=o("."))])])]),e[48]||(e[48]=r('<h2 id="alphabetic_style" tabindex="-1">Alphabetic style <a class="header-anchor" href="#alphabetic_style" aria-label="Permalink to &quot;Alphabetic style {#alphabetic_style}&quot;">​</a></h2><p>The <code>style=:alpha</code> formats citations and references like <code>:numeric</code>, except that it uses labels derived from the author names and publication year and sorts the references alphabetically.</p><ul><li><p><code>[GoerzQ2022](@cite)</code> renders as &quot;[GCM22]&quot;</p></li><li><p><code>[FuerstNJP2014,SolaAAMOP2018](@cite)</code> renders as &quot;[FGP+14, SCMM18]&quot;</p></li><li><p><code>[GoerzQ2022](@citet)</code> renders as &quot;Goerz <em>et al.</em> [GCM22]&quot;</p></li><li><p><code>[GoerzQ2022](@citep)</code> renders as &quot;[GCM22]&quot; — <code>@citep</code> is the same as <code>@cite</code> for this style</p></li><li><p><code>[GoerzQ2022; Eq. (1)](@cite)</code> renders as &quot;[GCM22, Eq. (1)]&quot;</p></li><li><p><code>[GoerzQ2022; Eq. (1)](@citet)</code> renders as &quot;Goerz <em>et al.</em> [GCM22], Eq. (1)&quot;</p></li><li><p><code>[GoerzQ2022](@citet*)</code> renders as &quot;Goerz, Carrasco and Malinovsky [GCM22]&quot;</p></li><li><p><code>[GoerzQ2022; Eq. (1)](@citet*)</code> renders as &quot;Goerz, Carrasco and Malinovsky [GCM22], Eq. (1)&quot;</p></li><li><p><code>[WinckelIP2008](@citet)</code> renders as &quot;von Winckel and Borzì [vWB08]&quot;</p></li><li><p><code>[WinckelIP2008](@Citet)</code> renders as &quot;Von Winckel and Borzì [vWB08]&quot;</p></li><li><p><code>[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@cite)</code> renders as &quot;[BS03, BCR10, SB12, Koc16, and references therein]&quot;. Note that unlike for <code>style=:numeric</code>, the citations are not compressed.</p></li><li><p><code>[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@Citet)</code> renders as &quot;Brumer and Shapiro [BS03], Brif <em>et al.</em> [BCR10], Shapiro and Brumer [SB12], Koch [Koc16], and references therein&quot;</p></li><li><p><code>[arbitrary text](@cite GoerzQ2022)</code> renders as &quot;arbitrary text&quot;</p></li></ul><p><strong>References:</strong></p><hr><h1 id="bibliography-2" tabindex="-1">Bibliography <a class="header-anchor" href="#bibliography-2" aria-label="Permalink to &quot;Bibliography&quot;">​</a></h1>',6)),t("ol",null,[e[27]||(e[27]=r('<li><p>C. Brif, R. Chakrabarti and H. Rabitz. <em>Control of quantum phenomena: past, present and future</em>. <a href="https://doi.org/10.1088/1367-2630/12/7/075008" target="_blank" rel="noreferrer">New J. Phys. <strong>12</strong>, 075008</a> (2010).</p></li><li><p>P. Brumer and M. Shapiro. <em>Principles and Applications of the Quantum Control of Molecular Processes</em> (Wiley Interscience, 2003).</p></li><li><p>H. A. Fürst, M. H. Goerz, U. G. Poschinger, M. Murphy, S. Montangero, T. Calarco, F. Schmidt-Kaler, K. Singer and C. P. Koch. <em>Controlling the transport of an ion: Classical and quantum mechanical solutions</em>. <a href="https://doi.org/10.1088/1367-2630/16/7/075007" target="_blank" rel="noreferrer">New J. Phys. <strong>16</strong>, 075007</a> (2014). Special issue on coherent control of complex quantum systems.</p></li><li><p>M. H. Goerz, S. C. Carrasco and V. S. Malinovsky. <em>Quantum Optimal Control via Semi-Automatic Differentiation</em>. <a href="https://doi.org/10.22331/q-2022-12-07-871" target="_blank" rel="noreferrer">Quantum <strong>6</strong>, 871</a> (2022).</p></li><li><p>C. P. Koch. <em>Controlling open quantum systems: tools, achievements, and limitations</em>. <a href="https://doi.org/10.1088/0953-8984/28/21/213001" target="_blank" rel="noreferrer">J. Phys.: Condens. Matter <strong>28</strong>, 213001</a> (2016).</p></li><li><p>M. Shapiro and P. Brumer. <a href="https://doi.org/10.1002/9783527639700" target="_blank" rel="noreferrer"><em>Quantum Control of Molecular Processes</em></a>. Second Edition (Wiley and Sons, 2012).</p></li><li><p>I. R. Sola, B. Y. Chang, S. A. Malinovskaya and V. S. Malinovsky. <a href="https://doi.org/10.1016/bs.aamop.2018.02.003" target="_blank" rel="noreferrer"><em>Quantum Control in Multilevel Systems</em></a>. In: <em>Advances In Atomic, Molecular, and Optical Physics</em>, Vol. 67, edited by E. Arimondo, L. F. DiMauro and S. F. Yelin (Academic Press, 2018); Chapter 3, pp. 151–256.</p></li>',7)),t("li",null,[t("p",null,[e[23]||(e[23]=o("G. von Winckel and A. Borzì. ")),t("em",null,[e[21]||(e[21]=o("Computational techniques for a quantum control problem with H")),t("mjx-container",m,[(i(),a("svg",c,e[19]||(e[19]=[r('<g stroke="currentColor" fill="currentColor" stroke-width="0" transform="scale(1,-1)"><g data-mml-node="math"><g data-mml-node="msup"><g data-mml-node="mi"></g><g data-mml-node="mn" transform="translate(33,363) scale(0.707)"><path data-c="31" d="M213 578L200 573Q186 568 160 563T102 556H83V602H102Q149 604 189 617T245 641T273 663Q275 666 285 666Q294 666 302 660V361L303 61Q310 54 315 52T339 48T401 46H427V0H416Q395 3 257 3Q121 3 100 0H88V46H114Q136 46 152 46T177 47T193 50T201 52T207 57T213 61V578Z" style="stroke-width:3;"></path></g></g></g></g>',1)]))),e[20]||(e[20]=t("mjx-assistive-mml",{unselectable:"on",display:"inline",style:{top:"0px",left:"0px",clip:"rect(1px, 1px, 1px, 1px)","-webkit-touch-callout":"none","-webkit-user-select":"none","-khtml-user-select":"none","-moz-user-select":"none","-ms-user-select":"none","user-select":"none",position:"absolute",padding:"1px 0px 0px 0px",border:"0px",display:"block",width:"auto",overflow:"hidden"}},[t("math",{xmlns:"http://www.w3.org/1998/Math/MathML"},[t("msup",null,[t("mi"),t("mn",null,"1")])])],-1))]),e[22]||(e[22]=o("-cost"))]),e[24]||(e[24]=o(". ")),e[25]||(e[25]=t("a",{href:"https://doi.org/10.1088/0266-5611/24/3/034007",target:"_blank",rel:"noreferrer"},[o("Inverse Problems "),t("strong",null,"24"),o(", 034007")],-1)),e[26]||(e[26]=o(" (2008)."))])])]),e[49]||(e[49]=r('<p>Note that the <code>:alpha</code> style is able to automatically disambiguate labels:</p><hr><h1 id="bibliography-3" tabindex="-1">Bibliography <a class="header-anchor" href="#bibliography-3" aria-label="Permalink to &quot;Bibliography&quot;">​</a></h1><ol><li><p>M. Grace, C. Brif, H. Rabitz, I. A. Walmsley, R. L. Kosut and D. A. Lidar. <em>Optimal control of quantum gates and suppression of decoherence in a system of interacting two-level particles</em>. <a href="https://doi.org/10.1088/0953-4075/40/9/s06" target="_blank" rel="noreferrer">J. Phys. B <strong>40</strong>, S103</a> (2007), <a href="https://arxiv.org/abs/quant-ph/0702147" target="_blank" rel="noreferrer">arXiv:quant-ph/0702147</a>.</p></li><li><p>M. D. Grace, C. Brif, H. Rabitz, D. A. Lidar, I. A. Walmsley and R. L. Kosut. <em>Fidelity of optimally controlled quantum gates with randomly coupled multiparticle environments</em>. <a href="https://doi.org/10.1080/09500340701639615" target="_blank" rel="noreferrer">J. Mod. Opt. <strong>54</strong>, 2339</a> (2007), <a href="https://arxiv.org/abs/0712.2935" target="_blank" rel="noreferrer">arXiv:0712.2935</a>.</p></li></ol><p>This works because the <code>DocumenterCitations</code> plugin automatically upgrades <code>style=:alpha</code> to the internal</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>DocumenterCitations.AlphaStyle</span></span></code></pre></div><h2 id="custom_styles" tabindex="-1">Custom styles <a class="header-anchor" href="#custom_styles" aria-label="Permalink to &quot;Custom styles {#custom_styles}&quot;">​</a></h2><p>In the following, we show two examples for user-defined styles. See the notes on customization on how to generally define a custom style.</p><h3 id="Custom-style:-enumerated-author-year" tabindex="-1">Custom style: enumerated author-year <a class="header-anchor" href="#Custom-style:-enumerated-author-year" aria-label="Permalink to &quot;Custom style: enumerated author-year {#Custom-style:-enumerated-author-year}&quot;">​</a></h3><p>In this example, the <code>:authoryear</code> style is used, but the references are shown in an enumerated list.</p><p>The important part of the definition is in the last line, indicating that the References should be shown as an enumeration (ordered list, <code>&lt;ol&gt;</code>, in HTML), see below. Meanwhile, citations render exactly as with <code>style=:authoryear</code>:</p><ul><li><p><code>[GoerzQ2022](@cite)</code> renders as &quot;(Goerz <em>et al.</em>, 2022)&quot;</p></li><li><p><code>[FuerstNJP2014,SolaAAMOP2018](@cite)</code> renders as &quot;(Fürst <em>et al.</em>, 2014; Sola <em>et al.</em>, 2018)&quot;</p></li><li><p><code>[WinckelIP2008](@Citet)</code> renders as &quot;Von Winckel and Borzì (2008)&quot;</p></li></ul><p><strong>References:</strong></p><hr><h1 id="bibliography-4" tabindex="-1">Bibliography <a class="header-anchor" href="#bibliography-4" aria-label="Permalink to &quot;Bibliography&quot;">​</a></h1>',15)),t("ol",null,[e[36]||(e[36]=r('<li><p>Brif, C.; Chakrabarti, R. and Rabitz, H. (2010). <em>Control of quantum phenomena: past, present and future</em>. <a href="https://doi.org/10.1088/1367-2630/12/7/075008" target="_blank" rel="noreferrer">New J. Phys. <strong>12</strong>, 075008</a>.</p></li><li><p>Brumer, P. and Shapiro, M. (2003). <em>Principles and Applications of the Quantum Control of Molecular Processes</em> (Wiley Interscience).</p></li><li><p>Fürst, H. A.; Goerz, M. H.; Poschinger, U. G.; Murphy, M.; Montangero, S.; Calarco, T.; Schmidt-Kaler, F.; Singer, K. and Koch, C. P. (2014). <em>Controlling the transport of an ion: Classical and quantum mechanical solutions</em>. <a href="https://doi.org/10.1088/1367-2630/16/7/075007" target="_blank" rel="noreferrer">New J. Phys. <strong>16</strong>, 075007</a>. Special issue on coherent control of complex quantum systems.</p></li><li><p>Goerz, M. H.; Carrasco, S. C. and Malinovsky, V. S. (2022). <em>Quantum Optimal Control via Semi-Automatic Differentiation</em>. <a href="https://doi.org/10.22331/q-2022-12-07-871" target="_blank" rel="noreferrer">Quantum <strong>6</strong>, 871</a>.</p></li><li><p>Koch, C. P. (2016). <em>Controlling open quantum systems: tools, achievements, and limitations</em>. <a href="https://doi.org/10.1088/0953-8984/28/21/213001" target="_blank" rel="noreferrer">J. Phys.: Condens. Matter <strong>28</strong>, 213001</a>.</p></li><li><p>Shapiro, M. and Brumer, P. (2012). <a href="https://doi.org/10.1002/9783527639700" target="_blank" rel="noreferrer"><em>Quantum Control of Molecular Processes</em></a>. Second Edition (Wiley and Sons).</p></li><li><p>Sola, I. R.; Chang, B. Y.; Malinovskaya, S. A. and Malinovsky, V. S. (2018). <a href="https://doi.org/10.1016/bs.aamop.2018.02.003" target="_blank" rel="noreferrer"><em>Quantum Control in Multilevel Systems</em></a>. In: <em>Advances In Atomic, Molecular, and Optical Physics</em>, Vol. 67, edited by Arimondo, E.; DiMauro, L. F. and Yelin, S. F. (Academic Press); Chapter 3, pp. 151–256.</p></li>',7)),t("li",null,[t("p",null,[e[32]||(e[32]=o("Von Winckel, G. and Borzì, A. (2008). ")),t("em",null,[e[30]||(e[30]=o("Computational techniques for a quantum control problem with H")),t("mjx-container",h,[(i(),a("svg",g,e[28]||(e[28]=[r('<g stroke="currentColor" fill="currentColor" stroke-width="0" transform="scale(1,-1)"><g data-mml-node="math"><g data-mml-node="msup"><g data-mml-node="mi"></g><g data-mml-node="mn" transform="translate(33,363) scale(0.707)"><path data-c="31" d="M213 578L200 573Q186 568 160 563T102 556H83V602H102Q149 604 189 617T245 641T273 663Q275 666 285 666Q294 666 302 660V361L303 61Q310 54 315 52T339 48T401 46H427V0H416Q395 3 257 3Q121 3 100 0H88V46H114Q136 46 152 46T177 47T193 50T201 52T207 57T213 61V578Z" style="stroke-width:3;"></path></g></g></g></g>',1)]))),e[29]||(e[29]=t("mjx-assistive-mml",{unselectable:"on",display:"inline",style:{top:"0px",left:"0px",clip:"rect(1px, 1px, 1px, 1px)","-webkit-touch-callout":"none","-webkit-user-select":"none","-khtml-user-select":"none","-moz-user-select":"none","-ms-user-select":"none","user-select":"none",position:"absolute",padding:"1px 0px 0px 0px",border:"0px",display:"block",width:"auto",overflow:"hidden"}},[t("math",{xmlns:"http://www.w3.org/1998/Math/MathML"},[t("msup",null,[t("mi"),t("mn",null,"1")])])],-1))]),e[31]||(e[31]=o("-cost"))]),e[33]||(e[33]=o(". ")),e[34]||(e[34]=t("a",{href:"https://doi.org/10.1088/0266-5611/24/3/034007",target:"_blank",rel:"noreferrer"},[o("Inverse Problems "),t("strong",null,"24"),o(", 034007")],-1)),e[35]||(e[35]=o("."))])])]),e[50]||(e[50]=r('<h3 id="Custom-style:-Citation-key-labels" tabindex="-1">Custom style: Citation-key labels <a class="header-anchor" href="#Custom-style:-Citation-key-labels" aria-label="Permalink to &quot;Custom style: Citation-key labels {#Custom-style:-Citation-key-labels}&quot;">​</a></h3><p>In this less trivial example, a style similar to <code>:alpha</code> is used, using the citation keys in the <code>.bib</code> file as labels. This would be somewhat more appropriate with citation keys that are shorter that the ones used here (keys similar to those automatically generated with the <code>:alpha</code> style).</p><ul><li><p><code>[GoerzQ2022](@cite)</code> renders as &quot;[GoerzQ2022]&quot;</p></li><li><p><code>[FuerstNJP2014,SolaAAMOP2018](@cite)</code> renders as &quot;[FuerstNJP2014, SolaAAMOP2018]&quot;</p></li><li><p><code>[GoerzQ2022](@citet)</code> renders as &quot;Goerz <em>et al.</em> [GoerzQ2022]&quot;</p></li><li><p><code>[GoerzQ2022](@citep)</code> renders as &quot;[GoerzQ2022]&quot; — <code>@citep</code> is the same as <code>@cite</code> for this style</p></li><li><p><code>[GoerzQ2022; Eq. (1)](@cite)</code> renders as &quot;[GoerzQ2022, Eq. (1)]&quot;</p></li><li><p><code>[GoerzQ2022; Eq. (1)](@citet)</code> renders as &quot;Goerz <em>et al.</em> [GoerzQ2022], Eq. (1)&quot;</p></li><li><p><code>[GoerzQ2022](@citet*)</code> renders as &quot;Goerz, Carrasco and Malinovsky [GoerzQ2022]&quot;</p></li><li><p><code>[GoerzQ2022; Eq. (1)](@citet*)</code> renders as &quot;Goerz, Carrasco and Malinovsky [GoerzQ2022], Eq. (1)&quot;</p></li><li><p><code>[WinckelIP2008](@citet)</code> renders as &quot;von Winckel and Borzì [WinckelIP2008]&quot;</p></li><li><p><code>[WinckelIP2008](@Citet)</code> renders as &quot;Von Winckel and Borzì [WinckelIP2008]&quot;</p></li><li><p><code>[arbitrary text](@cite GoerzQ2022)</code> renders as &quot;arbitrary text&quot;</p></li></ul><p><strong>References:</strong></p><hr><h1 id="bibliography-5" tabindex="-1">Bibliography <a class="header-anchor" href="#bibliography-5" aria-label="Permalink to &quot;Bibliography&quot;">​</a></h1>',6)),t("ol",null,[e[45]||(e[45]=r('<li><p>C. Brif, R. Chakrabarti and H. Rabitz. <em>Control of quantum phenomena: past, present and future</em>. <a href="https://doi.org/10.1088/1367-2630/12/7/075008" target="_blank" rel="noreferrer">New J. Phys. <strong>12</strong>, 075008</a> (2010).</p></li><li><p>P. Brumer and M. Shapiro. <em>Principles and Applications of the Quantum Control of Molecular Processes</em> (Wiley Interscience, 2003).</p></li><li><p>H. A. Fürst, M. H. Goerz, U. G. Poschinger, M. Murphy, S. Montangero, T. Calarco, F. Schmidt-Kaler, K. Singer and C. P. Koch. <em>Controlling the transport of an ion: Classical and quantum mechanical solutions</em>. <a href="https://doi.org/10.1088/1367-2630/16/7/075007" target="_blank" rel="noreferrer">New J. Phys. <strong>16</strong>, 075007</a> (2014). Special issue on coherent control of complex quantum systems.</p></li><li><p>M. H. Goerz, S. C. Carrasco and V. S. Malinovsky. <em>Quantum Optimal Control via Semi-Automatic Differentiation</em>. <a href="https://doi.org/10.22331/q-2022-12-07-871" target="_blank" rel="noreferrer">Quantum <strong>6</strong>, 871</a> (2022).</p></li><li><p>C. P. Koch. <em>Controlling open quantum systems: tools, achievements, and limitations</em>. <a href="https://doi.org/10.1088/0953-8984/28/21/213001" target="_blank" rel="noreferrer">J. Phys.: Condens. Matter <strong>28</strong>, 213001</a> (2016).</p></li><li><p>M. Shapiro and P. Brumer. <a href="https://doi.org/10.1002/9783527639700" target="_blank" rel="noreferrer"><em>Quantum Control of Molecular Processes</em></a>. Second Edition (Wiley and Sons, 2012).</p></li><li><p>I. R. Sola, B. Y. Chang, S. A. Malinovskaya and V. S. Malinovsky. <a href="https://doi.org/10.1016/bs.aamop.2018.02.003" target="_blank" rel="noreferrer"><em>Quantum Control in Multilevel Systems</em></a>. In: <em>Advances In Atomic, Molecular, and Optical Physics</em>, Vol. 67, edited by E. Arimondo, L. F. DiMauro and S. F. Yelin (Academic Press, 2018); Chapter 3, pp. 151–256.</p></li>',7)),t("li",null,[t("p",null,[e[41]||(e[41]=o("G. von Winckel and A. Borzì. ")),t("em",null,[e[39]||(e[39]=o("Computational techniques for a quantum control problem with H")),t("mjx-container",f,[(i(),a("svg",y,e[37]||(e[37]=[r('<g stroke="currentColor" fill="currentColor" stroke-width="0" transform="scale(1,-1)"><g data-mml-node="math"><g data-mml-node="msup"><g data-mml-node="mi"></g><g data-mml-node="mn" transform="translate(33,363) scale(0.707)"><path data-c="31" d="M213 578L200 573Q186 568 160 563T102 556H83V602H102Q149 604 189 617T245 641T273 663Q275 666 285 666Q294 666 302 660V361L303 61Q310 54 315 52T339 48T401 46H427V0H416Q395 3 257 3Q121 3 100 0H88V46H114Q136 46 152 46T177 47T193 50T201 52T207 57T213 61V578Z" style="stroke-width:3;"></path></g></g></g></g>',1)]))),e[38]||(e[38]=t("mjx-assistive-mml",{unselectable:"on",display:"inline",style:{top:"0px",left:"0px",clip:"rect(1px, 1px, 1px, 1px)","-webkit-touch-callout":"none","-webkit-user-select":"none","-khtml-user-select":"none","-moz-user-select":"none","-ms-user-select":"none","user-select":"none",position:"absolute",padding:"1px 0px 0px 0px",border:"0px",display:"block",width:"auto",overflow:"hidden"}},[t("math",{xmlns:"http://www.w3.org/1998/Math/MathML"},[t("msup",null,[t("mi"),t("mn",null,"1")])])],-1))]),e[40]||(e[40]=o("-cost"))]),e[42]||(e[42]=o(". ")),e[43]||(e[43]=t("a",{href:"https://doi.org/10.1088/0266-5611/24/3/034007",target:"_blank",rel:"noreferrer"},[o("Inverse Problems "),t("strong",null,"24"),o(", 034007")],-1)),e[44]||(e[44]=o(" (2008)."))])])])])}const P=n(l,[["render",b]]);export{v as __pageData,P as default};
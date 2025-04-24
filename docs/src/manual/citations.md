# DocumenterCitations.jl integration

This page shows the DocumenterCitations.jl integration and what it looks like.  You can use DocumenterCitations in DocumenterVitepress in the same way that you use them in Documenter!

This page's source was taken from the DocumenterCitations docs and rendered via DocumenterVitepress.

# [Citation Style Gallery](@id gallery)

The citation style is determined when instantiating the `CitationBibliography`, via the `style` argument.

The built-in styles are:

* `style=:numeric` (default): [numeric style](@ref numeric_style)
* `style=:authoryear`: [author-year style](@ref author_year_style)
* `style=:alpha`: [alphabetic style](@ref alphabetic_style)

## [Numeric style](@id numeric_style)

This is the default style (`style=:numeric`) used throughout the other pages of this documentation, cf. the Syntax examples.

* `[GoerzQ2022](@cite)` renders as "[GoerzQ2022](@cite)"
* `[FuerstNJP2014,SolaAAMOP2018](@cite)` renders as "[FuerstNJP2014,SolaAAMOP2018](@cite)"
* `[GoerzQ2022](@citet)` renders as "[GoerzQ2022](@citet)"
* `[GoerzQ2022](@citep)` renders as "[GoerzQ2022](@citep)" — `@citep` is the same as `@cite` for this style
* `[GoerzQ2022; Eq. (1)](@cite)` renders as "[GoerzQ2022; Eq. (1)](@cite)"
* `[GoerzQ2022; Eq. (1)](@citet)` renders as "[GoerzQ2022; Eq. (1)](@citet)"
* `[GoerzQ2022](@citet*)` renders as "[GoerzQ2022](@citet*)"
* `[GoerzQ2022; Eq. (1)](@citet*)` renders as "[GoerzQ2022; Eq. (1)](@citet*)"
* `[WinckelIP2008](@citet)` renders as "[WinckelIP2008](@citet)"
* `[WinckelIP2008](@Citet)` renders as "[WinckelIP2008](@Citet)"
* `[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@cite)` renders as "[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@cite)"
* `[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@Citet)` renders as "[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@Citet)"
* `[arbitrary text](@cite GoerzQ2022)` renders as "[arbitrary text](@cite GoerzQ2022)"

**References:**

```@bibliography
Pages = [@__FILE__]
Style = :numeric
```

## [Author-year style](@id author_year_style)

The author-year style (`style=:authoryear`) formats citations with the author name and publication year. This is the citation style used, e.g., in [Rev. Mod. Phys.](https://journals.aps.org/rmp/) (`rmp` option in [REVTeX](https://www.ctan.org/tex-archive/macros/latex/contrib/revtex/auguide)). The bibliography is sorted alphabetically by author name. The default `@cite` command is parenthetical (`@cite` and `@citep` are equivalent) which is different from the `authoryear` style in [natbib](https://mirrors.rit.edu/CTAN/macros/latex/contrib/natbib/natnotes.pdf).

* `[GoerzQ2022](@cite)` renders as "[GoerzQ2022](@cite%authoryear%)"
* `[FuerstNJP2014,SolaAAMOP2018](@cite)` renders as "[FuerstNJP2014,SolaAAMOP2018](@cite%authoryear%)"
* `[GoerzQ2022](@citet)` renders as "[GoerzQ2022](@citet%authoryear%)"
* `[GoerzQ2022](@citep)` renders as "[GoerzQ2022](@citep%authoryear%)" — `@citep` is the same as `@cite` for this style
* `[GoerzQ2022; Eq. (1)](@cite)` renders as "[GoerzQ2022; Eq. (1)](@cite%authoryear%)"
* `[GoerzQ2022; Eq. (1)](@citet)` renders as "[GoerzQ2022; Eq. (1)](@citet%authoryear%)"
* `[GoerzQ2022](@cite*)` renders as "[GoerzQ2022](@cite*%authoryear%)"
* `[GoerzQ2022](@citet*)` renders as "[GoerzQ2022](@citet*%authoryear%)"
* `[GoerzQ2022; Eq. (1)](@cite*)` renders as "[GoerzQ2022; Eq. (1)](@cite*%authoryear%)"
* `[GoerzQ2022; Eq. (1)](@citet*)` renders as "[GoerzQ2022; Eq. (1)](@citet*%authoryear%)"
* `[WinckelIP2008](@citet)` renders as "[WinckelIP2008](@citet%authoryear%)"
* `[WinckelIP2008](@Citet)` renders as "[WinckelIP2008](@Citet%authoryear%)"
* `[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@cite)` renders as "[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@cite%authoryear%)"
* `[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@Citet)` renders as "[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@Citet%authoryear%)"
* `[arbitrary text](@cite GoerzQ2022)` renders as "[arbitrary text](@cite GoerzQ2022)"

**References:**

```@bibliography
Pages = [@__FILE__]
Style = :authoryear
Canonical = false
```

## [Alphabetic style](@id alphabetic_style)

The `style=:alpha` formats citations and references like `:numeric`, except that it uses labels derived from the author names and publication year and sorts the references alphabetically.

* `[GoerzQ2022](@cite)` renders as "[GoerzQ2022](@cite%alpha%)"
* `[FuerstNJP2014,SolaAAMOP2018](@cite)` renders as "[FuerstNJP2014,SolaAAMOP2018](@cite%alpha%)"
* `[GoerzQ2022](@citet)` renders as "[GoerzQ2022](@citet%alpha%)"
* `[GoerzQ2022](@citep)` renders as "[GoerzQ2022](@citep%alpha%)" — `@citep` is the same as `@cite` for this style
* `[GoerzQ2022; Eq. (1)](@cite)` renders as "[GoerzQ2022; Eq. (1)](@cite%alpha%)"
* `[GoerzQ2022; Eq. (1)](@citet)` renders as "[GoerzQ2022; Eq. (1)](@citet%alpha%)"
* `[GoerzQ2022](@citet*)` renders as "[GoerzQ2022](@citet*%alpha%)"
* `[GoerzQ2022; Eq. (1)](@citet*)` renders as "[GoerzQ2022; Eq. (1)](@citet*%alpha%)"
* `[WinckelIP2008](@citet)` renders as "[WinckelIP2008](@citet%alpha%)"
* `[WinckelIP2008](@Citet)` renders as "[WinckelIP2008](@Citet%alpha%)"
* `[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@cite)` renders as "[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@cite%alpha%)". Note that unlike for `style=:numeric`, the citations are not compressed.
* `[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@Citet)` renders as "[BrumerShapiro2003, BrifNJP2010, Shapiro2012, KochJPCM2016; and references therein](@Citet%alpha%)"
* `[arbitrary text](@cite GoerzQ2022)` renders as "[arbitrary text](@cite GoerzQ2022)"

**References:**

```@bibliography
Pages = [@__FILE__]
Style = :alpha
Canonical = false

SolaAAMOP2018
```

```@raw latex
Compared to the HTML version of the documentation, the hanging indent in the above list of references is too small for the longer labels of the \texttt{:alpha} style. This can be remedied by adjusting the \texttt{dl\_hangindent} and \texttt{dl\_labelwidth} parameters with \hyperlinkref{sec:customizing_latex_output}{\texttt{DocumenterCitations.set\_latex\_options}}.
```

Note that the `:alpha` style is able to automatically disambiguate labels:

```@bibliography
Pages = []
Style = :alpha
Canonical = false

GraceJMO2007
GraceJPB2007
```

This works because the `DocumenterCitations` plugin automatically upgrades `style=:alpha` to the internal

```
DocumenterCitations.AlphaStyle
```


## [Custom styles](@id custom_styles)

In the following, we show two examples for user-defined styles. See the notes on customization on how to generally define a custom style.

### Custom style: enumerated author-year

In this example, the `:authoryear` style is used, but the references are shown in an enumerated list.

~~~@eval
# custom styles are included in docs/make.jl, which is how we get around
# world-age issues.
using Markdown
custom_style = joinpath(@__DIR__, "..", "custom_styles", "enumauthoryear.jl")
if isfile(custom_style)
    Markdown.parse("""
    ```julia
    $(read(custom_style, String))
    ```
    """)
end
~~~

The important part of the definition is in the last line, indicating that the References should be shown as an enumeration (ordered list, `<ol>`, in HTML), see below. Meanwhile, citations render exactly as with `style=:authoryear`:

* `[GoerzQ2022](@cite)` renders as "[GoerzQ2022](@cite%enumauthoryear%)"
* `[FuerstNJP2014,SolaAAMOP2018](@cite)` renders as "[FuerstNJP2014,SolaAAMOP2018](@cite%enumauthoryear%)"
* `[WinckelIP2008](@Citet)` renders as "[WinckelIP2008](@Citet%enumauthoryear%)"

**References:**

```@bibliography
Pages = [@__FILE__]
Style = :enumauthoryear
Canonical = false
```

### Custom style: Citation-key labels

In this less trivial example, a style similar to `:alpha` is used, using the citation keys in the `.bib` file as labels. This would be somewhat more appropriate with citation keys that are shorter that the ones used here (keys similar to those automatically generated with the `:alpha` style).

~~~@eval
# custom styles are included in docs/make.jl, which is how we get around
# world-age issues.
using Markdown
custom_style = joinpath(@__DIR__, "..", "custom_styles", "keylabels.jl")
if isfile(custom_style)
    Markdown.parse("""
    ```julia
    $(read(custom_style, String))
    ```
    """)
end
~~~

* `[GoerzQ2022](@cite)` renders as "[GoerzQ2022](@cite%keylabels%)"
* `[FuerstNJP2014,SolaAAMOP2018](@cite)` renders as "[FuerstNJP2014,SolaAAMOP2018](@cite%keylabels%)"
* `[GoerzQ2022](@citet)` renders as "[GoerzQ2022](@citet%keylabels%)"
* `[GoerzQ2022](@citep)` renders as "[GoerzQ2022](@citep%keylabels%)" — `@citep` is the same as `@cite` for this style
* `[GoerzQ2022; Eq. (1)](@cite)` renders as "[GoerzQ2022; Eq. (1)](@cite%keylabels%)"
* `[GoerzQ2022; Eq. (1)](@citet)` renders as "[GoerzQ2022; Eq. (1)](@citet%keylabels%)"
* `[GoerzQ2022](@citet*)` renders as "[GoerzQ2022](@citet*%keylabels%)"
* `[GoerzQ2022; Eq. (1)](@citet*)` renders as "[GoerzQ2022; Eq. (1)](@citet*%keylabels%)"
* `[WinckelIP2008](@citet)` renders as "[WinckelIP2008](@citet%keylabels%)"
* `[WinckelIP2008](@Citet)` renders as "[WinckelIP2008](@Citet%keylabels%)"
* `[arbitrary text](@cite GoerzQ2022)` renders as "[arbitrary text](@cite GoerzQ2022)"

**References:**

```@bibliography
Pages = [@__FILE__]
Style = :keylabels
Canonical = false
```

```@raw latex
As with the \texttt{:alpha} style, for \LaTeX{} output, the \texttt{dl\_hangindent} and \texttt{dl\_labelwidth} parameters should be adjusted with \hyperlinkref{sec:customizing_latex_output}{\texttt{DocumenterCitations.set\_latex\_options}} to obtain a more suitable hanging indent that matches the HTML version of this documentation.
```

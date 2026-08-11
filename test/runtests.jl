using DocumenterVitepress
using DocumenterVitepress.Documenter
using Bonito
using Test


@testset "frontmatter YAML escaping" begin
    esc = DocumenterVitepress._escape_yaml_double_quoted
    # plain text is unchanged
    @test esc("plain description") == "plain description"
    # double quotes escaped (the regression: an unescaped `"` broke the build)
    @test esc("Mirrors the \"Spherical joint\" test") == "Mirrors the \\\"Spherical joint\\\" test"
    # newlines become escape sequences, never raw line breaks
    @test esc("line one\nline two") == "line one\\nline two"
    # backslashes are doubled
    @test esc("a\\b") == "a\\\\b"
    # tabs and carriage returns
    @test esc("a\tb\rc") == "a\\tb\\rc"
    # non-string values are accepted (page meta may hold any value)
    @test esc(:sym) == "sym"
    # the escaped value embedded in a `key: "..."` line stays on a single line
    val = esc("Dyad docs.  Mirrors the \"Spherical joint without state\" test")
    @test !occursin('\n', "description: \"$val\"")
end

@testset "frontmatter delimiter stripping" begin
    strip_delims = DocumenterVitepress._strip_frontmatter_delimiters
    # no trailing newline
    @test strip_delims("---\ntitle: My Page\n---") == "title: My Page"
    # trailing newline must not leave the closing `---` behind (the regression)
    @test strip_delims("---\ntitle: My Page\n---\n") == "title: My Page"
    @test !occursin("---", strip_delims("---\ntitle: My Page\n---\n"))
    # multi-line body and surrounding whitespace
    @test strip_delims("\n---\na: 1\nb: 2\n---\n\n") == "a: 1\nb: 2"
end

@testset "Bases" begin
    determine_bases(args...; kwargs...) = DocumenterVitepress.determine_bases(args...; kwargs..., log = false)
    # 0.0.X
    for keep in [:patch, :minor, :breaking]
        @test determine_bases("v0.0.1"; keep, all_tagged_versions = [v"0.0.2"]) == ["v0.0.1"]
        @test determine_bases("v0.0.2"; keep, all_tagged_versions = [v"0.0.2"]) == ["v0.0.2", "stable"]
        @test determine_bases("v0.0.3"; keep, all_tagged_versions = [v"0.0.2"]) == ["v0.0.3", "stable"]
    end

    # 0.X.Y
    @test determine_bases("v0.1.1"; keep = :patch, all_tagged_versions = [v"0.1.2"]) == ["v0.1.1"]
    @test determine_bases("v0.1.2"; keep = :patch, all_tagged_versions = [v"0.1.2"]) == ["v0.1.2", "stable", "v0.1"]
    @test determine_bases("v0.1.3"; keep = :patch, all_tagged_versions = [v"0.1.2"]) == ["v0.1.3", "stable", "v0.1"]

    for keep in [:minor, :breaking]
        @test determine_bases("v0.1.1"; keep, all_tagged_versions = [v"0.1.2"]) == []
        @test determine_bases("v0.1.2"; keep, all_tagged_versions = [v"0.1.2"]) == ["stable", "v0.1"]
        @test determine_bases("v0.1.3"; keep, all_tagged_versions = [v"0.1.2"]) == ["stable", "v0.1"]
    end

    # X.Y.Z
    @test determine_bases("v1.1.1"; keep = :patch, all_tagged_versions = [v"1.1.2"]) == ["v1.1.1"]
    @test determine_bases("v1.1.2"; keep = :patch, all_tagged_versions = [v"1.1.2"]) == ["v1.1.2", "stable", "v1", "v1.1"]
    @test determine_bases("v1.1.3"; keep = :patch, all_tagged_versions = [v"1.1.2"]) == ["v1.1.3", "stable", "v1", "v1.1"]

    @test determine_bases("v1.1.1"; keep = :minor, all_tagged_versions = [v"1.1.2"]) == []
    @test determine_bases("v1.1.2"; keep = :minor, all_tagged_versions = [v"1.1.2"]) == ["stable", "v1", "v1.1"]
    @test determine_bases("v1.1.3"; keep = :minor, all_tagged_versions = [v"1.1.2"]) == ["stable", "v1", "v1.1"]

    @test determine_bases("v1.1.1"; keep = :breaking, all_tagged_versions = [v"1.1.2"]) == []
    @test determine_bases("v1.1.2"; keep = :breaking, all_tagged_versions = [v"1.1.2"]) == ["stable", "v1"]
    @test determine_bases("v1.1.3"; keep = :breaking, all_tagged_versions = [v"1.1.2"]) == ["stable", "v1"]

    @test_throws ErrorException determine_bases("v0.0.1"; keep = :bla, all_tagged_versions = [v"0.0.2"])
end

@testset "postprocess before push" begin
    base = "v1"
    versions = DocumenterVitepress.BaseVersion(base)

    other_builds = [
        ("dev", "dev"),
        (v"1.3.0", "stable"),
        (v"1.3.0", "v1"), # test that sorting happens by siteinfo, not base
        (v"1.2.2", "v1.2"),
        (v"1.2.1", "v1.2.1"),
        (v"0.1.3", "v0.1"),
        (v"0.1.2", "v0.1.2"),
        ("invalid", "v4.5.6"), # moved last because siteinfo version can't be read
    ]

    mktempdir() do dir
        for (version, base) in other_builds
            folder = joinpath(dir, base)
            mkdir(folder)
            open(joinpath(folder, "siteinfo.js"), "w") do io
                println(io, "var DOCUMENTER_CURRENT_VERSION = \"$version\";")
            end
        end

        Documenter.postprocess_before_push(
            versions;
            subfolder = "",
            devurl = "dev",
            deploy_dir = joinpath(dir, base),
            dirname = ""
        )

        versions_js = read(joinpath(dir, "versions.js"), String)

        @test occursin("""
        var DOC_VERSIONS = [
          "dev",
          "stable",
          "v1",
          "v1.2",
          "v1.2.1",
          "v0.1",
          "v0.1.2",
          "v4.5.6",
        ];""", versions_js)

        @test occursin("""var DOCUMENTER_NEWEST = "1.3.0";""", versions_js)
        @test occursin("""var DOCUMENTER_STABLE = "stable";""", versions_js)

        # "stable" is present among other_builds, so the root redirect should point there.
        index_html = read(joinpath(dir, "index.html"), String)
        @test startswith(index_html, "<!--This file is automatically generated by DocumenterVitepress.jl-->")
        @test occursin("""url=./stable/""", index_html)
    end
end

@testset "write_redirect_index!" begin
    write_redirect = DocumenterVitepress.write_redirect_index!
    dv_marker = "<!--This file is automatically generated by DocumenterVitepress.jl-->"

    mktempdir() do dir
        write_redirect(dir, "stable")
        content = read(joinpath(dir, "index.html"), String)
        @test startswith(content, dv_marker)
        @test occursin("""url=./stable/""", content)

        # regenerates its own previously-written file with an updated target
        write_redirect(dir, "dev")
        @test occursin("""url=./dev/""", read(joinpath(dir, "index.html"), String))

        # a `nothing` target is a no-op
        write_redirect(dir, nothing)
        @test occursin("""url=./dev/""", read(joinpath(dir, "index.html"), String))
    end

    mktempdir() do dir
        # a legacy Documenter.jl-generated redirect (e.g. from before switching to
        # DocumenterVitepress) is recognized and safely regenerated
        write(joinpath(dir, "index.html"), "<!--This file is automatically generated by Documenter.jl-->\nold")
        write_redirect(dir, "stable")
        @test startswith(read(joinpath(dir, "index.html"), String), dv_marker)
    end

    mktempdir() do dir
        # a user's own custom landing page is left alone
        write(joinpath(dir, "index.html"), "<html><body>custom</body></html>")
        write_redirect(dir, "stable")
        @test read(joinpath(dir, "index.html"), String) == "<html><body>custom</body></html>"
    end
end

@testset "escape_markdown_text" begin
    esc = DocumenterVitepress.escape_markdown_text
    # Characters that don't need escaping: HTML entities in the markdown source
    # propagate through vitepress into the page-data JSON used to set document.title,
    # surfacing as literal `&amp;` / `&#39;` / `&quot;` in browser tab titles.
    @test esc("PDF & SVG") == "PDF & SVG"
    @test esc("it's") == "it's"
    @test esc("he said \"hi\"") == "he said \"hi\""
    # `<` and `>` must still be escaped, otherwise Vue parses them as HTML tags (#101).
    @test esc("a <cond> b") == "a &lt;cond&gt; b"
    @test esc("plain text") == "plain text"
end

@testset "heading escaping (full vitepress round-trip)" begin
    mktempdir() do dir
        dir = realpath(dir)
        src = joinpath(dir, "src")
        mkpath(src)
        write(joinpath(src, "index.md"), "# PDF & SVG\n\nbody with <cond> in it.\n")
        # DocumenterVitepress shells out to `git tag` to determine version aliases;
        # make `dir` a git repo so that succeeds (empty repo => no tags is fine).
        run(pipeline(`$(Documenter.git()) -C $dir init --quiet`, stdout=devnull))

        Documenter.makedocs(;
            sitename = "Test",
            root = dir,
            source = "src",
            build = "build",
            warnonly = true,
            remotes = nothing,
            format = DocumenterVitepress.MarkdownVitepress(
                repo = "github.com/test/Test.jl",
                devbranch = "main",
                devurl = "dev",
                deploy_decision = Documenter.DeployDecision(; all_ok = false),
            ),
            pages = ["index.md"],
        )

        rendered_md = read(joinpath(dir, "build", ".documenter", "index.md"), String)
        @test occursin("# PDF & SVG", rendered_md)
        @test occursin("&lt;cond&gt;", rendered_md)

        # The browser-tab title comes from two places, and the bug only manifests in one:
        #   1. The static `<title>` in the HTML head — vitepress HTML-escapes the title
        #      text here, so a bare `&` becomes `&amp;` and renders correctly as `&`.
        #   2. The page-data JSON embedded in `assets/index.md.*.js`, used by the
        #      client to call `document.title = data.title` after hydration. Vitepress
        #      writes the markdown title text verbatim into this JSON — so if the
        #      markdown source held the entity-encoded form `PDF &amp; SVG`, the JSON
        #      gets the literal 13-char string `"PDF &amp; SVG"` and the tab ends up
        #      showing "PDF &amp; SVG" once JS runs.
        assets_dir = joinpath(dir, "build", "1", "assets")
        page_data_js = only(filter(
            f -> startswith(f, "index.md.") && endswith(f, ".js") && !endswith(f, ".lean.js"),
            readdir(assets_dir),
        ))
        page_data = read(joinpath(assets_dir, page_data_js), String)
        json_title = match(r"\\\"title\\\":\\\"(.*?)\\\"", page_data)
        @test json_title !== nothing
        @test json_title.captures[1] == "PDF & SVG"
    end
end

@testset "REPL block ANSI color output (issue #373)" begin
    # Colored `@repl` output becomes one `ansi` fence with a `julia-repl-runs=`
    # spec; plain `@repl` stays one `julia` block. Markdown flush-left so the
    # ```@repl fences aren't indented.
    md_content = raw"""
# Repl ansi

```@repl ansi-demo
struct Colored end
Base.show(io::IO, ::MIME"text/plain", ::Colored) = print(io, get(io, :color, false) ? "\e[31mred\e[39m" : "red")
Colored()
```

```@repl plain-demo
1 + 1
```
"""
    mktempdir() do dir
        dir = realpath(dir)
        src = joinpath(dir, "src")
        mkpath(src)
        write(joinpath(src, "index.md"), md_content)
        run(pipeline(`$(Documenter.git()) -C $dir init --quiet`, stdout = devnull))

        Documenter.makedocs(;
            sitename = "Test",
            root = dir,
            source = "src",
            build = "build",
            warnonly = true,
            remotes = nothing,
            format = DocumenterVitepress.MarkdownVitepress(
                repo = "github.com/test/Test.jl",
                devbranch = "main",
                devurl = "dev",
                build_vitepress = false,  # only need the emitted markdown
                deploy_decision = Documenter.DeployDecision(; all_ok = false),
            ),
            pages = ["index.md"],
        )

        rendered = read(joinpath(dir, "build", ".documenter", "index.md"), String)

        # Colored block: one `ansi` fence carrying the runs spec.
        fence = match(r"```ansi julia-repl-runs=(\S+)\n(.*?)\n```"s, rendered)
        @test fence !== nothing
        runspec, body = fence.captures
        # Input prompt and colored output share the one fence.
        @test occursin("julia> Colored()", body)
        @test occursin("\e[31mred\e[39m", body)
        # Spec interleaves `julia` (input) and `ansi` (output) runs.
        @test occursin("julia:", runspec) && occursin("ansi:", runspec)

        # No escape codes leak into a plain `julia` fence.
        for m in eachmatch(r"```julia\n(.*?)\n```"s, rendered)
            @test !occursin('\e', m.captures[1])
        end

        # Colorless block: unchanged single `julia` transcript.
        @test occursin("```julia\njulia> 1 + 1\n2\n```", rendered)
    end
end

@testset "noindex injection" begin
    apply_noindex = DocumenterVitepress.apply_noindex
    marker = "// REPLACE_ME_DOCUMENTER_VITEPRESS_NOINDEX"
    meta = "['meta', { name: 'robots', content: 'noindex, nofollow' }],"

    # Config like the package template: marker present inside `head`.
    template_config = """
    export default defineConfig({
      head: [
        ['link', { rel: 'icon', href: 'favicon.ico' }],
        $marker
      ],
    })
    """

    # Non-stable base -> marker replaced with the robots meta entry.
    out = apply_noindex(template_config, true, "v1.2.3")
    @test occursin(meta, out)
    @test !occursin(marker, out)

    # Stable base -> marker removed, no robots meta emitted.
    out = apply_noindex(template_config, true, "stable")
    @test !occursin("noindex", out)
    @test !occursin(marker, out)

    # Root base (empty string) -> root / single-version deploy stays indexable.
    out = apply_noindex(template_config, true, "")
    @test !occursin("noindex", out)
    @test !occursin(marker, out)

    # Feature disabled -> marker removed, no robots meta emitted.
    out = apply_noindex(template_config, false, "dev")
    @test !occursin("noindex", out)
    @test !occursin(marker, out)

    # User config (no marker) but with a `head` array -> injected into `head`.
    user_config = """
    export default defineConfig({
      head: [
        ['link', { rel: 'icon', href: 'favicon.ico' }],
      ],
    })
    """
    out = apply_noindex(user_config, true, "dev")
    @test occursin(meta, out)
    @test first(findfirst(meta, out)) > first(findfirst("head: [", out)) # inside `head`
    out = apply_noindex(user_config, true, "v1.2")
    @test occursin(meta, out)
    out = apply_noindex(user_config, true, "stable")
    @test !occursin("noindex", out)
    out = apply_noindex(user_config, false, "dev")
    @test !occursin("noindex", out)

    # Quoted `head` key (as a linter/formatter may emit) is still matched.
    quoted_config = """
    export default defineConfig({
      "head": [
        ['link', { rel: 'icon', href: 'favicon.ico' }],
      ],
    })
    """
    out = apply_noindex(quoted_config, true, "dev")
    @test occursin(meta, out)

    # No marker and no `head` array at all -> warn, leave config unchanged.
    bare_config = "export default defineConfig({ title: 'x' })"
    out = @test_logs (:warn,) match_mode = :any apply_noindex(bare_config, true, "dev")
    @test out == bare_config
end

@testset "plugin asset merge-copy" begin
    merge_copy! = DocumenterVitepress._merge_copy!
    mktempdir() do root
        a = joinpath(root, "plugin_a")
        b = joinpath(root, "plugin_b")
        public = joinpath(root, "public")
        # Two plugins ship into the same-named subdirectory but with different files.
        mkpath(joinpath(a, "sub")); write(joinpath(a, "sub", "a.js"), "a")
        mkpath(joinpath(b, "sub")); write(joinpath(b, "sub", "b.js"), "b")

        merge_copy!(a, public)
        merge_copy!(b, public)

        # Both survive: the second copy merged into `sub/` rather than replacing it
        # (a plain `cp(; force=true)` on the directory would have deleted `a.js`).
        @test isfile(joinpath(public, "sub", "a.js"))
        @test isfile(joinpath(public, "sub", "b.js"))

        # Same-named files still overwrite, last writer wins.
        write(joinpath(a, "top.txt"), "from-a"); merge_copy!(a, public)
        write(joinpath(b, "top.txt"), "from-b"); merge_copy!(b, public)
        @test read(joinpath(public, "top.txt"), String) == "from-b"
    end
end

@testset "pagelist2str dispatch" begin
    # `Pair`-based entries don't touch `doc`, so a dummy `nothing` is enough here.
    p2s(arg) = DocumenterVitepress.pagelist2str(nothing, arg, Val(:sidebar))
    # leaf pair
    @test occursin("text: 'Home'", p2s("Home" => "index.md"))
    # a non-String name routes through the `Any => Any` fallback without recursing forever
    @test occursin("text: 'sym'", p2s(:sym => "page.md"))
    # a `nothing` page is omitted
    @test p2s("Hidden" => nothing) == ""
    # a genuinely unsupported page type errors instead of infinitely recursing
    @test_throws ErrorException p2s("bad" => 123)
    # nested arrays drop omitted children — no `{}` junk
    nested = p2s("Sec" => ["A" => "a.md", "Skip" => nothing])
    @test occursin("text: 'A'", nested)
    @test !occursin("{}", nested)
    # collection level filters empties too — no `{  }` junk
    @test !occursin("{  }", p2s(["A" => "a.md", "Skip" => nothing]))
end

@testset "Bonito plugin" begin
    plugin = DocumenterVitepress.BonitoPlugin()
    @test plugin isa Documenter.Plugin

    dirs = DocumenterVitepress.vitepress_assets(plugin)
    @test length(dirs) == 1
    @test isdir(only(dirs))

    render_button() = sprint() do io
        show(io, MIME"text/html"(), App() do session
            count = DOM.span("0")
            button = Button("Click me!")
            onjs(session, button.value, js"""
                function (clicked) {
                    const el = $(count)
                    el.textContent = String(parseInt(el.textContent, 10) + 1)
                }
                """)
            return DOM.div(button, DOM.p("Clicks: ", count))
        end)
    end

    Page()
    html1 = render_button()
    m1 = match(r"src=\"(/bonito/js/[^\"]+)\"", html1)
    @test m1 !== nothing
    # absolute, not relative to the rendering page
    @test startswith(m1[1], "/bonito/")

    # a fresh Page() (new markdown page) reuses the same bundle — the whole
    # point of a shared asset folder instead of Bonito's per-page default.
    Page()
    html2 = render_button()
    m2 = match(r"src=\"(/bonito/js/[^\"]+)\"", html2)
    @test m2 !== nothing
    @test m1[1] == m2[1]

    asset_path = joinpath(only(dirs), m1[1][2:end]) # strip the leading '/'
    @test isfile(asset_path)

    @test DocumenterVitepress.vitepress_asset_prefixes(plugin) == ["/bonito/"]

    # The `import(new URL(…))` for an ES6 module ends up inside the binary session
    # blob, so it has to pick the base up from the page at runtime instead.
    ext = Base.get_extension(DocumenterVitepress, :DocumenterVitepressBonitoExt)
    mktempdir() do d
        js = joinpath(d, "mymodule.js")
        write(js, "export const x = 1;\n")
        expr = Bonito.import_js_url(ext.VitepressAssetFolder(), Bonito.Asset(js; es6module = true))
        @test occursin("window.__DV_BASE__", expr)
        # base-relative, so no root-relative URL survives to be requested as-is
        @test !occursin("'/bonito/", expr)
        @test occursin("+ 'bonito/", expr)
    end
end

@testset "plugin asset URL rebasing" begin
    rebase = DocumenterVitepress.rebase_asset_urls
    prefixes = ["/bonito/"]
    # As emitted into the markdown: html-escaped, inside a `v-html` literal.
    md = """
    <ClientOnly>
    <div v-html="`<script src=&quot;/bonito/js/WGLMakie.bundled.js&quot;></script>
    Bonito.fetch_binary('/bonito/bin/f0a1.bin')`"></div>
    </ClientOnly>
    """
    bases = ["/DGG.jl/dev/", "/DGG.jl/stable/"]

    # A project-page base is prefixed onto every asset URL — this is the 404 that
    # `/bonito/js/WGLMakie.bundled.js` gave on juliageo.org/DiscreteGlobalGrids.jl/dev.
    dev = rebase(md, prefixes, bases[1], bases)
    @test occursin("/DGG.jl/dev/bonito/js/WGLMakie.bundled.js", dev)
    @test occursin("/DGG.jl/dev/bonito/bin/f0a1.bin", dev)
    @test !occursin("&quot;/bonito/", dev)

    # Idempotent: the same base applied twice must not nest.
    @test rebase(dev, prefixes, bases[1], bases) == dev
    @test !occursin("/DGG.jl/dev/DGG.jl", dev)

    # Each base rewrites from the shared markdown tree, so the previous base's
    # prefix is replaced, not appended to.
    stable = rebase(dev, prefixes, bases[2], bases)
    @test occursin("/DGG.jl/stable/bonito/js/WGLMakie.bundled.js", stable)
    @test !occursin("/DGG.jl/dev/", stable)
    @test stable == rebase(md, prefixes, bases[2], bases)

    # A root deploy is left exactly as rendered.
    @test rebase(md, prefixes, "/", ["/"]) == md

    # No plugin prefixes at all -> untouched, whatever the base.
    @test rebase(md, String[], bases[1], bases) == md
end

@testset "Bonito asset URLs carry the deploy base (full build)" begin
    md_content = raw"""
# Bonito

```@example bonito
using Bonito
App() do
    DOM.div("hello")
end
```
"""
    # `subfolder` is what `deploydocs` would hand us on CI; with no `deploy_url`
    # the site root comes from the repo name, so the base is `/Test.jl/dev/`.
    function build(dir, subfolder)
        src = joinpath(dir, "src")
        mkpath(src)
        write(joinpath(src, "index.md"), md_content)
        run(pipeline(`$(Documenter.git()) -C $dir init --quiet`, stdout = devnull))
        Page() # fresh page state, so this build re-emits the bundle `<script src>`
        Documenter.makedocs(;
            sitename = "Test",
            root = dir,
            source = "src",
            build = "build",
            warnonly = true,
            remotes = nothing,
            format = DocumenterVitepress.MarkdownVitepress(
                repo = "github.com/test/Test.jl",
                devbranch = "main",
                devurl = "dev",
                build_vitepress = false,  # only need the emitted markdown
                deploy_decision = Documenter.DeployDecision(; all_ok = false, subfolder),
            ),
            plugins = [DocumenterVitepress.BonitoPlugin()],
            pages = ["index.md"],
        )
        return read(joinpath(dir, "build", ".documenter", "index.md"), String)
    end

    mktempdir() do dir
        rendered = build(realpath(dir), "dev")
        # The bundle `<script src>` and every binary blob URL carry the base.
        @test occursin("/Test.jl/dev/bonito/js/", rendered)
        # No bare URL survives — that is exactly the request that 404s.
        @test !occursin(r"(?<!/Test\.jl/dev)/bonito/", rendered)
        @test !occursin("/Test.jl/dev/Test.jl/dev/", rendered)
    end

    mktempdir() do dir
        # Root deploy (no base): unchanged, still served from the site root.
        rendered = withenv("CI" => nothing) do
            build(realpath(dir), "")
        end
        @test occursin("/bonito/js/", rendered)
        @test !occursin("//bonito/", rendered)
        @test !occursin("/Test.jl/bonito/", rendered)
    end
end

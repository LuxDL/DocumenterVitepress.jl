using DocumenterVitepress
using DocumenterVitepress.Documenter
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

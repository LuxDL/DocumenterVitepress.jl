using DocumenterVitepress
using DocumenterVitepress.Documenter
using Test


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

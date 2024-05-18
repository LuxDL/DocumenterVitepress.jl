"""
    dev_docs(builddir::String)

Runs the vitepress dev server to serve the docs built from the Markdown
files (generated by `makedocs`) in the given directory.

If passing a String, pass the path to the `builddir`, i.e., `\$packagepath/docs/build`.

For now, these assume that the Markdown files generated are in `\$builddir/.documenter`.
Work is in progress to let the user pass the config object to fix this.

!!! warning
    This does **NOT** run `makedocs` - you have to do that yourself! 
    Think of it as the second stage of `LiveServer.jl` for DocumenterVitepress specifically.
"""
dev_docs(builddir::String) = run_vitepress_command(builddir, "dev")

"""
    build_docs(builddir::String)

Builds the Vitepress site in the given directory.

If passing a String, pass the path to the `builddir`, i.e., `\$packagepath/docs/build`.
"""
build_docs(builddir::String) = run_vitepress_command(builddir, "build")


function run_vitepress_command(builddir::String, command::String)
    @assert ispath(builddir)
    builddir = abspath(builddir)
    md_output_path = ".documenter"
    @info "DocumenterVitepress: running `vitepress $command`."
    should_remove_package_json = false
    try
        if !isfile(joinpath(dirname(builddir), "package.json"))
            @warn "DocumenterVitepress: Did not find `docs/package.json` in your repository.  Substituting default for now."
            cp(joinpath(dirname(@__DIR__), "template", "package.json"), joinpath(dirname(builddir), "package.json"))
            should_remove_package_json = true
        end
        # We have to be here, so that the package.json is picked up by npm.
        cd(dirname(builddir)) do
            # NodeJS_20_jll treats `npm` as a `FileProduct`, meaning that it has no associated environment variable
            # when interpolating the `npm` command.  
            # However, `node() do ...` actually uses `withenv` internally, so we can wrap all invocations of `npm` in
            # a `node()` block to ensure that the `npm` from the JLL finds the `node` from the JLL.
            node(; adjust_PATH = true, adjust_LIBPATH = true) do _
                if should_remove_package_json
                    if !isfile(joinpath(dirname(builddir), "package.json"))
                        cp(joinpath(dirname(@__DIR__), "template", "package.json"), joinpath(dirname(builddir), "package.json"))
                        should_remove_package_json = true
                    end
                    run(`$(npm) install`)
                end
                run(`$(npm) run env -- vitepress $command $(joinpath(splitpath(builddir)[end], md_output_path))`)
            end
        end
    catch e
        rethrow(e)
    finally
        if should_remove_package_json
            rm(joinpath(dirname(builddir), "package.json"))
            rm(joinpath(dirname(builddir), "package-lock.json"))
        end
    end
end



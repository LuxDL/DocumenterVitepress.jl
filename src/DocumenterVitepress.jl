"""
    DocumenterVitepress

Similar to DocumentationMarkdown.jl but designed to work with
[vitepress](https://vitepress.dev/).
"""
module DocumenterVitepress

using Documenter: Documenter, Selectors

using DocStringExtensions
using NodeJS_20_jll: node, npm

const ASSETS = normpath(joinpath(@__DIR__, "..", "assets"))

include("vitepress_interface.jl")
include("vitepress_config.jl")
include("writer.jl")
include("ANSIBlocks.jl")

export MarkdownVitepress

# Selectors interface in Documenter, for dispatching on different writers
abstract type MarkdownFormat <: Documenter.FormatSelector end

Selectors.order(::Type{MarkdownFormat}) = 0.0
Selectors.matcher(::Type{MarkdownFormat}, fmt, _) = isa(fmt, MarkdownVitepress)
Selectors.runner(::Type{MarkdownFormat}, fmt, doc) = render(doc, fmt)

"""
    generate_template(target_directory::String, package = "YourPackage")

Copies template files from `DocumenterVitepress.jl` to a target directory, replacing
"YourPackage" with the specified package name in `package`.

`target` should be the directory of your package's documentation, and not its root!

Skips existing files and only updates new ones.

## Arguments
- `target_directory`: Destination for template files.
- `package`: Name to replace "YourPackage" with, defaulting to "YourPackage".

## Example
```julia
generate_template(".julia/dev/MyPackage/docs", "MyPackage")
```
"""
function generate_template(target::String, package = "YourPackage")
    # This is the `template` directory in the source tree of DocumenterVitepress.jl
    template_dir = joinpath(dirname(@__DIR__), "template")
    # Iterate through each file in `template_dir`
    for (root, dirs, files) in walkdir(template_dir)
        # Determine the relative path of the current directory
        path = relpath(root, template_dir)
        # Create a path to the equivalent directory in `target`
        target_path = mkpath(joinpath(target, path))
        # Iterate through each file in this repo!
        for file in files
            # Check if the file already exists in the target directory
            if isfile(joinpath(target, path, file))
                @debug "File $(joinpath(path, file)) already exists!"
                continue
            # If the file does not exist, we have to copy it in!
            else
                contents = read(joinpath(root, file), String)
                new_contents = replace(contents, "YourPackage" => package)
                write(joinpath(target_path, file), new_contents)
            end
        end
    end
end

struct BaseVersion
    base::String
end

function Documenter.determine_deploy_subfolder(deploy_decision, versions::BaseVersion)
    # we never use a subfolder and just set that manually via the `dirname`
    return nothing
end

function Documenter.postprocess_before_push(versions::BaseVersion; subfolder, devurl, deploy_dir, dirname)
    @warn "No special postprocessing implemented yet for $versions"
    @show subfolder devurl deploy_dir dirname
    actual_root = replace(deploy_dir, Regex("$(versions.base)\$") => "")
    @info "The actual base root directory is $actual_root"
    return
end

function deploydocs(;
    repo,
    build_dir,
    branch,
    devbranch,
    push_preview,
)
    bases = readlines(joinpath(build_dir, "bases.txt"))
    @info "Found bases for deployment: $bases"

    for (i, base) in enumerate(bases)
        @info "Deploying docs for base $(repr(base))"
        dir = joinpath(build_dir, "$i")
        Documenter.deploydocs(;
            repo,
            target = dir, # each version built has its own dir
            versions = DocumenterVitepress.BaseVersion(base),
            dirname = base,
            branch,
            devbranch,
            push_preview,
        )
    end

end

end

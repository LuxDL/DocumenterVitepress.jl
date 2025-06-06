
"""
    modify_config_file(doc, settings, deploy_decision)

Modifies the config file located at `\\\$builddir/\\\$md_output_path/.vitepress/config.mts` to include attributes determined at runtime.

In general, the config file will contain various strings like `REPLACE_ME_DOCUMENTER_VITEPRESS` which this function will replace with content.

## Replaced config items

Currently, this function replaces the following config items:
- Vitepress base path (`base`)
- Vitepress output path (`outDir`)
- Navbar
- Sidebar
- Title
- Edit link
- Github repo link
- Logo
- Favicon

## Adding new config hooks

Simply add more elements to the `replacers` array within this function.
"""
function modify_config_file(doc, settings, deploy_decision, i_folder, base)

    # Main.@infiltrate
    # Read in the config file,
    # First, we establish paths to some useful directories, so that we can use them later.
    builddir = isabspath(doc.user.build) ? doc.user.build : joinpath(doc.user.root, doc.user.build)
    sourcedir = isabspath(doc.user.source) ? doc.user.source : joinpath(doc.user.root, doc.user.source)
    source_vitepress_dir = joinpath(sourcedir, ".vitepress")
    build_vitepress_dir = normpath(joinpath(builddir, settings.md_output_path, ".vitepress"))
    template_vitepress_dir = joinpath(dirname(@__DIR__), "template", "src", ".vitepress")

    # Make the theme directory
    mkpath(joinpath(build_vitepress_dir, "theme"))

    # Check for the config file
    vitepress_config_file = joinpath(source_vitepress_dir, "config.mts") # We check the source dir here because `clean=false` will persist the old, non-generated file in the build dir, and we need to overwrite it.
    if !isfile(vitepress_config_file)
        mkpath(splitdir(vitepress_config_file)[1])
        @info "DocumenterVitepress: Did not detect `docs/src/.vitepress/config.mts` file. Substituting in the default file."
        # We use `write` instead of `cp` here, because `cp`'ed files inherit the permissions of the source file,
        # which may not be writable.  However, `write` creates a new file for which Julia must have write permissions.
        write(joinpath(build_vitepress_dir, "config.mts"), read(joinpath(template_vitepress_dir, "config.mts"), String))
    else # the user has provided a config file
        # Sometimes this file can get corrupted by makedocs(clean=false),
        # so we need to copy it over again.
        write(joinpath(build_vitepress_dir, "config.mts"), read(vitepress_config_file, String))
    end

    # ? theme / check for index.ts, style.css and docstrings.css files
    if !isfile(joinpath(source_vitepress_dir, "theme", "index.ts"))
        @info "DocumenterVitepress: Did not detect `docs/src/.vitepress/theme/index.ts` file. Substituting in the default file."
        write(joinpath(build_vitepress_dir, "theme", "index.ts"), read(joinpath(template_vitepress_dir, "theme", "index.ts"), String))
    end
    if !isfile(joinpath(source_vitepress_dir, "theme", "style.css"))
        @info "DocumenterVitepress: Did not detect `docs/src/.vitepress/theme/style.css` file. Substituting in the default file."
        write(joinpath(build_vitepress_dir, "theme", "style.css"), read(joinpath(template_vitepress_dir, "theme", "style.css"), String))
    end
    if !isfile(joinpath(source_vitepress_dir, "theme", "docstrings.css"))
        @info "DocumenterVitepress: Did not detect `docs/src/.vitepress/theme/docstrings.css` file. Substituting in the default file."
        write(joinpath(build_vitepress_dir, "theme", "docstrings.css"), read(joinpath(template_vitepress_dir, "theme", "docstrings.css"), String))
    end
    # We have already rewritten the config file, so we can't get burned by clean=false
    # again.
    vitepress_config_file = joinpath(build_vitepress_dir, "config.mts")
    config = read(vitepress_config_file, String)
    replacers = Vector{Pair{<: Union{AbstractString, Regex}, <: AbstractString}}()


    # # Vitepress base path

    # VitePress relies on its config file in order to understand where files will exist.
    # We need to modify this file to reflect the correct base URL, however, Documenter
    # only knows about the base URL at the time of deployment.

    # So, after building the Markdown, we need to modify the config file to reflect the
    # correct base URL, and then build the VitePress site.

    # We don't do this anymore because we build multiple subfolder versions manually
    # because vitepress isn't relocatable
    # folder = deploy_decision.subfolder

    deploy_relpath = "$(base)$(isempty(base) ? "" : "/")"
    deploy_abspath = if isempty(base) && !haskey(ENV, "CI")
            @info "Base is \"\" and ENV[\"CI\"] is not set so this is a local build. Not adding any additional base prefix based on the repository or deploy url and instead using absolute path \"/\" to facilitate serving docs locally."
            "/"
        elseif isnothing(settings.deploy_url)
            "/" * splitpath(settings.repo)[end]  # Get the last identifier of the repo path, i.e., `user/$repo`.
        else
            s_path = startswith(settings.deploy_url, r"http[s?]:\/\/") ? splitpath(settings.deploy_url)[2:end] : splitpath(settings.deploy_url)
            s = length(s_path) > 1 ? joinpath(s_path) : "" # ignore custom URL here
            isempty(s) ? "/" : "/$(s)"
        end

    base_str = deploy_abspath == "/" ? "base: '$(deploy_abspath)$(deploy_relpath)'" : "base: '$(deploy_abspath)/$(deploy_relpath)'"

    push!(replacers, "REPLACE_ME_DOCUMENTER_VITEPRESS_DEPLOY_ABSPATH" => deploy_abspath)
    push!(replacers, "base: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => base_str)

    # # Vitepress output path
    push!(replacers, "outDir: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "outDir: '../$(i_folder)'")
    # # Vitepress navbar and sidebar

    provided_page_list = doc.user.pages
    sidebar_info = sprint(print, pagelist2str(doc, provided_page_list, Val(:sidebar)))
    navbar_info = sprint(print, pagelist2str(doc, provided_page_list, Val(:navbar)))
    push!(replacers, "sidebar: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "sidebar: $(sidebar_info)\n")
    push!(replacers, "nav: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "nav: $(navbar_info)\n")

    # # Title
    push!(replacers, "title: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "title: '$(doc.user.sitename)'")

    # # Description
    push!(replacers, "description: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "description: '$(replace(settings.description, "'" => "\\'"))'")

    # # Edit link
    push!(replacers, "editLink: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "editLink: { pattern: \"https://$(settings.repo)$(endswith(settings.repo, "/") ? "" : "/")edit/$(settings.devbranch)/docs/src/:path\" }")

    # # Github repo
    full_repo = startswith(settings.repo, r"https?:\/\/") ? settings.repo : "https://" * settings.repo
    push!(replacers, """{ icon: 'github', link: 'REPLACE_ME_DOCUMENTER_VITEPRESS' }""" => """{ icon: 'github', link: '$full_repo' }""")

    # # Logo

    if occursin("logo:", config)
        if  isfile(joinpath(doc.user.build, settings.md_output_path, "public", "logo.png"))
            push!(replacers, "logo: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "logo: { src: '/logo.png', width: 24, height: 24}")
        elseif isfile(joinpath(doc.user.build, settings.md_output_path, "public", "logo.svg"))
            push!(replacers, "logo: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "logo: { src: '/logo.svg', width: 24, height: 24}")
        else
            @warn "DocumenterVitepress: No logo.png file found in `docs/src/assets`.  Skipping logo replacement."
            push!(replacers, "logo: 'REPLACE_ME_DOCUMENTER_VITEPRESS'," => "")
        end
    end

    # # Favicon

    if occursin("rel: 'icon', href: 'REPLACE_ME_DOCUMENTER_VITEPRESS_FAVICON'", config)
        if  isfile(joinpath(doc.user.build, settings.md_output_path, "public", "favicon.ico"))
            push!(replacers, "rel: 'icon', href: 'REPLACE_ME_DOCUMENTER_VITEPRESS_FAVICON'" => "rel: 'icon', href: `\${baseTemp.base}favicon.ico`")
        else
            @warn "DocumenterVitepress: No favicon.ico file found in `docs/src/assets`.  Skipping favicon replacement."
            push!(replacers, "['link', { rel: 'icon', href: 'REPLACE_ME_DOCUMENTER_VITEPRESS_FAVICON' }]," => "")
        end
    end

    # Finally, run all the replacers and write the new config file

    new_config = replace(config, replacers...)
    write(vitepress_config_file, new_config)
    yield()
    touch(vitepress_config_file)

    return
end

# Utility methods to get data about pages

function get_title(doc, page::AbstractString)
    # If no name is given, find the first header in the page,
    # and use that as the name.
    elements = collect(doc.blueprint.pages[page].mdast.children)
    # elements is a vector of Markdown.jl objects,
    # you can get the MarkdownAST stuff via `page.mdast`.
    # I f``
    idx = findfirst(x -> x.element isa Union{MarkdownAST.Heading, Documenter.AnchoredHeader}, elements)
    name = if isnothing(idx)
        splitext(page)[1]
    else
        Documenter.MDFlatten.mdflatten(elements[idx])
    end
    return name
end
get_title(doc, page::Pair{<: AbstractString, <: Any}) = first(page)

# Catch all method: just broadcast over any iterable assuming it is a collection
function pagelist2str(doc, pages, sidenav::Val)
    contents = map(pages) do page
        "{ " * pagelist2str(doc, page, sidenav) * " }"
    end
    return "[" * join(contents, ",\n") * "]"
end
function pagelist2str(doc, page::AbstractString, sidenav::Val)
    name = get_title(doc, page)
    return "text: '$(replace(name, "'" => "\\'"))', link: '/$(splitext(page)[1])'" # , $(sidebar_items(doc, page)) }"
end

function pagelist2str(doc, name_page::Pair{<: Any, <: Any}, sidenav::Val)
    name, page = name_page
    # This is the simplest and easiest case.
    return pagelist2str(doc, name => page, sidenav) # , $(sidebar_items(doc, page)) }"
end

function pagelist2str(doc, name_page::Pair{<: Any, <: Nothing}, sidenav::Val)
    return ""
end

function pagelist2str(doc, name_page::Pair{<: AbstractString, <: AbstractString}, sidenav::Val)
    name, page = name_page
    # This is the simplest and easiest case.
    return "text: '$(replace(name, "'" => "\\'"))', link: '/$(splitext(page)[1])'" # , $(sidebar_items(doc, page)) }"
end
function pagelist2str(doc, name_contents::Pair{<: AbstractString, <: AbstractArray}, sidenav::Val)
    name, contents = name_contents
    # This is for nested stuff.  Should work automatically but you never know...
    rendered_contents = map(contents) do content
        "{" * pagelist2str(doc, content, sidenav) * "}"
    end
    final_contents = join(rendered_contents, ",\n")
    collapse = if sidenav === Val(:sidebar)
        "collapsed: false,"
    else
        ""
    end
    return "text: '$(replace(name, "'" => "\\'"))', $collapse items: [\n$(final_contents)\n]" # TODO: add a link here if the name is the same name as a file?
end

function _item_link(page, item)
    return "{ text: '$(replace(Documenter.MDFlatten.mdflatten(item), "'" => "\\'"))', link: '/$(splitext(page)[1])#$(replace(item, " " => "-"))' }"

end

function _get_first_or_string(x::String)
    return x
end

function _get_first_or_string(x)
    return first(x)
end

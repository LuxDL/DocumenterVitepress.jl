
function modify_config_file(doc, settings, deploy_decision)

    # Main.@infiltrate
    # Read in the config file, 
    vitepress_config_file = joinpath(doc.user.build, settings.md_output_path, ".vitepress", "config.mts")
    if !isfile(vitepress_config_file)
        mkpath(splitdir(vitepress_config_file)[1])
        @warn "DocumenterVitepress: Did not detect `docs/src/.vitepress/config.mts` file.  Substituting in the default file."
        if !isdir(joinpath(doc.user.build, settings.md_output_path, ".vitepress", "theme"))
            cp(joinpath(dirname(@__DIR__), "docs", "src", ".vitepress", "theme"), joinpath(doc.user.build, settings.md_output_path, ".vitepress", "theme"); follow_symlinks = true)
        end
        cp(joinpath(dirname(@__DIR__), "docs", "src", ".vitepress", "config.mts"), vitepress_config_file)
        cp(joinpath(dirname(@__DIR__), "docs", "src", "components"), joinpath(doc.user.build, settings.md_output_path, "components"))
    end

    config = read(vitepress_config_file, String)
    replacers = Vector{Pair{<: AbstractString, <: AbstractString}}()


    # # Vitepress base path

    # VitePress relies on its config file in order to understand where files will exist.
    # We need to modify this file to reflect the correct base URL, however, Documenter
    # only knows about the base URL at the time of deployment.

    # So, after building the Markdown, we need to modify the config file to reflect the
    # correct base URL, and then build the VitePress site.
    folder = deploy_decision.subfolder
    deploy_relpath = "$(folder)$(isempty(folder) ? "" : "/")"
    deploy_abspath = if isnothing(settings.deploy_url) 
        "/" * splitdir(settings.repo)[2] 
        else
            s = splitdir(settings.deploy_url)[2]
            isempty(s) ? "/" : "/$(s)"
        end
   
    push!(replacers, "base: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "base: '$(deploy_abspath)/$(deploy_relpath)'")

    # # Vitepress output path
    push!(replacers, "outDir: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "outDir: '../final_site'")
    # # Vitepress navbar and sidebar

    provided_page_list = doc.user.pages
    sidebar_navbar_info = pagelist2str.((doc,), provided_page_list)
    sidebar_navbar_string = join(sidebar_navbar_info, ",\n")
    push!(replacers, "sidebar: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "sidebar: [\n$sidebar_navbar_string\n]\n")
    push!(replacers, "nav: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "nav: [\n$sidebar_navbar_string\n]\n")
   
    # # Title
    push!(replacers, "title: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "title: '$(doc.user.sitename)'")

    # # Edit link
    push!(replacers, "editLink: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "editLink: { pattern: \"$(settings.repo)$(endswith(settings.repo, "/") ? "" : "/")edit/$(settings.devbranch)/docs/src/:path\" }")
    
    # # Github repo
    push!(replacers, """{ icon: 'github', link: 'REPLACE_ME_DOCUMENTER_VITEPRESS' }""" => """{ icon: 'github', link: '$(settings.repo)' }""")

    # # Logo

    if occursin("logo:", config)
        if  isfile(joinpath(doc.user.build, settings.md_output_path, "assets", "logo.png"))
            push!(replacers, "logo: 'REPLACE_ME_DOCUMENTER_VITEPRESS'" => "logo: { src: '/logo.png', width:2 24, height: 24}")
        else
            @warn "DocumenterVitepress: No logo.png file found in `docs/src/assets`.  Skipping logo replacement."
            push!(replacers, "logo: 'REPLACE_ME_DOCUMENTER_VITEPRESS'," => "")
        end
    end

    # # Favicon

    if occursin("rel: 'icon', href: 'REPLACE_ME_DOCUMENTER_VITEPRESS_FAVICON'", config)
        if  isfile(joinpath(doc.user.build, settings.md_output_path, "assets", "favicon.ico"))
            push!(replacers, "rel: 'icon', href: 'REPLACE_ME_DOCUMENTER_VITEPRESS_FAVICON'" => "rel: 'icon', href: '/favicon.ico'")
        else
            @warn "DocumenterVitepress: No favicon.ico file found in `docs/src/assets`.  Skipping favicon replacement."
            push!(replacers, "head: [['link', { rel: 'icon', href: 'REPLACE_ME_DOCUMENTER_VITEPRESS_FAVICON' }]]," => "")
        end
    end

    # Finally, run all the replacers and write the new config file
   
    new_config = replace(config, replacers...)
    write(vitepress_config_file, new_config)

   
    # 

end

function pagelist2str(doc, page::String)
    # If no name is given, find the first header in the page, 
    # and use that as the name.
    elements = doc.blueprint.pages[page].elements
    idx = findfirst(x -> x isa Markdown.Header, elements)
    name = if isnothing(idx)
        splitext(page)[1]
    else
        elements[idx].text[1]
    end
    return "{ text: '$name', link: '/$(splitext(page)[1])' }" # , $(sidebar_items(doc, page)) }"
end

function pagelist2str(doc, name_page::Pair{String, String})
    name, page = name_page
    # This is the simplest and easiest case.
    return "{ text: '$name', link: '/$(splitext(page)[1])' }" # , $(sidebar_items(doc, page)) }"
end

function pagelist2str(doc, name_contents::Pair{String, <: AbstractVector})
    name, contents = name_contents
    # This is for nested stuff.  Should work automatically but you never know...
    rendered_contents = pagelist2str.((doc,), contents)
    return "{ text: '$name', collapsed: false, items: [\n$(join(rendered_contents, ",\n"))]\n }" # TODO: add a link here if the name is the same name as a file?
end

function sidebar_items(doc, page::String)
    # We look at the page elements, and obtain all level 1 and 2 headers.
    elements = doc.blueprint.pages[page].elements
    headers = elements[findall(x -> x isa Union{Markdown.Header{1}, Markdown.Header{2}}, elements)]
    # If nothing is found, move on in life
    if length(headers) ≤ 1
        return ""
    end
    # Otherwise, we return a collapsible tree of headers for each level 1 and 2 header.
    items = _get_first_or_string.(getproperty.(headers, :text))
    return "collapsed: true, items: [\n $(join(_item_link.((page,), items), ",\n"))\n]"
end

function _item_link(page, item)
    return "{ text: '$item', link: '/$(splitext(page)[1])#$(replace(item, " " => "-"))' }"

end

function _get_first_or_string(x::String)
    return x
end

function _get_first_or_string(x)
    return first(x)
end

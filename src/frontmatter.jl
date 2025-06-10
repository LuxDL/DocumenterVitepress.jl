# In Vitepress you can only have one frontmatter block.
# But users / other Documenter stages may inject multiple.
# So, we have a stage that will merge and render all frontmatter blocks
# before doing anything else.

function merge_and_render_frontmatter(io::IO, mime::MIME"text/yaml", page, doc; kwargs...)
    frontmatter = String[]
    for block in page.mdast.children
        element = block.element
        if element isa MarkdownAST.CodeBlock && element.info == "@frontmatter"
            push!(frontmatter, element.code)
        elseif element isa Documenter.RawNode && startswith(element.text, "---")
            push!(frontmatter, join(split(element.text, "\n")[2:end-1], "\n"))
        end
    end

    if haskey(page.globals.meta, :Title)
        pushfirst!(frontmatter, "title: \"$(page.globals.meta[:Title])\"")
    end
    if haskey(page.globals.meta, :Description)
        pushfirst!(frontmatter, "description: \"$(page.globals.meta[:Description])\"")
    end
    println(io, "---")
    println(io, join(frontmatter, "\n"))
    println(io, "---")
end

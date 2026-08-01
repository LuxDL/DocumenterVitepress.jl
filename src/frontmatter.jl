# Vitepress allows only one frontmatter block, but users / Documenter stages may
# inject several, so this stage merges them into one.

"""
    _escape_yaml_double_quoted(value) -> String

Escape `value` for embedding in a double-quoted YAML scalar (`key: "..."`). Page
titles/descriptions from `page.globals.meta` are arbitrary text; an unescaped `"`
or newline would otherwise close the scalar early and break the frontmatter.
"""
function _escape_yaml_double_quoted(value)
    io = IOBuffer()
    for c in string(value)
        if c == '\\'
            print(io, "\\\\")
        elseif c == '"'
            print(io, "\\\"")
        elseif c == '\n'
            print(io, "\\n")
        elseif c == '\r'
            print(io, "\\r")
        elseif c == '\t'
            print(io, "\\t")
        else
            print(io, c)
        end
    end
    return String(take!(io))
end

"""
    _strip_frontmatter_delimiters(text) -> String

Inner YAML of a `---…---` block, robust to a trailing newline that a plain
`split[2:end-1]` would mishandle (leaving the closing `---`).
"""
function _strip_frontmatter_delimiters(text::AbstractString)
    cleaned = strip(text)
    head = startswith(cleaned, "---") ? 3 : 0
    tail = endswith(cleaned, "---") ? 3 : 0
    return strip(chop(cleaned; head, tail))
end

function merge_and_render_frontmatter(io::IO, mime::MIME"text/yaml", page, doc; kwargs...)
    # One merged block; later (page) blocks win on duplicate keys.
    println(io, "---")
    if haskey(page.globals.meta, :Title)
        println(io, "title: \"$(_escape_yaml_double_quoted(page.globals.meta[:Title]))\"")
    end
    if haskey(page.globals.meta, :Description)
        println(io, "description: \"$(_escape_yaml_double_quoted(page.globals.meta[:Description]))\"")
    end
    for block in page.mdast.children
        element = block.element
        if element isa MarkdownAST.CodeBlock && element.info == "@frontmatter"
            println(io, rstrip(element.code))
        elseif element isa Documenter.RawNode && startswith(element.text, "---")
            println(io, _strip_frontmatter_delimiters(element.text))
        end
    end
    println(io, "---")
end

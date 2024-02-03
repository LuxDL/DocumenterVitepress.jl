import Documenter: Anchors, Builder, Documents, Expanders, Documenter, Utilities
import Documenter.Utilities: Selectors
import Markdown, REPL
import Base64: stringmime
import IOCapture
import Documenter.Expanders: iscode, droplines, prepend_prompt, remove_sandbox_from_output

abstract type ANSIBlocks <: Expanders.ExpanderPipeline end

Selectors.order(::Type{ANSIBlocks})     = 12.0
Selectors.matcher(::Type{ANSIBlocks},     node, page, doc) = iscode(node, r"^@ansi")

function Selectors.runner(::Type{ANSIBlocks}, x, page, doc)
    matched = match(r"^@ansi(?:\s+([^\s;]+))?\s*(;.*)?$", x.language)
    matched === nothing && error("invalid '@ansi' syntax: $(x.language)")
    name, kwargs = matched.captures

    # Bail early if in draft mode
    if Utilities.is_draft(doc, page)
        @debug "Skipping evaluation of @ansi block in draft mode:\n$(x.code)"
        page.mapping[x] = create_draft_result(x; blocktype="@ansi")
        return
    end

    # The sandboxed module -- either a new one or a cached one from this page.
    mod = Utilities.get_sandbox_module!(page.globals.meta, "atexample", name)

    # "parse" keyword arguments to repl
    ansicolor = true

    multicodeblock = Markdown.Code[]
    linenumbernode = LineNumberNode(0, "REPL") # line unused, set to 0
    @debug "Evaluating @ansi block:\n$(x.code)"
    for (ex, str) in Utilities.parseblock(x.code, doc, page; keywords = false,
                                          linenumbernode = linenumbernode)
        input  = droplines(str)
        if VERSION >= v"1.5.0-DEV.178"
            # Use the REPL softscope for REPLBlocks,
            # see https://github.com/JuliaLang/julia/pull/33864
            ex = REPL.softscope!(ex)
        end
        c = IOCapture.capture(rethrow = InterruptException, color = ansicolor) do
            cd(page.workdir) do
                Core.eval(mod, ex)
            end
        end
        Core.eval(mod, Expr(:global, Expr(:(=), :ans, QuoteNode(c.value))))
        result = c.value
        buf = IOContext(IOBuffer(), :color=>ansicolor)
        output = if !c.error
            hide = REPL.ends_with_semicolon(input)
            Documenter.DocTests.result_to_string(buf, hide ? nothing : c.value)
        else
            Documenter.DocTests.error_to_string(buf, c.value, [])
        end
        if !isempty(input)
            push!(multicodeblock, Markdown.Code("ansi", prepend_prompt(input)))
        end
        out = IOBuffer()
        print(out, c.output) # c.output is std(out|err)
        if isempty(input) || isempty(output)
            println(out)
        else
            println(out, output, "\n")
        end

        outstr = String(take!(out))
        # Replace references to gensym'd module with Main
        outstr = remove_sandbox_from_output(outstr, mod)
        push!(multicodeblock, Markdown.Code("documenter-ansi", rstrip(outstr)))
    end
    page.mapping[x] = Documents.MultiCodeBlock("ansi", multicodeblock)
end
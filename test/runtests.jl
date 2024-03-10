using Test, DocumenterVitepress

@test DocumenterVitepress.MarkdownVitepress(; repo = "...", devbranch = "...", devurl = "...") isa DocumenterVitepress.MarkdownVitepress
@test_throws ArgumentError DocumenterVitepress.MarkdownVitepress(; repo = "...", devbranch = "...", devurl = "...",
    build_vitepress = false, redirect_trailing_slash = true)

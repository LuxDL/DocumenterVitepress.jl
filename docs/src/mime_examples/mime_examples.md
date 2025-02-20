# MIME-type examples

This file tests the output for all available MIME-types.

```@example mime-examples
"""
    MediaOutput{MIME"..."}(contents::String)

A struct representing media output with a specific MIME type.

# Fields
- `contents::String`: The contents of the media output.
"""
struct MediaOutput{MimeType}
    contents::Vector{UInt8}
end
MediaOutput{MimeType}(contents::String) where MimeType = MediaOutput{MimeType}(Vector{UInt8}(contents))
# This defines the show method for the target MIME type only!
Base.show(io, ::MimeType, media::MediaOutput{MimeType}) where MimeType = write(io, media.contents)
# MediaOutput{MIME"text/plain"}("Hello there!")
```

```@example mime-examples
using DocumenterVitepress
MediaOutput{MIME"image/png"}(read(joinpath(pathof(DocumenterVitepress) |> dirname |> dirname, "docs", "src", "assets", "logo.png")))
```

```@example mime-examples
MediaOutput{MIME"image/jpeg"}(read(download("https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Felis_silvestris_silvestris.jpg/519px-Felis_silvestris_silvestris.jpg")))
```

Vite automatically inlines assets under 4KB by default, if this causes issues with your SVG files you can disable this behavior by adding the following to your vitepress configuration:

::: info config.mts

    vite: {
        build: {
            assetsInlineLimit: 0, // so we can tell whether we have created inlined images or not, we don't let vite inline them
        }
    },

:::

```@example mime-examples
MediaOutput{MIME"image/svg+xml"}("https://upload.wikimedia.org/wikipedia/commons/6/6c/SVG_Simple_Icon.svg" |> download |> read)
```

```@example mime-examples
MediaOutput{MIME"image/gif"}(read(download("https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif")))
```

```@example mime-examples
HTML(raw"""
<div style="width: 100px; height: 100px; background-color: black;"
     onmousemove="let r = Math.round(event.offsetX / 100 * 255);
                  let b = Math.round((100 - event.offsetY) / 100 * 255);
                  this.style.backgroundColor = `rgb(${r}, 0, ${b})`;">
</div>
""")
```

To see more examples of Markdown syntax, see the [Markdown examples page](../markdown-examples.md).
## Video Embedding

DocumenterVitepress automatically converts Markdown image syntax to HTML5 video tags when the file extension indicates a video format.

### Basic video

**Input**
````
![](./my_video.mp4)
````
**Output**

![](./my_video.mp4)

### Alt Attribute as Title

**Input**
````
![Click to play](my_video.mp4)
````

**Output**

![Click to play](my_video.mp4)

### Title Attribute

**Input**
````
![Click to play](./my_video.mp4 "Also my title")
````

**Output**

![Click to play](./my_video.mp4 "Also my title")

### Using @raw html Blocks

`@raw html` blocks preserve HTML content exactly as written, without any markdown processing or conversion.

**Input**

````
```@raw html
<video src="./my_video.mp4" controls="controls" title="Auto play video" autoplay="autoplay"></video>
```
````

**Output**

```@raw html
<video src="./my_video.mp4" controls="controls" title="Auto play video" autoplay="autoplay"></video>
```

### Supported Video Formats

DocumenterVitepress recognizes the following video formats:

- `.mp4` - MPEG-4 (best browser support)
- `.webm` - WebM (modern, widely supported)
- `.ogg` - Ogg
- `.ogv` - Ogg Video
- `.m4v` - MPEG-4 Video (Apple)
- `.avi` - AVI (limited browser support)
- `.mov` - QuickTime (limited browser support)
- `.mkv` - Matroska (limited browser support)


::: tip

For best cross-browser compatibility, use `.mp4` or `.webm` formats.

:::

::: warning

Formats marked with "limited browser support" may not play in all browsers. Test your videos across different browsers if using these formats.

:::

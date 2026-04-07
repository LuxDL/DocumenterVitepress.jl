# Get Started

This guide will help you migrate from Documenter.jl to `DocumenterVitepress.jl` or set up documentation from scratch. The instructions below are tested with the current version and should work out of the box.

## Quick Start (Recommended for First-Time Users)

If you're new to DocumenterVitepress, follow these steps for the simplest setup:

### 1. Install DocumenterVitepress

Navigate to your package's `docs` directory and add the package:

```sh
$ cd docs
docs $ julia
julia> ]
pkg> activate .
pkg> add DocumenterVitepress Documenter
```

### 2. Update Your `make.jl`

Add `using DocumenterVitepress` to your `make.jl` file and replace the `format = HTML(...)` argument in `makedocs` with:

```julia
using Documenter
using DocumenterVitepress

makedocs(;
    # ... your other arguments ...
    format = DocumenterVitepress.MarkdownVitepress(
        repo = "github.com/YourName/YourPackage.jl",
        devbranch = "main", # or master, trunk, ...
        devurl = "dev",
    ),
)
```

### 3. Build Your Documentation

Run your `make.jl` file:

```julia
julia> include("make.jl")
```

This will generate documentation in `docs/build/1`.

> [!NOTE]
> Why `build/1` and not just `build`?
> 
> Since version 0.2, DocumenterVitepress renders a separate build for each base URL where your site should be accessible (e.g., `/v1.2.3`, `/v1.2`, `/v1`, `/stable`). Each build is stored in sequentially numbered folders `build/1`, `build/2`, etc. The bases are tracked in `bases.txt`.
> 
> When building locally, you're not creating a versioned deployment, so the build always goes to `docs/build/1`.

### 4. View Your Documentation Locally

To preview your documentation, serve the `docs/build/1` folder using `LiveServer`, but first, `install LiveServer` in your docs environment if you haven't already:

```julia
pkg> add LiveServer
```

and in another terminal do

```julia
pkg> activate . # do this inside the docs folder
using LiveServer

LiveServer.serve(dir = "build/1")
```

Then open your browser to the URL shown (typically `http://localhost:8000/`).


### 5. Update Your Deployment

Replace your existing `Documenter.deploydocs` call with `DocumenterVitepress.deploydocs`:

```julia
DocumenterVitepress.deploydocs(;
    repo = "github.com/YourName/YourPackage.jl",
    target = joinpath(@__DIR__, "build"),
    branch = "gh-pages",
    devbranch = "main",
    push_preview = true,
)
```

> [!CAUTION]
> Deployment will fail if there are symlinks on your gh-pages branch!
> 
> If you're migrating from Documenter.jl, your `gh-pages` branch may contain symlinks like `stable` or version folders. DocumenterVitepress cannot write to symlinks and you must delete them manually.
> 
> To delete symlinks:
> 1. Go to `https://github.com/YourName/YourPackage.jl/tree/gh-pages`
> 2. Click on the symlink (identifiable by an arrow symbol)
> 3. Delete it through the context menu
> 
> Common symlinks to check for: `stable`, `v0.1`, `v1`, etc.

That's it! Your documentation should now build and deploy with DocumenterVitepress.

## Live Development Workflow

For active documentation development, you have two options:

### Option A: Simple Rebuild (Recommended)

First, install `LiveServer` in your docs environment if you haven't already:

```julia
pkg> add LiveServer
```

Then, after making changes to your markdown files:

1. Run `include("make.jl")` again to rebuild
2. Use LiveServer to view the updated docs:
   ```julia
   using LiveServer
   LiveServer.serve(dir = "build/1")
   ```
3. `Refresh your browser`

This is the most reliable method.

### Option B: Using Vitepress Development Server (Advanced)

If you want to use Vitepress's built-in development server with hot-reload, you can run:

```sh
docs $ npm run docs:dev # in a new terminal
```

This will start a development server (typically at `http://localhost:5173`) with automatic hot-reloading when you change files.

::: details stop any vitepress session

```julia
# you might need to stop the Vitepress server if it's running before
# updating or creating new files
try run(`pkill -f vitepress`) catch end
```

:::

> [!WARNING]
> This requires a `package.json` file in your `docs` folder
> 
> You'll need to have a properly configured `package.json` with Vitepress as a dependency. You can copy one from the [DocumenterVitepress.jl repository](https://github.com/LuxDL/DocumenterVitepress.jl/blob/main/docs/package.json) or create your own.
> 
> You'll also need to have `npm` installed on your system and run `npm install` in the `docs` folder first to install dependencies.

This option is more complex to set up but provides the fastest development experience once configured.

## Advanced: Customizing Vitepress

If you need full control over styling, configuration, or advanced Vitepress features, you can generate a customizable template.

### Generate the Template

Run this command to create all necessary Vitepress files:

```julia
using DocumenterVitepress

DocumenterVitepress.generate_template("/path/to/YourPackage/docs", "YourPackage")
```

This creates the following structure in your `docs/src` folder:

```
docs/src/
├── .vitepress/
│   ├── config.mts      # Main Vitepress configuration
│   └── theme/
│       ├── index.ts    # Theme customization
│       └── style.css   # Custom styles
└── assets/
    ├── favicon.ico
    ├── logo_dark.png
    └── logo_light.png
```

### What Gets Generated

- **`config.mts`**: The main Vitepress configuration file. Edit this to customize navigation, sidebar, search, and other site settings.
- **`theme/index.ts`**: Theme entry point. Use this to add custom Vue components or override Vitepress theme defaults.
- **`theme/style.css`**: Custom CSS styles for your documentation.
- **`assets/`**: Images and icons used by your documentation.

> [!TIP]
> After generating the template, you can edit these files freely. However, you'll need to maintain them manually when updating DocumenterVitepress, as the template is a starting point, not an automatically updated configuration.

### Using the Generated Files

Once you've generated the template:

1. Edit `config.mts` to customize your site's navigation and settings
2. Add custom CSS to `theme/style.css`
3. Replace logos in `assets/` with your own branding
4. Build as usual with `include("make.jl")`

For detailed Vitepress configuration options, see the [Vitepress documentation](https://vitepress.dev/reference/site-config).

## Common Issues and Solutions

### Issue: Cannot find module config.mts

**Solution**: Run `DocumenterVitepress.generate_template()` to create the required Vitepress configuration files, or remove any custom `.vitepress` folder and let DocumenterVitepress use its defaults.

### Issue: 404 Error When Viewing Locally

**Cause**: Trying to access the documentation at a URL path that doesn't exist locally (e.g., `/Example.jl/` instead of `/`).

**Solution**: When using `LiveServer` to view docs locally, the documentation is always at the root (`http://localhost:8000/`), not at a subdirectory.

### Issue: Deployment Fails with Symlink Errors

**Cause**: Your `gh-pages` branch contains symlinks from a previous Documenter.jl deployment.

**Solution**: Manually delete the symlinks on the `gh-pages` branch via GitHub's web interface (see Caution box in step 5 above).

### Issue: Changes Not Showing Up

**Cause**: Browser cache or `LiveServer` not refreshing.

**Solution**: 
1. Hard refresh your browser (Ctrl+Shift+R or Cmd+Shift+R)
2. Or rebuild with `include("make.jl")` and restart `LiveServer`

### Issue: Vitepress Errors About Missing Dependencies

**Cause**: The `node_modules` folder is missing or outdated.

**Solution**: DocumenterVitepress handles its own Node.js dependencies automatically. If you see these errors, they're likely from a manually installed Vitepress. Remove any `package.json`, `package-lock.json`, and `node_modules` from your `docs` folder and let DocumenterVitepress manage dependencies.

## Next Steps

Now that you have basic documentation running:

- Read the [Markdown Examples](./markdown-examples.md) to learn about supported Markdown features
- Explore [Code Examples](./code_example.md) to see how to document code effectively
- Check the [Rendering Pipeline](../devs/render_pipeline.md) to understand how DocumenterVitepress works under the hood
- Visit the [Vitepress documentation](https://vitepress.dev/) for advanced customization options

## Project Structure Reference

For reference, here's the typical structure of a DocumenterVitepress documentation project:

```
YourPackage/
└── docs/
    ├── Project.toml           # Julia dependencies
    ├── make.jl                # Build script
    └── src/
        ├── index.md           # Homepage
        ├── getting_started.md # Other pages...
        ├── assets/            # Optional: custom assets
        │   ├── favicon.ico
        │   └── logo.png
        └── .vitepress/        # Optional: custom Vitepress config
            ├── config.mts
            └── theme/
                ├── index.ts
                └── style.css
```

The `.vitepress` and `assets` folders are **optional**. If you don't provide them, DocumenterVitepress will use sensible defaults. Only add them if you need custom styling or configuration.
# Changelog

## unreleased

## v0.3.5 - 2026-07-14

- Updating logo image to docs/src/assets location in README.md [#390](https://github.com/LuxDL/DocumenterVitepress.jl/pull/390)
- Cleaned up `docs/make.jl` by removing unused `DocumenterCitations` integration code and clarifying remaining dependencies [#382](https://github.com/LuxDL/DocumenterVitepress.jl/pull/382).
- Fixed `DecomposeInSidebar` to properly handle mixed lists of decomposed and regular page entries [#381](https://github.com/LuxDL/DocumenterVitepress.jl/pull/381)
- Changed the default text colour for code blocks to be the same as plain text, to avoid confusion with hyperlinks [#380](https://github.com/LuxDL/DocumenterVitepress.jl/pull/380)
- Added an `overrides.css` file to allow for targeted overrides to the default Vitepress and DocumenterVitepress styles without having to copy the entire theme [#379](https://github.com/LuxDL/DocumenterVitepress.jl/pull/379)
- Fixed a bug where DocumenterVitepress would error if outside of a git repository
- Fixed ANSI-colored `@repl` output (e.g. from StyledStrings or colored `show` methods) rendering as raw escape codes. `@repl` output whose text carries ANSI escapes is now emitted as a single `ansi` fence annotated with a `julia-repl-runs=` spec, and the `julia-repl-transformer` re-highlights the input as `julia` and the output as `ansi` into one `<pre>` — matching Documenter's HTML output (syntax-highlighted input, colored output in one box). Colorless `@repl` blocks are unchanged [#373](https://github.com/LuxDL/DocumenterVitepress.jl/issues/373)
- Fixed missing root `index.html` redirect on deploy: `Documenter.deploydocs` writes this for its standard `versions=` argument, but `DocumenterVitepress.deploydocs` uses a custom `versions` type that bypasses that code path, so a freshly-deployed site had nothing at its root and 404'd instead of redirecting to `stable`/`dev` [#368](https://github.com/LuxDL/DocumenterVitepress.jl/pull/368)
- Made sidebar/navbar generation overloadable: `pagelist2str` now dispatches on a `Val{:sidebar}`/`Val{:navbar}` tag (with a `get_title` helper), so a custom `make.jl` can control how pages map to VitePress nav entries [#357](https://github.com/LuxDL/DocumenterVitepress.jl/pull/357)
- Fixed VitePress `base`-path derivation from `repo`/`deploy_url`: split on `/` instead of `splitpath` (which mangled URLs), support custom-domain subpaths, and strip trailing slashes [#359](https://github.com/LuxDL/DocumenterVitepress.jl/pull/359)
- Added `Documenter.Plugin` extension hooks (`vitepress_dependencies`, `vitepress_components`, `vitepress_config_transform`, `vitepress_assets`) for plugins to inject npm deps, Vue components, `config.mts` transforms, and `public/` assets at build time; all default to no-ops [#363](https://github.com/LuxDL/DocumenterVitepress.jl/pull/363)
- `npm install` failures now surface the captured npm stderr/stdout via `@error` instead of a bare `ProcessExited` [#362](https://github.com/LuxDL/DocumenterVitepress.jl/pull/362)
- Added a frontmatter stage that merges multiple `@frontmatter`/raw blocks into the single block VitePress allows, emits page `title` and meta `description`, and escapes them for YAML [#358](https://github.com/LuxDL/DocumenterVitepress.jl/pull/358)
- Added a `write_inventory` option to `MarkdownVitepress` (default `true`); set it to `false` to skip writing the `objects.inv` inventory [#360](https://github.com/LuxDL/DocumenterVitepress.jl/pull/360)
- Added a `noindex_non_stable` option to `MarkdownVitepress` (default `true`) that injects a `noindex, nofollow` robots meta into non-stable, non-root deployments so search engines only index the stable docs [#361](https://github.com/LuxDL/DocumenterVitepress.jl/pull/361)
- Interactive `text/html` show output that contains `<script>` tags (e.g. WGLMakie/Bonito figures, Plotly) now actually runs. Such output is wrapped in `<ClientOnly>` (so the potentially-multi-MB widget is not server-rendered) and its scripts are executed on the client via a new `v-exec-scripts` directive, on the initial render and on client-side navigation — previously `v-html` set `innerHTML`, whose `<script>` tags the browser never executes, so figures only appeared on a hard reload. Script-free HTML output keeps the plain server-rendered `v-html` path.
- Added a GitHub Actions workflow for posting a PR preview comment with a link to the documentation preview. The workflow automatically reads `deploy_repo` from `docs/make.jl` to support cross-repository deployments, and only runs on PRs from the same repository (not forks) [#355](https://github.com/LuxDL/DocumenterVitepress.jl/pull/355)

## v0.3.4 - 2026-05-21

- Stopped HTML-escaping plain text in the emitted markdown beyond what is required to keep Vue from parsing `<`/`>` as HTML tags. Previously, characters like `&`, `'`, `"` were turned into entities, which surfaced as literal `&amp;` / `&#39;` / `&quot;` in browser tab titles (e.g. a heading `# PDF & SVG` showed as "PDF &amp; SVG") [#351](https://github.com/LuxDL/DocumenterVitepress.jl/pull/351)

- Fixed list ordering / numbering and removed extra newlines [#276](https://github.com/LuxDL/DocumenterVitepress.jl/pull/276).

## v0.3.3 - 2026-04-10

- Fixed Windows paths for `Documenter`-crosslinks (`Documenter.PageLink` and `Documenter.LocalLink`) and for the nav/sidebar (via `pagelist2str`) [#340](https://github.com/LuxDL/DocumenterVitepress.jl/pull/340)
- Improved visual distinction between code input and output blocks: output blocks now have a distinct background and a surrounding border [#338](https://github.com/LuxDL/DocumenterVitepress.jl/pull/338)
- Added `sidebar_drawer` config option to `MarkdownVitepress` and a `SidebarDrawerToggle` Vue component for toggling sidebar visibility [#329](https://github.com/LuxDL/DocumenterVitepress.jl/pull/329)
- Adds syntax highlighting for `julia>` and `pkg>` Julia REPL mode prompts using Shiki transformer with regex matching [#322](https://github.com/LuxDL/DocumenterVitepress.jl/pull/322)
- Documents `LiveServer.servedocs` as an option for live documentation development [#337](https://github.com/LuxDL/DocumenterVitepress.jl/issues/337)

## v0.3.2 - 2026-02-16

- use loadDynamicFiles official API [#325](https://github.com/LuxDL/DocumenterVitepress.jl/pull/325)

## v0.3.1 - 2026-02-16

- fixed load path for mathjax [#320](https://github.com/LuxDL/DocumenterVitepress.jl/pull/320)
- don't try open siteinfo.js on local windows builds, there are not automatic builds here [#319](https://github.com/LuxDL/DocumenterVitepress.jl/pull/319)
- wraps standard image-like markdown syntax for videos into <video /> tags [#318](https://github.com/LuxDL/DocumenterVitepress.jl/pull/318)

## v0.3.0 - 2026-01-02

- updates get started section, now is consistent with README [#313](https://github.com/LuxDL/DocumenterVitepress.jl/pull/313)
- parses plain \eqref and \ref. [#312](https://github.com/LuxDL/DocumenterVitepress.jl/pull/312).
- template updates and mathjax-plugin cleanup. Fixes equations width overflow. Added smooth scroll to targets. [#310](https://github.com/LuxDL/DocumenterVitepress.jl/pull/310).
- Custom script to preload tex fonts [#305](https://github.com/LuxDL/DocumenterVitepress.jl/pull/305).
- Switched to `@mdit/plugin-mathjax` from `markdown-it-mathjax3` in order to support labels and referencing equations [#302](https://github.com/LuxDL/DocumenterVitepress.jl/pull/302).
- Renamed `master` to `main`

    Local clones should do
    ```sh
    git branch -m master main
    git fetch origin
    git branch -u origin/main main
    git remote set-head origin -a
    ```

## v0.2.6 - 2025-06-08

- Lowers MIME priority for LaTeX rendering.

## v0.2.5 - 2025-05-29

- Add LaTeX rendering support on outputs from Documenter blocks.
- Fix a bug with `@ansi` blocks in draft mode.
- Add a definition to let `@example` blocks print in color.

## v0.2.4 - 2025-05-26

- Skip empty bases when deploying to not overwrite all docs accidentally [#274](https://github.com/LuxDL/DocumenterVitepress.jl/pull/274).

## v0.2.3 - 2025-05-25

- Fixed occasional double slashes in version picker URLs and removed the unnecessary current version from the bottom of the version list [#272](https://github.com/LuxDL/DocumenterVitepress.jl/pull/272).

## v0.2.2 - 2025-05-21

- Fixed relative path to favicon in vitepress config [#265](https://github.com/LuxDL/DocumenterVitepress.jl/pull/265).
- Added `keep` option in `DocumenterVitepress.MarkdownFormat` to control which versions of the documentation are kept. The new default is `:breaking`, which means that **only versions are kept that are incompatible with each other**. This means that v1.2.3 will be accessible only under v1, and when v1.2.4 or v1.3.0 are rendered, they will overwrite only this v1 folder because they are not breaking. If a v2.0.0 is tagged, it will be saved under v2 because it's breaking relative to v1. For versions starting with v0, all minor versions will be kept because they are considered incompatible under Julia semver rules. The other options are `:minor` and `:patch`. For `:minor`, `v1.0` and `v1.1` would be kept as well, and for `:patch` every patch release. Note that `:patch` will take most storage on the `gh-pages` branch, which will affect deploy times especially if doc builds contain many images or other larger assets [#269](https://github.com/LuxDL/DocumenterVitepress.jl/pull/269). If you have previously rendered patch versions like `v1.2.3` to your gh-pages branch, you might want to delete those manually after switching to, e.g., the `:breaking` scheme, so that the version picker dropdown only reflects `v1`.

## v0.2.1 - 2025-05-15

Bug fix release after v0.2.0 - now, namespacing deploydocs as `DocumenterVitepress.deploydocs` should "just work".

- Fix error when trying to read nonexistent `.vitepress/config.mts`.
- Pass `deploydocs` keyword arguments through correctly
- Respect the `dirname` keyword to deploydocs
- Compute the root directory in `DV.deploydocs` and pass it down to Documenter, so that relative `target` paths work.
- Add the correct path to the Github Actions post status JSON that Documenter pushes, by invoking it ourselves after all deployments.
- Log info statements, not warnings, when filling in missing Vitepress config files.
- Fix a bug where the `@ansi` block errored when in draft mode.

## v0.2.0 - 2025-05-14

- **Breaking**: `makedocs` now renders a separate build for each `base` needed by vitepress, for example `v1.2.3`, `v1.2`, `v1` and `stable`. This fixes problems stemming from the non-relocatability of vitepress sites (the base they have been rendered for must be the same as where it is deployed). Because the structure of the `build` folder changes and now contains subfolders which must be deployed separately, `Documenter.deploydocs` cannot be used anymore. Instead, use the function of similar name `DocumenterVitepress.deploydocs` which wraps Documenter's function in a way that handles the multi-folder setup correctly [#246](https://github.com/LuxDL/DocumenterVitepress.jl/pull/246). You will also have to delete every symlink on the `gh-pages` branch which Documenter has written and which you want to deploy to using DocumenterVitepress, for example `stable` will be a symlink but needs to be removed before DocumenterVitepress can render to an actual directory there. For more information check the README.
- Added the ability to write inventories using [DocInventories](https://github.com/JuliaDocs/DocInventories.jl) [#249](https://github.com/LuxDL/DocumenterVitepress.jl/pull/249)

# Changelog

## Unreleased

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

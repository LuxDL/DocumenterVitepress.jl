# Changelog

## Unreleased

- Fixed relative path to favicon in vitepress config [#265](https://github.com/LuxDL/DocumenterVitepress.jl/pull/265).
- Changed internal templating mechanism which will require synchronizing custom `config.mts` files to use the new format [#266](https://github.com/LuxDL/DocumenterVitepress.jl/pull/266).

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

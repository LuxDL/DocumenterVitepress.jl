# Upgrading docs from Documenter.jl to DocumenterVitepress.jl

**Assuming that your current documentation is based on Documenter.jl, you can upgrade to DocumenterVitepress.jl by following these steps:**

Let us suppose that you are working on a package named `Example.jl` that is part of a GitHub organization named `ExampleOrg`.

Then the very first step here is to update the `make.jl` file to follow the DocumenterVitepress.jl format.

1. Go the the `make.jl` file in your `docs` folder and do the following necessary changes to upgrade to DocumenterVitepress.jl:

   :::tabs

   == From Documenter.jl

   The `make.jl` file with `Documenter.jl` should look like this:

   ```julia
   using Example
   using Documenter

   DocMeta.setdocmeta!(Example, :DocTestSetup, :(using Example); recursive=true)

   makedocs(;
       modules = [Example],
       repo = Remotes.GitHub("ExampleOrg", "Example.jl"),
       authors = "Jay-sanjay <landgejay124@gmail.com>, and contributors",
       sitename = "Example.jl",
       format = Documenter.HTML(;
           canonical = "https://github.com/ExampleOrg/Example.jl",
           edit_link = "main",
           assets = String[],
       ),
       pages = [
           "Home" => "index.md",
           "Tutorials" => "tutorials.md",
           "API" => "api.md",
           "Contributing" => "contributing.md"
       ],
   )

   deploydocs(;
       repo = "github.com/jay-sanjay/Example.jl",
       devbranch = "main",
   )
   ```

   == to DocumenterVitepress.jl

   The same `make.jl` file with `DocumenterVitepress.jl` will look like this:

   ```julia
   using Example
   using Documenter
   using DocumenterVitepress

   DocMeta.setdocmeta!(Example, :DocTestSetup, :(using Example); recursive=true)

   makedocs(;
       modules = [Example],
       repo = Remotes.GitHub("ExampleOrg", "Example.jl"),
       authors = "Jay-sanjay <landgejay124@gmail.com>, and contributors",
       sitename = "Example.jl",
       format = DocumenterVitepress.MarkdownVitepress(
           repo = "https://github.com/ExampleOrg/Example.jl",
       ),
       pages = [
           "Home" => "index.md",
           "Tutorials" => "tutorials.md",
           "API" => "api.md",
           "Contributing" => "contributing.md"
       ],
   )

   deploydocs(;
       repo = "github.com/ExampleOrg/Example.jl",
       target = "build", # this is where Vitepress stores its output
       devbranch = "main",
       branch = "gh-pages",
       push_preview = true,
   )
   ```

   :::

::: details stop any vitepress session

```julia
# you might need to stop the Vitepress server if it's running before
# updating or creating new files
try run(`pkill -f vitepress`) catch end # [!code error]
```

:::

2. Next, to build new docs from docs/src,
   ```sh
   $ cd docs
   docs $
   ```
3. Then, in docs/, start a julia session and activate a new environment.
   ```sh
   docs $ julia
   julia> ]
   pkg> activate .
   ```
4. Add packages as necessary. Here, we will need

   ```julia-repl
   pkg> add DocumenterVitepress, Documenter
   ```

5. Then run the `make.jl` file to build the documentation.

   ```julia-repl
   julia> include("make.jl")
   ```

6. Finally, hit `;` to enter the shell mode and run:

   ```sh
   shell> npm i
   ```
   The above command shall create a folder named `node_modules` and `package-lock.json` in your docs folder.

7. Next, hit 'Backspace' to get back to the Julia REPL and run:
   ```julia-repl
   julia> DocumenterVitepress.dev_docs("build")
   ```

8. Finally the live preview of your documentation at `http://localhost:5173/Example.jl/` in your browser.

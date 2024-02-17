# Plotting outputs

## GLMakie

````@example GLMakie
using GLMakie
meshscatter(rand(Point3f,10); color=rand(10))
````

````@example GLMakie
fig, ax, obj = meshscatter(rand(Point3f,10); color=rand(10))
fig
````

## CairoMakie

````@example CairoMakie
using CairoMakie
CairoMakie.activate!(type = "svg")
scatter(rand(Point2f,10); color=rand(10))
````


````@example CairoMakie
CairoMakie.activate!(type = "svg")
fig, ax, obj = scatter(rand(Point2f,10); color=rand(10))
fig
````

````@example CairoMakie
CairoMakie.activate!(type = "png")
fig, ax, obj = scatter(rand(Point2f,10); color=rand(10))
fig
````

## WGLMakie and Bonito

````@example bonito
using WGLMakie
using Bonito, Markdown
Page(exportable=true, offline=true)
WGLMakie.activate!()
Makie.inline!(true) # Make sure to inline plots into Documenter output!
scatter(1:4, color=1:4)
````

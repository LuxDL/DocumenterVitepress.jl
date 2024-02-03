# Julia code example

The `Julia` code used here is done using the following packages versions:

````@example version
using Pkg
Pkg.status()
````

And a simple task:

````@example simple_sum
2 + 2
````

## ANSI example

````@ansi
printstyled("this is my color"; color = :red)
````
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

A more colorful example for [documenter](https://documenter.juliadocs.org/stable/showcase/#Raw-ANSI-code-output):

````@ansi
for color in 0:15
    print("\e[38;5;$color;48;5;$(color)m  ")
    print("\e[49m", lpad(color, 3), " ")
    color % 8 == 7 && println()
end
````
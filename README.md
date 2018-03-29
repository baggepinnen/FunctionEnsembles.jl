# FunctionEnsembles

[![Build Status](https://travis-ci.org/baggepinnen/FunctionEnsembles.jl.svg?branch=master)](https://travis-ci.org/baggepinnen/FunctionEnsembles.jl)

```julia
using FunctionEnsembles

v = [sin,cos]
e = Ensemble(v)
e[1] === v[1] # e behaves very much like a vector
length(e) == length(v)

# Call like a function
e(1) == @ensemble(v(1)) == @ensemble([sin,cos](1)) == [v[1](1), v[2](1)] # These are all equivalent

@ensemble gg = [sin,cos](1)
gg == e(1)

e(+,0,1) == sum(e(1)) # Works like reduce

a = randn(4)
sum(abs2, a) # This function ccepts function as first argument
mean(abs2, a) # This function ccepts function as first argument
std(abs2, a) # This function does not
@functionfirst std(abs2, a) # Now it does
@functionfirst std(a) do x # Allows for a nice syntax
    abs2(x)
end
```

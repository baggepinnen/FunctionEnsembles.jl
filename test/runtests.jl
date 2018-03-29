using FunctionEnsembles
using Base.Test

v = [sin,cos]
e = Ensemble(v)
@test e[1] === v[1] # e behaves very much like a vector
@test length(e) == length(v)

@test e(1) == @ensemble(v(1)) == @ensemble([sin,cos](1)) == [v[1](1), v[2](1)] # These are all equivalent
@test @ensemble(e(1)) == e(1)
@ensemble gg = [sin,cos](1)
@test gg == e(1)

@test e(+,0,1) == sum(e(1)) # Works like reduce


a = randn(4)
sum(abs2, a)
mean(abs2, a)
@test std(abs2.(a)) == @functionfirst std(abs2, a)
@test std(abs2.(a)) == @functionfirst std(a) do x
    abs2(x)
end

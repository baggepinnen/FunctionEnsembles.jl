module FunctionEnsembles

export Ensemble, @ensemble, @functionfirst

using Lazy
struct Ensemble{T}
    funs::Vector{T}
end
Ensemble(e::Ensemble) = e

Base.getindex(e::Ensemble, inds...) = e.funs[inds...]
@forward Ensemble.funs Base.length, Base.size, Base.isempty, Base.getindex, Base.setindex!, Base.push!, Base.deleteat!, Base.insert!, Base.prepend!, Base.start, Base.next, Base.done


function (e::Ensemble)(args...; kwargs...)
    results = map(e.funs) do f
        f(args...; kwargs...)
    end
end

function (e::Ensemble)(op::Function, v0, args...; kwargs...)
    reduce(op, v0, f(args...; kwargs...) for f in e.funs)
end

macro ensemble(e)
    @assert e isa Expr "Call syntax: @ensemble v(args...) where v::Vector{Function}"
    if e.head == :call
        quote
            Ensemble($(esc(e.args[1])))($(esc(e.args[2:end]...)))
        end
    elseif e.head == :(=)
        quote
            $(esc(e.args[1])) = Ensemble($(esc(e.args[2].args[1])))($(esc(e.args[2].args[2:end]...)))
        end
    else
        error("Call syntax: @ensemble v(args...) where v::Vector{Function}")
    end
end

macro functionfirst(e)
    @assert e isa Expr "Call syntax: @functionfirst fun1(fun2, iterable)"
    @assert e.head == :call  "Call syntax: @functionfirst fun1(fun2, iterable)"
    quote
        outerfun = $(esc(e.args[1]))
        innerfun = $(esc(e.args[2]))
        arg = $(esc(e.args[3]))
        outerfun(innerfun.(arg))
    end
end




end # module

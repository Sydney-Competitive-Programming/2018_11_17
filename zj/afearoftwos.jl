using Base.Iterators
x=[0,1,3:9...]
f(n)=n==0 ? x : vec([x+y for (x,y) in product(x.*10^n,f(n-1))])
vcat(sort(f(5))[2:end],Int(1e6))
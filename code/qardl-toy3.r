T = 1000
u = runif(T)

a0 = a1 = a2 = b0 = b1 = b2 = 1

sigma = function(x,y) b0 + b1*y + b2*x

y0 = runif(1)
x0 = runif(1)

y.current = y0
x.current = x0

y = numeric()
x = numeric()

for (t in 1:T){
 y[t] = a0 + a1*y.current + a2*x.current + sigma(x.current,y.current)*u[t]
 x[t] = a0 + a1*x.current + a2*y.current + sigma(y.current,x.current)*u[t]
 y.current = y[t]
 x.current = x[t]
}

ts.plot(y[1:30])


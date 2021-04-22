library(quantreg)
T = 10050
g = function(z) (atan(z)+pi/2)/pi
x0 = rnorm(1, sd=.1)
y0 = rnorm(1, sd=1)

x.current = x0
y.current = y0

x = y = numeric()

for (t in 1:T){
u1 = runif(1)
 y[t] = .99*y.current + qnorm(u1)*(1+abs(x.current))
u2 = runif(1)
 x[t] = qnorm(u2, sd=1)
 x.current = x[t]
 y.current = y[t]
}

burn = 50
y = y[burn:T]
x = x[burn:T]
T=length(y)
ts.plot(y)
plot(y[2:T]~y[2:T-1])
plot(y[2:T]~x[2:T-1])
acf(y)
pacf(y)
plot(y~x)
hist(y,breaks=50)
range(y)
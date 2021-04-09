library(quantreg)
T = 10050
g = function(z) (atan(z)+pi/2)/pi/2
x0 = rnorm(1)
y0 = rnorm(1)

x.current = x0
y.current = y0

x = y = numeric()

for (t in 1:T){
 y[t] = 10*g(y.current) + qnorm(runif(1))*10*g(x.current)
 x[t] = 10*g(x.current) + qnorm(runif(1))*10*g(y.current)
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



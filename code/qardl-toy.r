# This code simulates a sample path of size T from a simple QARDL(1,1) model:
# Q(𝜏| ℱ[t-1]) = a(𝜏) + b(𝜏)*y[t-1] + c(𝜏)*x[t-1]
# where a(𝜏) = -b(𝜏) = -c(𝜏) = sqrt(𝜏)
# and where x[t] given ℱ[t-1] and y[t] is uniform on [0, 1-y[t]]

set.seed(1)
library(quantreg)

# Arbitrary starting point (y0,x0) satisfying x0+y0 < 1
y0 = runif(1)
x0 = runif(1,0,1-y0)

y = x = numeric()
x.current = x0
y.current = y0

# Functional parameters
a = function(tau) sqrt(tau)
b = function(tau) -sqrt(tau)
c = function(tau) -sqrt(tau)

# Quantile function of y[t] given ℱ[t-1]
Q = function(tau,y.current,x.current){
a(tau) + b(tau)*y.current + c(tau)*x.current
}

T = 2000
for (t in 1:T){
# simulates y[t] given ℱ[t-1] using the Fundamental Theorem of Simulation
u = runif(1)
y[t] = Q(u, y.current, x.current)

# conditional on ℱ[t-1] and y[t], x[t] is uniform over [0, 1-y[t]]
x[t] = runif(1,0,1-y[t])

x.current = x[t]
y.current = y[t]
}

acf(y)
pacf(y)
acf(x)
pacf(x)

plot(y[2:T]~y[1:(T-1)])
plot(y[2:T]~x[1:(T-1)])
hist(y, breaks = T/100)
hist(x, breaks = T/100)



Y = y[2:T]
X = cbind(y[1:(T-1)], x[1:(T-1)])

tau.grid = seq(from=.01,to=.99, by=.01)
qrfit = rq(Y~X, tau = tau.grid)

par(mfrow=c(3,1))
plot(tau.grid, a(tau.grid), type = 'l', col='blue', lwd=2, lty='dotted')
lines(tau.grid, coef(qrfit)[1,], lwd=2, col = rgb(0,0,0,.7))

plot(tau.grid, b(tau.grid), type = 'l', col='blue', lwd=2, lty='dotted')
lines(tau.grid, coef(qrfit)[2,], lwd=2, col = rgb(0,0,0,.7))

plot(tau.grid, c(tau.grid), type = 'l', col='blue', lwd=2, lty='dotted')
lines(tau.grid, coef(qrfit)[3,], lwd=2, col = rgb(0,0,0,.7))

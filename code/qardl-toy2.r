# This code simulates a sample path of size T from a simple QARDL(1,1) model:
# Q(𝜏| ℱ[t-1]) = a(𝜏) + b(𝜏)*y[t-1] + c(𝜏)*x[t-1]

# set.seed(1)
library(quantreg)
library(conquer)


tau.grid = seq(from=.01,to=.99, by=.01)

# Arbitrary starting point (y0,x0)
y0 = runif(1)
x0 = runif(1)

y = x = numeric()
x.current = x0
y.current = y0

# Value of the conditional quantile function at three
# vertices of the unit square
v00 = function(tau) qbeta(tau, 8,2)
v10 = function (tau) qbeta(tau, 2,8)
# v11 = function (tau) qbeta(tau, 2,12)
# v01 = function (tau) v00(tau) + v11(tau) - v10(tau)
v01 = function(tau) qbeta(tau,8,2)
v11 = function (tau) v10(tau) + v01(tau) - v00(tau)
plot(tau.grid, v11(tau.grid))
dbplot = function(a,b){
 tau = seq(from=0,to=1,by=.01)
 plot(tau, dbeta(tau,a,b))
}
# (for the quantile function to be well defined for (y.current,x.current)\in[0,1]^2
# it is necessary that v10' + v01' - v00' \ge0)

# Functional parameters
b0 = v00
b1 = function(tau) v10(tau) - v00(tau)
b2 = function(tau) v11(tau) - v10(tau)

# Quantile function of y[t] given ℱ[t-1]
Q = function(tau,y.current,x.current){
 b0(tau) + b1(tau)*y.current + b2(tau)*x.current
}

T = 10000
for (t in 1:T){
 # simulates y[t] given ℱ[t-1] using the Fundamental Theorem of Simulation
 y[t] = Q(runif(1), y.current, x.current)
 
 # x[t] has the “same” quantile function as y[t]
 x[t] = runif(1)#Q(runif(1), x.current, y.current)#runif(1,max(y[t]-.1,0),min(y[t]+.1,1))#Q(runif(1), x.current, y.current)
 
 x.current = x[t]
 y.current = y[t]
}

acf(y)
pacf(y)

plot(y[2:T]~y[1:(T-1)])
plot(y[2:T]~x[1:(T-1)])
hist(y, border=NA, breaks="FD")
ts.plot(y)


Y = y[2:T]
X = cbind(y[1:(T-1)], x[1:(T-1)])

# qrfit = rq(Y~X, tau = tau.grid)
# 
# plot(tau.grid, b0(tau.grid), type = 'l', col='blue', lwd=2, lty='dotted')
# lines(tau.grid, coef(qrfit)[1,], lwd=2, col = rgb(0,0,0,.7))
# 
# plot(tau.grid, b1(tau.grid), type = 'l', col='blue', lwd=2, lty='dotted')
# lines(tau.grid, coef(qrfit)[2,], lwd=2, col = rgb(0,0,0,.7))
# 
# plot(tau.grid, b2(tau.grid), type = 'l', col='blue', lwd=2, lty='dotted')
# lines(tau.grid, coef(qrfit)[3,], lwd=2, col = rgb(0,0,0,.7))

conquerfit = sapply(tau.grid, function(tau) conquer(X,Y,tau=tau)$coeff)
plot(tau.grid, b0(tau.grid), type = 'l', col='blue', lwd=2, lty='dotted')
lines(tau.grid, conquerfit[1,], lwd=2, col = rgb(0,0,0,.7))

plot(tau.grid, b1(tau.grid), type = 'l', col='blue', lwd=2, lty='dotted')
lines(tau.grid, conquerfit[2,], lwd=2, col = rgb(0,0,0,.7))

plot(tau.grid, b2(tau.grid), type = 'l', col='blue', lwd=2, lty='dotted')
lines(tau.grid, conquerfit[3,], lwd=2, col = rgb(0,0,0,.7))

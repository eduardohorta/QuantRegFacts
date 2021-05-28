library(quantreg)
library(qrcm)
#require(splines)
require(hdrcde)
#source('sqr_function.r')

N = length(maxtemp)
X <- maxtemp[-N] # exclude last observation
Y <- maxtemp[-1] # exclude first observation

s <- (X<40)  #Delete a few (influential, ridiculously hot) days
X <- X[s]
Y <- Y[s]

idx = sort.int(X, index.return = TRUE)$ix # sort sample in acending order (X)
X = X[idx]
Y = Y[idx]

X = X[-1] # this guy seems to be an outlier
Y = Y[-1]

X = log(X) # the scatterplot looks nicer on log scale
Y = log(Y)

dev.off()
plot(Y~X, pch = 16, col=rgb(0,0,1,.2), cex=.5, xlab = "yesterday's max temperature", ylab = "today's max temperature")


Xmat = cbind(X^1,X^2)

fo1o = lm(Y~Xmat)
lines(X, cbind(1,Xmat)%*%fo1o$coef, lwd=4, col=rgb(0,0,0,.2))

tau_grid = seq(from=.1, to=.9, by =.05)
fo2o = rq(Y~Xmat, tau = tau_grid)


L = 3
### FRUMENTO
fo3o = qrcm::iqr(Y~Xmat, formula.p = ~slp(p,k=L-1))
fo4o=slp(tau_grid,k=L-1)
PHI = cbind(1,fo4o)
BETA = fo3o$coef%*%t(PHI)
Xpred = cbind(1,Xmat)%*%BETA

### GLOBAL
source('Utils.R')
phi = phi_generator(L, tau_grid)

M = length(tau_grid)
D = ncol(Xmat) + 1 # plus 1 for intercept
N = nrow(Xmat)

Y = matrix(rep(Y,M),N,M)
TAUS = matrix(rep(tau_grid,N),N,M, byrow = TRUE)

a = Variable(D,L)
Xmat1 = cbind(1,Xmat)
objective = R(a, Y, Xmat1, TAUS, phi)
problem = Problem(Minimize(objective))
result = solve(problem)
ahat = result$getValue(a)
bhat = ahat%*%phi


par(mar=c(0,0,0,0), oma=c(0,0,0,0))
plot(Y~X, ann=FALSE, bty='n', type='n', axes=FALSE)

for (i in 1:length(tau_grid)){
  #lines(X, fo2o$fitted.values[,i], col=rgb(1,0,0,.2))
  lines(X, Xpred[,i],col=rgb(0,0,0,.2), lwd=1)
}
set.seed(2)
idx = sample(1:N, size = 700, replace = FALSE)
points(Y[idx]~X[idx], pch = 16, col=rgb(0,0,.8,.2), lwd=3, cex=1.2, ann=FALSE, bty='n')

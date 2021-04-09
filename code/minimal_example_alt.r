library(conquer)
library(quantreg)
data(engel)
y = engel$foodexp
x = engel$income
ones = rep(1, length(y))
plot(y~x)
tau_grid = seq(from=.1, to=.9, by =.1)

for (i in 1:length(tau_grid)){
  foo = rq(y~x, tau = tau_grid[i])
  a = foo$coef[1]
  b = foo$coef[2]
  abline(a,b, col='red', lty='dotted')
  
  foo = conquer(as.matrix(x), y, tau = tau_grid[i])$coef
  z = y - cbind(rep(1,length(y)),x)%*%foo
  iqr_z = quantile(z, .75) - quantile(z, .25)

  sigma_z = min(sd(z), iqr_z/1.34898)
  h = 1.06*sigma_z/length(y)^(1/5)
  
foo = conquer(as.matrix(x), y, tau = tau_grid[i], h=h)
a = foo$coef[1]
b = foo$coef[2]
abline(a,b, col = 'blue')
}




tau_grid = seq(from=.01, to=.99, by =.01)

betarq = numeric()
betaconq = numeric()
betaconqtmp = matrix(0,length(tau_grid),2)

for (i in 1:length(tau_grid)){
betarq[i] = rq(y~x, tau = tau_grid[i])$coef[2]

betaconqtmp[i,] = conquer(as.matrix(x), y, tau = tau_grid[i])$coef # estimate the parameter vector via standard QR
z = y - cbind(rep(1,length(y)),x)%*%betaconqtmp[i,]
iqr_z = quantile(z, .75) - quantile(z, .25)

sigma_z = min(sd(z), iqr_z/1.34898)
h = 1.06*sigma_z/length(y)^(1/5)
  
betaconq[i] = conquer(as.matrix(x), y, tau = tau_grid[i], h=h)$coef[2]
}

plot(tau_grid, betarq, type='l')
lines(tau_grid, betaconqtmp[,2], col='red')
lines(tau_grid, betaconq, col='blue')

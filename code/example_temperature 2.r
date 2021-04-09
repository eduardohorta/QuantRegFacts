library(quantreg)
#require(splines)
require(hdrcde)
source('sqr_function.r')

x <- maxtemp[-3650]
y <- maxtemp[-1]

plot.ts(maxtemp)
s <- (x<40)  #Delete a few (influential, ridiculously hot) days
x <- x[s]
y <- y[s]

idx = sort.int(x, index.return = TRUE)$ix
x = x[idx]
y = y[idx]

x1 = x
x2 = x^2
x3 = x^3
x4 = x^4

plot(y~x, pch = 16, col=rgb(0,0,0,.2), cex=.5, xlab = "yesterday's max temperature", ylab = "today's max temperature")
abline(lm(y~x), lwd=2)

tau_grid = seq(from=.1, to=.9, by =.1)
for (i in 1:length(tau_grid)){
  foo = rq(y~x1+x2+x3+x4, tau = tau_grid[i])
  lines(x, foo$fitted.values, col='red')
  
  foo = sqr(x = cbind(rep(1,length(x)), x1, x2, x3, x4), y = y, tau = tau_grid[i], h = 'rule-of-thumb', initial_value = foo$coef)
  sqr_fitted = foo[1] + foo[2]*x1 + foo[3]*x2 + foo[4]*x3 + foo[5]*x4
  lines(x, sqr_fitted, col='blue')
  
}


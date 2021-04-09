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

plot(y~x, pch = 16, col=rgb(0,0,0,.2), cex=.5, xlab = "yesterday's max temperature", ylab = "today's max temperature", ylim=c(0,20),xlim=c(6,10))
abline(lm(y~x), lwd=2)

# tau_grid = seq(from=.1, to=.9, by =.1)
tau_grid = c(.01,.5,.99)
for (i in 1:length(tau_grid)){
  foo = rq(y~x1+x2+x3+x4, tau = tau_grid[i])
  lines(x, foo$fitted.values, col='red')
  
  foo1 = sqr(x = cbind(rep(1,length(x)), x1, x2, x3, x4), y = y, tau = tau_grid[i], h = 'rule-of-thumb', initial_value = foo$coef)
  sqr_fitted = foo1[1] + foo1[2]*x1 + foo1[3]*x2 + foo1[4]*x3 + foo1[5]*x4
  lines(x, sqr_fitted, col='blue')
  
  foo2 = sqr_2(x = cbind(rep(1,length(x)), x1, x2, x3, x4), y = y, tau = tau_grid[i], h = 'rule-of-thumb', initial_value = foo$coef)
  sqr_fitted2 = foo2[1] + foo2[2]*x1 + foo2[3]*x2 + foo2[4]*x3 + foo2[5]*x4
  lines(x, sqr_fitted2, col='green')
  
}


round(cbind(foo$coef,foo1,foo2), digits = 8)


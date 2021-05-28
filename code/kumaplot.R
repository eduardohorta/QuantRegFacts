kumaplot = function(a,b){
 tau = seq(from=.01, to=.99, by=.01)
 feval = a*b*tau^(a-1)*(1-tau^a)^(b-1)
 plot(tau, feval)
}
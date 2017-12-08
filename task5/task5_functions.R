
normalSamplingX = function(mu, sigma){
  return (rnorm(1, mu, sigma))
}

update_x = function(sigma2, phi){
  x = array(0,T+1)
  x[1] =  rnorm(1, 0, sqrt(sigma2/(1-phi^2)))
  
  # for (t in 2:(T+1)){
  #   x[t] = rnorm(1, phi*x[t-1], sqrt(sigma2))
  # }
  
  x[2:(T+1)] = sapply(phi*x[1:T], normalSampligX, sqrt(sigma2))
  
  return (x)
}

update_sigma2 = function(x, phi){
  a = 0.01
  b = 0.01
  
  # temp = 0
  # for (t in 2:(T+1))
  #   temp = temp + (x[t] - phi*x[t-1])^2
  
  temp = sum((x[2:(T+1)]-phi*x[1:T])^2)
  
  return (rigamma(1, a+T/2, b+temp/2))
}

update_beta2 = function(x, y){
  a = 0.01
  b = 0.01
  
  x = x[-1]
  # temp = 0
  # for (t in 1:T)
  #   temp = temp + exp(-x[t])*y[t]^2
  
  temp = sum(exp(-x)*(y^2))
  
  return (rigamma(1, a+T/2, b+temp/2))
}
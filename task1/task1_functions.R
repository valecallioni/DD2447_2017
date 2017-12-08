normalSamplingX = function(mu, sigma){
  return (rnorm(1, mu, sigma))
}

estimateLikelihood = function(beta, y){
  
  # set.seed(12254)
  
  T = dim(y)[1]
  N = 1000
  phi = 0.98
  sigma = 0.16
  l = 0 
  
  # At each time t, we sample N samples, and therefore we have N weights 
  x = array(0,c(T,N))
  w = array(0,c(T,N))
  
  # Time t = 1, thanks to the stationarity setting
  x0 = rnorm(N, 0, sqrt(sigma^2/(1-phi^2)))
  
  # Sampling N times, looking at x0 values
  x[1,] = sapply(phi*x0, normalSamplingX, sigma=sigma)
  
  # Supposing to have y vector of length T, the data, the weight is given by 
  # the probability of each datapoint given the sample
  w[1,] = dnorm(y[1,1], 0, sqrt((beta^2)*exp(x[1,]))) 
  l = l + log(sum(w[1,])) - log(N)
  
  # At each time, first sample N points, then compute the weights, that give
  # us the estimate of the target probability distribution
  for (t in 2:T){
    x[t,] = sapply(phi*x[t-1,], normalSamplingX, sigma = sigma)
    w[t,] = dnorm(y[t,1], 0, sqrt((beta^2)*exp(x[t,])))
    l = l + log(sum(w[t,])) - log(N)
  }
  
  return(l)
  
}

generateU = function(v, u1, N){
  return (u1+(v-1)/N)
}

estimateLikelihoodResampl = function(beta, y){
  
  # set.seed(12254)
  
  T = dim(y)[1]
  N = 1000
  phi = 0.98
  sigma = 0.16
  l = 0
  
  # At each time t, we sample N samples, and therefore we have N weights 
  x = array(0,c(T,N))
  w = array(0,c(T,N))
  W = array(0,c(T,N))
  offspring = array(0,c(T,N))
  
  u = array(0,N)
  u[1] = runif(1, 0, 1/N)
  u[2:N] = sapply(2:N, generateU, u1=u[1], N=N)
  
  # Time t = 1
  x0 = rnorm(N, 0, sqrt(sigma^2/(1-phi^2)))
  
  # Supposing to have y vector of length T, the data, the weight is given by 
  # the probability of that datapoint given the sample
  x[1,] = sapply(phi*x0, normalSamplingX, sigma=sigma)
  
  w[1,] = dnorm(y[1,1], 0, sqrt((beta^2)*exp(x[1,]))) 
  
  # Normalize the weights
  W[1,] = w[1,]/sum(w[1,])
  
  for (i in 1:N){
    lower = sum(W[1,1:(i-1)])
    upper = sum(W[1,1:i])
    count = length(which(u>=lower & u<=upper))
    offspring[1,i] = count
  }
  
  l = l + log(sum(offspring[1,])/N)
  
  for (t in 2:T){
    
    x[t,] = sapply(phi*x[t-1,], normalSamplingX, sigma = sigma)
    w[t,] = dnorm(y[t,1], 0, sqrt((beta^2)*exp(x[t,])))
    W[t,] = w[t,]/sum(w[t,])
    
    # Resampling step
    for (i in 1:N){
      lower = sum(W[t,1:(i-1)])
      upper = sum(W[t,1:i])
      count = length(which(u>=lower & u<=upper))
      offspring[t,i] = count
    }
    
    l = l + log(sum(offspring[t,])/N) 
  }
  
  return(l)
  
}
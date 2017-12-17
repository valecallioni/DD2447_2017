normalSamplingX = function(mu, sigma){
  return (rnorm(1, mu, sigma))
}

estimateLikelihood = function(beta, y){
  
  T = 100
  N = 1000
  phi = 0.951934
  sigma = 0.164643756
  l = 0 
  
  # Time t = 1, thanks to the stationarity setting
  x0 = rnorm(N, 0, sqrt(sigma^2/(1-phi^2)))
  
  # Sampling N times, looking at x0 values
  x_old = sapply(phi*x0, normalSamplingX, sigma=sigma)
  x_new = x_old
  
  p1 = sum(mapply(dnorm, x_old, phi*x0, sd=sqrt((sigma^2/(1-phi^2)))) * dnorm(x0,  0, sqrt(sigma^2/(1-phi^2))))
  alpha = dnorm(y[1,1], 0, sqrt((beta^2)*exp(x_old))) * p1
  w = alpha
  W = w/sum(w)
  
  l = l + log(sum(w))
  
  # At each time, first sample N points, then compute the weights, that give
  # us the estimate of the target probability distribution
  for (t in 2:T){
    x_new = sum(sapply(phi*x_old, normalSamplingX, sigma = sigma))

    alpha = dnorm(y[t,1], 0, sqrt((beta^2)*exp(x_new)))
    
    l = l + log(sum(W*alpha))
    w = w * alpha
    W = w/sum(w)
    
    x_old = x_new
  }
  
  return(l)
  
}

generateU = function(v, u1, N){
  return (u1+(v-1)/N)
}

estimateLikelihoodResampl = function(beta, y){
  
  T = 100
  N = 1000
  phi = 0.951934
  sigma = 0.164643756
  l = 0
  
  u = array(0,N)
  u[1] = runif(1, 0, 1/N)
  u[2:N] = sapply(2:N, generateU, u1=u[1], N=N)
  
  # Time t = 1
  x0 = rnorm(N, 0, sqrt(sigma^2/(1-phi^2)))
  
  # Sampling N times, looking at x0 values
  x_old = sapply(phi*x0, normalSamplingX, sigma=sigma)
  
  p1 = sum(mapply(dnorm, x_old, phi*x0, sd=sqrt((sigma^2/(1-phi^2)))) * dnorm(x0,  0, sqrt(sigma^2/(1-phi^2))))
  alpha = dnorm(y[1,1], 0, sqrt((beta^2)*exp(x_old))) * p1
  w = alpha
  W = w/sum(w)
  
  offspring = array(0,length(w))
  x_new = NULL
  for (i in 1:N){
    if (i==1)
      lower = 0
    else 
      lower = sum(W[1:(i-1)])
    upper = sum(W[1:i])
    count = length(which(u>=lower & u<=upper))
    offspring[i] = count
    if (count > 0){
      x_new = c(x_new, rep(x_old[i], offspring[i])) 
    }
  }
  
  if (!is.null(x_new)){
    
    alpha = dnorm(y[1,1], 0, sqrt((beta^2)*exp(x_new)))
    l = l + log(sum((1/N)*alpha))
  
  }
  
  for (t in 2:T){
    
    x_old = sapply(phi*x_new, normalSamplingX, sigma = sigma)
    
    alpha = dnorm(y[t,1], 0, sqrt((beta^2)*exp(x_old)))
    w = w * alpha
    W = w/sum(w)
    
    u = array(0,N)
    u[1] = runif(1, 0, 1/N)
    u[2:N] = sapply(2:N, generateU, u1=u[1], N=N)
    
    # Resampling step
    x_new = NULL
    offspring = array(0,length(w))
    for (i in 1:length(offspring)){
      if (i==1)
        lower = 0
      else 
        lower = sum(W[1:(i-1)])
      upper = sum(W[1:i])
      count = length(which(u>=lower & u<=upper))
      offspring[i] = count
      if (count > 0){
        x_new = c(x_new, rep(x_old[i], offspring[i])) 
      }
    }
    
    if (is.null(x_new)){
      break
    }
    
    alpha = dnorm(y[t,1], 0, sqrt((beta^2)*exp(x_new)))
    l = l + log(sum((1/N)*alpha))

  }
  
  return(l)
  
}
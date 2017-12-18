####################################################################
#         2.5 Stochastic volatility unknown parameter              #
####################################################################
setwd("C:/Users/Vale/Dropbox/Poli/Erasmus/KTH/Statitical Methods for Applied Computer Science/DD2447_2017/task5")
source("task5_functions.R")

library(invgamma)
library(pscl)
library(ggplot2)

# Question 11
#-------------------------------------------------------------------
T = 500
N = 10000
phi = 0.951934

X = NULL        # will have dimension TXN
sigma2 = NULL   # will have dimension 1xN
beta2 = NULL    # will have dimension 1xN

y = read.table("output.txt")

# Initialization of sigma2 and X
sigma0 = 0.164643756
x = array(0,T+1)
x[1] =  rnorm(1, 0, sqrt(sigma0/(1-phi^2)))
for (t in 2:(T+1))
  x[t] = rnorm(1, phi*x[t-1], sqrt(sigma0))

# Gibbs sampling
for (i in 1:N){
  sigma = update_sigma2(x, phi, T)
  sigma2 = c(sigma2, sigma)
  x = update_x(sigma, phi, T)
  X = rbind(X, x)
  beta = update_beta2(x, y[,1], T)
  beta2 = c(beta2, beta)
}

# x11()
# plot(1:N, sigma2, main="Sigma2 estimates", type="l")
# 
# x11()
# plot(1:N, beta2, main="Beta2 estimates", type="l")

x11()
qplot(sigma2, geom="histogram", fill=I("blue"), col=I("grey"), main="Marginal distribution for Sigma") 

x11()
qplot(beta2, geom="histogram", fill=I("blue"), col=I("grey"), main="Marginal distribution for Beta") 

# Question 12
#-------------------------------------------------------------------
T = 500
N = 10000
phi = 0.951934


x = array(0,c(T+1,N))
sigma2 = array(0,c(T,N))
beta2 = array(0,c(T,N))

y = read.table("output.txt")

# Initialization of sigma2 and X
sigma0 = 0.164643756
x0 = array(0,N)
x0 = sapply(sqrt(sigma0/1-phi^2), normalSamplingX, mu = 0)
x[1, ] = mapply(normalSamplingX, phi*x0, sigma0)


# Sequential sampling
for (t in 1:(T+1)){
  x[t+1,] = mapply(normalSamplingX, phi*x[t-1], sigma2[t])
  temp1 = array(0,N)
  temp2 = array(0,N)
  for (i in 1:N){
    temp1[i] = sum((x[2:(t+1),i]-phi*x[1:t,i])^2)
    temp2[i] = sum(exp(-x[t+1,i])*y[t,1]^2)
  }
  if (t<=T){
    sigma2[t,] = sapply(b+0.5*temp1, samplingIG, a=a+t/2)
    beta2[t,] = sapply(b+0.5*temp2, samplingIG, a=a+t/2)
  }
}

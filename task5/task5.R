####################################################################
#         2.5 Stochastic volatility unknown parameter              #
####################################################################
source("task5_functions.R")

# Question 11
#-------------------------------------------------------------------
T = 500
N = 1e5
phi = 0.98
a = 0.01
b = 0.01

X = NULL        # will have dimension TXN
sigma2 = NULL   # will have dimension 1xN
beta2 = NULL    # will have dimension 1xN

y = read.table("output.txt")

# Initialization of sigma2 and X
sigma0 = rigamma(1, a, b)
x = array(0,T+1)
x[1] =  rnorm(1, 0, sqrt(sigma0/(1-phi^2)))
x[2:(T+1)] = sapply(phi*x[1:T], normalSamplingX, sigma = sqrt(sigma0))
# for (t in 2:(T+1)){
#   x[t] = rnorm(1, phi*x[t-1], sqrt(sigma0))
# }

# Gibbs sampling
for (i in 1:N){
  sigma = update_sigma2(x, phi)
  sigma2 = c(sigma2, sigma)
  x = update_x(sigma, phi)
  X = rbind(X, x)
  beta = update_beta2(x, y)
  beta2 = c(beta2, beta)
}

x11()
plot(1:N, sigma2, main="Sigma2 estimates")

x11()
plot(1:N, beta2, main="Beta2 estimates")



# Question 12
#-------------------------------------------------------------------
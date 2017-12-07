####################################################################
#         2.1 SMC for the stochastic volatility model              #
####################################################################
source("task1_functions.R")

# Question 1
#-------------------------------------------------------------------

y = read.table("output.txt")

beta = seq(0, 2, length.out = 20)
likelihood = NULL
for (k in 1:10){
  l = NULL
  l = sapply(beta, estimateLikelihood, y=y)
  likelihood = rbind(likelihood, l)
}

x11()
boxplot.matrix(likelihood, xlab = "Beta values", ylab = "Log-likelihood", main = "SMC without resampling", names = round(beta, digit=2))



# Question 2
#-------------------------------------------------------------------

y = read.table("output.txt")

beta = seq(0, 2, length.out = 20)
likelihood = NULL
for (k in 1:10){
  l = NULL
  l = sapply(beta, estimateLikelihoodResampl, y=y)
  likelihood = rbind(likelihood, l)
}

x11()
boxplot.matrix(likelihood, xlab = "Beta values", ylab = "Log-likelihood", main = "SMC with resampling", names = round(beta, digit=2))



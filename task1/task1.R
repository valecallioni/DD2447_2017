####################################################################
#         2.1 SMC for the stochastic volatility model              #
####################################################################
setwd("C:/Users/Vale/Dropbox/Poli/Erasmus/KTH/Statitical Methods for Applied Computer Science/DD2447_2017/task1")
source("task1_functions.R")

# Question 1
#-------------------------------------------------------------------

y = read.table("output.txt")

beta = seq(0.001, 0.5, length.out = 20)
likelihood = NULL
for (k in 1:10){
  l = NULL
  l = sapply(beta, estimateLikelihood, y=y)
  likelihood = rbind(likelihood, l)
}

x11()
boxplot.matrix(likelihood, xlab = "Beta values", ylab = "Log-likelihood", main = "SMC without resampling", names = round(beta, digit=2), ylim=c(-200, 250))



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



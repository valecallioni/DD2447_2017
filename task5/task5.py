from math import sqrt,exp
from numpy.random import normal,beta
from scipy.stats import invgamma
from numpy.random import seed
import numpy as np

def update_x(sigma2, phi, T):
    x = np.zeros(T+1)
    x[0] = np.random.normal(0, math.sqrt(sigma2/(1-math.pow(phi,2))), 1)
    for t in range(1,T+1):
        x[t] = np.random.normal(phi*x[t-1], math.sqrt(sigma2), 1)
    return x

def update_sigma2(x, phi, T):
    a = 0.01
    b = 0.01
    temp = 0
    for t in range(1,T+1):
        temp = temp + math.pow((x[t] - phi*x[t-1]),2)
    return (rinvgamma(1, shape=a+T/2, scale=b+temp/2))

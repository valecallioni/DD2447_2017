import matplotlib.pyplot as plt
from graph import *
from train import *
from mcmc import *
from gibbs import *

train = Train()

print("Tracks:")
print(train.graph.G)

print("Observations:")
print(train.O)

print("True path:")
print(train.path)

original_settings = train.graph.alphas


# Metropolis Hastings:

setting_probs, ml_settings = metropolis_hastings(1000, train)

print("True switch settings:")
print(original_settings)
print("Most likely switch settings according to Metropolis Hastings:")
print(ml_settings)

print("MCMC samples:", len(setting_probs))
plt.plot(setting_probs)
plt.title("Metropolis-Hastings MCMC sampling")
plt.ylabel("Probability")
plt.xlabel("Sample")
plt.show()


# Gibbs sampling:
train.graph.setAlphas(original_settings)
settings_prob_gibbs, ml_gibbs = GibbsSampling(1000, train)

print("True switch settings:")
print(original_settings)
print("Most likely switch settings according to Gibbs sampling:")
print(ml_gibbs)

print("Gibbs samples:", len(settings_prob_gibbs))
plt.plot(settings_prob_gibbs)
plt.title("Gibbs sampling MCMC sampling")
plt.ylabel("Probability")
plt.xlabel("Sample")
plt.show()

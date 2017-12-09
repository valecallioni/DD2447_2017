import matplotlib.pyplot as plt
from mcmc import *
from graph import *
from train import *

train = Train()

print("Tracks:")
print(train.graph.G)

print("Observations:")
print(train.O)

print("True path:")
print(train.path)

original_settings = train.graph.alphas

setting_probs, most_likely_settings = metropolis_hastings(1000, train)

print("True switch settings:")
print(original_settings)
print("Most likely switch settings:")
print(most_likely_settings)

print("MCMC samples:", len(setting_probs))
plt.plot(setting_probs)
plt.title("Metropolis-Hastings MCMC sampling")
plt.ylabel("Probability")
plt.xlabel("Sample")
plt.show()

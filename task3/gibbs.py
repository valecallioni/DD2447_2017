import numpy as np
import collections

# To perform Gibbs sampling, at each iteration we have to sample
# just one component of the switche settings
# With probability 0.5 alpha(v_i) remains the same,
# With probability 0.5 alpha(v_i) changes
def getSampleSwitchComponent(oldAlphas, i):
    newAlphas = oldAlphas.copy()
    r = np.random.randint(0, 2)  # r can be either 0 or 1
    if r == 1:
        if newAlphas[i] == 2:
            newAlphas[i] = 1
        else:
            newAlphas[i] = 2
    return newAlphas

def GibbsSampling(num_samples, train):
    burn_in = int(num_samples / 2)  # Number of samples to discard
    N = num_samples + burn_in       # Number of samples to be considered

    # Initialization
    alphas = train.graph.alphas
    alphas_p = train.computeProbObs()
    samplesSS = list()              # Sampled switch settings
    probabilitiesSS = list()        # Probabilities associated to the sampled switch settings

    print("Start switch settings probability:", alphas_p)

    for i in range(N):
        # Sample one switch component at a time
        for j in range(train.V):
            alphas = getSampleSwitchComponent(alphas, j)
            train.graph.setAlphas(alphas)
            alphas_p = train.computeProbObs()
            samplesSS.append(alphas)
            probabilitiesSS.append(alphas_p)

    # Find the most likely switch settings according to the probabilities observed
    temp = [tuple(lst) for lst in samplesSS]
    counter = collections.Counter(temp)
    most_likely = counter.most_common(1)[0]
    most_likely = list(most_likely[0])

    return probabilitiesSS, most_likely

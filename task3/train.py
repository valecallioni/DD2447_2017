import numpy as np
from graph import *

class Train:
    graph = Graph()
    D = graph.degree
    V = graph.V
    T = 5                   # Number of observations, the given data
    O = list()              # Observations
    path = list()           # Path corresponding to the true observations
    p = 0.05                # Probability associated with noise

    def __init__(self):
        O, path = self.generateObservationsPath()

    def generateObservationsPath(self):
        observations = list()
        path = list()

        # First random observation
        o = np.random.randint(0, self.D)
        observations.append(o)

        # First random vertex and edge feasible with first observation
        current_v = np.random.randint(0, self.V)
        for i in range(self.V):
            if i != current_v and self.graph.G[current_v, i] == o:
                path.append((current_v, i))
                current_v = i

        # Generate path
        for i in range(1, T):
            if o == 0:
                # Then the train can exit either through L or through R
                o = np.random.randint(1, self.D)
                for j in range(self.V):
                    # Make sure not going back and find the edge
                    if j != current_v and self.graph.G[current_v, j] == o:
                        observations.append(o)
                        previous_v = current_v
                        current_v = j
                        path.append((previous_v, current_v))
                        break
            elif o == 1 or o ==2:
                # Then the train has to exit through 0
                o = 0
                for j in range(self.V):
                    if j != current_v and self.graph.G[current_v, j] == o:
                        observations.append(o)
                        previous_v = current_v
                        current_v = j
                        path.append((previous_v, current_v))
                        break

        # Add some noise
        for i in range(self.T):
            r = np.random.randint(1, 101)
            if r < self.p * 100:
                observations[r] = np.random.randint(0, self.D)

        return observations, path

    # Probability of going from some position s' to s=(v,e) (i.e., the train
    # has passed v exiting through e) in t steps and observing observations O
    # e = tuple, e[0] = v
    # f = (u,v)
    # g = (w,v)
    def c(self, s, t):
        v = s[0]
        e = s[1]
        u = v
        w = v

        if (t == 0):
            return 1./float(self.V)

        else:
            # Look for the label of e in graph.G
            # Look for the switch of v in graph.alphas
            # Look for the neighbors of v and for the connecting edges
            switch = self.graph.alphas[v]
            for i in range(self.V):
                for j in range(self.V):
                    if i==v and j==e[1]: # e found
                        label_e = self.graph.G[i,j]
                    elif i==v and j!=e[1] and self.graph.A[i,j] == 1 and u == v: # first neighbor foung
                        u = j
                        f = (u,v)
                        label_f = self.graph.G[u,v]
                    elif i==v and j!=e[1] and self.graph.A[i,j] == 1 and u!=v: # second neighbor foung
                        w = j
                        g = (w,v)
                        label_g = self.graph.G[w,v]

            if label_e==0 and self.O[t]==0:
                return (self.c((u,f), t-1) + self.c((w,g), t-1))*(1-self.p)
            elif label_e==0 and self.O[t]!=0:
                return (self.c((u,f), t-1) + self.c((w,g), t-1))*self.p

            elif label_e==1 and switch==1 and O[t]==1 and (label_f==0 || label_g==0):
                if label_f==0:
                    return (self.c((u,f), t-1))*(1-self.p)
                else
                    return (self.c((w,g), t-1))*(1-self.p)
            elif label_e==1 and switch==1 and O[t]!=1 and (label_f==0 || label_g==0):
                if label_f==0:
                    return (self.c((u,f), t-1))*self.p
                else
                    return (self.c((w,g), t-1))*self.p

            elif label_e==2 and switch==2 and O[t]==2 and (label_f==0 || label_g==0):
                if label_f==0:
                    return (self.c((u,f), t-1))*(1-self.p)
                else
                    return (self.c((w,g), t-1))*(1-self.p)
            elif label_e==2 and switch==2 and O[t]!=2 and (label_f==0 || label_g==0):
                if label_f==0:
                    return (self.c((u,f), t-1))*self.p
                else
                    return (self.c((w,g), t-1))*self.p

            elif label_e==1 and switch==2:
                return 0.0

            elif label_e==2 and switch==1:
                return 0.0
        return 0.0

    def computeProbObs(self):
        sum_prob = 0.0
        #probabilities = list()

        last = 0
        # for every node, compute the probability of passing that node through
        # each exiting edge
        for v in range(self.V):
            prob = 0.0
            for w in range(self.V):
                if self.graph.G[v, w] != 3 and w != v:
                    # first exiting edge found
                    e = (v, w)
                    last = w
                    break
            prob = self.c((v, e), self.T)
            #probabilities.append(prob)
            sum_prob = sum_prob + prob

            for w in range(last + 1, self.V):
                if self.graph.G[v, w] != 3 and w != v:
                    # second exiting edge found
                    e = (v, w)
                    last = w
                    break
            prob = self.c((v, e), self.T)
            #probabilities.append(prob)
            sum_prob = sum_prob + prob

            for w in range(last + 1, self.V):
                if self.graph.G[v, w] != 3 and w != v:
                    # third exiting edge found
                    e = (v, w)
                    break
            prob = self.c((v, e), self.T)
            #probabilities.append(prob)
            sum_prob = sum_prob + prob

        #highest_prob = max(probabilities)

    return sum_prob

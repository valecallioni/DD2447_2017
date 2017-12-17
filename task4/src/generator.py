
import numpy as np

"""
This script generates N sequences of length M over the alphabet, each containing a magic word of length W
"""

def sample(alphabet, categorical):
    """
    :param alphabet: the alphabet of the sequences
    :param categorical: parameter of the categorical distribution
    :return: a sample from the given categorical distribution
    """
    return alphabet[np.argmax(np.random.multinomial(1,categorical))]

def generate_sequences(alphabet = ['A', 'B', 'C','D'], alpha = [1,1,1,1], alpha_prime = [1,1,1,1], N = 5, M = 10, W = 5):
    """
    :return: a list of sequences and a list of starting positions
    """
    #background
    theta_back = np.random.dirichlet(alpha_prime)
    sequences = [[sample(alphabet, theta_back) for j in range(M)]for i in range(N)]

    #magic-word
    thetas_magic = np.random.dirichlet(alpha, W)
    positions = [np.random.randint(0, M-W+1) for i in range(N)]
    sequences = [[sample(alphabet, thetas_magic[x-pos]) if x >= pos and x < pos+W else seq[x] for x in range(len(seq))] for seq, pos in zip(sequences, positions)]

    return sequences, positions


if __name__ == "__main__":
    categorical = np.ones(4)*1/4
    alphabet = ['A', 'C', 'G', 'T']
    alpha_prime = [1,1,1,1]
    alpha = [12,7,3,1]
    sequences, positions = generate_sequences(alphabet,alpha, alpha_prime)
    for s in sequences :
        for c in s  :
            print(c + ' & ', end='')
        print("\\\\")
    print("sequences", sequences)
    print("positions", positions)

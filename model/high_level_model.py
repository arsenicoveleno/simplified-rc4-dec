import os

MOD = 256
KEY_LENGHT = 32

# KEY SCHEDULING ALGORITHM
def ksa(key):

    # Creazione array
    S = list(range(MOD))
    j = 0
    for i in range(MOD):
        j = (j + S[i] + ord(key[i % KEY_LENGHT])) % MOD
        # Swap
        S[i], S[j] = S[j], S[i]

    return S

# PSEUDO-RANDOM GENERATOR ALGORITHM and ENCRYPTION
def prga(S, plaintext):
    
    # Plaintext
    P = [ord(p) for p in plaintext]
    # Ciphertext
    C = []

    i = 0
    j = 0
    for l in range(0, len(P)):
        i = (i+1) % MOD
        j = (j+ S[i]) % MOD
        # Swap
        S[i], S[j] = S[j], S[i]

        K = S[(S[i]+S[j]) % MOD]
        C.append(P[l] ^ K)

    return C, P

if __name__ == "__main__":
    path = "../modelsim/tv/"

    # Test Plaintext -> Ciphertext

    keys = [
        "chiavediprovaalgoritmorc4ksaprga",
        "chiavediprovaalgoritmorc4ksaprag",
        "chiavediprovaalgoritmorc4ksarpga",
        "chiavediprovaalgoritmorc4ksapgra"    
    ]

    plaintexts = [
        "Lorem ipsum dolor sit amet",
        "consectetur adipiscing elit",
        "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
        "Ut enim ad minim veniam"
    ]

    
    i = 0
    for key,plaintext in zip(keys,plaintexts): 
        # Registrazione chiave
        with open(path + f"key{i}.txt", 'w') as f:
            f.write('\n'.join(['{0:08b}'.format(ord(c)) for c in key]))

        # RC4
        S = ksa(key)
        C, P = prga(S,plaintext)

        # Registrazione ciphertext
        with open(path + f"cipher{i}.txt", 'w') as f:
            f.write('\n'.join(['{0:08b}'.format(c) for c in C]))

        # Registrazione plaintext
        with open(path + f"plain{i}.txt", 'w') as f:
            f.write('\n'.join(['{0:08b}'.format(p) for p in P]))
        
        i += 1
    

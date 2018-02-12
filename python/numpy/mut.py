import numpy as np

m1 = np.linspace(1, 10, 10)[:,None]
m2 = np.linspace(1, 5, 5)[None, :]
print(m1, m2)
print(np.multiply(m1, m2))

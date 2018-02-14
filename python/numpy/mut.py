import numpy as np

m1 = np.linspace(1, 4, 4)[:,None]
m2 = np.linspace(1, 2, 2)[None, :]
m3 = np.multiply(m1, m2)
print(m1, m1.shape)
print(m2, m2.shape)
print(m3, m3.shape)

print(m3 + 1)
print(m3 + m1)
print(m3 + m2)
print(m3 + m3)

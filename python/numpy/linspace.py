import numpy as np

a0 = np.linspace(0, 19, 20).reshape((4, 5))
print(a0)
print(a0[1,2])
print(a0[:, 1])
print(a0[0:3, :])
print(a0[2:4, 2:4])

for x in a0.flat:
    print(x, end=' ')
print()

noise = np.random.normal(0, 0.02, (10, 1))
print(noise)
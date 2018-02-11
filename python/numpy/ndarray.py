import numpy as np

# shape
v1 = np.array([1, 2, 3])
v2 = np.array([[1, 2, 3]])
v3 = np.array([[[1, 2, 3]]])
print('v1', v1, 'shape', v1.shape)
print('v2', v2, 'shape', v2.shape)
print('v3', v3, 'shape', v3.shape)

v4 = np.array([[1],[2],[3]])
print('v4', v4, 'shape', v4.shape)

v2 = np.array([[1, 2], [3, 4]])
print(v2, v2.shape)

# zeros & ones
z1 = np.zeros((4, 4))
print(z1)

o1 = np.ones((5, 5))
print(o1)

# arange, linspace logspace
print(np.arange(0 ,10))
print(np.arange(0 ,10, 2))
print(np.linspace(0, 10, 20))
print(np.logspace(0, 10, 10))

# array[beg:end:step]
x = np.arange(16) * 4
print(x[11])
print(x[::3])
print(x[::-3])

# fromstring fromfunction
s1 = '1,2,3,4,5'
print(np.fromstring(s1, sep=','))

def func(i, j):
    return (i + 1) * (j + 1)
print(np.fromfunction(func, (9, 9)))
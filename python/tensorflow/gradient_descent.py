import numpy as np
import matplotlib.pyplot as plt

x = np.arange(-5, 5, 0.001)
y = x ** 4 - 3 * x ** 3 + 2
plt.plot(x, y)
plt.show()

old = 0
new = 5
step = 0.01
precision = 0.00001

def derivative(x):
    return 4 * x ** 3 - 9 * x ** 2

while abs(new - old) > precision:
    old = new
    new = new - step * derivative(new)

print(new)
import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(-1, 1, 1000)
y1 = (x - 1) / (x * x)
y2 = (x*x -1) / (x*x + 1)
y3 = x / ((x * x - 1) * (x * x + 1))

plt.plot(x, y1, 'r-x', label='(x - 1) / (x * x)')
plt.plot(x, y2, 'g-x', label='(x*x -1) / (x*x + 1)')
plt.plot(x, y3, 'b-x', label='x / ((x * x - 1) * (x * x + 1))')
plt.legend()
plt.show()
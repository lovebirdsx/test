import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(-0.1, 0.1, 2000)
y1 = x * np.sin(1/x)
y2 = x * x * np.sin(1/x)

plt.plot(x, y1, label='x * sin(1/x)')
plt.plot(x, y2, label='x * x * sin(1/x)')
plt.legend()
plt.show()
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0, 2 * np.pi, 50)
plt.plot(x, np.sin(x), 'r-x', label='Sin(x)')
plt.plot(x, np.cos(x), 'g-^', label='Cos(x)')
plt.legend()
plt.xlabel('Rads')
plt.ylabel('Amplitude')
plt.title('Sin and Cos Waves')
plt.show()
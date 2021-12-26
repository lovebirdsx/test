import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0 , 2*np.pi, 50)

plt.subplot(2, 1, 1)
plt.plot(x, np.sin(x), 'r')
plt.subplot(2, 1, 2)
plt.plot(x, np.cos(x), 'g')
plt.show()
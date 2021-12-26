import matplotlib.pyplot as plt
import numpy as np

x = np.random.randn(1000)
plt.hist(x, 50)
plt.show()
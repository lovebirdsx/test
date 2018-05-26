# 线性回归

from keras.models import Sequential
from keras.layers import Dense, Activation
from keras.optimizers import SGD
import numpy as np

data = np.random.random((10, 1))
labels = data * 2 + 1

model = Sequential()
layer = Dense(1, input_dim=1)
model.add(layer)
model.compile(optimizer=SGD(lr=0.4), loss='mse')
model.fit(data, labels, epochs=50, batch_size=1, verbose=0)
print(layer.get_weights())
print(model.predict(np.array([1])))
print(model.predict(np.array([2])))
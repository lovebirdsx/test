from keras.models import Sequential
from keras.layers import Dense
from keras.optimizers import SGD

import numpy as np

data = np.random.random((10, 1))
labels = data ** 2 + 1

model = Sequential()
model.add(Dense(1, activation='tanh', input_dim=1))
model.add(Dense(1))
model.compile(optimizer=SGD(lr=0.2), loss='mse')
model.fit(x=data, y=labels, batch_size=1, epochs=200)

print(model.evaluate(x=data, y=labels, batch_size=1))
print(model.predict([1]))
import numpy as np

foo = np.arange(0, 10)
bar = foo[:, np.newaxis]
car = foo[:, np.newaxis, np.newaxis]
print(foo, foo.shape)
print(bar, bar.shape)
print(car, car.shape)

far = foo[np.newaxis, :]
print(far, far.shape)

import tensorflow as tf

v = tf.get_variable('hello', [1,2,3])

W = tf.Variable(tf.random_normal([1]), name='weight')
print(v)
print(W)
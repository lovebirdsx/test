import tensorflow as tf
hello = tf.constant('Hello, TensorFlow!')
sess = tf.Session()
print(sess.run(hello))

a = tf.constant(10)
b = tf.constant(20)
print(sess.run(a + b))

w = tf.constant([[1, 2, 3], [4, 5, 6]])
print(w)

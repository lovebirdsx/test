import tensorflow as tf

a = tf.constant([1,2,3], name='a')
b = tf.constant([4,5,6], name='b')
y = a + b

init = tf.global_variables_initializer()

with tf.Session() as sess:
    sess.run(init)
    output = sess.run(y)
    print('output', output)
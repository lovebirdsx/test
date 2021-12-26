import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt

# Gen 200 random points by numpy
x_data = np.linspace(-0.5, 0.5, 200)[:, np.newaxis]
noise = np.random.normal(0, 0.02, x_data.shape)
y_data = np.square(x_data) + noise

# Dim 2 placeholder
x = tf.placeholder(tf.float32, [None, 1], name='x')
y = tf.placeholder(tf.float32, [None, 1], name='y')

# Dim middle layer of neural network
Weights_L1 = tf.Variable(tf.random_normal([1, 10]), name='Weights_L1')
biases_L1 = tf.Variable(tf.zeros([1, 10]), name='biases_L1')
Wx_plus_b_L1 = tf.matmul(x, Weights_L1) + biases_L1
L1 = tf.nn.tanh(Wx_plus_b_L1, name='L1')

# Dim output layer of neural network
Weights_L2 = tf.Variable(tf.random_normal([10, 1]), name='Weights_L2')
biases_L2 = tf.Variable(tf.zeros([1, 1]), name='biases_L2')
Wx_plus_b_L2 = tf.matmul(L1, Weights_L2) + biases_L2
prediction = tf.nn.tanh(Wx_plus_b_L2, name='prediction')

# x             Tensor("Placeholder:0", shape=(?, 1), dtype=float32)
# y             Tensor("Placeholder_1:0", shape=(?, 1), dtype=float32)
# Weights_L1    <tf.Variable 'Variable:0' shape=(1, 10) dtype=float32_ref>
# biases_L1     <tf.Variable 'Variable_1:0' shape=(1, 10) dtype=float32_ref>
# Wx_plus_b_L1  Tensor("add:0", shape=(?, 10), dtype=float32)
# L1            Tensor("Tanh:0", shape=(?, 10), dtype=float32)
# Weights_L2    <tf.Variable 'Variable_2:0' shape=(10, 1) dtype=float32_ref>
# biases_L2     <tf.Variable 'Variable_3:0' shape=(1, 1) dtype=float32_ref>
# Wx_plus_b_L2  Tensor("add_1:0", shape=(?, 1), dtype=float32)
# prediction    Tensor("Tanh_1:0", shape=(?, 1), dtype=float32)

# Loss function
loss = tf.reduce_mean(tf.square(y - prediction), name='loss')

# Train function
train_step = tf.train.GradientDescentOptimizer(0.1).minimize(loss)

with tf.Session() as sess:
    # Init
    summaryMerged = tf.summary.merge_all()
    writer = tf.summary.FileWriter('./summary_log/nonlinear', sess.graph)

    sess.run(tf.global_variables_initializer())
    for i in range(2000):
        error,_,sumOut = sess.run(train_step, feed_dict={x:x_data, y:y_data})
        writer.add_summary(sumOut, i)

    # Get prediction value
    prediction_value = sess.run(prediction, feed_dict={x:x_data})

    # Draw output
    plt.figure()
    plt.scatter(x_data, y_data)
    plt.plot(x_data, prediction_value, 'r-', lw=5)
    plt.show()
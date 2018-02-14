# 求解方程组: x**3 - 3*x + 1 = 0

def iter(x):
    return 1 / (3 - x*x)

def cal_result():
    x = 1
    for _ in range(20):
        x = iter(x)
    return x

x = cal_result()
print(x)
print(x ** 3 - 3 * x + 1)

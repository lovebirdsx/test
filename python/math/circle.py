from math import sqrt

p4 = 4 * sqrt(2-sqrt(2+sqrt(2)))
p8 = 8 * sqrt(2-sqrt(2+sqrt(2+sqrt(2))))
p16 = 16 * sqrt(2-sqrt(2+sqrt(2+sqrt(2+sqrt(2)))))
print(p4*2, p8*2, p16*2)

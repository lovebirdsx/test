#coding=utf8

a, b, c = 'good', 'bad', 'ugly'
print a
print b
print c

text = ['hello', 'world', 'lovebird']
if 'lovebird' in text:
    print text

for x in text:
    print x

i = 1
while i < 5:
    print i
    i = i + 1

for i in range(10):
    if i % 2 == 0:
        continue
    print i
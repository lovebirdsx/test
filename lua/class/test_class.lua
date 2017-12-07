local Foo = require('class.foo')
local Bar = require('class.bar')

f = Foo('lovebird')
f.foo()
f.hello()

b = Bar('bar')
b:output()


local function Foo(name)
local I = {}


name = name or 'hello'

function I.foo()
    return name
end

function I.hello()
    print(name)
end

return I
end

return Foo
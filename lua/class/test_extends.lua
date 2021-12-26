local class = require('class')

---@class Base
local Base = class(function (self, count)
    self:_init(count)
end)

function Base:_init(count)
    self.count = count
end

function Base:get_total()
    return self.count + self:get_count2()
end

function Base:get_count2()
    return 0
end

---@class Child :Base
local Child = class(Base, function (self, count)
    self:_init(count)
end)

function Child:_init(count)
    Base._init(self, count)
end

function Child:get_count2()
    return 3
end

local b = Base(2)
local c = Child(3)

print(b.count, b:get_total())
print(c.count, c:get_total())
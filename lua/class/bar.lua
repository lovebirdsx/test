require('class')

---@class Bar
local Bar = class(function (self, name)
    self:init(name)
end)

function Bar:init(name)
    self.bar = name or 'Hello world'
end

function Bar:output()
    print(self.bar)
end

function Bar:output2()
    print(self.bar)
end

return Bar

local test = {}

function test.index()
    local t = {foo = 'foo'}
    local m = {__index = {bar = 'fuck'}}
    setmetatable(t, m)
    print(t.foo, t.bar)
end

function test.index_by_fun()
    local t = {foo = 'foo1'}
    local m = {__index = function (t, key)
        return key
    end}
    setmetatable(t, m)
    print(t.foo, t.bar, t.car)
end

local function run_all_test()
    for name, fun in pairs(test) do
        print('test', name)
        fun()
    end
end

run_all_test()
--[[
local function foo(a, b)
    for k, v in pairs(a) do
        print(k, v)
    end
end

foo {
    foo = 'bar',
    hello = 'world'
}

local function parse_hp_ratio(str)
    return tonumber(string.match(str, '血量比例=(%d+)'))
end

print(parse_hp_ratio('血量比例=30 无防御=1'))
print(parse_hp_ratio('血量比例=30'))

local function test_param1(name, p1, p2, p3, p4)
    print(name, p1, p2, p3, p4)
end

local function test_param2(p1, p2, p3, p4)
    print(p1, p2, p3, p4)
end

local params = {1,2,3}
test_param1('hello', unpack(params))
test_param2(unpack(params))

print(tonumber(string.match('弓箭武器+1', '[^%+]+%+(%d+)')))
print(tonumber(string.match('弓箭武器+2', '[^%+]+%+(%d+)')))
print(tonumber(string.match('弓箭武器+3', '[^%+]+%+(%d+)')))
print(tonumber(string.match('子弹武器+1', '[^%+]+%+(%d+)')))
print(tonumber(string.match('子弹武器+2', '[^%+]+%+(%d+)')))

local from, to = 1, 1
from, to = to + 2, to + 3

print(from, to)
]]

--[[
local _a = 1
function get_a()
    _a = _a + 1
    return _a
end

repeat
    local a = get_a()
    print(a)
until a > 5]]

--[[local p0 = {x = 0, y = 0}
local p1 = {x = 0, y = 1}
local p2 = {x = 1, y = 0}

local function s_trangle(p1, p2, p3)
    return 0.5 * (p1.x*p2.y+p2.x*p3.y+p3.x*p1.y-p1.x*p3.y-p2.x*p1.y-p3.x*p2.y)
end

local function distance(p1, p2)
    return ((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2) ^ 0.5
end

local function cal_distance(p0, p1, p2)
    return math.abs(2 * s_trangle(p0, p1, p2))  / distance(p0, p1)
end

print(s_trangle(p2, p1, p0))
print(cal_distance(p0, p1, p2))

local p3 = {x = 0.5, y = 0.5}

print(cal_distance(p0, p1, p3))]]

--[[
local function is_wall_region(name)
    return string.match(name, 'wall%d+') ~= nil
end

print(is_wall_region('wall1'))
print(is_wall_region('wall2'))
print(is_wall_region('wall11'))
print(is_wall_region('wall31'))
print(is_wall_region('wall'))]]

--print(string.format('%.3f', 0.123456))

local function random()
    return math.random()
end

-- 数组求和
function table.sum(t)
    local r = 0
    for _, v in ipairs(t) do
        r = r + v
    end
    return r
end

local function gen_random_sum_array(n, sum, divide_times)
    local raw_a = {}
    for i = 1, n do
        raw_a[i] = 1 + divide_times * random()
    end

    local sum_raw_a = table.sum(raw_a)

    local ret_a = {}
    for i, e in ipairs(raw_a) do
        ret_a[i] = e / sum_raw_a * sum
    end

    return ret_a
end

function table.concat_fmt(t, e_fmt, sep)
    local st = {}
    for i, e in ipairs(t) do
        st[i] = string.format(e_fmt, e)
    end
    return table.concat(st, sep)
end

local function test()
    local str =

[[
1 Hello World,
2 Hello Lovebird
]]

    print(str)
end

local function set_task_hit(str)
    print(str)
end

local function set_task_hint_mine(...)
    local str = table.concat({...}, '\n')
    set_task_hit(str)
end

set_task_hint_mine('hello', 'world', '1', '2')
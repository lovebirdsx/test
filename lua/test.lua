FUCK_FOU = 2

function test_map()
	local cfg_map = {
    	['狂战'] = {'bh', 'bs1', 'bs2', 'bs3'},
    	['游侠'] = {'rh', 'rs1', 'rs2', 'rs3'},
    	['骑士'] = {'kh', 'ks1', 'ks2', 'ks3'},
    	['炼金'] = {'ah', 'as1', 'as2', 'as3'},
    }

    local cfg = cfg_map['狂战']
    for i, name in ipairs(cfg) do
    	print(i, name)
    end    
end

function test_class()
    local create = function (a, b)
        local self = {}
        self.a = a
        self.b = b

        self.foo = function (self)
            print(self.a, self.b)
        end

        return self
    end

    local bar = create('hello', 'world')
    bar:foo()
end

function output_something()
    print(1080*2)
    print(1080*3)
    print(1080*4)
    print(1080*5)
    print(86*1.5,115*1.5)
end

function test_break()
    for i,v in ipairs({1,2,3,4,5}) do
        print(i,v)
        if i == 2 then
            break
        end
    end
end

function test_upvalue()
    function foo(name, a, b)
        local a = a
        local b = b

        local obj = {}

        obj.bar = function ()
            print(name, a, b)
            a = a + 1
            b = b + 1
        end

        return obj
    end

    local obj_a = foo('obj_a', 10, 10)
    obj_a.bar()
    obj_a.bar()

    local obj_b = foo('obj_b', 5, 5)
    obj_b.bar()
    obj_b.bar()

    obj_a.bar()
    obj_b.bar()
end

function test_var_parms()
    function foo(a, ...)
        print(a)
        for i, e in ipairs({...}) do
            print(i, e)
        end
    end

    foo('hello', 'I', 'am', 'Lovebird')
end

function test_and_or()
    print(true and false or true)
    print(true and true or true)
    print(true and false or false)
    print(false and true or true)
end

function test_type()
    local a = 1
    local b = '1'
    local c = {}

    print(type(a), type(b), type(c))
end

function test_sort()
    local t = {3,1,2,3,4,9,11,8}
    print('before:', table.concat(t, ','))
    table.sort(t, function (a, b) return a < b end)
    print('after:', table.concat(t, ','))
end

function test_local_function()
    -- 必须要在调用前声明
    local function foo(a, b)
        print(a, b)
    end

    foo('hello', 'world')
end

function create_pos(x, y)
    return {x = x, y = y}
end

function gen_circle_points(pos, radius, div)
    local points = {}
    local x, y = pos.x, pos.y

    for i = 1, div do
        local ra = math.pi * 2 / div * i
        local px = x + radius * math.cos(ra)
        local py = y + radius * math.sin(ra)        
        table.insert(points, create_pos(px, py))
    end

    return points
end

function test_gen_circle_points()
    local points = gen_circle_points({x = 0, y = 0}, 100, 4)
    for _, p in ipairs(points) do
        print(p.x, p.y)
    end
end

function gen_line_points(from, to, len, count)
    local points = {}
    local fx, fy, tx, ty = from.x, from.y, to.x, to.y
    local angle = math.atan2(ty - fy, tx - fx)
    local dx = len * math.cos(angle)
    local dy = len * math.sin(angle)

    local x, y = fx + dx, fy + dy
    for i = 1, count do
        table.insert(points, {x = x, y = y})
        x, y = x + dx, y + dy
    end

    return points
end

function test_gen_line_points()
    local points = gen_line_points({x=0, y=0}, {x=0, y=100}, 10, 10)
    for _, p in ipairs(points) do
        print(p.x, p.y)
    end
end

function gen_scatter_points(pos, radius, count)
    local x, y = pos.x, pos.y
    local points = {}
    for i = 1, count do
        local len = math.random() ^ 0.5 * radius
        local angle = math.rad(math.random(1, 360))
        local dx, dy = len * math.cos(angle), len * math.sin(angle)
        table.insert(points, {x = x + dx, y = y + dy})
    end
    return points
end

function test_gen_scatter_points()
    local points = gen_scatter_points({x=0, y=0}, 100, 100)
    for _, p in ipairs(points) do
        print(p.x, p.y)
    end
end

function test_continue()
    local i = 1
    while true do
        if i < 5 then            
            print(i)
            i = i + 1
        else
            break
        end
    end
end

function gen_scatter_points2(pos, r1, r2, count)
    local x, y = pos.x, pos.y
    local points = {}
    local dis2 = 2 * r2
    for i = 1, count do        
        while true do
            local len = math.random() ^ 0.5 * r1
            local angle = math.rad(math.random(1, 360))
            local dx, dy = len * math.cos(angle), len * math.sin(angle)
            local nx, ny = x + dx, y + dy

            -- 检查是否有重叠
            local ok = true
            for _, p in ipairs(points) do
                local dis = ((p.x - nx) ^ 2 + (p.y - ny) ^ 2) ^ 0.5
                print(dis, dis2)
                if dis <= dis2 then
                    print('not ok')
                    ok = false
                    break
                end
            end

            if ok then
                table.insert(points, {x = x + dx, y = y + dy})
                break
            end
        end
    end

    return points
end

function test_gen_scatter_points2()
    math.randomseed(os.time())
    local points = gen_scatter_points2({x=0, y=0}, 1500, 200, 5)
    for _, p in ipairs(points) do
        print(p.x, p.y)
    end
end

function gen_side_points(from, to, angle, r)    
    local points = {}
    local a1 = math.atan2(to.y - from.y, to.x - from.x)
    local angles = {a1 + angle, a1 - angle}
    for _, a in ipairs(angles) do
        local dx, dy = r * math.cos(a), r * math.sin(a)
        table.insert(points, {x = from.x + dx, y = from.y + dy})
    end
    return points
end

function test_gen_side_points()
    math.randomseed(os.time())
    local points = gen_side_points({x=0, y=0}, {x=0, y=100}, math.pi/4, 141)
    for _, p in ipairs(points) do
        print(p.x, p.y)
    end
end

function test_var_parms2()
    local function bar(a,  ... )
        print(a)
        for i,v in ipairs({...}) do
            print(i,v)
        end
    end

    local function foo(a,  ... )
        bar(a, ...)
    end

    foo(1,2,3,4)
    print(_VERSION)
    if _VERSION == 'Lua 5.1' then
        foo(unpack({1,2,3,4}))
    else
        foo(table.unpack({1,2,3,4}))
    end
end

function get_pos_by_offset(from, to, offset)
    local fx, fy, tx, ty = from.x, from.y, to.x, to.y
    local angle = math.atan2(ty - fy, tx - fx)    
    print(math.deg(angle))
    return create_pos(fx + offset * math.cos(angle), fy + offset * math.sin(angle))  
end

function test_get_pos_by_offset()

     -- from   to   angle 47.428585212223 offset -1000

    local from, to = {x=-1874.0, y=55.0}, {x=-680.86168162028, y=1353.828125}
    local offset = -1000
    local pos = get_pos_by_offset(from, to, offset)
    print(pos.x, pos.y)
end

function test_split()
    for i in string.gmatch('wahaha hello world', '%S+') do
        print(i)
    end

    for i in string.gmatch('wahaha,hello,world', '%P+') do
        print(i)
    end

    for i in string.gmatch('wahaha:hello.world', '%P+') do
        print(i)
    end
end

function test_table_concat()
    print(table.concat({1,2,3}, ','))
end

function test_to_string()
    print(tostring(false))
end

function test_random()
    print(math.random(1, 1))
end

function test_coroutine()
    local function foo(a, b)
        local c = coroutine.yield(a*2, b*2)
        print(c)
    end

    local c = coroutine.create(foo)
    local r, a, b = coroutine.resume(c, 1, 2)
    coroutine.resume(c, a+b)
end

function test_to_number()
    print(tonumber('1234'))
    print(tonumber(1234))
    print(tonumber(nil))
end

function test_parse_units_str()
    local function parse_units_str(s)
        local units = {}
        for i in string.gmatch(s, '[^,]+') do
            table.insert(units, i)
        end
        return units
    end

    local units = parse_units_str('s,s,(s),[S]')
    for i,v in ipairs(units) do
        print(i,v)
    end
end

function test_dict()
    local a = {foo='wahaha', bar='car'}
    print(a.foo)    
    print(a[nil])    
end

function test_find_str()
    print(string.find('炮塔亡灵', '炮塔'))
    print(string.find('箭塔亡灵', '箭塔'))
    print(string.find('箭塔亡灵', '箭'))
    print(string.find('箭塔亡灵', '塔'))
    print(string.find('炮塔亡灵', '剑塔'))
end

function test_table()
    local foo = {}
    print(#foo)
    foo[1] = 1
    foo[2] = 1
    print(#foo)
    foo[1] = nil
    foo[2] = nil
    print(#foo)
end

function test_for()
    for i = 1, 0 do
        print('foo')
    end

    for i = 1, 1 do
        print('foo')
    end    
end

function test_parse_kv_str()
    local function parse_kv_str(str)
        local t = {}
        for k, v in string.gmatch(str, "(%w+)=(%w+)") do
            t[k] = v
        end
        return t
    end

    local t = parse_kv_str('hello=world, wahaha=xiao')
    for k,v in pairs(t) do
        print(k,v)
    end
end

function test_arg()
    print(#arg)
    print(arg[0])
end

function test_function_class()
    function foo()
        local i = 1
        local self = {}

        function self.bar()
            i = i + 1
            print(i)
        end

        return self
    end

    local f1 = foo()
    local f2 = foo()

    print(f1.bar())
    print(f2.bar())
    print(f1.bar())
    print(f2.bar())
    print(f1.bar())
    print(f2.bar())
end

function test_array()
    local a = {nil, 1, 2, 3}
    if _VERSION == 'Lua 5.1' then
        print(unpack(a))
    else
        print(table.unpack(a))
    end
end

function test_params()
    local function foo(...)
        print(select('#', ...))
        for i = 1, select('#', ...) do
            print(select(i, ...))
        end
    end

    foo(1,2,3,{1,2,3})
end

local function bar(a, b, c, d)
    
end

-- test_params()
print(string.format("%s ~= %s", 1, 2))
local function foo()
    return 'hello', 'world'
end

local function bar()
    return foo()
end

local function car(s1, s2, s3)
    print(s1 .. ' ' .. s2 .. ' ' .. s3)
end

local a, b = bar()
print(a, b)
--car(foo(), 'fuck')
car(foo(), 'fuck1', 'fuck2')
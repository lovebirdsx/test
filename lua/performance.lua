local function foo1(...)
    local t = {...}
    local r = 0
    for i, e in ipairs(t) do
        r = r + e
    end
    return r
end

local function foo2(...)
    local n = select('#', ...)
    local r = 0
    for i = 1, n do
        r = r + select(i, ...)
    end
    return r
end

local function tableinsert1()
    local t = {}
    for i = 1, 10 do
        table.insert(t, 1)
    end
end

local function tableinsert2()
    local t = {}
    for i = 1, 10 do
        t[#t + 1] = 1
    end
end

local function run(fun, times, ...)
    local start_time = os.clock()
    for i = 1, times do
        fun(...)
    end
    local end_time = os.clock()

    return end_time - start_time
end

local function main()
    local times = 100000
    print('foo1', run(foo1, times, 1, 2, 3, 4, 5, 6))
    print('foo2', run(foo2, times, 1, 2, 3, 4, 5, 6))

    print('tab1', run(tableinsert1, times, 1, 2, 3, 4, 5, 6))
    print('tab2', run(tableinsert2, times, 1, 2, 3, 4, 5, 6))
end

main()
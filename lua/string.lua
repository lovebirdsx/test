local function test1()
    local s = 'player1'
    print(s:sub(1, -2))
    
    local s2 = [[
    1 - by_type('camera_pos')
    2 - by_name('test')
    3 - by_name('')
    4 - by_name('none')]]
    print(s2)
end

local function test2()
    print('123' > '234')
    print('234' > '123')
    print('123' == '123')
end

local function test3()
    print(string.find('牢笼_小', '牢笼'))
    print(string.find('牢笼_中', '牢笼'))
    print(string.find('牢笼_大', '牢笼'))
    
    print(string.gsub('我<color=red>黄盖的技能可以让全队恢复大量生命！！</color>', '<color=(%w+)>', '<color=Dblue>'))
    print(string.gsub('我<color=red>黄盖</color>的技能可以让全队恢复<color=red>大量</color>生命！！', '<color=(%w+)>', '<color=Dblue>'))
end

local function test4()
    local cmdline = 'finduser 小'
    for s in string.gmatch(cmdline, "%S+") do
        print(s)
    end
end

test4()

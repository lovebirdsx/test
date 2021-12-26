-- ***********************************************************
-- print(string.find('banana', 'an'))
-- print(string.find('banaba', 'lua'))
-- print(string.find('abcdefg', 'b..'))

-- print(string.match('banana', 'ba'))
-- print(string.match('foo 123 bar', '%d%d%d'))
-- print(string.match('Hello World', '%u'))
-- print(string.match('abcd', '[bc][bc]'))
-- print(string.match('abcd', '[^ad]'))
-- print(string.match('123', '[0-9]'))

-- print(string.match('examples', 'examples?'))
-- print(string.match('example', 'examples?'))
-- print(string.match('example', 'examples'))

-- print(string.match('hello, 1234, world', '%d+'))

-- print(string.match('one | two | three', '|.*|'))
-- print(string.match('one || three', '|.*|'))
-- print(string.match('one || three', '|.+|'))

-- -- * And -
-- print(string.match('one | two | three | four | five', '|.*|'))
-- print(string.match('one | two | three | four | five', '|.-|'))
-- print(string.match('abc', 'a.*'))
-- print(string.match('abc', 'a.-'))
-- print(string.match('abc', 'a.-$'))
-- print(string.match('abc', '^.-b'))

-- -- Special characters
-- print(string.match('%*^', '%%%*%^'))

-- Return sevaral result
-- print(string.match('foo: 123 bar:456', '(%a+):%s*(%d+)%s+(%a+):%s*(%d+)'))
-- print(string.match('update_foo', 'update_([%a_]+)'))
-- print(string.match('enter_foo_bar', 'enter_([%a_]+)'))
-- print(string.match('exit_foo_bar_car', 'exit_([%a_]+)'))

-- U can not use:
-- '(foo)+' '(foo|bar)'

-- ***********************************************************
-- function get_api_line(line)
-- 	return string.match(line, 'function%s+%a+.-%(-%)')
-- end

-- print(get_api_line('function foo()'))
-- print(get_api_line('function foo() end'))
-- print(get_api_line('function  foo() end'))
-- print(get_api_line('function foo()  end'))
-- print(get_api_line('function ()  end'))
-- print(get_api_line('function foo(bar) end'))
-- print(get_api_line('function foo(bar, car) end'))
-- print(get_api_line('function foo(bar, ...) end'))

-- ***********************************************************
-- local s = 'gen_point.lua'
-- print(s:match('[%a_]+'))
-- print(string.match(s, '[%a_]+'))


-- local arg = 'play=kill_survival,survival diff=1'
-- print('map start args:')
-- for k, v in string.gmatch(arg, "(%w+)=([%w_,]+)") do
--     print(k, v)
-- end


-- function string.split(str, sep)
--     local sep, fields = sep or ":", {}
--     local pattern = string.format("([^%s]+)", sep)
--     str:gsub(pattern, function(c) fields[#fields+1] = c end)
--     return fields
-- end

-- local fields = string.split('kill_survival,survival', ',')
-- for i = 1, #fields do
-- 	print(fields[i])
-- end

-- local arg = 'name=剧情本1-1; time=10;  hello=world; 你好=世界'
-- for k, v in string.gmatch(arg, '([^; ]+)=([^; ]+)') do
--     print(string.format('%s = %s', k, v))
-- end

print(string.find('头顶-遇到蔡文姬', '头顶'))

local s = '孙尚香,皇甫嵩,蔡文姬'
for name in string.gmatch(s, '([^,]+)') do
    print(string.format('%s', name))
end

local trace = [[.\lib\play\condition\time_score.lua:78: attempt to call method 'get_time' (a nil value)]]
print(trace)
print(string.gsub(trace, '(%.\\)', ''))
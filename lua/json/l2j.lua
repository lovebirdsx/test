require('json')
require('serpent')

function read_file(path)
	local f = assert(io.open(path), 'rb')
	local s = assert(f:read('a'))
	f:close()
	return s
end

function write_file(path, s)
	local f = assert(io.open(path, 'w+'))
	assert(f:write(s))
	f:close()
end

function l2j(lua_file, json_file)
	local src = read_file(lua_file)	
    local func = loadstring('return ' .. src)
    if func then
    	local t = func()
    	local out = JSON:encode_pretty(t)
		write_file(json_file, out)
    end	
end

function main()
	if #arg ~= 2 then
		print('Usage: l2j [lua file path] [json file path]')
		return 1
	end

	local lua_file, json_file = arg[1], arg[2]
	l2j(lua_file, json_file)
	return 0
end

main()
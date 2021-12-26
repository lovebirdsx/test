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

function j2l(json_file, lua_file)
	local src = read_file(json_file)
	local t = JSON:decode(src)
	write_file(lua_file, serpent.block(t, {sparse = true, comment = false, indent = '\t'}))
end

function main()
	if #arg ~= 2 then
		print('Usage: j2l [json file path] [lua file path]')
		return 1
	end

	local json_file, lua_file = arg[1], arg[2]
	j2l(json_file, lua_file)
	return 0
end

main()

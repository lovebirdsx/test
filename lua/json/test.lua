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

function test_decode()
	local s = read_file('level_cfg.json')
	local t = JSON:decode(s)
	write_file('tmp.lua', serpent.block(t, {sparse = true, comment = false, indent = '\t'}))
	local out = JSON:encode_pretty(t)
	write_file('tmp.json', out)
end

test_decode()

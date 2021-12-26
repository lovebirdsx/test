function hello()
	print('hello from bar')
end

require('foo')

print('bar')

local M = {}

local v = 1

function M.module_fun()
	print('M.module_fun', v)
	v = v + 1
end

assert(false)

return M
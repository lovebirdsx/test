require 'table'

function pack(...)
	return {n = select('#', ...), ...}
end

table.pack = pack
table.unpack = unpack

table.foreach(table, print)

function fun(k, v)
	print(k, '=', v)
end

local t = {1,2,3,a='foo', b='bar',nil}
table.foreach(t, fun)
-- local a = table.pack(1, nil, 'wahaha')
-- print(table.tostring(a))

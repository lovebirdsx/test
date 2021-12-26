require('ops')

local t = 0
function get_time()
	t = t + 1 / 30
	return t
end

-- ********************************************************
-- Test Normal
local ops = create_ops()

function foo()
	function enter(name)		
		print('foo enter', name)
	end
	return nil, enter
end

function bar()
	local param
	local id
	function enter(...)
		param = {...}
		id = 1
	end

	function update()
		local p = param[id]
		print('bar', p)
		id = id + 1
		return id > #param
	end

	function exit()
		print('bar exit')
	end

	return update, enter, exit
end

ops.reg('foo', foo())
ops.reg('bar', bar())

local op_list = {
	{op = 'foo', param = {'hello'}},
	{op = 'bar', param = {'what', 'the', 'fuck'}},
	{op = 'foo', param = {'world'}},
	{op = 'bar', param = {'god', 'like'}}
}
ops.start(op_list)
while not ops.is_finish() do ops.frame() end

ops.start(op_list, 2)
while not ops.is_finish() do ops.frame() end


-- ********************************************************
-- Test Auto Reg
local obj = {
	enter_foo = function () end,
	update_foo = function () end,
	exit_foo = function () end,
	enter_bar = function() end,
	update_car = function() end,
	enter_var = 1,
	update_var = 2,
	exit_var = 3,
}

local ops = create_ops(obj)
ops.debug()

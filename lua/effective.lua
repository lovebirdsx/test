local count = 100 * 10000

function a()
	local x, y = 1, 2
	for i = 1, count do
		x = x + 1
		y = y + 1
	end
end

function b()
	local x, y = 1, 2
	for i = 1, count do
		local t = {x = x + i, y = y + i}
	end
end

function get_run_time(fun)
	local start_time = os.clock()
	fun()
	local end_time = os.clock()	
	return end_time - start_time
end

local time_a = get_run_time(a)
local time_b = get_run_time(b)

print(string.format('a = %g b = %g a / b = %g', 
	time_a, time_b, time_a / time_b))

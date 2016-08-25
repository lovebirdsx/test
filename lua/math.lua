-- print(math.pi)
-- print(math.deg(math.pi))
-- print(math.floor(1.5))
-- print(math.ceil(1.5))

-- print(math.pi / 2)
-- local speed = (math.pi / 2) / 7

-- print('speed', speed)
-- print(math.pi / 2 / speed)

function get_intersection(t1, t2)
	local record = {}
	for i = 1, #t1 do
		record[t1[i]] = true
	end

	local result = {}
	for i = 1, #t2 do
		if record[t2[i]] then
			result[#result + 1] = t2[i]
		end
	end

	return result
end

local t = get_intersection({1, 2, 3, 4, 5}, {2, 3, 4})
for i = 1, #t do print(t[i]) end

function NOW()
	return 5
end

function ISBLANK(v)
	return not v
end

function get_status(exp_start, exp_end, real_start, real_end)
	if ISBLANK(real_start) then
		if NOW() > exp_start then
			return "延期"
		else
			return "未开始"
		end
	else
		if ISBLANK(real_end) then
			if NOW() > exp_end then
				return "延期"
			else				
				return "进行中"
			end
		else
			return "完成"
		end
	end
end

function test()
	local now = NOW()

	assert(get_status(now - 1, now + 1) == "延期")
	assert(get_status(now - 1, now + 1, now) == "进行中")
	assert(get_status(now - 5, now + 5, now - 5, now + 3) == "完成")
	assert(get_status(now - 5, now + 5, now - 5, now + 8) == "完成")
	assert(get_status(now + 1, now + 5) == "未开始")
end

test()

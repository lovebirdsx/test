local cfgs = {
	[1] = {fail_rate=0.3, price=100},
	[2] = {fail_rate=0.3, price=200},
	[3] = {fail_rate=0.3, price=300},
	[4] = {fail_rate=0.3, price=400},
	[5] = {fail_rate=0.3, price=500},
	[6] = {fail_rate=0.3, price=600},
	[7] = {fail_rate=0.3, price=700},
	[8] = {fail_rate=0.3, price=800},
	[9] = {fail_rate=0.3, price=900},
	[10] = {fail_rate=0.3, price=1000},
}

function get_price()
	local level = 0
	local cost = 0
	local count = 0
	while level < 10 do
		local cfg = cfgs[level + 1]

		if math.random() < cfg.fail_rate then
			level = level -1
			if level < 0 then level = 0 end
		else
			level = level + 1
		end
		cost = cost + cfg.price
		count = count + 1
	end
	return cost, count
end

local times = 1000
local total_cost = 0
local total_count = 0
for i = 1, times do
	local cost, count = get_price()
	total_cost = total_cost + cost
	total_count = total_count + count
end

local avg_cost, avg_count = total_cost / times, total_count / times
print(avg_cost, avg_count)
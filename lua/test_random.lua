local M = require('random')

local R = M.create()

R.randomseed(os.time())

for i = 1, 10 do
	print(R.random())
end


local records = {}
for i = 1, 10 do records[i] = 0 end

for i = 1, 100000 do
	local n = R.random(10)
	records[n] = records[n] + 1
end

print(table.concat(records, ', '))

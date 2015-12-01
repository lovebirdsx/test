print(math.pi)
print(math.deg(math.pi))
print(math.floor(1.5))
print(math.ceil(1.5))

local cd = 10
local loop = {random_cd_range = 0.5}
random = math.random
for i = 1,  100 do
	print(cd * ((1 - loop.random_cd_range) + random() * loop.random_cd_range * 2))
end
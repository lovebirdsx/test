local M = {}

function M.create()
	local I = {}

	local A1, A2 = 727595, 798405  -- 5^17=D20*A1+A2
	local D20, D40 = 2^20, 2^40
	local X1, X2 = 0, 1	
	local function rand()
	    local U = X2*A2
	    local V = (X1*A2 + X2*A1) % D20
	    V = (V*D20 + U) % D40
	    X1 = math.floor(V/D20)
	    X2 = V - X1*D20
	    return V/D40
	end

	-- 种子的范围是 [0, 2^40 - 1]
	function I.randomseed(seed)
		if seed >= 2 ^ 40 then
			seed = seed % 2 ^ 40
		end

		local max = 2 ^ 20
		if seed > max then
			local a = math.floor(seed / max)
			local b = math.floor(seed - a * max)

			-- 确保b是基数
			if b % 2 ~= 0 then
				b = b + 1
			end

			X1, X2 = a, b
		else
			X1, X2 = seed, 1
		end
	end

	-- 效果和math.random
	function I.random(a, b)
		if not a then
			return rand()
		else
			if not b then
				b = a
				a = 1
			end

			local decimal = (b - a + 1) * rand()
			return a - 1 + math.ceil(decimal)
		end
	end

	return I
end

return M

require 'table'

function foo(a, b)
	print(type(a))
	print(type(b))
end

local function get_best_row_col(n, max_row, max_col)
	max_row = max_row or 4
	max_col = max_col or 4

	if n > max_col * max_row then
		local row = (n % max_col == 0) and (n / max_col) or math.ceil(n / max_col)
		return row, max_col
	else
		local best_r, best_c = 1, max_row * max_col
		for r = 1, max_row do
			for c = 1, max_col do
				if r <= c and r * c >= n and r + c < best_r + best_c then
					best_r = r
					best_c = c
				end
			end
		end
		return best_r, best_c
	end	
end

function main()
	-- print(table.tostring({1,2,3}))
	for k, v in pairs(table) do
		print(k,v)
	end
end

main()
require 'table'

local function foo()
	local function bar()
		
	end

	print(bar)
end

function main()
	for i = 1, 4 do
		foo()
	end
end

main()
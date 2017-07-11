require 'table'

local function foo()
	local function bar()
		
	end

	print(bar)
end

function main()
	local _, count = string.gsub('123\n123\n', '\n', '\n')
	print(count + 1)
end

main()
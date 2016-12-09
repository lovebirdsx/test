local function parse_line(s)
	local head = {}

	for k in string.gmatch(s, '([^ ]+)') do
		table.insert(head, k)
	end

	return head
end

local function parse_group_cfg(path)
	local file = assert(io.open(path), 'rb')
	local i = 1
	local head
	local result = {}
	for line in file:lines() do
		if i == 1 then
			head = parse_line(line)
		else
			local row = {}
			local values = parse_line(line)
		end		
	end
end

local function main()
	parse_group_cfg('group_cfg.txt')
end

local function test()
	parse_head('GroupName   Difficulty  Type')
end

-- main()
test()

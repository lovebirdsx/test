require 'random_squad'

local test = {}

function test_all()
	for name, case in pairs(test) do
		print('test ',  name)
		case()
	end
end

function test.parse_squad_names()
	local names = {
		'黄巾-简单-教徒1',
		'黄巾-简单-教徒2',
		'黄巾-简单-教徒3',
	}

	local r = parse_squad_names(names)

	local r1 = r[1]

	assert(#r == #names)
	assert(r1.difficulty == '简单')
	assert(r1.troop_type == '黄巾')
	assert(r1.units_type == '教徒1')
end

test_all()

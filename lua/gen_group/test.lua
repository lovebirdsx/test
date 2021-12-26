io.stdout:setvbuf('no')

require 'common'

local test = {}

function test_all()
	print('============Test Start===============')

	for k,v in pairs(test) do
		print('test ' .. k)
		v()
	end

	print('============Test Finish==============')
end

function test.parse_group_name()
	local g = parse_group_name('三国-困难-[B]铁英+特强英')
	assert(g.troop_type == '三国')
	assert(g.difficulty == '困难')
	assert(g.is_boss)
	assert(g.units[1] == '[B]铁骑英雄')	
	assert(g.units[2] == '[B]特殊强弓英雄')

	local g = parse_group_name('三国-普通-[B]铁英+教徒')
	assert(g.troop_type == '三国')
	assert(g.difficulty == '普通')
	assert(g.is_boss)
	assert(g.units[1] == '[B]铁骑英雄')
	assert(g.units[2] == '教徒')
end

function test.get_unit_name()
	assert(get_unit_name('铁英', false, '黄巾') == '黄巾铁骑英雄')
	assert(get_unit_name('修英', false, '黄巾') == '黄巾修罗虎卫')
	assert(get_unit_name('铁英', true, '三国') == '[B]铁骑英雄')
	assert(get_unit_name('修英', true, '三国') == '[B]修罗虎卫')
end

function test.is_hero_by_name()
	assert(is_hero_by_name('黄巾铁骑英雄'))
	assert(not is_hero_by_name('铁骑'))
end

function test.get_member_by_name()
	assert(get_member_by_name('黄巾铁骑英雄') == '黄巾铁骑')
	assert(get_member_by_name('铁骑英雄') == '铁骑')
end

function test.U3()
	local units = U3('铁骑', 2, '强弓', 3)
	assert(units[1] == '铁骑')
	assert(units[2] == '铁骑')
	assert(units[3] == '强弓')
	assert(units[4] == '强弓')
	assert(units[5] == '强弓')
end

function test.gen_groups()
	local function gen(name)
		local cfg = parse_group_name(name)
		local groups = gen_groups(cfg)
		assert(#groups > 0, name)		
	end

	-- 1h
	gen('三国-简单-铁英')
	gen('三国-普通-铁英')
	gen('三国-普通-修英')

	-- 1s
	gen('黄巾-普通-教徒')	
	gen('三国-简单-铁兵')
	gen('三国-普通-铁兵')
	
	-- 2_hh_xx
	gen('三国-普通-铁英+盾英')
	gen('三国-困难-铁英+盾英')
	gen('三国-超难-铁英+盾英')

	-- 2_hh_12
	gen('三国-普通-铁英+强英')
	gen('三国-困难-铁英+强英')
	gen('三国-超难-铁英+强英')
	gen('三国-超难-修英+强英')

	-- 2_hs_xx
	gen('三国-普通-铁英+盾兵')
	gen('三国-困难-铁英+盾兵')
	gen('三国-超难-铁英+盾兵')

	-- 2_hs_12
	gen('三国-普通-铁英+强兵')
	gen('三国-困难-铁英+强兵')
	gen('三国-超难-铁英+强兵')
	gen('三国-超难-修英+强兵')

	-- 2_hs_21
	gen('三国-普通-强英+铁兵')
	gen('三国-困难-强英+铁兵')
	gen('三国-超难-强英+铁兵')

	-- 2_ss_xx
	gen('三国-普通-铁兵+盾兵')
	gen('三国-困难-铁兵+盾兵')

	-- 2_ss_12
	gen('三国-普通-铁兵+强兵')
	gen('三国-困难-铁兵+强兵')
	gen('三国-超难-铁兵+强兵')

	-- 3_hhh_122	
	gen('三国-超难-铁英+强英+法英')
	gen('三国-变态-铁英+强英+法英')
	gen('三国-变态-修英+强英+法英')

	-- 3_hhh_112
	gen('三国-超难-铁英+盾英+法英')
	gen('三国-变态-铁英+盾英+法英')

	-- 3_hhs_11x
	gen('三国-困难-铁英+盾英+法兵')
	gen('三国-超难-铁英+盾英+法兵')
	gen('三国-变态-铁英+盾英+法兵')

	-- 3_hhs_122
	gen('三国-困难-铁英+强英+法兵')
	gen('三国-超难-铁英+强英+法兵')
	gen('三国-变态-铁英+强英+法兵')
	gen('三国-变态-修英+强英+法兵')

	-- 3_hhs_221
	gen('三国-困难-铁英+法英+强兵')
	gen('三国-超难-铁英+法英+强兵')
	gen('三国-变态-铁英+法英+强兵')
	gen('三国-变态-修英+法英+强兵')
end

function test.groups_normal_to_special()
	local group = {
		formation = 'heros',
		units = {'强弓英雄', '强弓', '强弓', '法师英雄', '法师', '法师'}
	}

	groups_normal_to_special(group, '三国-普通-特强英+特法英')

	-- 特殊强弓英雄, 强弓, 强弓, 特殊法师英雄, 法师, 法师
	assert(group.units[1] == '特殊强弓英雄')
	assert(group.units[4] == '特殊法师英雄')
end

local GROUP_NAMES = {
	-- '三国-超难-[B]刺英+法兵',
	-- '三国-超难-[B]盾英+刺英+刺英',
	-- '三国-超难-刺英+刺英',
	-- '三国-超难-盾英+特强英+法英',
	-- '三国-普通-铁兵+法兵+刺兵',
	-- '三国-普通-铁兵+炼兵',
	-- '三国-普通-铁英+法兵',
	-- '三国-普通-[B]铁英+教徒',
	'三国-超难-修英+强英',
}

function test.gen_groups2()
	local function gen(name)
		local cfg = parse_group_name(name)		
		local groups = gen_groups(cfg)
		assert(#groups > 0, name)
		-- for _, g in ipairs(groups) do
		-- 	for i, v in ipairs(g.units) do
		-- 		io.write(v .. ' ')
		-- 	end
		-- 	io.write('\n')
		-- end
	end

	for _, name in ipairs(GROUP_NAMES) do	
		gen(name)
	end
end

function test.get_gen_group_names()
	local names = get_gen_group_names('group_input.json', 'group_output.json')
	-- print(table.concat(names, '\n'))
end

function test.update_group_output()	
	local results = {
		{name = '黄巾-简单-铁兵', units = {'黄巾铁骑', '黄巾铁骑', '黄巾铁骑', '黄巾铁骑'}}
	}

	update_group_output(results, 'group_input.json', 'group_output.json')
end

test_all()
-- test.gen_groups2()
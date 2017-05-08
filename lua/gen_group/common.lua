if not import then import = require end

local File = import('file')

local ROW_SOLDIER_COUNT = 6 -- 一排最多站多少小兵

local UNITS_MAP = {
	['铁兵'] = '铁骑',
	['盾兵'] = '盾甲',
	['强兵'] = '强弓',
	['炼兵'] = '炼金',
	['法兵'] = '法师',
	['刺兵'] = '刺客',

	['铁英'] = '铁骑英雄',
	['盾英'] = '盾甲英雄',
	['强英'] = '强弓英雄',
	['炼英'] = '炼金英雄',
	['法英'] = '法师英雄',
	['刺英'] = '刺客英雄',
	['修英'] = '修罗虎卫',

	['[B]铁英'] = '[B]铁骑英雄',
	['[B]盾英'] = '[B]盾甲英雄',
	['[B]强英'] = '[B]强弓英雄',
	['[B]炼英'] = '[B]炼金英雄',
	['[B]法英'] = '[B]法师英雄',
	['[B]刺英'] = '[B]刺客英雄',
	['[B]修英'] = '[B]修罗虎卫',

	['教徒'] = '教徒',
}

local UNITS_ORDER_MAP = {
	'修英',
	'[B]修英',
	'铁英',
	'[B]铁英',
	'特铁英',
	'盾英',
	'[B]盾英',
	'[B]特铁英',
	'强英',
	'[B]强英',
	'特强英',
	'[B]特强英',
	'炼英',
	'[B]炼英',
	'特炼英',
	'[B]特炼英',
	'法英',
	'[B]法英',
	'特法英',
	'[B]特法英',
	'刺英',
	'[B]刺英',
	'教徒',
	'铁兵',
	'盾兵',
	'强兵',
	'炼兵',
	'法兵',
	'刺兵',
	'自爆',
}

local UNITS_ORDER_ID_MAP = {}
for i, name in ipairs(UNITS_ORDER_MAP) do
	UNITS_ORDER_ID_MAP[name] = i
end

function is_hero_by_name(name)
	return string.find(name, '英雄') or string.find(name, '修罗虎卫')
end

function get_unit_name(short_name, is_boss, troop_type)
	local is_special = string.find(short_name, '特')
	local special_str = is_special and '特殊' or ''
	local short_id = string.gsub(short_name, '特', '')
	local name_str = assert(UNITS_MAP[short_id], short_name)
	local is_hero = is_hero_by_name(name_str)
	local boss_str = (is_boss and is_hero) and '[B]' or ''	
	local troop_str = (troop_type == '三国') and '' or troop_type
	return boss_str .. special_str .. troop_str .. name_str
end

local function get_unit_order(short_name)
	local order = UNITS_ORDER_ID_MAP[short_name]
	assert(order, '找到不到order id' .. short_name)
	return order
end

function parse_group_name(name)
	local troop_type, difficulty, units_type = string.match(name, '([^-]+)-([^-]+)-([^-%d]+)')
	-- 注意: 队伍中武将要么全是[B],要么全不是,所以此处可以用第一武将的[B]前缀来判断队伍是否为boss类型队伍
	local is_boss = string.sub(units_type, 1, 3) == '[B]'
	local units = {}
	local last_unit_order = 0
	for k, v in string.gmatch(units_type, '([^+]+)') do
		local unit_id = (string.sub(k, 1, 3) == '[B]') and string.sub(k, 4) or k
		local unit_name = get_unit_name(unit_id, is_boss, troop_type)
		local unit_order = get_unit_order(unit_id)
		assert(unit_order >= last_unit_order, name)
		last_unit_order = unit_order
		table.insert(units, unit_name)
	end

	return {troop_type = troop_type, difficulty = difficulty, is_boss = is_boss, units = units}
end


local function is_melee_by_name(name)
	local melee_names = {'铁骑', '盾甲', '刺客', '自爆兵', '教徒',}
	for _, mname in ipairs(melee_names) do
		if string.find(name, mname) then
			return true
		end
	end

	return false
end

local function is_in_front_row_by_name(name)
    local front_names = {'铁骑', '盾甲', '教徒', '修罗虎卫'}
    for _, fname in ipairs(front_names) do
		if string.find(name, fname) then
			return true
		end
	end

	return false
end

function get_member_by_name(name)
	local soldier_names = {'黄巾铁骑', '黄巾盾甲', '黄巾强弓', '黄巾炼金', '黄巾法师', '黄巾刺客', '铁骑', '盾甲', '强弓', '炼金', '法师', '刺客'}

	assert(is_hero_by_name(name))
	for i, sname in ipairs(soldier_names) do
		if string.find(name, sname) then
			return sname
		end
	end
end

function U3(...)
	local result = {}
	local cfg = {...}
	for i = 1, #cfg / 2 do
		local unit_name = cfg[i*2 - 1]
		local count = cfg[i*2]
		for j = 1, count do
			table.insert(result, unit_name)
		end
	end

	return result
end

local function range(from, to)
	local r = {}
	for i = from, to do
		table.insert(r, i)
	end
	return r
end

local function is_ok_hero_units(units)
	if #units == 0  then return true end

	local front_heroes = {}
	local back_heroes = {}	
	local unit_counts = {}
	for _, u in ipairs(units) do
		if is_hero_by_name(u) then							
			if is_in_front_row_by_name(u) then
				table.insert(front_heroes, u)
			else
				table.insert(back_heroes, u)
			end		
		end

		if not unit_counts[u] then
			unit_counts[u] = 1
		else			
			unit_counts[u] = unit_counts[u] + 1
		end
	end

	-- 判断在同一排的武将是否满足条件
	local function is_the_same_row_2_heroes_ok(hero1, hero2)
		local member1 = get_member_by_name(hero1)
		local member2 = get_member_by_name(hero2)
		if member1 == member2 then
			-- 两个相同的武将,小兵数量必定为双数
			local member_count = unit_counts[member1]			
			if member_count and member_count % 2 ~= 0 then
				return false
			else
				return true
			end
		else
			-- 不同的武将,带的小兵数量一样
			local member1_count = unit_counts[member1]
			local member2_count = unit_counts[member2]			
			return member1_count == member2_count
		end
	end

	if #front_heroes > 0 then
		if #front_heroes == 1 then
			-- 前排只有一个武将,那么小兵数量要么不存在,要么是双数
			local member = get_member_by_name(front_heroes[1])
			local member_count = unit_counts[member]
			if member_count == 1 or member_count == 3 then
				return false
			end
		elseif #front_heroes == 2 then
			if not is_the_same_row_2_heroes_ok(front_heroes[1], front_heroes[2]) then
				return false
			end
		else
			assert(false)
		end
	end

	if #back_heroes > 0 then
		if #back_heroes == 1 then
			-- 后排只有一个武将那么必须带双数小兵
			local member = get_member_by_name(back_heroes[1])
			local member_count = unit_counts[member]		
			if member_count == 1 or member_count == 3 then
				return false
			end
		elseif #back_heroes == 2 then
			if not is_the_same_row_2_heroes_ok(back_heroes[1], back_heroes[2]) then
				return false
			end
		else
			assert(false)
		end	
	end

	return true
end

local function is_ok_soldier_units(units)
	if #units == 0 then return true end

	-- 先记录数据
	local front_soldiers = {}
	local back_soldiers = {}
	local unit_counts = {}
	local unit_types = {}
	local front_type_count = 0
	local back_type_count = 0
	for _, u in ipairs(units) do
		if not is_hero_by_name(u) then							
			if is_in_front_row_by_name(u) then
				table.insert(front_soldiers, u)				
			else
				table.insert(back_soldiers, u)
			end
		end

		if not unit_counts[u] then
			table.insert(unit_types, u)
			if is_in_front_row_by_name(u) then
				front_type_count = front_type_count + 1
			else
				back_type_count = back_type_count + 1
			end
			unit_counts[u] = 1
		else			
			unit_counts[u] = unit_counts[u] + 1
		end

	end	

	if #unit_types == 1 then
		-- 同种小兵是,任何数量都可以
	elseif #unit_types == 2 then
		-- 同排小兵
		if #front_soldiers == 0 or #back_soldiers == 0 then
			local c1 = unit_counts[unit_types[1]]
			local c2 = unit_counts[unit_types[2]]
			if c1 > ROW_SOLDIER_COUNT and c2 >ROW_SOLDIER_COUNT then				
				return false
			end
		else
			if #front_soldiers > ROW_SOLDIER_COUNT then
				-- 前排小兵顶多站一排
				return false
			end
		end
	elseif #unit_types == 3 then		
		if front_type_count == 1 then
			-- 只有最后一排能够排多个小兵
			local full_row_count = 0
			for unit, count in pairs(unit_counts) do
				if count > ROW_SOLDIER_COUNT then
					full_row_count = full_row_count + 1
				end
			end
			if full_row_count >= 2 then
				return false
			else
				-- 保证前排单位只有一排
				if #front_soldiers > ROW_SOLDIER_COUNT then
					return false
				end
			end
		elseif front_type_count == 2 then
			-- 只有最后一排能够排多个小兵
			local full_row_count = 0
			for unit, count in pairs(unit_counts) do
				if count > ROW_SOLDIER_COUNT then
					full_row_count = full_row_count + 1
				end
			end			
			if full_row_count >= 2 then
				return false
			else
				if #back_soldiers <= ROW_SOLDIER_COUNT then
					if full_row_count >= 1 then
						return false
					end
				else
					if full_row_count >= 2 then
						return false
					end
				end
			end
		else
			assert(false, string.format('非法的怪物组合: %s', table.concat(units, ',')))
		end			
	else
		assert(false, string.format('非法的怪物组合: %s', table.concat(units, ',')))
	end

	return true
end

-- 该接口用于过滤不符合条件的组合
function is_ok_units(units)	
	if #units > 24 then return false end

	-- 如果单位中存在值为nil的,也过滤掉(这个有可能是因为加入了修罗虎卫(没有member))
	for i, u in ipairs(units) do
		if not u then
			return false
		end
	end
	
	local hero_units = {}
	local soldier_units = {}
	local front_hero_count, back_hero_count = 0, 0
	for _, u in ipairs(units) do
		if is_hero_by_name(u) then
			table.insert(hero_units, u)
			if is_in_front_row_by_name(u) then
				front_hero_count = front_hero_count + 1
			else
				back_hero_count = back_hero_count + 1
			end
		else
			table.insert(soldier_units, u)
		end
	end

	local function pop(unit)
		for i, u in ipairs(soldier_units) do
			if u == unit then
				return table.remove(soldier_units, i)
			end
		end
	end

	for i = 1, #hero_units do
		local hero = hero_units[i]
		local max_member_count
		if is_in_front_row_by_name(hero) then
			max_member_count = front_hero_count == 1 and 4 or 3
		else
			max_member_count = back_hero_count == 1 and 4 or 3
		end

		local member = get_member_by_name(hero)
		for j = 1, max_member_count do
			local m = pop(member)
			if m then
				table.insert(hero_units, m)
			else
				break
			end
		end
	end

	return is_ok_hero_units(hero_units) and is_ok_soldier_units(soldier_units)
end

local function add_group(groups, formation, ...)
	local units = U3(...)
	if is_ok_units(units) then
		table.insert(groups, {formation = formation, units = units})
	end
end

local function gen_groups_1_h(hero, difficulty, is_boss)
	local from, to
	if difficulty == '简单' then
		from, to = 2, 6
	elseif difficulty == '普通' then
		from, to = 2, 8
	elseif difficulty == '困难' then
		from, to = 2, 16
	elseif difficulty == '超难' then
		from, to = 6, 20
	else
		error(('1个英雄[%s]不支持难度[%s]'):format(hero, difficulty))
	end

	local groups = {}
	local member = get_member_by_name(hero)
	for i = from, to do
		add_group(groups, 'heros', hero, 1, member, i)
	end
	return groups
end

local function gen_groups_1_s(soldier, difficulty, is_boss)
	local from, to
	if difficulty == '简单' then
		from, to = 2, 10
	elseif difficulty == '普通' then
		from, to = 2, 20
	elseif difficulty == '困难' then
		from, to = 2, 24
	else
		error(('1个小兵[%s]不支持难度[%s]'):format(soldier, difficulty))
	end

	local groups = {}
	for i = from, to do
		add_group(groups, 'row8', soldier, i)
	end
	return groups
end

local function gen_groups_1(units, difficulty, is_boss)
	local unit = units[1]
	if is_hero_by_name(unit) then
		return gen_groups_1_h(unit, difficulty, is_boss)
	else
		return gen_groups_1_s(unit, difficulty, is_boss)
	end
end

local function gen_groups_2_hh_x_x(h1, h2, difficulty, is_boss)
	local s1_counts, s2_counts
	if difficulty == '普通' then
		s1_counts = range(0, 3)
		s2_counts = range(0, 6)
	elseif difficulty == '困难' then
		s1_counts = range(0, 3)
		s2_counts = range(0, 8)
	elseif difficulty == '超难' then
		s1_counts = range(1, 3)
		s2_counts = range(2, 16)
	else
		error(string.format('[%s, %s] 不支持难度 [%s]', h1, h2, difficulty))
	end
	
	local groups = {}
	local m1, m2 = get_member_by_name(h1), get_member_by_name(h2)
	for _, s1_count in ipairs(s1_counts) do
		for _, s2_count in ipairs(s2_counts) do
			add_group(groups, 'heros', h1, 1, m1, s1_count, h2, 1, m2, s2_count)
		end
	end

	return groups
end

local function gen_groups_2_hh_1_2(h1, h2, difficulty, is_boss)
	-- 有前排有后排, 确保前排是2个或者4个小兵, 视觉上比较拉风
	local s1_counts, s2_counts
	if difficulty == '普通' then
		s1_counts = {0, 2, 4}
		s2_counts = range(0, 6)
	elseif difficulty == '困难' then
		s1_counts = is_boss and {0, 2, 4} or {2, 4}
		s2_counts = range(2, 8)
	elseif difficulty == '超难' then		
		s1_counts = is_boss and {0, 2, 4} or {4}
		s2_counts = range(2, 16)
	else
		error(string.format('[%s, %s] 不支持难度 [%s]', h1, h2, difficulty))
	end

	local groups = {}
	local m1, m2 = get_member_by_name(h1), get_member_by_name(h2)
	for _, s1_count in ipairs(s1_counts) do
		for _, s2_count in ipairs(s2_counts) do
			add_group(groups, 'heros', h1, 1, m1, s1_count, h2, 1, m2, s2_count)
		end
	end

	return groups
end

local function gen_groups_2_hh(h1, h2, difficulty, is_boss)
	local is_front1 = is_in_front_row_by_name(h1)
	local is_front2 = is_in_front_row_by_name(h2)

	if is_front1 == is_front2 then
		return gen_groups_2_hh_x_x(h1, h2, difficulty, is_boss)
	elseif is_front1 and not is_front2 then
		return gen_groups_2_hh_1_2(h1, h2, difficulty, is_boss)
	else 
		error('不支持的2单位配置: ' .. table.concat({h1, h2}, ', '))
	end
end

local function gen_groups_2_hs_1_x(h, s, difficulty, is_boss)	
	-- 英雄在前排, 保证带2,4个小兵,视觉拉风
	local hs_counts, s_counts
	if difficulty == '简单' then
		hs_counts = {0, 2}
		s_counts = range(1, 6)
	elseif difficulty == '普通' then
		hs_counts = {0, 2}
		s_counts = range(1, 6)
	elseif difficulty == '困难' then
		hs_counts = {0, 2, 4}
		s_counts = range(2, 16)
	elseif difficulty == '超难' then
		hs_counts = {0, 2, 4}
		s_counts = range(2, 20)
	else
		error(string.format('[%s, %s] 不支持难度 [%s]', h, s, difficulty))
	end

	local groups = {}
	local m = get_member_by_name(h)
	for _, hs_count in ipairs(hs_counts) do
		for _, s_count in ipairs(s_counts) do
			add_group(groups, 'heros', h, 1, m, hs_count, s, s_count)
		end
	end

	return groups
end

local function gen_groups_2_hs_2_1(h, s, difficulty, is_boss)
	-- 小兵在前排, 填补英雄的小兵
	local hs_counts, s_counts
	if difficulty == '简单' then
		hs_counts = range(0, 4)
		s_counts = {1, 2}
	elseif difficulty == '普通' then
		hs_counts = range(0, 6)
		s_counts = {1, 2, 3, 4}
	elseif difficulty == '困难' then
		hs_counts = range(2, 12)
		s_counts = {4}
	elseif difficulty == '超难' then
		hs_counts = range(2, 16)
		s_counts = {4}
	else
		error(string.format('[%s, %s] 不支持难度 [%s]', h, s, difficulty))
	end

	local groups = {}
	local m = get_member_by_name(h)
	for _, hs_count in ipairs(hs_counts) do
		for _, s_count in ipairs(s_counts) do
			add_group(groups, 'heros', h, 1, m, hs_count, s, s_count)
		end
	end

	return groups
end

local function gen_groups_2_hs_2_2(h, s, difficulty, is_boss)
	-- 小兵在后排, 填补同类型小兵
	local hs_counts, s_counts
	if difficulty == '简单' then
		hs_counts = {0, 1, 2}
		s_counts = range(1, 6)
	elseif difficulty == '普通' then
		hs_counts = {0, 1, 2, 3, 4}
		s_counts = range(1, 8)
	elseif difficulty == '困难' then
		hs_counts = {0, 1, 2, 3, 4}
		s_counts = range(2, 12)
	elseif difficulty == '超难' then
		hs_counts = {4}
		s_counts = range(2, 16)
	else
		error(string.format('[%s, %s] 不支持难度 [%s]', h, s, difficulty))
	end

	local groups = {}
	local m = get_member_by_name(h)
	for _, hs_count in ipairs(hs_counts) do
		for _, s_count in ipairs(s_counts) do
			add_group(groups, 'heros', h, 1, m, hs_count, s, s_count)
		end
	end

	return groups
end

local function gen_groups_2_hs(h, s, difficulty, is_boss)
	local is_front_h = is_in_front_row_by_name(h)
	local is_front_s = is_in_front_row_by_name(s)
	
	if is_front_h then
		return gen_groups_2_hs_1_x(h, s, difficulty, is_boss)
	else
		if is_front_s then
			return gen_groups_2_hs_2_1(h, s, difficulty, is_boss)
		else
			return gen_groups_2_hs_2_2(h, s, difficulty, is_boss)
		end
	end
end

local function gen_groups_2_ss_x_x(s1, s2, difficulty, is_boss)
	local s1_counts, s2_counts

	if difficulty == '简单' then
		s1_counts = range(1, 6)
		s2_counts = range(1, 6)
	elseif difficulty == '普通' then
		s1_counts = range(2, 8)
		s2_counts = range(2, 8)
	elseif difficulty == '困难' then
		s1_counts = range(4, 12)
		s2_counts = range(4, 12)
	elseif difficulty == '超难' then
		s1_counts = range(8, 12)
		s2_counts = range(8, 12)
	else
		error(string.format('[%s, %s] 不支持难度 [%s]', h, s, difficulty))
	end

	local groups = {}
	for _, s1_count in ipairs(s1_counts) do
		for _, s2_count in ipairs(s2_counts) do
			add_group(groups, 'heros', s1, s1_count, s2, s2_count)
		end
	end

	return groups
end

local function gen_groups_2_ss_1_2(s1, s2, difficulty, is_boss)
	local s1_counts, s2_counts

	-- 有前后排
	if difficulty == '简单' then
		s1_counts = range(1, 4)
		s2_counts = range(1, 4)
	elseif difficulty == '普通' then
		s1_counts = range(2, 4)
		s2_counts = range(2, 6)
	elseif difficulty == '困难' then
		s1_counts = range(2, 8)
		s2_counts = range(2, 12)
	elseif difficulty == '超难' then
		s1_counts = range(6, 8)
		s2_counts = range(6, 12)
	else
		error(string.format('[%s, %s] 不支持难度 [%s]', h, s, difficulty))
	end

	local groups = {}
	for _, s1_count in ipairs(s1_counts) do
		for _, s2_count in ipairs(s2_counts) do
			add_group(groups, 'heros', s1, s1_count, s2, s2_count)
		end
	end

	return groups
end

local function gen_groups_2_ss(s1, s2, difficulty, is_boss)
	local is_front_s1 = is_in_front_row_by_name(s1)
	local is_front_s2 = is_in_front_row_by_name(s2)

	-- 在同一排
	if is_front_s1 == is_front_s2 then		
		return gen_groups_2_ss_x_x(s1, s2, difficulty, is_boss)
	elseif is_front_s1 and not is_front2 then
		return gen_groups_2_ss_1_2(s1, s2, difficulty, is_boss)
	else
		error('不支持的2单位配置: ' .. table.concat({s1, s2}, ', '))
	end
end

local function gen_groups_2(units, difficulty, is_boss)
	local u1, u2 = units[1], units[2]
	local is_hero1 = is_hero_by_name(u1)
	local is_hero2 = is_hero_by_name(u2)
	if is_hero1 and is_hero2 then
		return gen_groups_2_hh(u1, u2, difficulty, is_boss)
	elseif is_hero1 and not is_heros2 then
		return gen_groups_2_hs(u1, u2, difficulty, is_boss)
	elseif not is_hero1 and not is_hero2 then
		return gen_groups_2_ss(u1, u2, difficulty, is_boss)
	else
		error('不支持的2单位配置: ' .. table.concat(units, ', '))
	end
end

local function gen_groups_3_hhh_1_2_2(h1, h2, h3, difficulty, is_boss)	
	local s1_counts, s2_counts, s3_counts
	if difficulty == '困难' then
		s1_counts = {0, 2, 4}
		s2_counts = range(0, 3)
		s3_counts = range(0, 12)
	elseif difficulty == '超难' or difficulty == '变态' then		
		s1_counts = {0, 2, 4}
		s2_counts = {3}
		s3_counts = range(3, 12)
	else
		error(string.format('[%s, %s, %s] 不支持难度 [%s]', h1, h2, h3, difficulty))
	end

	local groups = {}
	local m1 = get_member_by_name(h1)
	local m2 = get_member_by_name(h2)
	local m3 = get_member_by_name(h3)
	for _, s1_count in ipairs(s1_counts) do
		for s23_count = 0, 2 do
			add_group(groups, 'heros',
						h1, 1, m1, s1_count,
						h2, 1, m2, s23_count,
						h3, 1, m3, s23_count
			)
		end

		for _, s2_count in ipairs(s2_counts) do
			for _, s3_count in ipairs(s3_counts) do
				add_group(groups, 'heros',
					h1, 1, m1, s1_count,
					h2, 1, m2, s2_count,
					h3, 1, m3, s3_count
				)
			end
		end		
	end
	return groups
end

local function gen_groups_3_hhh_1_1_2(h1, h2, h3, difficulty, is_boss)
	local s12_counts, s3_counts
	if difficulty == '困难' then
		s12_counts = range(0, 2)
		s3_counts = range(0, 12)
	elseif difficulty == '超难' or difficulty == '变态' then
		s12_counts = range(0, 4)
		s3_counts = range(0, 12)
	else
		error(string.format('[%s, %s, %s] 不支持难度 [%s]', h1, h2, h3, difficulty))
	end

	local groups = {}
	local m1 = get_member_by_name(h1)
	local m2 = get_member_by_name(h2)
	local m3 = get_member_by_name(h3)
	for _, s12_count in ipairs(s12_counts) do
		for _, s3_count in ipairs(s3_counts) do
			add_group(groups, 'heros',
				h1, 1, m1, s12_count,
				h2, 1, m2, s12_count,
				h3, 1, m3, s3_count
			)
		end
	end
	return groups
end

local function gen_groups_3_hhh(h1, h2, h3, difficulty, is_boss)
	local is_front1 = is_in_front_row_by_name(h1)
	local is_front2 = is_in_front_row_by_name(h2)
	local is_front3 = is_in_front_row_by_name(h3)

	if is_front1 and not is_front2 and not is_front3 then
		return gen_groups_3_hhh_1_2_2(h1, h2, h3, difficulty, is_boss)
	elseif is_front1 and is_front2 and not is_front3 then
		return gen_groups_3_hhh_1_1_2(h1, h2, h3, difficulty, is_boss)
	else
		error('不支持的3单位配置: ', table.concat({h1, h2, h3}, ', '))
	end
end

local function gen_groups_3_hhs_1_1_x(h1, h2, s, difficulty, is_boss)
	local s12_counts, s3_counts
	if difficulty == '困难' then
		s12_counts = {2, 4}
		s3_counts = range(3, 12)
	elseif difficulty == '超难' then
		s12_counts = {2, 4}
		s3_counts = range(3, 12)
	elseif difficulty == '变态' then
		s12_counts = {4}
		s3_counts = range(3, 12)
	else
		error(string.format('[%s, %s, %s] 不支持难度 [%s]', h1, h2, h3, difficulty))
	end

	local groups = {}
	local m1 = get_member_by_name(h1)
	local m2 = get_member_by_name(h2)	
	for _, s12_count in ipairs(s12_counts) do
		for _, s3_count in ipairs(s3_counts) do
			add_group(groups, 'heros',
				h1, 1, m1, s12_count,
				h2, 1, m2, s12_count,
				s, s3_count
			)
		end
	end
	return groups
end

local function gen_groups_3_hhs_1_2_2(h1, h2, s, difficulty, is_boss)
	local s12_counts, s3_counts
	if difficulty == '困难' then
		s12_counts = {2, 4}
		s3_counts = range(3, 12)
	elseif difficulty == '超难' then
		s12_counts = {2, 4}
		s3_counts = range(3, 12)
	elseif difficulty == '变态' then
		s12_counts = {4}
		s3_counts = range(3, 12)
	else
		error(string.format('[%s, %s, %s] 不支持难度 [%s]', h1, h2, h3, difficulty))
	end

	local groups = {}
	local m1 = get_member_by_name(h1)
	local m2 = get_member_by_name(h2)	
	for _, s12_count in ipairs(s12_counts) do
		for _, s3_count in ipairs(s3_counts) do
			add_group(groups, 'heros',
				h1, 1, m1, s12_count,
				h2, 1, m2, s12_count,
				s, s3_count
			)
		end
	end
	return groups
end

local function gen_groups_3_hhs_2_2_1(h1, h2, s, difficulty, is_boss)
	local s1_counts, s2_counts, s3_counts
	if difficulty == '困难' then
		s3_counts = {2, 3, 4}
		s1_counts = {3}
		s2_counts = range(3, 8)
	elseif difficulty == '超难' then
		s3_counts = {4}
		s1_counts = {3}
		s2_counts = range(3, 8)
	elseif difficulty == '变态' then
		s3_counts = {4}
		s1_counts = {3}
		s2_counts = range(3, 12)
	else
		error(string.format('[%s, %s, %s] 不支持难度 [%s]', h1, h2, h3, difficulty))
	end

	local groups = {}
	local m1 = get_member_by_name(h1)
	local m2 = get_member_by_name(h2)	
	for _, s1_count in ipairs(s1_counts) do
		for _, s2_count in ipairs(s2_counts) do
			for _, s3_count in ipairs(s3_counts) do
				add_group(groups, 'heros',
					h1, 1, m1, s1_count,
					h2, 1, m2, s2_count,
					s, s3_count
				)
			end
		end
	end

	return groups
end

local function gen_groups_3_hhs(h1, h2, s, difficulty, is_boss)
	local is_front_h1 = is_in_front_row_by_name(h1)
	local is_front_h2 = is_in_front_row_by_name(h2)
	local is_front_s = is_in_front_row_by_name(s)

	assert(get_member_by_name(h1) ~= s, '英雄和小兵重复:' .. table.concat({h1, h2, s}, ', '))
	assert(get_member_by_name(h2) ~= s, '英雄和小兵重复:' .. table.concat({h1, h2, s}, ', '))

	-- 2前排英雄
	if is_front_h1 and is_front_h2 then
		return gen_groups_3_hhs_1_1_x(h1, h2, s, difficulty, is_boss)

	-- 1前排英雄, 1后排英雄, 1后排小兵
	elseif is_front_h1 and not is_front_h2 and not is_front_s then
		return gen_groups_3_hhs_1_2_2(h1, h2, s, difficulty, is_boss)

	-- 2后排英雄, 1前排小兵
	elseif not is_front_h1 and not is_front_h2 and is_front_s then
		return gen_groups_3_hhs_2_2_1(h1, h2, s, difficulty, is_boss)

	else
		error('不支持的3单位配置: ' .. table.concat({h1, h2, s}, ', '))
	end
end

local function gen_groups_3_sss_1_1_2(s1, s2, s3, difficulty, is_boss)
	local s1_counts, s2_counts, s3_counts
	if difficulty == '普通' then
		s1_counts = range(1, 8)
		s2_counts = range(1, 8)	
		s3_counts = range(1, 8)
	elseif difficulty == '困难' then
		s1_counts = range(1, 8)
		s2_counts = range(1, 8)	
		s3_counts = range(1, 8)
	else
		error(string.format('[%s, %s, %s] 不支持难度 [%s]', s1, s2, s3, difficulty))
	end

	local groups = {}
	for _, s1_count in ipairs(s1_counts) do
		for _, s2_count in ipairs(s2_counts) do
			for _, s3_count in ipairs(s3_counts) do
				add_group(groups, 'auto',
					s1, s1_count,
					s2, s2_count,
					s3, s3_count
				)
			end
		end
	end

	return groups
end

local function gen_groups_3_sss_1_2_2(s1, s2, s3, difficulty, is_boss)
	local s1_counts, s2_counts, s3_counts
	if difficulty == '普通' then
		s1_counts = range(1, 8)
		s2_counts = range(1, 8)	
		s3_counts = range(1, 8)
	elseif difficulty == '困难' then
		s1_counts = range(1, 8)
		s2_counts = range(1, 8)	
		s3_counts = range(1, 8)
	else
		error(string.format('[%s, %s, %s] 不支持难度 [%s]', s1, s2, s3, difficulty))
	end

	local groups = {}
	for _, s1_count in ipairs(s1_counts) do
		for _, s2_count in ipairs(s2_counts) do
			for _, s3_count in ipairs(s3_counts) do
				add_group(groups, 'auto',
					s1, s1_count,
					s2, s2_count,
					s3, s3_count
				)
			end
		end
	end

	return groups
end

local function gen_groups_3_sss(s1, s2, s3, difficulty, is_boss)
	local is_front_s1 = is_in_front_row_by_name(s1)
	local is_front_s2 = is_in_front_row_by_name(s2)
	local is_front_s3 = is_in_front_row_by_name(s3)

	-- 2前1后
	if is_front_s1 and is_front_s2 and not is_front_s3 then
		return gen_groups_3_sss_1_1_2(s1, s2, s3, difficulty, is_boss)

	-- 1前2后
	elseif is_front_s1 and not is_front_s2 and not is_front_s3 then
		return gen_groups_3_sss_1_2_2(s1, s2, s3, difficulty, is_boss)

	else
		error('不支持的3单位配置: ' .. table.concat({s1, s2, s3}, ', '))
	end
end

local function gen_groups_3(units, difficulty, is_boss)
	local u1, u2, u3 = units[1], units[2], units[3]
	local is_hero1 = is_hero_by_name(u1)
	local is_hero2 = is_hero_by_name(u2)
	local is_hero3 = is_hero_by_name(u3)

	if is_hero1 and is_hero2 and is_hero3 then
		return gen_groups_3_hhh(u1, u2, u3, difficulty, is_boss)
	elseif is_hero1 and is_hero2 and not is_hero3 then
		return gen_groups_3_hhs(u1, u2, u3, difficulty, is_boss)
	elseif not is_hero1 and not is_hero2 and not is_hero3 then
		return gen_groups_3_sss(u1, u2, u3, difficulty, is_boss)		
	else
		error('不支持的3单位配置: ' .. table.concat(units, ', '))
	end
end

function gen_groups(cfg)
	local ucount = #cfg.units
	local is_boss, difficulty = cfg.is_boss, cfg.difficulty

	if ucount == 1 then
		return gen_groups_1(cfg.units, difficulty, is_boss)
	elseif ucount == 2 then
		return gen_groups_2(cfg.units, difficulty, is_boss)
	elseif ucount == 3 then
		return gen_groups_3(cfg.units, difficulty, is_boss)
	else
		assert(false)
	end
end

function groups_normal_to_special(group, origin_name)
	local normal_name = string.gsub(origin_name, '特', '')
	local g1 = parse_group_name(origin_name)
	local g2 = parse_group_name(normal_name)

	local record = {}
	for i, name in ipairs(g1.units) do
		if string.match(name, '特殊') then
			if not record[name] then
				record[name] = 1
			else
				record[name] = record[name] + 1
			end
		end
	end

	for name, count in pairs(record) do
		local name_c = string.gsub(name, '特殊', '')
		local c = 0
		
		for i = 1, #group.units do
			if group.units[i] == name_c then
				group.units[i] = name
				c = c + 1
				if c >= count then
					break
				end
			end
		end
	end

	return group
end

local function get_units_by_row(r)
	local units = {}
	for i = 1, 24 do
		if r['Monster' .. i] then
			table.insert(units, r['Monster' .. i])
		end
	end
	return units
end

function get_gen_group_names(input_path, output_path)
	local input_t = File.read_table(input_path)
	local output_t = File.read_table(output_path)

	local output_by_names = {}
	for i = 1, output_t.row_count do
		local r = output_t.rows[tostring(i)]
		output_by_names[r.GroupName] = r
	end

	local names = {}
	for i = 1, input_t.row_count do
		local ri = input_t.rows[tostring(i)]
		local ro = output_by_names[ri.GroupName]		
		if not ri.IgnoreGen then
			if ro then
				local units = get_units_by_row(ro)
				if ro.VersionID ~= ri.VersionID or not is_ok_units(units) then
					table.insert(names, ri.GroupName)
				end	
			else
				table.insert(names, ri.GroupName)
			end
		end
	end

	return names
end

function add_row_to_output_table(t, name)
	local row = {}	
	row.GroupName = name

	local row_count = t.row_count + 1
	t.row_count = row_count
	t.rows[tostring(row_count)] = row

	return row
end

function update_group_output(results, input_path, output_path)
	local input_t = File.read_table(input_path)
	local output_t = File.read_table(output_path)

	local input_by_names = {}
	for i = 1, input_t.row_count do
		local r = input_t.rows[tostring(i)]
		input_by_names[r.GroupName] = r
	end
	
	local output_by_names = {}
	for i = 1, output_t.row_count do
		local r = output_t.rows[tostring(i)]
		output_by_names[r.GroupName] = r
	end

	-- 将input中的自定义项更新到output中
	for name, ri in pairs(input_by_names) do
		if ri.IgnoreGen then
			local ro = output_by_names[name]
			if not ro then
				ro = add_row_to_output_table(output_t, name)
			end

			ro.VersionID = ri.VersionID
			ro.Formation = ri.Formation
			for i = 1, 24 do
				ro['Monster' .. i] = ri['Monster' .. i]				
			end
		else
			local ro = output_by_names[name]
			if ro then
				ro.Formation = ri.Formation
			end
		end
	end

	-- 去除output中的多余项, 只能从后往前遍历
	for i = output_t.row_count, 1, -1  do
		local ro = output_t.rows[tostring(i)]
		local ri = input_by_names[ro.GroupName]
		if not ri then
			-- 去除多余项
			output_t.row_count = output_t.row_count - 1
			for j = i, output_t.row_count do
				output_t.rows[tostring(j)] = output_t.rows[tostring(j + 1)]
			end
			output_t.rows[tostring(output_t.row_count + 1)] = nil
		end
	end

	-- 写入result结果
	for _, r in ipairs(results) do
		local name, units = r.name, r.units
		local ri = input_by_names[name]
		local ro = output_by_names[name]
		if not ro then
			ro = add_row_to_output_table(output_t, name)
		end

		ro.Formation = ri.Formation
		ro.VersionID = ri.VersionID
		for i = 1, 24 do
			ro['Monster' .. i] = units[i]
		end
	end

	File.write_table(output_path, output_t)
end

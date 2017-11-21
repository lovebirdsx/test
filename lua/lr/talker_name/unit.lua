-------------------------------------------------------------------------------
-- Unit桩接口
-------------------------------------------------------------------------------
local CLASS_MAP = {
    ['盾甲'] = '盾甲',
    ['铁骑'] = '铁骑',
    ['强弓'] = '强弓',
    ['炼金'] = '炼金',
    ['法师'] = '法师',
    ['刺客'] = '刺客',
    ['张飞'] = '盾甲',
    ['[B]张飞'] = '盾甲',
    ['黄忠'] = '强弓',
    ['[B]黄忠'] = '强弓',
}

local FRONT_CLASS = {
    ['盾甲'] = true,
    ['铁骑'] = true,
}

local HERO_MAP = {
    ['盾甲'] = false,
    ['铁骑'] = false,
    ['强弓'] = false,
    ['炼金'] = false,
    ['法师'] = false,
    ['刺客'] = false,
    ['张飞'] = true,
    ['[B]张飞'] = true,
    ['黄忠'] = true,
    ['[B]黄忠'] = true,
}

function get_name(unit)
    return unit.name
end

function is_dead(unit)
    return unit.is_dead
end

function kill(unit)
    unit.is_dead = true
end

function get_class(unit)
    if type(unit) == 'table' then
        return CLASS_MAP[unit.name]
    else
        return CLASS_MAP[unit]
    end
end

function is_hero(unit)
    if type(unit) == 'table' then
        return HERO_MAP[unit.name]
    else
        return HERO_MAP[unit]
    end
end

function is_in_front_row(unit)
    return FRONT_CLASS[get_class(unit)]
end

function get_units(obj)
    return obj
end

function get_pos(unit)
    return unit.pos
end

function create_units(unit_names)
    local obj = {}

    for _, unit_name in ipairs(unit_names) do
        local unit = {
            name = unit_name,
            pos = {
                x = math.random(1, 1000),
                y = math.random(1, 1000),
            },
            is_dead = false
        }
        obj[#obj + 1] = unit
    end

    return obj
end

-------------------------------------------------------------------------------
-- 工具性函数
-------------------------------------------------------------------------------

function warn(fmt, ...)
    print('W', string.format(fmt, ...))
end

function debug(fmt, ...)
    print('D', string.format(fmt, ...))
end

function random(a, b)
    return math.random(a, b)
end

function world2display(x, y)
    return x, y
end

function get_random_d()
    return 40
end

function table.is_array(t)
    local max = 0
    local count = 0
    for k, v in pairs(t) do
        if type(k) == 'number' then
            if k > max then max = k end
            count = count + 1
        else
            return false
        end
    end
    if max > count * 2 then
        return false
    end

    return true
end

function table.tostring(t, indent)
	indent = indent or '\t'
	local function str(t, n)
		local indent_str1 = string.rep(indent, n)
		local indent_str2 = string.rep(indent, n + 1)
		if type(t) == 'table' then
			if table.is_array(t) then
				local strs = {}
				for i = 1, #t do
					local v = t[i]
					if type(v) == 'table' then
						strs[i] = str(v, n + 1)
					else
						strs[i] = tostring(v)
					end
				end
				return '{' .. table.concat(strs, ', ') ..'}'
			else
				local strs = {}
				for k, v in pairs(t) do
					if type(v) == 'table' then
						strs[#strs + 1] = indent_str2 .. tostring(k) .. ' = ' .. str(v, n + 1)
					else
						strs[#strs + 1] = indent_str2 .. tostring(k) .. ' = ' .. tostring(v)
					end
				end
				return '{\n' .. table.concat(strs, ',\n') .. indent_str1 .. '\n' .. indent_str1 .. '}'
			end
		else
			return indent_str1 .. tostring(t)
		end
	end

	return str(t, 0)
end

-------------------------------------------------------------------------------
-- talker
-------------------------------------------------------------------------------

local talk_unit_map = {}
function talk_map(key, unit)
    talk_unit_map[key] = unit
end

function get_talker(key)
    return talk_unit_map[key]
end

function clear_talk_map()
    talk_unit_map = {}
end

function get_all_talk_map()
    return talk_unit_map
end


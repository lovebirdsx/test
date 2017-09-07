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

local units = {
    {name = 'A', pos = {x = 100, y = 100}},
    {name = 'A', pos = {x = 120, y = 98}},
    {name = 'A', pos = {x = 130, y = 102}},
    {name = 'A', pos = {x = 130, y = 80}},
    {name = 'B', pos = {x = 100, y = 100}},
    {name = 'C', pos = {x = 100, y = 100}},
}

function get_units(obj)
    return units
end

function world2display(x, y)
    return x, y
end

function get_title(unit)
    return unit.name
end

function sd_get_enemy_group(id)
    return nil
end

function get_pos(unit)
    return unit.pos
end

function get_random_d()
    return 5
end

function talk_map(key, unit)
    print(key, unit.name, unit.pos.x, unit.pos.y)
end

function sd_map_talker(id)
    -- 生成记录
	local records = {}
    for i, u in ipairs(get_units(sd_get_enemy_group(id))) do
        local pos = get_pos(u)
        local wx, wy = pos.x, pos.y
        local sx, sy = world2display(wx, wy)

        local name = get_title(u)
        if not records[name] then
            records[name] = {}
        end

        table.insert(records[name], {unit = u, x = sx, y = sy})
    end

    -- 排序
    local d = get_random_d()
    for name, units_records in pairs(records) do        
        table.sort(units_records, function (a, b)
            if math.abs(a.y - b.y) <= d then
                if math.abs(a.x - b.x) <= d then
                    return false
                else
                    return a.x < b.x
                end
            else
                return a.y < b.y
            end
        end)
    end

    -- 映射
    for name, units_records in pairs(records) do
        for i, record in ipairs(units_records) do
            local key = string.format('第%d波%s%d', id, name, i)
            talk_map(key, record.unit)
        end
    end
end

sd_map_talker(1)
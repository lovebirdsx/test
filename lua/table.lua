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

function table.reverse(t)
    local r = {}
    for i = 1, #t do
        r[i] = t[#t - i + 1]
    end
    return r
end

function table.contains(t1, t2)
    local r = {}
    for _, e in ipairs(t1) do
        if r[e] then
        	r[e] = r[e] + 1
        else
        	r[e] = 1
        end
    end

    for _, e in ipairs(t2) do
        if not r[e] or r[e] <= 0 then
            return false
        end
        r[e] = r[e] - 1
    end

    return true
end

function table.array_to_kv(t, key)
	local r = {}
	for _, e in ipairs(t) do
		assert(e[key], 'no key ' .. key)
		r[e[key]] = e
	end
	return r
end

-- table.tostirng
print(table.tostring({
	b = {
		foo = 1,
		c = function () end,
		bar = { 1, 2, {1, 2}, 3, 4, 5 }
	},
	a = wahaha
}))

print(table.tostring(
	table.array_to_kv(
		{
			{name='foo', value='foo_value'},
			{name='bar', value='bar_value'},
		},
		'name'
	)
))


--[[table.reverse
local t = {1,2,3,4,5}
print(table.tostring(t))
print(table.tostring(table.reverse(t)))
--]]


local a = {nil, 2, 3}
print(table.unpack(nil))

function parse_name(name)
	local troop_type, difficulty, units_type = string.match(name, '([^-]+)-([^-]+)-([^-]+)')
	return {troop_type = troop_type, difficulty = difficulty, units_type = units_type, name = name}
end

function parse_squad_names(names)
	local r = {}
	for _, name in ipairs(names) do
		table.insert(r, parse_name(name))
	end
	return r
end

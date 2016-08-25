require('json')

function write_file(path, s)
	local f = assert(io.open(path, 'w+'))
	assert(f:write(s))
	f:close()
end

function write_josn(t, path)
	local out = JSON:encode_pretty(t)
	write_file(path, out)
end

function gen_unit_cfg(dir)	
	local unit_cfg = require('unit_cfg')
	write_josn(unit_cfg, dir .. '/unit_cfg.json')
end

function gen_level_cfg(dir)
	local level_cfg = require('level_cfg')
	write_josn(level_cfg, dir .. '/level_cfg.json')
end

function main()
	local dir = arg[1] or '.'
	gen_unit_cfg(dir)
	gen_level_cfg(dir)
end

main()
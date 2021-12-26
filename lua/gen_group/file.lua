local Json = import('json')

local M = {}

function M.write(path, str)
	local f, err = io.open(path, 'w+')
	if not f then
		print(string.format('write file %s failed: %s', path, err))
        return false
	end
	f:write(str)
	f:close()
    return true
end

function M.read(path)
    local f, err = io.open(path)
    if not f then
        print(string.format('read file %s failed: %s', path, err))
    else
	    local str = f:read('*all')
	    f:close()
	    return str
    end
end

function M.read_table(path)
	local s = M.read(path)
	if s then
		return Json:decode(s)
	else
		return nil
	end
end

function M.write_table(path, t)
	local s = Json:encode_pretty(t)
	return M.write(path, s)
end

function M.copy(from, to)
    local content = M.read(from)
    M.write(to, content)
end

function M.cut(from, to)
	local content = M.read(from)
    M.write(to, content)
    M.remove(from)
end

return M

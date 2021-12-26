
function file_exists(name)
	local f = io.open(name,"r")
	if f ~= nil then io.close(f) return true else return false end
end

function directory_exists(path)
	local response = os.execute('cd ' .. path)
	return response == 0 and true or false
end

local sb3_snippet_dir = os.getenv('APPDATA') .. '/Sublime Text 3/Packages/User'

print(file_exists('lanuage.lua'))
print(file_exists('not_exsit.lua'))
print(file_exists(sb3_snippet_dir))

print(directory_exists(sb3_snippet_dir))
print(directory_exists('C:/not_exsit'))
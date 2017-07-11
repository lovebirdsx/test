local socket = require('socket')
local cmd = [[
--START
G.notify_ui('ui.battle.pause_menu', 'restart')
--END
]]
local s = socket.tcp()
print(s:connect('localhost', 4221))
print(s:send(cmd))
print(s:close())
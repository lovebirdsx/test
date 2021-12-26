local game = require 'flow.game'
local msg = require 'flow.message'

local function GameObj1()
	local M = {}
	local update_count = 0

	function M.url()
		return 'obj1'
	end

	function M.update(dt)
		update_count = update_count + 1
		if update_count < 5 then
			print('obj1 update_count = ', update_count)
		else
			msg.post('obj2', 'exit_game', {reason = 'why not!'})
			print(M.url(), 'send', 'exit_game', 'to', 'obj2')
		end
	end

	function M.on_message(message_id, message, sender)
		print(M.url(), 'recv', message_id, 'from', sender)
	end

	return M
end

local function GameObj2()
	local M = {}

	function M.url()
		return 'obj2'
	end

	function M.on_message(message_id, message, sender)
		if message_id == 'exit_game' then
			print(M.url(), 'recv', message_id, 'from', sender)
			msg.post(sender, 'exit_game_response')
			game.exit()
		end
	end

	return M
end

game.add_obj(GameObj1())
game.add_obj(GameObj2())
game.run(100)
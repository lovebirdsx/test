require 'message'

local flow = require 'flow'
local game = require 'game'

local function Quiter(active_times)
	local M = {}
	local flow = flow.create()

	function M.url()
		return 'quiter'
	end

	function M.init()
		flow.start(function ()
			flow.wait_message('start_quit')
			for i = 1, active_times do
				flow.wait_message('quit')
			end
			print('game.exit()')
			game.exit()
		end)
	end

	function M.update(dt)
		flow.update(dt)
	end

	function M.on_message(message_id, message, sender)
		flow.on_message(message_id, message, sender)
	end

	return M
end

local function Runner(id, times)
	local M = {}
	local flow = flow.create()

	function M.url()
		return 'runner' .. id
	end

	function M.init()
		flow.start(function ()
			for i = 1, times do
				flow.wait(1)
			end

			msg.post('quiter', 'quit')
		end)
	end

	function M.update(dt)
		flow.update(dt)
	end

	function M.on_message(message_id, message, sender)
		flow.on_message(message_id, message, sender)
	end

	return M
end

local function Controller()
	local M = {}
	local flow = flow.create()

	function M.url()
		return 'controller'
	end

	function M.init()
		flow.start(function ()
			local active_times = 3
			game.add_obj(Quiter(active_times))
			for i = 1, active_times do
				game.add_obj(Runner(i, i * 2))
			end
			flow.wait(0.1)
			msg.post('quiter', 'start_quit')
		end)
	end

	function M.update(dt)
		flow.update(dt)
	end

	function M.on_message(message_id, message, sender)
		flow.on_message(message_id, message, sender)
	end

	return M
end

game.add_obj(Controller())
game.run()

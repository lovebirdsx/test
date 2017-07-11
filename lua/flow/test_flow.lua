local msg = require 'message'
local flow = require 'flow'
local game = require 'game'

local function printf(fmt, ...)
	print(string.format(fmt, ...))
end

local function create_quiter(active_times)
	local Quiter = {}

	function Quiter.url()
		return 'quiter'
	end

	function Quiter.init()
		flow.start(function ()
			print(flow.wait_message('start_quit'))
			for i = 1, active_times do
				print(flow.wait_message('quit'))
				printf('quiter %d', i)
			end
			print('game.exit()')
			game.exit()
		end)
	end

	function Quiter.on_message(message_id, message, sender)
		flow.on_message(message_id, message, sender)
	end

	return Quiter
end

local function create_runner(id, times)
	local Runner = {}

	function Runner.url()
		return 'runner' .. id
	end

	function Runner.init()
		flow.start(function ()
			for i = 1, times do
				flow.wait(1)
			end

			msg.post('quiter', 'quit')
		end)
	end

	function Runner.on_message(message_id, message, sender)
		flow.on_message(message_id, message, sender)
	end

	return Runner
end

local function Controller()
	local M = {}

	function M.url()
		return 'controller'
	end

	function M.init()
		flow.start(function ()
			local active_times = 3
			game.add_obj(create_quiter(active_times))
			for i = 1, active_times do
				game.add_obj(create_runner(i, math.random(1, 10)))
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

math.randomseed(os.time())
game.add_obj(Controller())
game.run()

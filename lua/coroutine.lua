local t = 0

function get_time()
	return t
end

local ai = {}
function ai.wait_conditon(c)
	while not c() do
		coroutine.yield()
	end
end

function ai.wait(time)
	local end_time = get_time() + time
	ai.wait_conditon(function() return get_time() >= end_time end)
end

function ai.stop()

end

function ai_main()
	print('ai_main', get_time())
	ai.wait(1)
	print('ai_main', get_time())
end

local ai_fun

local game = {}
function game.init()
	ai_fun = coroutine.create(ai_main)
end

function game.frame()	
	if coroutine.status(ai_fun) ~= 'dead' then
		coroutine.resume(ai_fun)
	end

	t = t + 1 / 30
end

function main()
	game.init()
	while coroutine.status(ai_fun) ~= 'dead' do
		game.frame()
	end
end

main()
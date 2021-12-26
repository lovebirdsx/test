require('game')

function test_wait()
	local g = Game()

	local function bar(name, count)
		for i = 1, count do
			print('bar', name, i)
			g:wait(0.5)
		end
	end

	local function foo(name, count)
		g:start_thread(bar, name, count)
		for i = 1, count do
			print('foo', name, i)
			g:wait(1)
		end
	end
	g:start_thread(foo, 'a', 5)
	g:start_thread(foo, 'b', 10)

	g:run()
end

function test_stage()
	local g = Game()

	local function show_help()
		set_camera(get_config('ViewPoint', 'ShowStart'))
		move_camera(get_config('ViewPoint', 'ShowEnd'))
		wait_camera()
	end

	local function stage_fun()
		show_help()
		game_logic()
		win()
	end

	g:start_thread(stage_fun)
	g:run()
end

test_wait()
-- test_stage()
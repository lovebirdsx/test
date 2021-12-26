local msg = require 'flow.message'
local flow = require 'flow.flow'
local game = require 'flow.game'

local function printf(fmt, ...)
    print(string.format(fmt, ...))
end

local function Quiter(active_times)
    local I = {}

    function I.url()
        return 'quiter'
    end

    function I.init()
        flow.start(function()
            print(flow.wait_message('start_quit'))
            for i = 1, active_times do
                print(flow.wait_message('quit'))
                printf('quiter %d', i)
            end
            print('game.exit()')
            game.exit()
        end)
    end

    function I.on_message(message_id, message, sender)
        flow.on_message(message_id, message, sender)
    end

    return I
end

local function Runner(id, times)
    local I = {}

    function I.url()
        return 'runner' .. id
    end

    function I.init()
        flow.start(function ()
            print('Runner', id, 'start at', game.time())
            local message, message_id = flow.wait_message_timeout(1, 'exit_runner')
            if message_id then
                print('Runner', id, 'exit by', message_id)
            else
                print('Runner', id, 'exit by', 'timeout', game.time())
            end
            msg.post('quiter', 'quit')
        end)
    end

    function I.on_message(message_id, message, sender)
        print('Runner.on_message', message_id)
        flow.on_message(message_id, message, sender)
    end

    return I
end

local function Controller()
    local I = {}

    function I.url()
        return 'controller'
    end

    function I.init()
        flow.start(function()
            local runner_count = 3
            game.add_obj(Quiter(runner_count))

            local runners = {}
            for i = 1, runner_count do
                runners[i] = Runner(i, math.random(1, 10))
                game.add_obj(runners[i])
            end

            flow.wait(0.1)
            msg.post('quiter', 'start_quit')

            for i = 1, runner_count do
                flow.start(function ()
                    flow.wait(math.random(0.5, 1.5))
                    msg.post(runners[i].url(), 'exit_runner')
                end)
            end
        end)
    end

    function I.update(dt)
        flow.update(dt)
    end

    function I.on_message(message_id, message, sender)
        flow.on_message(message_id, message, sender)
    end

    return I
end

math.randomseed(os.time())
game.add_obj(Controller())
game.run()

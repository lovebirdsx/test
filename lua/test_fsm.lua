-- ********************************************************
-- Normal
-- require('fsm')
-- local fsm = create_fsm {
--   initial = 'green',
--   events = {
--     { name = 'warn',  from = 'green',  to = 'yellow' },
--     { name = 'panic', from = 'yellow', to = 'red'    },
--     { name = 'calm',  from = 'red',    to = 'yellow' },
--     { name = 'clear', from = 'yellow', to = 'green'  }
--   }
-- }

-- print(fsm.current)
-- fsm.warn() 
-- print(fsm.current)
-- fsm.panic()
-- print(fsm.current)
-- fsm.calm() 
-- print(fsm.current)
-- fsm.clear()
-- print(fsm.current)
-- print(fsm.is('green'))
-- print(fsm.is('red'))
-- print(fsm.can('clear'))
-- print(fsm.can('warn'))
-- print(fsm.cannot('clear'))


-- ********************************************************
-- Mutiple state
-- require('fsm')
-- local fsm = create_fsm {
--   initial = 'hungry',
--   events = {
--     { name = 'eat',  from = 'hungry',     to = 'satisfied' },
--     { name = 'eat',  from = 'satisfied',  to = 'full'      },
--     { name = 'eat',  from = 'full',       to = 'sick'      },
--     { name = 'rest', from = '*',          to = 'hungry'    },
--     -- { name = 'rest', from = {'hungry', 'satisfied', 'full', 'sick'}, to = 'hungry'    },
-- }}

-- fsm.eat()
-- print(fsm.current)

-- fsm.eat()
-- print(fsm.current)

-- fsm.eat()
-- print(fsm.current)

-- fsm.rest()
-- print(fsm.current)

-- fsm.eat()
-- print(fsm.current)

-- ********************************************************
-- Callbacks
require('fsm')
local fsm = create_fsm {
  initial = 'green',
  events = {
    { name = 'warn',  from = 'green',  to = 'yellow' },
    { name = 'panic', from = 'yellow', to = 'red'    },
    { name = 'calm',  from = 'red',    to = 'yellow' },
    { name = 'clear', from = 'yellow', to = 'green'  }
  },
  callbacks = {
    on_panic =  function(event, from, to, msg) print('panic! ' .. msg)    end,
    on_clear =  function(event, from, to, msg) print('thanks to ' .. msg) end,
    on_green =  function(event, from, to)      print('green light')       end,
    on_yellow = function(event, from, to)      print('yellow light')      end,
    on_red =    function(event, from, to)      print('red light')         end,
    on_state_change = function(event, from, to) print(from, '->', to) end,
  }
}

fsm.warn()
fsm.panic('killer bees')
fsm.calm()
fsm.clear('sedatives in the honey pots')

-- ********************************************************
-- Async Test
-- require('fsm')

-- local manager = {}
-- function manager.switch(state)
--   print('switch', state)
-- end

-- function manager.slide(speed, cb)
--   print('slide', speed)
--   manager.cb = cb
--   manager.state = 'slide'
-- end

-- function manager.fade(speed, cb)
--   print('fade', speed)
--   manager.cb = cb
--   manager.state = 'fade'
-- end

-- function manager.update()
--   if manager.state then
--     print(manager.state, 'ok')
--     manager.cb()
--     manager.state = nil
--   end
-- end

-- local fsm
-- fsm = create_fsm {
--   initial = 'menu',
--   events = {
--     { name = 'play', from = 'menu', to = 'game' },
--     { name = 'quit', from = 'game', to = 'menu' }
--   },
--   callbacks = {
--     on_enter_menu = function() manager.switch('menu') end,
--     on_enter_game = function() manager.switch('game') end,
--     on_leave_menu = function()
--       manager.fade('fast', function()
--         fsm.transition()
--       end)
--       return 'async'
--     end,
--     on_leave_game = function()
--       manager.slide('slow', function()
--         fsm.transition()
--       end)
--       return 'async'
--     end,
--     on_state_change = function(event, from, to)
--       print(event, from, to)
--     end
--   }
-- }

-- fsm:play()
-- manager.update()
-- fsm:quit()
-- manager.update()

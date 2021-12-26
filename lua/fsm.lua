function create_fsm(options)
    local fsm = {}

    local function call_handler(handler, params)
        if handler then
            return handler(table.unpack(params))
        end
    end

    local function build_event(name)
        return function (...)
            if fsm.transition then
                error('transition not finish [' .. fsm.current .. ']')
            end

            local can, to = fsm.can(name)
            if not can then
                error(string.format('can not apply event [%s] from [%s]', name, fsm.current))
            end

            local from = fsm.current
            local params = {name, from, to, ... }
            if call_handler(fsm['on_before_' .. name], params) == false then
                return false
            end

            if from == to then 
                call_handler(fsm['on_after_' .. name] or fsm['on_' .. name], params)
                return true
            end

            fsm.transition = function ()
                fsm.transition = nil
                fsm.current = to
                call_handler(fsm['on_enter_' .. to] or fsm['on_' .. to], params)
                call_handler(fsm['on_after_' .. name] or fsm['on_' .. name], params)
                call_handler(fsm['on_state_change'], params)
                return true
            end

            fsm.cancle = function ()
                fsm.transition = nil
                call_handler(fsm['on_after_' .. name] or fsm['on_' .. name], params)
            end

            local leave = call_handler(fsm['on_leave_' .. from], params)
            if leave == false then
                fsm.transition = nil
                return false
            elseif leave == 'async' then
                return true
            else
                fsm.transition()
            end            
        end
    end

    local function add_to_map(map, event)
        if type(event.from) == 'string' then
            map[event.from] = event.to
        else
            for _, from in ipairs(event.from) do
                map[from] = event.to
            end
        end
    end

    function fsm.init(options)
        assert(options.events)

        fsm.options = options
        fsm.current = options.initial or 'none'
        fsm.events = {}

        for _, event in ipairs(options.events or {}) do
            local name = event.name
            fsm[name] = fsm[name] or build_event(name)
            fsm.events[name] = fsm.events[name] or { map = {} }
            add_to_map(fsm.events[name].map, event)
        end
    
        for name, callback in pairs(options.callbacks or {}) do
            fsm[name] = callback
        end

        return fsm
    end

    function fsm.is(state)
        return fsm.current == state
    end

    function fsm.can(e)
        local event = fsm.events[e]
        local to = event and event.map[fsm.current] or event.map['*']
        return to ~= nil, to
    end

    function fsm.cannot(e)
        return not fsm.can(e)
    end

    fsm.init(options)
    return fsm
end
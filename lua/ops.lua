function create_ops(obj)
    local ops, state_funs = {}, {}
    local curr_state_fun, curr_state_cfg, s_id, state_list, loop_left
    local next_update_time, is_paused
    local empty_bool_fun = function () return true end
    local empty_void_fun = function () end

    function ops.reg(state_name, update_fun, enter_fun, exit_fun)
        state_funs[state_name] = {
            update = update_fun or empty_bool_fun,
            enter = enter_fun or empty_void_fun,
            exit = exit_fun or empty_void_fun
        }
    end

    local function reg_default_ops()
        local default = {}
        local wait_end
        function default.enter_wait(time)
            wait_end = get_time() + time
        end

        function default.update_wait()
            return get_time() >= wait_end
        end

        function default.update_wait_unit(unit)
            return get_unit_cmd_list_length(unit) <= 0
        end

        function default.update_wait_boss_hp(boss, percent)
            local hp, max_hp = boss_get_hp(boss)
            return hp / max_hp <= percent
        end

        function default.enter_send_user_msg(...)
            if param.params then
                send_user_msg(param.type, ...)
            else
                send_user_msg(param.type)
            end
        end

        function default.enter_start_ops(ops, op_list, loop)
            ops.start(op_list, loop)
        end

        function default.update_wait_ops(ops)
            return ops.is_finish()
        end

        ops.auto_reg(default)
    end

    function ops.auto_reg(obj)
        local update_map, enter_map, exit_map, names_map = {}, {}, {}, {}

        local function check_and_add(key, fun, regx, map)
            local a = string.match(key, regx)
            if a then 
                map[a] = fun
                names_map[a] = true
                return true
            end
        end

        for key, fun in pairs(obj) do
            if type(fun) == 'function' then
                if not check_and_add(key, fun, 'update_([%a_]+)', update_map) then
                    if not check_and_add(key, fun, 'enter_([%a_]+)', enter_map) then
                        check_and_add(key, fun, 'exit_([%a_]+)', exit_map)
                    end
                end
            end
        end

        for name, _ in pairs(names_map) do
            ops.reg(name, update_map[name], enter_map[name], exit_map[name])
        end
    end

    function ops.start(list, loop_times)
        state_list = list
        loop_left = loop_times or 1
        is_paused = false
        s_id = 0
        ops._enter_next_state()
    end

    function ops.pause()
        is_paused = true
    end

    function ops.resume()
        is_paused = false
    end

    local function unpack(t)
        if t then return table.unpack(t) end
    end

    function ops._enter_next_state()
        if ops.is_finish() then return end

        if s_id >= 1 then
            curr_state_fun.exit(unpack(curr_state_cfg.param))
        end

        s_id = s_id + 1

        if s_id > #state_list then
            if loop_left > 0 then
                loop_left = loop_left - 1
                if loop_left > 0 then
                    s_id = 1
                end
            elseif loop_left == -1 then
                s_id = 1
            end            
        end

        if s_id <= #state_list then
            curr_state_cfg = state_list[s_id]            
            curr_state_fun = state_funs[curr_state_cfg.op]
            assert(curr_state_fun, 'can not find op type ' .. curr_state_cfg.op)
            curr_state_fun.enter(unpack(curr_state_cfg.param))
            next_update_time = get_time()
        end
    end

    function ops.frame()
        if is_paused or ops.is_finish() then return end

        local now = get_time()
        if now >= next_update_time then
            local r = curr_state_fun.update(unpack(curr_state_cfg.param))
            if r then
                ops._enter_next_state()
            else
                if curr_state_cfg.interval then
                    next_update_time = next_update_time + curr_state_cfg.interval
                end
            end
        end
    end

    function ops.is_finish()
        return s_id > #state_list
    end

    function ops.debug()
        for name, funs in pairs(state_funs) do
            print(name, funs.update, funs.enter, funs.exit)
        end
    end

    function ops.init(obj)
        reg_default_ops()
        if obj then
            ops.auto_reg(obj)
        end
        is_paused = true
    end

    ops.init(obj)
    return ops
end
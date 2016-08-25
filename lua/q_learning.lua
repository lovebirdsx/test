local is_debug = false

function debug(fmt, ...)
    if is_debug then
        print(string.format(fmt, ...))
    end
end

function table.max(t)
    local max = t[1]
    for i = 2, #t do
        if t[i] > max then
            max = t[i]
        end
    end
    return max
end

function episode(R, Q, r)
    local s0 = math.random(1, #R)
    local row = R[s0]
    local next_states = {}
    for i = 1, #row do
        if row[i] ~= -1 then
            next_states[#next_states + 1] = i
        end
    end

    local s1 = next_states[math.random(1, #next_states)]
    debug('s0', s0)
    debug('s1', s1)
    debug('before Q[%d][%d] = %g', s0, s1, Q[s0][s1])

    local Q_row = Q[s1]
    local Q_row_ok = {}
    for i = 1, #Q_row do
        if Q_row[i] ~= -1 then
            Q_row_ok[#Q_row_ok + 1] = Q_row[i]
        end
    end

    Q[s0][s1] = R[s0][s1] + r * table.max(Q_row_ok)
    debug('after  Q[%d][%d] = %g', s0, s1, Q[s0][s1])
end

function print_m(m)
    for i = 1, #m do
        local r = m[i]
        for j = 1, #r do
            io.write(r[j] .. '\t')
        end
        io.write('\n')
    end
end

function test()
    local r = 0.8
    local R = {
        {-1,-1,-1,-1,0,-1},
        {-1,-1,-1,0,-1,100},
        {-1,-1,-1,0,-1,-1},    
        {-1,0,0,-1,0,-1},    
        {0,-1,-1,0,-1,100},
        {-1,0,-1,-1,0,100},
    }

    local Q = {
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
    }

    for i = 1, 10000 do
        episode(R, Q, r)
    end

    print('R')
    print_m(R)
    print('Q')
    print_m(Q)
end

function test_step()
    local r = 0.8    
    local R = {
        {-1,-1,-1,-1,0,-1},
        {-1,-1,-1,0,-1,100},
        {-1,-1,-1,0,-1,-1},    
        {-1,0,0,-1,0,-1},    
        {0,-1,-1,0,-1,100},
        {-1,0,-1,-1,0,100},
    }

    local Q = {
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
    }

    is_debug = true
    for i = 1, 10 do
        episode(R, Q, r)
    end
end

-- test_step()
test()

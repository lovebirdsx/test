local DIR_N = 1
local DIR_N_NE = 9
local DIR_NE = 2
local DIR_E_NE = 10
local DIR_E = 3
local DIR_E_SE = 11
local DIR_SE = 4
local DIR_S_SE = 12
local DIR_S = 5
local DIR_S_SW = 13
local DIR_SW = 6
local DIR_W_SW = 14
local DIR_W = 7
local DIR_W_NW = 15
local DIR_NW = 8
local DIR_N_NW = 16

local DIR_ANGLES = {
    [DIR_N] =       math.pi / 8 * 10,
    [DIR_N_NE] =    math.pi / 8 * 11,
    [DIR_NE] =      math.pi / 8 * 12,
    [DIR_E_NE] =    math.pi / 8 * 13,
    [DIR_E] =       math.pi / 8 * 14,
    [DIR_E_SE] =    math.pi / 8 * 15,
    [DIR_SE] =      math.pi / 8 * 16,
    [DIR_S_SE] =    math.pi / 8 * 1,
    [DIR_S] =       math.pi / 8 * 2,
    [DIR_S_SW] =    math.pi / 8 * 3,
    [DIR_SW] =      math.pi / 8 * 4,
    [DIR_W_SW] =    math.pi / 8 * 5,
    [DIR_W] =       math.pi / 8 * 6,
    [DIR_W_NW] =    math.pi / 8 * 7,
    [DIR_NW] =      math.pi / 8 * 8,
    [DIR_N_NW] =    math.pi / 8 * 9,
}

-- 获得朝向的角度
function dir2angle(dir)
    return DIR_ANGLES[dir]
end

function format_pos(p)
    return p
end

local INDEX_TO_DIR = {
    DIR_S_SE,
    DIR_S,
    DIR_S_SW,
    DIR_SW,
    DIR_W_SW,
    DIR_W,
    DIR_W_NW,
    DIR_NW,
    DIR_N_NW,
    DIR_N,
    DIR_N_NE,
    DIR_NE,
    DIR_E_NE,
    DIR_E,
    DIR_E_SE,
    DIR_SE,
}
-- 获得点a到点b的方向
function pos2dir(a, b)
    local pa = format_pos(a)
    local pb = format_pos(b)

    local a = math.atan(pb.y - pa.y, pb.x - pa.x)
    if a < 0 then a = a + math.pi * 2 end
    local div_a = 2 * math.pi / 16
    local index = math.floor((a - div_a / 2) / div_a + 0.5)
    print(string.format('(%s,%s)->(%s,%s) a = %s deg = %s index = %s', pa.x, pa.y, pb.x, pb.y, a, math.deg(a), index))
    if index == 0 then index = 16 end
    return INDEX_TO_DIR[index]
end

local DIR_TO_STRING = {
    [DIR_S_SE] = 'sse',
    [DIR_S] = 's',
    [DIR_S_SW] = 'ssw',
    [DIR_SW] = 'sw',
    [DIR_W_SW] = 'wsw',
    [DIR_W] = 'w',
    [DIR_W_NW] = 'wnw',
    [DIR_NW] = 'nw',
    [DIR_N_NW] = 'nnw',
    [DIR_N] = 'n',
    [DIR_N_NE] = 'nne',
    [DIR_NE] = 'ne',
    [DIR_E_NE] = 'ene',
    [DIR_E] = 'e',
    [DIR_E_SE] = 'ese',
    [DIR_SE] = 'se',
}
function dir2str(dir)
    return DIR_TO_STRING[dir]
end

function test_pos2dir_by_angle(a)
    local p1 = {x = 0 , y = 0}
    local x2, y2 = 100 * math.cos(a), 100 * math.sin(a)
    local p2 = {x = x2, y = y2}
    local dir = pos2dir(p1, p2)
    print(string.format('angle = %s, result = %s', math.deg(a), dir2str(dir)))
end

function test_pos2dir()
    for i = 1, 32 do
        local a = math.pi * 2 / 32 * i
        test_pos2dir_by_angle(a)
    end
end

function test_math_atan()
    local function help(x, y)
        local atan = math.atan(y, x)
        local deg = math.deg(atan)
        print(string.format('(%2s,%2s) -> %3s atan -> %s', x, y, deg, atan))
    end

    help(1, 0)
    help(1, 1)
    help(0, 1)
    help(-1, 1)
    help(-1, 0)
    help(-1, -1)
    help(0, -1)
    help(1, -1)
end

test_pos2dir()
-- test_pos2dir_by_angle(math.pi * 2 / 32 * 16)
-- test_pos2dir_by_angle(math.pi * 2 / 32 * 17)
-- print(_VERSION)
-- test_math_atan()
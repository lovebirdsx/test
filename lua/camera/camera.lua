-- 获得普通情况下镜头的默认缩放值
local function get_default_normal_view_scale()
    local MIN_ASPECT_RATIO = 960 / 540
    local MAX_ASPECT_RATIO = 1480 / 720
    local MIN_NORMAL_VIEW_SCALE = 0.5
    local MAX_NORMAL_VIEW_SCALE = 0.46

    local w, h = get_screen_size()
    local aspect_ratio = w / h

    -- 确保宽高比率处在可控的范围内
    if aspect_ratio < MIN_ASPECT_RATIO then
        aspect_ratio = MIN_ASPECT_RATIO
    end
    if aspect_ratio > MAX_ASPECT_RATIO then
        aspect_ratio = MAX_ASPECT_RATIO
    end

    -- 按照比例来算镜头的高度
    return MIN_NORMAL_VIEW_SCALE - (MIN_NORMAL_VIEW_SCALE - MAX_NORMAL_VIEW_SCALE) * (aspect_ratio - MIN_ASPECT_RATIO) / (MAX_ASPECT_RATIO - MIN_ASPECT_RATIO)
end

local _screen_w = 960
local _screen_h = 540
function get_screen_size()
    return _screen_w, _screen_h
end

function set_screen_size(w, h)
    _screen_w, _screen_h = w, h
end

local function get_view_scale(w, h)
    set_screen_size(w, h)
    return get_default_normal_view_scale()
end

local function test_case(w, h)
    print(w, h, get_view_scale(w, h))
end

local function test()
    local cases = {
        {w = 1280, h = 960},
        {w = 960, h = 540},
        {w = 960, h = 500},
        {w = 1480, h = 720},
    }

    for _, case in ipairs(cases) do
        test_case(case.w, case.h)
    end
end

test()
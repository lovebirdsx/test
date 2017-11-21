local _talker_prefix_record = {}

--[[ 记录对话映射记录
    unit        - 单位
    wave_id     - 第几波
    unit_name   - 为单位名字
    id          - 单位序号，类似于：1，2，3
]]
local function add_talker_prefix(unit, wave_id, unit_name, id)
    if not _talker_prefix_record[wave_id] then
        _talker_prefix_record[wave_id] = {
            unit_map = {},
            front_row = {},
            back_row = {},
            heroes = {}
        }
    end

    local wave_record = _talker_prefix_record[wave_id]
    
    local unit_map = wave_record.unit_map
    if not unit_map[unit_name] then
        unit_map[unit_name] = {}
    end    
    local unit_record = unit_map[unit_name]    
    unit_record[id] = unit
    
    if is_hero(unit) then
        local heroes = wave_record.heroes
        heroes[#heroes + 1] = unit
    else
        if is_in_front_row(unit) then
            local front_row = wave_record.front_row
            front_row[#front_row + 1] = unit
        else
            local back_row = wave_record.back_row
            back_row[#back_row + 1] = unit
        end
    end
end

function get_prefix_by_wave_id(wave_id)
    return string.format('第%d波', wave_id)
end

function format_talker_name(wave_id, unit_name, id)
    return string.format('第%d波%s%d', wave_id, unit_name, id)
end

function parse_talker_name(talker_name)
    local wave_id, unit_name, id = string.match(talker_name, '第([%d]+)波([^%d]+)([%d]+)')
    return tonumber(wave_id), unit_name, tonumber(id)
end

function talker_map_by_prefix_debug()
    print(table.tostring(_talker_prefix_record))
end

function clear_talker_map_by_prefix()
    _talker_prefix_record = {}
end

--[[ 查找满足条件的单位，用于冒泡
    - 1.若找不到对应名字的小兵，则优先寻找同职业的并且是活的小兵
    - 2.若没有活的同样职业的小兵，则寻找同样工种的活的小兵
    - 3.若还是没有同样工种的小兵，则在剩下活的小兵随机寻找一个显示
    - 4.若没有小兵剩下，则显示在活的boss头顶，有多个活的boss，则随机一个
]]
function get_talker_by_map_prefix(talker_name)
    local wave_id, unit_name, id = parse_talker_name(talker_name)
    if not wave_id then
        debug('get_talker_by_map_prefix 格式不符合: %s', talker_name)
        return nil
    end

    local wave_record = _talker_prefix_record[wave_id]
    if not wave_record then        
        warn('get_talker_by_map_prefix 没有适合的波次: %s', talker_name)
        return nil
    end

    -- 找同名的
    local unit_map = wave_record.unit_map
    local unit_record = unit_map[unit_name]
    if unit_record then
        local unit = unit_record[id]
        if unit then
            if not is_dead(unit) then
                return unit
            end
        else
            -- 1.若找不到对应名字的单位，则优先寻找同职业的并且是活的
            local ok_units = {}
            for id, unit in pairs(unit_record) do
                if not is_dead(unit) then
                    ok_units[#ok_units + 1] = unit
                end
            end
            if #ok_units > 0 then
                return ok_units[random(1, #ok_units)]
            end
        end
    end

    local function get_random_alive_unit(units)
        local ok_units = {}
        for _, unit in ipairs(units) do
            if not is_dead(unit) then
                ok_units[#ok_units + 1] = unit
            end
        end
        if #ok_units > 0 then
            return ok_units[random(1, #ok_units)]
        end
    end

    if not is_hero(unit_name) then
        -- 找同一排的小兵
        local row_record = is_in_front_row(unit_name) and wave_record.front_row or wave_record.back_row
        local unit = get_random_alive_unit(row_record)
        if unit then return unit end
        
        -- 找不同排的小兵
        local row_record = is_in_front_row(unit_name) and wave_record.back_row or wave_record.front_row
        local unit = get_random_alive_unit(row_record)
        if unit then return unit end
    end

    -- 找武将
    local unit = get_random_alive_unit(wave_record.heroes)
    if unit then return unit end
end

-- 获得单位在映射时使用的名字，会去掉名字中的`[B]`前缀
function filter_map_talker_name(unit_name)
    return string.gsub(unit_name, '%[B%]', '')
end

-- 映射怪物名字,用于对白和冒泡
-- 例如prefix为'第1波',怪物为 {张飞,盾甲,盾甲,盾甲,强弓,强弓,强弓}
-- 将映射成 {第1波张飞1,第1波盾甲1,第1波盾甲2,第1波盾甲3,第1波强弓1,第1波强弓2,第1波强弓3}
-- 同种单位的序号,按照屏幕方向从左到右,从上到下来依次确定
function map_talker_by_prefix(wave_id, obj)
    -- 生成记录
	local records = {}
    for i, u in ipairs(get_units(obj)) do
        local pos = get_pos(u)
        local wx, wy = pos.x, pos.y
        local sx, sy = world2display(wx, wy)

        local name = get_name(u)
        name = filter_map_talker_name(name)
        if not records[name] then
            records[name] = {}
        end

        table.insert(records[name], {unit = u, x = sx, y = sy})
    end

    -- 排序
    local d = get_random_d()
    for name, units_records in pairs(records) do        
        table.sort(units_records, function (a, b)
            if math.abs(a.y - b.y) <= d then
                if math.abs(a.x - b.x) <= d then
                    return false
                else
                    return a.x < b.x
                end
            else
                return a.y < b.y
            end
        end)
    end

    -- 映射
    for name, units_records in pairs(records) do
        for i, record in ipairs(units_records) do
            local key = format_talker_name(wave_id, name, i)
            talk_map(key, record.unit)
            add_talker_prefix(record.unit, wave_id, name, i)
        end
    end
end

--[[
自动映射当前战场上我方单位,将映射成:
    '我方英雄1', '我方小兵11', '我方小兵12', '我方小兵13'
    '我方英雄2', '我方小兵21', '我方小兵22', '我方小兵23'
    '我方英雄3', '我方小兵31', '我方小兵23', '我方小兵33'
]]
function talk_map_player_units()
    local function map_player_squad(s, id)
        local h = get_squad_leader(s)
        talk_map('我方英雄' .. id, h)
        local soldier_id = 1
        for _, unit in ipairs(get_units(s)) do
            if unit ~= h then
                talk_map('我方小兵' .. id .. soldier_id, unit)
                soldier_id = soldier_id + 1
            end
        end
    end

    for i = 1, 3 do
        local s = get_player_squad(i)
        if s then map_player_squad(s, i) end
    end
end

EXPRESSION_SURPRISED = '惊讶'
EXPRESSION_QUESTION = '疑问'
EXPRESSION_CRY = '吓哭'
EXPRESSION_TALK = '说话'
EXPRESSION_WIN = '胜利'
EXPRESSION_ANGRY = '生气'
EXPRESSION_HAPPY = '得意'
EXPRESSION_SHY = '害羞'
EXPRESSION_SWEAT = '汗'
EXPRESSION_AWKWARD = '尴尬'
EXPRESSION_HORNY = '色'

local EXPRESSION_BUFF_MAP = {
    ['惊讶'] = {'感叹号气泡表情', 40 / 30},
    ['疑问'] = {'问号气泡表情', 40 / 30},
    ['吓哭'] = {'吓哭气泡表情', 40 / 30},
    ['说话'] = {'说话气泡表情', 40 / 30},
    ['胜利'] = {'胜利气泡表情', 40 / 30},
    ['生气'] = {'生气气泡表情', 40 / 30},
    ['得意'] = {'得意气泡表情', 42 / 30},
    ['害羞'] = {'满意气泡表情', 40 / 30},
    ['汗'] = {'汗气泡表情', 50 / 30},
    ['尴尬'] = {'郁闷气泡表情', 50 / 30},
    ['色'] = {'色眯眯气泡表情', 40 / 30},
}

function hide_expression(obj, exp)
    local exp_cfg = assert(EXPRESSION_BUFF_MAP[exp], '不支持的表情: '..exp)
    local buff_name = exp_cfg[1]
    del_buff(obj, buff_name)
end

function show_expression(obj, exp, sync, cast_time)
    local exp_cfg = assert(EXPRESSION_BUFF_MAP[exp], '不支持的表情: '..exp)
    local buff_name, cfg_cast_time = exp_cfg[1], exp_cfg[2]
    cast_time = cast_time or cfg_cast_time
    add_buff(obj, nil, buff_name, cast_time)
    if sync then wait(cast_time) end
end

-- 显示强调
function show_emphasize(obj, bool)
    assert(count(obj) > 0, '显示强调失败,obj中的单位数量为0(有可能都已经死亡)')
    local buff_name = (is_enemy(get_first_unit(obj)) and '头顶箭头' or '友方头顶箭头')
    if bool then
        add_buff(obj, nil, buff_name)
    else
        del_buff(obj, buff_name)
    end
end

--[[ 头顶冒泡
list 为数组, list 每一项为一步
{ 角色名, 停留时间, 对话内容 }
示例: bubble {
 { 'Erica', 1, '哎哟哎哟', '高兴' },
 { 'Maria', 2, '哎哟喂', '生气' },
 { 'Erica', 2, '哎哟喂呀', '害羞' },
}
对话内容支持表情,具体参考EXPRESSION_BUFF_MAP
]]
function bubble(list)
    for _, cfg in ipairs(list) do
        local talker_name = cfg[1]
        local talker = get_talker(talker_name)
        -- 没有找到talker，则尝试使用自动匹配算法
        if not talker then
            talker = get_talker_by_map_prefix(talker_name)
            if talker then
                debug('bubble talker: %s -> %s', talker_name, get_talker_name(talker))
            end
        end
        
        local wait_time, text, expression = cfg[2], cfg[3], cfg[4]
        if expression and expression ~= '' then
            local exp_cfg = assert(EXPRESSION_BUFF_MAP[expression], '不支持的表情: '..expression)
            local buff_name, cast_time = exp_cfg[1], exp_cfg[2]            

            if talker then
                add_buff(talker, nil, buff_name, cast_time)
            else
                warn('找不到用于冒泡的单位[%s]', talker_name)
            end
            wait(cast_time)
        end

        if text and text ~= '' then
            if talker then
                show_head_tip(talker, 'text', text)
            else
                warn('找不到用于冒泡的单位[%s]', talker_name)
            end
        end

        -- 对话内容为空时,则只等待
        wait(wait_time)
    end
end

-- 关卡结束时我方部队显示胜利表情
function show_victory()
    local player_units = get_unit_group_by_camp('CAMP_PLAYER', 'CAMP_ALLY')
    stop_all(player_units)
    local enemies = get_unit_group_by_camp('CAMP_ENEMY', 'CAMP_ENEMY2')
    if count(enemies) > 0 then
        face_to_obj(player_units, enemies)    
    end
    release_obj(player_units); player_units = nil
    release_obj(enemies); enemies = nil
    wait(0.5)
    play_victory_anim()
end

-- 显示关卡目标
function show_task(task, hint)
    show_battle_objective('任务目标', task, true)
    if hint then
        set_task_hint(hint)
    end
end

-- 清除任务目标提示
function clear_task_hint()
    set_task_hint('')
end

-- 显示提示
function show_center_tip(fmt, ...)
    local msg = string.format(fmt, ...)
    show_battle_objective('提示', msg, true)
end

-- 显示多条提示,会在每一条提示前面加符号 ◇
function show_tips(title, ...)
    local tips = {...}
    for i = 1, #tips do
        tips[i] = '◇ ' .. tips[i]
    end
    show_battle_objective(title, table.concat(tips, '\n'), true)
end

--[[ 显示兵种的出场提示
eg. 
    show_unit_tip(s_djb, '盾甲兵',
        '<color=Dblue>攻击偏低</color>但<color=Dblue>防御奇高</color>', 
        '<color=Dblue>破防</color>技能对他们特别有效'
    )
]]
function show_unit_tip(obj, name, ...)
    show_emphasize(obj, true)
    show_tips(name, ...)    
    show_emphasize(obj, false)
end

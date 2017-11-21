require('unit')
require('dialog')

local test = {}

function test.filter_map_talker_name()
    assert(filter_map_talker_name('[B]张飞') == '张飞')
end

function test.parse_talker_name()
    local wave_id, unit_name, id = 3, '张飞', 1
    local talker_name = format_talker_name(wave_id, unit_name, id)
    local wave_id2, unit_name2, id2 = parse_talker_name(talker_name)
    assert(wave_id == wave_id2)
    assert(unit_name == unit_name2)
    assert(id == id2)
end

function test.map_talker_by_prefix()
    local obj = create_units({'盾甲', '盾甲', '强弓', '强弓', '张飞'})
    map_talker_by_prefix(1, obj)
    assert(get_talker('第1波盾甲1'))
    assert(get_talker('第1波盾甲2'))
    assert(get_talker('第1波强弓1'))
    assert(get_talker('第1波强弓2'))
    assert(get_talker('第1波张飞1'))
end

local function map_units(wave_id, unit_names)
    map_talker_by_prefix(wave_id, create_units(unit_names))
end

-- 同名+存活
function test.get_talker_the_same_unit_alive()
    map_units(1, {'张飞', '盾甲', '盾甲', '强弓', '强弓', '强弓'})
    local talker1 = get_talker('第1波盾甲1')
    local talker2 = get_talker_by_map_prefix('第1波盾甲1')
    assert(talker2)
    assert(talker1 == talker2)
end

-- 同名为不同对象
function test.get_talker_two_unit_not_the_same()
    map_units(1, {'盾甲', '盾甲', '强弓', '强弓', '强弓'})
    local talker1 = get_talker_by_map_prefix('第1波盾甲1')
    local talker2 = get_talker_by_map_prefix('第1波盾甲2')
    assert(talker1 ~= talker2)
end

-- 同名+死亡
function test.get_talker_the_same_unit_dead()
    map_units(1, {'盾甲', '盾甲', '强弓', '强弓', '强弓'})
    kill(get_talker('第1波盾甲1'))
    kill(get_talker('第1波盾甲2'))
    local t = get_talker_by_map_prefix('第1波盾甲1')
    assert(get_class(t) ~= '盾甲')
end

-- 有同行
function test.get_talker_the_same_row()
    map_units(1, {'盾甲', '盾甲', '强弓', '强弓', '强弓'})
    local t = get_talker_by_map_prefix('第1波铁骑1')
    assert(t)
    assert(get_name(t) == '盾甲')
end

-- 没有同行
function test.get_talker_the_different_row()
    map_units(1, {'强弓', '强弓', '强弓'})
    local t = get_talker_by_map_prefix('第1波铁骑1')
    assert(t)
    assert(get_name(t), '强弓')
end

-- 全部死亡
function test.get_talker_all_dead()
    map_units(1, {'盾甲', '盾甲'})
    kill(get_talker('第1波盾甲1'))
    kill(get_talker('第1波盾甲2'))
    assert(not get_talker_by_map_prefix('第1波盾甲1'))
end

-- 没有对应波次
function test.get_talker_no_wave()
    map_units(1, {'盾甲', '盾甲', '强弓', '强弓', '强弓'})
    assert(not get_talker_by_map_prefix('第2波盾甲1'))
end

-- 带[B]的名字
function test.get_talker_contain_boss()
    map_units(1, {'[B]张飞', '盾甲', '盾甲', '强弓', '强弓', '强弓'})
    assert(get_talker_by_map_prefix('第1波张飞1'))
end

-- 不合法的talker_name
function test.get_talker_contain_boss()
    map_units(1, {'盾甲', '盾甲', '强弓', '强弓', '强弓'})
    assert(not get_talker_by_map_prefix('盾甲'))
end

-- 只能找到武将
function test.get_talker_only_hero()
    map_units(1, {'张飞'})
    assert(get_talker_by_map_prefix('第1波盾甲1'))
end

local function test_all()
    local pass_count = 0
    local fail_count = 0
    for name, case in pairs(test) do
        clear_talk_map()
        clear_talker_map_by_prefix()

        local passed, reason = pcall(case)
        if passed then
            pass_count = pass_count + 1
            print('pass', name)
        else
            fail_count = fail_count + 1
            print('fail', name)
            print(reason)
        end
    end
    print('pass', pass_count)
    print('fail', fail_count)
end

test_all()


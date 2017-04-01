function random(a, b)
    return math.random(a, b)
end

-- 从数组中随机取n个不重复的元素
function random_select(a, n)
    assert(#a >= n)
    local record = {}
    local result = {}
    local i = 0
    while i < n do
        while true do
            local id = random(1, #a)
            if not record[id] then
                record[id] = true
                result[#result + 1] = a[id]
                i = i + 1
                break
            end
        end
    end

    return result
end

--[[ 根据参数计算掉落信息
对于:
    loot_count = 2,             -- 掉落数量
    boss_count = 2,             -- boss数量
    hero_count = 2,             -- 英雄数量
    soldier_count = 4           -- 杂鱼数量

返回掉落配置:
{
    boss = {1, 1},
    hero = {0, 0},
    soldier = {0, 0, 0, 0}
}
]]
function cal_loot(loot_count, boss_count, hero_count, soldier_count)
    -- 算法:
    -- 掉落优先级: boss > hero > soldier
    -- 如果掉落数量大于总怪物数量,则多余的掉落全都均分在boss身上

    -- 计算如何掉落
    local monster_count = boss_count + hero_count + soldier_count
    local boss_loot, hero_loot, soldier_loot = 0, 0, 0

    -- 先分别计算不同怪物的掉落总数
    if loot_count <= monster_count then
        if loot_count <= boss_count then
            boss_loot = loot_count
        else
            if loot_count - boss_count <= hero_count then
                boss_loot = boss_count
                hero_loot = loot_count - boss_count
            else
                boss_loot = boss_count
                hero_loot = hero_count
                soldier_loot = loot_count - boss_count - hero_count
            end
        end
    else
        boss_loot = loot_count - hero_count - soldier_count
        hero_loot = hero_count
        soldier_loot = soldier_count
    end

    local function get_loot_record(monster_count, loot_count)
        local r = {}
        if monster_count == 0 then
            return r
        end

        if monster_count == loot_count then
            for i = 1, loot_count do r[i] = 1 end
        else
            if monster_count < loot_count then
                for i = 1, monster_count do r[i] = 1 end
                local left = loot_count - monster_count
                while left > 0 do
                    for i = monster_count, 1, -1 do
                        r[i] = r[i] + 1
                        left = left - 1
                        if left <= 0 then
                            break
                        end
                    end
                end
            else
                for i = 1, monster_count do r[i] = 0 end
                local t = {}
                for i = 1, monster_count do t[i] = i end
                local loot = random_select(t, loot_count)
                for _, id in ipairs(loot) do
                    r[id] = 1
                end
            end
        end

        return r
    end

    -- 然后计算不同类型死亡时的掉落数量
    return {
        boss = get_loot_record(boss_count, boss_loot),
        hero = get_loot_record(hero_count, hero_loot),
        soldier = get_loot_record(soldier_count, soldier_loot),
    }
end

function test_case(...)
    local result = cal_loot(...)
    print('result = ', table.concat(result.boss), table.concat(result.hero), table.concat(result.soldier))
end

function test()
    local cases = {
        -- loot boss hero soldier
        {10, 3, 4, 5},
        {10, 2, 3, 5},
        {10, 1, 2, 3},
        {0, 1, 2, 3},
        {10, 1, 2, 0},
        {10, 0, 0, 0},
    }

    for i, case in ipairs(cases) do
        test_case(unpack(case))
    end
end

function random_test()
    for i = 1, 1000 do
        local loot_count = random(0, 10)
        local boss_count = random(0, 10)
        local hero_count = random(0, 10)
        local soldier_count = random(0, 10)

        test_case(loot_count, boss_count, hero_count, soldier_count)
    end
end

test()
random_test()
local map = {}

local function cs_map_rank(rank, player_count)
    map['rank'] = rank
    map['player_count'] = player_count
end

local function get(key)
    return map[key]
end

-- 吃鸡玩法检查排名是否正确
local function RankOK()
    -- 验证排名和死亡人数的关系
    local rank = get('rank')
    local player_count = get('player_count')

    if player_count == 0 then
        return rank == 2
    end

    if rank == 1 then
        return player_count == 1
    else
        return player_count == rank - 1
    end
end

local _is_dead = false

local function set_is_dead(bool)
    _is_dead = bool
end

local function is_dead(unit)
    return _is_dead
end

local _count = 0

local function set_count(n)
    _count = n
end

local function count()
    return _count
end

local function net_get_self_team_id()
    return 1
end

local function net_get_self_squad()
    return nil
end

local g_all_players
local kill_count_record = {}
local function gen_battle_result()
    local player_count = count(g_all_players)
    local is_win = player_count == 1 and not is_dead(net_get_self_squad())
    local rank
    if is_win then
        rank = 1
    else
        if player_count == 0 then
            rank = 2
        else
            rank = player_count + 1
        end
    end

    -- 映射反作弊需要用的数据
    cs_map_rank(rank, count(g_all_players))

    return {
        rank = rank,
        kill_count = kill_count_record[net_get_self_team_id()],
    }
end

local function test_case(is_dead, player_count)
    set_is_dead(is_dead)
    set_count(player_count)
    local r = gen_battle_result()
    if not RankOK() then
        print(string.format('is_dead=%s player_count=%s rank=%s', tostring(is_dead), player_count, tostring(r.rank)))
    end
end

local function main()
    for _, is_dead in ipairs({true, false}) do
        for player_count = 0, 9 do
            test_case(is_dead, player_count)
        end
    end
end

main()
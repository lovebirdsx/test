local t1_player_count = 5
local t2_player_count = 5

local function set_war_cfg(player_count1, player_count2)
    t1_player_count = player_count1
    t2_player_count = player_count2
end

local function net_get_war_cfg()
    return {
        teams = {
            {id = 1, player_count = t1_player_count},
            {id = 2, player_count = t2_player_count},
        }
    }
end

--[[根据team_id和team_player_id计算玩家的id
譬如:
对于net_war.lua中的配置
teams = {
    { id = 1, player_count = 5},
    { id = 2, player_count = 5},
}
如果team_id = 2, team_player_id = 3
那么就会返回 5 + 3 = 8
]]
function net_get_player_id_by_team_id(team_id, team_player_id)
    local cfg = net_get_war_cfg()
    local player_id = team_player_id
    for i, team in ipairs(cfg.teams) do
        if team_id == team.id then
            break
        else
            player_id = player_id + team.player_count
        end
    end
    return player_id
end

--[[net_get_player_id_by_team_id的逆操作
返回两个值 team_id和team_player_id
]]
function net_get_team_id_by_player_id(player_id)
    local team_id = 1
    local team_player_id = player_id
    local cfg = net_get_war_cfg()
    for i, team in ipairs(cfg.teams) do
        if team_player_id <= team.player_count then
            break
        else
            team_id = team_id + 1
            team_player_id = team_player_id - team.player_count
        end
    end
    return team_id, team_player_id
end

local function test()
    local player_count1 = 1
    local player_count2 = 5
    local total_player_count = player_count1 + player_count2

    set_war_cfg(player_count1, player_count2)

    for team_id = 1, 2 do
        for team_player_id = 1, 5 do
            print(team_id, team_player_id, net_get_player_id_by_team_id(team_id, team_player_id))
        end
    end

    for player_id = 1, total_player_count do
        local team_id, team_player_id = net_get_team_id_by_player_id(player_id)
        print(player_id, team_id, team_player_id)
    end
end

test()
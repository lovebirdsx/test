require('player_data')

-- 玩家最小战力
local POWER_MIN = 100 * 10000

-- 玩家每天攻打次数的范围
local FIGHT_RANGE = {6, 12}

-- 玩家攻打一局需要的秒数
local STAGE_TIME = 4 * 60

-- 玩法开启持续总时间
local TOTAL_OPEN_TIME = 4 * 60 * 60

-- 玩家的参与率
local PLAY_RATE = 0.9

-- 玩家每天战力成长范围
local POWER_INCREASE_RANGE = {0, 0.1}

-- 玩家的操作能力对于战力的提升范围
local PLAYER_OP_RANGE = {0.1, 0.3}

-- 每一局需要的玩家数
local PLAYER_COUNT = 5 * 2

-- 匹配时的最大分差
local MATCH_RANK_DIFF = 400

-- 分段配置
POWER_SECTIONS_TO_RANK = {
    1000000,
    3000000,
    5000000,
    8000000,
    10000000,
    20000000,
    50000000,
    100000000,
    150000000,
    200000000,
    300000000,
    500000000,
    1000000000,
}

-- 初始积分段配置
INIT_RANK_RANGE = {800, 1800}

-- 玩家的状态
local PlayerState = {
    Ready = 'ready',        -- 准备进入游戏(匹配之前)
    Match = 'match',        -- 开始匹配
    Stage = 'stage',        -- 正在关卡中
    Out = 'out',            -- 玩法结束
}

-- 游戏的状态
local GameState = {
    Ready = 'ready',
    Playing = 'playing',
    Done = 'done'
}

-- 用于监测的玩家的id
local debug_player_id

local function rand_float(a, b)
    return a + (b - a) * math.random()
end

function get_power_section_id(power)
    if power <= POWER_SECTIONS_TO_RANK[1] then
        return 0
    end

    if power >= POWER_SECTIONS_TO_RANK[#POWER_SECTIONS_TO_RANK] then
        return #POWER_SECTIONS_TO_RANK
    end

    for i, ps in ipairs(POWER_SECTIONS_TO_RANK) do
        if power < ps then
            return i - 1
        end
    end

    assert(false, 'power = ' .. power)
end

-- 计算玩家的初始积分
function cal_init_rank(power)
    local rank_min, rank_max = INIT_RANK_RANGE[1], INIT_RANK_RANGE[2]
    local power_min, power_max = POWER_SECTIONS_TO_RANK[1], POWER_SECTIONS_TO_RANK[#POWER_SECTIONS_TO_RANK]
    if power <= power_min then
        return rank_min
    elseif power >= power_max then
        return rank_max
    else
        local section_id = get_power_section_id(power)
        local ps_min = POWER_SECTIONS_TO_RANK[section_id]
        local ps_max = POWER_SECTIONS_TO_RANK[section_id + 1]
        local rate = (section_id - 1 + ((power - ps_min) / (ps_max - ps_min))) / (#POWER_SECTIONS_TO_RANK - 1)

        return rank_min + (rank_max - rank_min) * rate
    end
end

-- 创建玩家
---@return Player
local function create_player(power, id)
    local op_rate = rand_float(PLAYER_OP_RANGE[1], PLAYER_OP_RANGE[2])
    local rank = cal_init_rank(power)

    ---@class Player
    local player = {
        id = id,
        power = power,
        rank = rank,
        init_rank = rank,
        op_rate = op_rate,
        real_power = power + power * op_rate,
        curr_fight_count = 0,
        total_fight_count = 0,
        match_time = 0,
    }

    return player
end

-- 载入玩家的数据
---@return Player[]
function load_players()
    local power_list = get_player_power_list()
    local players = {}
    for i, power in ipairs(power_list) do
        if power > POWER_MIN then
            players[#players + 1] = create_player(power, i)
        end
    end

    return players
end

---@param p Player
local function init_player_sim_data(p, day_id)
    -- 模拟玩家是否参加这个玩法
    if math.random() <= PLAY_RATE then
        -- 模拟玩家玩这个玩法的次数
        local fight_count = math.random(FIGHT_RANGE[1], FIGHT_RANGE[2])

        -- 估算游玩战场需要的总时间
        local fight_time = fight_count * STAGE_TIME

        -- 模拟玩家开始玩这个玩法的时间,相对于玩法开启的时间
        local play_start_time = math.random(0, TOTAL_OPEN_TIME - fight_time)

        p.play_start_time = play_start_time
        p.total_fight_count = p.total_fight_count + fight_count
        p.state = PlayerState.Ready

        -- 模拟玩家每天增长战力
        if day_id > 1 then
            p.power = p.power * (1 + rand_float(POWER_INCREASE_RANGE[1], POWER_INCREASE_RANGE[2]))
            p.real_power = p.power + p.power * p.op_rate
        end
    end
end

---@param players Player[]
local function can_start_match(players)
    assert(#players == PLAYER_COUNT, 'player count = ' .. #players)
    local min_rank, max_rank = 99999, 0
    for _, player in ipairs(players) do
        if player.rank < min_rank then
            min_rank = player.rank
        end

        if player.rank > max_rank then
            max_rank = player.rank
        end
    end

    return (max_rank - min_rank) <= MATCH_RANK_DIFF
end

-- 分配玩家,返回两个玩家组
---@param players Player[]
local function allocate_players(players)
    assert(#players == PLAYER_COUNT)
    local players1, players2 = {}, {}
    for i = 1, PLAYER_COUNT / 2 do
        players1[#players1 + 1] = players[i * 2 - 1]
        players2[#players2 + 1] = players[i * 2]
    end
    return players1, players2
end

-- 创建Team
---@param players Player[]
---@return Team
local function create_team(players)
    ---@class Team
    ---@field public players Player
    local team = {
        players = players
    }

    return team
end

local game_id = 1

-- 创建游戏
---@param players Player[]
---@return Game
local function create_game(players, time)
    -- 将players按照积分进行分组
    local players1, players2 = allocate_players(players)
    
    ---@class Game
    ---@field public teams Team[]
    local game = {
        teams = {
            create_team(players1),
            create_team(players2),
        },
        state = GameState.Ready,
        start_time = time,
        id = game_id
    }

    game_id = game_id + 1

    return game
end

-- 游戏开始
---@param game Game
local function start_game(game, time)
    -- 更新玩家的状态
    for i, t in ipairs(game.teams) do
        for j, player in ipairs(t.players) do
            player.state = PlayerState.Stage

            -- 记录匹配时间
            player.match_time = player.match_time + time - player.match_start_time
        end
    end
end

---@param team Team
local function get_team_power(team)
    local power = 0
    for i, player in ipairs(team.players) do
        power = power + player.real_power
    end
    return power
end

---@param game Game
---@return Team
local function get_winner(game)
    local t1_power = get_team_power(game.teams[1])
    local t2_power = get_team_power(game.teams[2])
    return t1_power > t2_power and game.teams[1] or game.teams[2]
end

--[[
ra 玩家a的积分
rb 玩家b的积分
sa a的胜负值, 胜=1,负=0
sb b的胜负值, 胜=1,负=0
返回 a,b之后的积分
]]
function cal_rank(ra, rb, sa, sb)
    local ea = 1 / (1 + 10 ^ ((rb - ra) / 400))
    local eb = 1 / (1 + 10 ^ ((ra - rb) / 400))

    -- K值根据玩家的当前分数的不同而不同
    local k
    if ra < 2000 then
        k = 30
    elseif ra <= 2400 then
        k = 130 - ra / 20
    else
        k = 10
    end

    local ra0 = ra + k * (sa - ea)
    local rb0 = rb + k * (sb - eb)
    return ra0, rb0
end

---@param team Team
local function get_team_avg_rank(team)
    local rank = 0
    for i, p in ipairs(team.players) do
        rank = rank + p.rank
    end
    return rank / #team.players
end

---@param team Team
local function get_team_total_rank(team)
    local rank = 0
    for i, p in ipairs(team.players) do
        rank = rank + p.rank
    end
    return rank
end

-- 根据胜利方和失败方更新积分
---@param winner Team
---@param loser Team
local function update_rank(winner, loser)
    local rank_winner = get_team_total_rank(winner)
    local rank_loser = get_team_total_rank(loser)

    for i, player in ipairs(winner.players) do
        local rank = cal_rank(player.rank, player.rank / rank_winner * rank_loser, 1, 0.5)
        player.rank = rank

        if player.id == debug_player_id then
            print(player.id, 'win', player.init_rank, math.floor(player.rank), math.floor(rank_winner), math.floor(rank_loser))
        end
    end

    for i, player in ipairs(loser.players) do
        local rank = cal_rank(player.rank, player.rank / rank_loser * rank_winner, 0.5, 1)
        player.rank = rank

        if player.id == debug_player_id then
            print(player.id, 'los', player.init_rank, math.floor(player.rank), math.floor(rank_winner), math.floor(rank_loser))
        end
    end
end

-- 游戏结束
---@param game Game
local function end_game(game, time)
    game.end_time = time

    -- 计算结果
    local winner = get_winner(game)
    local loser = (winner == game.teams[1] and game.teams[2] or game.teams[1])

    update_rank(winner, loser)

    -- 更新玩家的状态
    for i, team in ipairs(game.teams) do
        for _, player in ipairs(team.players) do
            player.curr_fight_count = player.curr_fight_count + 1
            player.state = (player.curr_fight_count < player.total_fight_count and PlayerState.Ready or PlayerState.Out)
        end
    end
end

---@param players Player[]
---@return Game[]
local function make_games(players, time)
    -- 将players按照积分排序,取出满足条件的玩家,让他们开始游戏
    ---@param p1 Player
    ---@param p2 Player
    local function player_cmp(p1, p2)
        return p1.rank < p2.rank
    end

    table.sort(players, player_cmp)

    local player_id = 1
    local games = {}
    local remove_record = {}
    while player_id <= #players - PLAYER_COUNT + 1 do
        local match_players = {}
        for i = 1, PLAYER_COUNT do
            match_players[i] = players[player_id + i - 1]
        end

        if can_start_match(match_players) then
            remove_record[#remove_record + 1] = player_id
            local game = create_game(match_players, time)
            games[#games + 1] = game
            player_id = player_id + PLAYER_COUNT
        else
            player_id = player_id + 1
        end
    end

    -- 移除玩家(从后向前移除,索引就可以保持有效)
    for i = #remove_record, 1, -1 do
        local id = remove_record[i]
        for j = id + PLAYER_COUNT - 1, id, -1 do
            table.remove(players, j)
        end
    end

    return games
end

---@param game Game
local function update_game(game, time)
    if game.state == GameState.Ready then
        start_game(game, time)
        game.state = GameState.Playing
    elseif game.state == GameState.Playing then
        if time >= game.start_time + STAGE_TIME then
            end_game(game, time)
            game.state = GameState.Done
        end
    end
end

---@param players Player[]
function sim_for_a_day(players, day_id)
    -- 初始化玩家的数据
    for i, p in ipairs(players) do
       init_player_sim_data(p, day_id)
    end

    -- 等待匹配的队列
    ---@type Player[]
    local wait_players = {}

    -- 正在游玩的game列表
    ---@type Game[]
    local games = {}

    for time = 1, TOTAL_OPEN_TIME, 10 do
        -- 将符合条件的玩家放到匹配队列中
        for _, p in ipairs(players) do
            if p.state == PlayerState.Ready and p.curr_fight_count < p.total_fight_count and p.play_start_time < time then
                wait_players[#wait_players + 1] = p
                p.state = PlayerState.Match
                p.match_start_time = time
            end
        end

        -- 将符合条件的玩家放到一起开始游戏
        local new_games = make_games(wait_players, time)
        for _, game in ipairs(new_games) do
            games[#games + 1] = game
        end

        -- 更新游戏列表,如果游戏结束,则更新玩家对应的积分
        local finished_game_ids = {}
        for i, game in ipairs(games) do
            update_game(game, time)
            if game.state == GameState.Done then
                finished_game_ids[#finished_game_ids + 1] = i
            end
        end

        -- 移除已经结束游戏
        for i = #finished_game_ids, 1, -1 do
            table.remove(games, finished_game_ids[i])
        end
    end
end

---@param players Player[]
function sim(players, days)
    for day = 1, days do
        sim_for_a_day(players, day)
    end
end

function format_power(power)
    if power >= 100000000 then
        return (math.floor(power / 100000000 * 100) / 100) .. '亿'
    elseif power >= 10000 then
        return math.floor(power / 10000)  .. '万'
    else
        return math.floor(power)
    end
end

---@param players Player[]
function output_result(players)
    for i, player in ipairs(players) do
        print(player.id,
                format_power(player.real_power),
                player.curr_fight_count,
                player.total_fight_count,
                math.floor(player.match_time / player.curr_fight_count),
                math.floor(player.init_rank),
                math.floor(player.rank)
        )
    end
end

function set_debug_player_id(id)
    debug_player_id = id
end
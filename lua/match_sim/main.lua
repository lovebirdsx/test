require('sim')

local function main()
    set_debug_player_id(tonumber(arg[1]))
    local players = load_players()
    sim(players, 7)
    output_result(players)
end

main()
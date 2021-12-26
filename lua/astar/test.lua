require('a_star')

local graph = {
	{id = 1, x = 0, 	y = 0, 		player_id = 1},
	{id = 2, x = 200, 	y = 200, 	player_id = 1},
	{id = 3, x = -200, 	y = 200, 	player_id = 1},
	{id = 4, x = 200, 	y = -200, 	player_id = 2},
	{id = 5, x = -200, 	y = -200, 	player_id = 2},
}

local valid_node_func = function (pos, neighbor)
	local MAX_DIST = 300
	if neighbor.player_id == pos.player_id and 
		distance(pos, neighbor) < MAX_DIST then
		return true
	end
	return false
end

local path = a_star(graph[2], graph [3], graph, valid_node_func)
if not path then
	print ("No valid path found")
else
	for i, pos in ipairs ( path ) do
		print ( "Step " .. i .. " >> " .. pos.id )
	end
end
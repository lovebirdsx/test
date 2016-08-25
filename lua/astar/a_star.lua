function distance(p1, p2)
    return ((p2.y - p1.y) ^ 2 + (p2.x - p1.x) ^ 2) ^ 0.5
end

function a_star(from, to, points, valid_node_func)
	local INF = 1/0

	local function heuristic_cost_estimate(a, b)
		return distance(a, b)
	end

	local function is_valid_node(node, neighbor)
		return true
	end

	local function lowest_f_score(set, f_score)
		local lowest, best_n = INF, nil
		for _, node in ipairs(set) do
			local score = f_score[node]
			if score < lowest then
				lowest, best_n = score, node
			end
		end
		return best_n
	end

	local function neighbor_nodes(n, points)
		local neighbors = {}
		for _, node in ipairs (points) do
			if n ~= node and is_valid_node(n, node) then
				table.insert(neighbors, node)
			end
		end
		return neighbors
	end

	local function not_in(set, n)
		for _, node in ipairs(set) do
			if node == n then return false end
		end
		return true
	end

	local function remove_node(set, n)
		for i, node in ipairs ( set ) do
			if node == n then 
				set [i] = set [#set]
				set [#set] = nil
				break
			end
		end
	end

	local function unwind_path(flat_path, map, current_node)
		if map[current_node] then
			table.insert(flat_path, 1, map [current_node])
			return unwind_path(flat_path, map, map[current_node])
		else
			return flat_path
		end
	end

	local closedset = {}
	local openset = {from}
	local came_from = {}

	if valid_node_func then is_valid_node = valid_node_func end

	local g_score, f_score = {}, {}
	g_score[from] = 0
	f_score[from] = g_score[from] + heuristic_cost_estimate(from, to)

	while #openset > 0 do	
		local current = lowest_f_score (openset, f_score)
		if current == to then
			local path = unwind_path ({}, came_from, to)
			table.insert (path, to)
			return path
		end

		remove_node(openset, current)
		table.insert (closedset, current)
		
		local neighbors = neighbor_nodes(current, points)
		for _, neighbor in ipairs(neighbors) do 
			if not_in(closedset, neighbor) then			
				local tentative_g_score = g_score[current] + distance(current, neighbor)				 
				if not_in(openset, neighbor) or tentative_g_score < g_score[neighbor] then 
					came_from[neighbor] = current
					g_score[neighbor] = tentative_g_score
					f_score[neighbor] = g_score [neighbor] + heuristic_cost_estimate (neighbor, to)
					if not_in(openset, neighbor) then
						table.insert(openset, neighbor)
					end
				end
			end
		end
	end

	return nil
end

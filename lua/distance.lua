function distance(p1, p2)
    return ((p2.y - p1.y) ^ 2 + (p2.x - p1.x) ^ 2) ^ 0.5
end

function sort_pos_list_by_distance(p, poses)
    table.sort(poses, function (a, b)
        return distance(p, a) < distance(p, b)
    end)
end

function poses_to_str(poses)
    local t = {}
    for _, p in ipairs(poses) do
        table.insert(t, string.format('(%3g, %3g)', p.x, p.y))
    end
    return table.concat(t, ', ')
end

function test()
    local p = {x = 0, y = 0}
    local poses = {
        {x = 10, y = 10},
        {x = 30, y = 30},
        {x = 40, y = 40},
        {x = 40, y = -40},
        {x = 20, y = 20},
        {x = 30, y = -30},
    }
    print(poses_to_str(poses))
    sort_pos_list_by_distance(p, poses)
    print(poses_to_str(poses))
end

test()

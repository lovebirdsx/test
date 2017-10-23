-- The while loop represents the game.
-- Each iteration represents a turn of the game
-- where you are given inputs (the heights of the mountains)
-- and where you have to print an output (the index of the mountain to fire on)
-- The inputs you are given are automatically updated according to your last actions.


-- game loop
while true do
    local max_h, max_id
    for i=0,8-1 do
        h = tonumber(io.read()) -- represents the height of one mountain.
        if not max_h or h > max_h then
            max_h = h
            max_id = i
        end
    end
    
    -- Write an action using print()
    -- To debug: io.stderr:write("Debug message\n")
    
    print(max_id) -- The index of the mountain to fire on.
end
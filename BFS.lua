local function bfs(map_util, start, goal)
    local direction = {
        {-1, 0},  -- up
        {-1, 1}, -- up right
        {1, 1},  -- down right
        {1, 0},  -- down
        {1, -1},  -- down left
        {-1, -1}  -- up left
    }
    local queue = {}
    
    local visited = {}
    local parent = {}
    table.insert(queue, start)
    visited[(start.row - 1) * map_util.map_col + start.col] = true

    while #queue > 0 do
        local current = table.remove(queue, 1)
        -- 到达goal
        if current.row == goal.row and current.col == goal.col then
            local path = {}
            local cur = current
            while cur do
                table.insert(path, 1, cur)
                cur = parent[(cur.row - 1) * map_util.map_col + cur.col]
            end
            return path
        end

        -- 扩展 neighbors
        for _, dir in ipairs(direction) do
            local new_row = current.row + dir[1]
            local new_col = current.col + dir[2]

            if map_util:isValidPosition(new_row, new_col) 
                    and not visited[(new_row - 1) * map_util.map_col + new_col] then
                visited[(new_row - 1) * map_util.map_col + new_col] = true
                parent[(new_row - 1) * map_util.map_col + new_col] = current
                table.insert(queue, {row = new_row, col = new_col})
            end
        end
    end
    return nil
end

return {bfs = bfs}
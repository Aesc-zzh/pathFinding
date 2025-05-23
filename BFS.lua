
function bfs()
    local start = {row = 1, col = 1}
    local goal = {row = 195, col = 20}
    
    local direction = {
        {-1, 0},  -- up
        {-1, 1}, -- up right
        {1, 1},  -- down right
        {1, 0},  -- down
        {1, -1},  -- down left
        {-1, -1}  -- up left
}
    local fileread = require("file_read")
    local map, map_row, map_col = fileread.read_map("map.bytes")
    local queue = {}
    
    if map[start.row][start.col] ~= 0 then
        print("start is not valid")
        return nil
    end
    if map[goal.row][goal.col] ~= 0 then
        print("goal is not valid")
        return nil
    end
    local visited = {}
    local parent = {}
    table.insert(queue, start)
    visited[start.row * map_col + start.col] = true
    -- parent[start.row * map_col + start.col] = nil
    while #queue > 0 do
        local current = table.remove(queue, 1)
        -- check if it reached the goal
        if current.row == goal.row and current.col == goal.col then
            local path = {}
            local cur = current
            while cur do
                table.insert(path, 1, cur)
                cur = parent[cur.row * map_col + cur.col]
            end
            return map, path
        end

        -- explore neighbors
        for _, dir in ipairs(direction) do
            local new_row = current.row + dir[1]
            local new_col = current.col + dir[2]

            if new_row >= 1 and new_row <= map_row and new_col >= 1 and new_col <= map_col and not visited[new_row * map_col + new_col] 
                                                                                            and map[new_row][new_col] == 0 then
                visited[new_row * map_col + new_col] = true
                parent[new_row * map_col + new_col] = current
                table.insert(queue, {row = new_row, col = new_col})
            end
        end
    end
    return map, nil
end

return {bfs = bfs}
-- map, path = bfs()
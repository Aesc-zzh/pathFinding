local function insert_priority_queue(queue, item)
    table.insert(queue, item)
    table.sort(queue, function(a, b)
        return a.cost < b.cost
    end)
end

local function greedy_bfs(map_util, start, goal)
    local direction = {
        {-1, 0},  -- up
        {-1, 1}, -- up right
        {1, 1},  -- down right
        {1, 0},  -- down
        {1, -1},  -- down left
        {-1, -1}  -- up left
    }
    local priority_queue = {}

    local visited = {}
    local parent = {}
    table.insert(priority_queue, {node = start, cost = map_util:heuristic(start.row, start.col, goal.row, goal.col)})
    
    local idx = function(r, c) return (r - 1) * map_util.map_col + c end

    visited[idx(start.row, start.col)] = true

    while #priority_queue > 0 do
        local current = table.remove(priority_queue, 1)

        -- 到达goal
        if current.node.row == goal.row and current.node.col == goal.col then
            local path = {}
            local cur = current.node
            while cur do
                table.insert(path, 1, cur)
                cur = parent[idx(cur.row, cur.col)]

            end
            return path
        end

        for _, dir in ipairs(direction) do
            local new_row = current.node.row + dir[1]
            local new_col = current.node.col + dir[2]
            if map_util:isValidPosition(new_row, new_col)
                        and not visited[idx(new_row, new_col)] then
                visited[idx(new_row, new_col)] = true
                parent[idx(new_row, new_col)] = current.node

                local new_node_cost = map_util:heuristic(new_row, new_col, goal.row, goal.col)
                insert_priority_queue(priority_queue, {node = {row = new_row, col = new_col}, cost = new_node_cost})
            end
        end
    end
    return nil
end

return {greedy_bfs = greedy_bfs}
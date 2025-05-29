local function dijkstra(map_util, start, goal)
    local direction = {
        {-1, 0},  -- up
        {-1, 1}, -- up right
        {1, 1},  -- down right
        {1, 0},  -- down
        {1, -1},  -- down left
        {-1, -1}  -- up left
    }

    local dist = {}  -- 距离起点的距离
    local parent = {}
    local MinHeapClass = require("minHeap")
    local open_heap = MinHeapClass.new()

    local idx = function(r, c) return (r - 1) * map_util.map_col + c end
    dist[idx(start.row, start.col)] = 0
    open_heap:push(start, dist[idx(start.row, start.col)])

    while not open_heap:empty() do
        local current = open_heap:pop()
        if current.row == goal.row and current.col == goal.col then
            local path = {}
            local cur = current
            while cur do
                table.insert(path, 1, cur)
                cur = parent[idx(cur.row, cur.col)]
            end
            return path
        end

        for _, dir in ipairs(direction) do
            local new_row = current.row + dir[1]
            local new_col = current.col + dir[2]
            if map_util:isValidPosition(new_row, new_col) then
                local new_id = idx(new_row, new_col)
                local tentative_dist = dist[idx(current.row, current.col)] + 1  -- 每步消耗为1
                if dist[new_id] == nil or tentative_dist < dist[new_id] then
                    dist[new_id] = tentative_dist
                    parent[new_id] = {row = current.row, col = current.col}
                    open_heap:push({row = new_row, col = new_col}, tentative_dist)
                end

            end
        end
    end
end

return {dijkstra = dijkstra}
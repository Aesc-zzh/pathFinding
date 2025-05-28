local function Astar(map_util, start, goal)
    local direction = {
        {-1, 0},  -- up
        {-1, 1}, -- up right
        {1, 1},  -- down right
        {1, 0},  -- down
        {1, -1},  -- down left
        {-1, -1}  -- up left
    }

    local idx = function(r, c) return (r - 1) * map_util.map_col + c end
    local gscore = {}  -- 代价函数
    local fscore = {}  -- 启发函数
    local parent = {}
    local MinHeapClass = require("minHeap")
    local open_heap = MinHeapClass.new()

    local start_id = idx(start.row, start.col)
    gscore[start_id] = 0
    fscore[start_id] = map_util:heuristic(start.row, start.col, goal.row, goal.col)
    open_heap:push(start, fscore[start_id])

    local visited = {}

    while not open_heap:empty() do
        local current, cur_fscore = open_heap:pop()
        local cr, cc = current.row, current.col
        local cur_id = idx(cr, cc)
        if visited[cur_id] then
            
        else
            visited[cur_id] = true
            if current.row == goal.row and current.col == goal.col then
                -- reconstruct path
                local path = {}
                local cur = current
                while cur do
                    table.insert(path, 1, cur)
                    local current_id = idx(cur.row, cur.col)
                    cur = parent[current_id]
                end
                return path
            end
            for _, d in ipairs(direction) do
                local new_row, new_col = current.row + d[1], cc + d[2]
                if map_util:isValidPosition(new_row, new_col) and not visited[idx(new_row, new_col)] then
                    local new_id = idx(new_row, new_col)
                    -- 代价计算 每步消耗为1
                    local tentative_g = gscore[cur_id] + 1
                    if gscore[new_id] == nil or tentative_g < gscore[new_id] then
                        gscore[new_id] = tentative_g
                        parent[new_id] = {row = cr, col = cc}
                        fscore[new_id] = tentative_g + map_util:heuristic(new_row, new_col, goal.row, goal.col)
                        open_heap:push({row = new_row, col = new_col}, fscore[new_id])
                    end
                end
            end
    
        end
    end
    return nil
end

return {Astar = Astar}
-- local forced_neighbors = {
    --     ["-1,0"] = {
    --         {-1, -1}, {-1, 1}
    --     },
    --     ["-1,1"] = {
    --         {-1, 0}, {-2, 1}
    --     },
    --     ["1,1"] = {
    --         {1, 0}, {2, 1}
    --     },
    --     ["1,0"] = {
    --         {1, -1}, {1, 1}
    --     },
    --     ["1,-1"] = {
    --         {1, 0}, {2, -1}
    --     },
    --     ["-1,-1"] = {
    --         {-1, 0}, {-2, -1}
    --     }
    -- }

local function jump(visited, dx, dy, map_util, r, c, parent_dir, goal)
    -- 定义强制邻居
    local forced_neighbors = {
        ["-1,0"] = {
            {-1, -1}, {-1, 1}
        },
        ["-1,1"] = {
            {-1, 0}, {1, 1}
        },
        ["1,1"] = {
            {1, 0}, {1, -1}
        },
        ["1,0"] = {
            {1, -1}, {1, 1}
        },
        ["1,-1"] = {
            {1, 0}, {-1, -1}
        },
        ["-1,-1"] = {
            {-1, 1}, {0, -1}
        }
    }
        
    -- 到达目标
    if r == goal.row and c == goal.col then
        return {row = r, col = c}
    end

    local id = (r - 1) * map_util.map_col + c

    if visited and visited[id] then
        return nil
    end

    local dir_key = tostring(dx) .. "," .. tostring(dy)

    -- 检查强制邻居
    for _, dir in ipairs(forced_neighbors[dir_key] or {}) do
        local nr, nc = r + dir[1], c + dir[2]
        local nid = (nr - 1) * map_util.map_col + nc
        if map_util:isValidPosition(nr, nc) then
            if not visited or not visited[nid] then
                -- 如果邻居是障碍物或未被访问
                if map_util.map[nr][nc] == 1 or not visited[nid] then
                    return {row = r, col = c}
                end
            end
        end
    end

    -- 继续跳跃
    local new_r, new_c = r + dx, c + dy
    if map_util:isValidPosition(new_r, new_c) then
        return jump(visited, dx, dy, map_util, new_r, new_c, {dx, dy}, goal)
    end

    return nil
end

-- JPS主函数
local function JPS(map_util, start, goal)
    local direction = {
        {-1, 0},  -- up
        {-1, 1}, -- up right
        {1, 1},  -- down right
        {1, 0},  -- down
        {1, -1},  -- down left
        {-1, -1}  -- up left
    }

    local idx = function(r, c) return (r - 1) * map_util.map_col + c end

    local gscore = {}
    local fscore = {}
    local parent = {}

    local MinHeapClass = require("minHeap")
    local open_heap = MinHeapClass.new()

    local visited = {}

    local start_id = idx(start.row, start.col)
    gscore[start_id] = 0
    fscore[start_id] = map_util:heuristic(start.row, start.col, goal.row, goal.col)
    open_heap:push(start, fscore[start_id])

    while not open_heap:empty() do
        local current, cur_fscore = open_heap:pop()
        local cr, cc = current.row, current.col
        local cur_id = idx(cr, cc)

        if cr == goal.row and cc == goal.col then
            local path = {}
            local cur = current
            while cur do
                table.insert(path, 1, cur)
                local current_id = idx(cur.row, cur.col)
                cur = parent[current_id]
            end
            return path
        end

        visited[cur_id] = true

        for _, dir in ipairs(direction) do
            local dr, dc = dir[1], dir[2]
            local nr, nc = cr + dr, cc + dc
            if map_util:isValidPosition(nr, nc) then
                local jump_point = jump(visited, dr, dc, map_util, nr, nc, dir, goal)
                if jump_point then
                    local new_id = idx(jump_point.row, jump_point.col)
                    if not visited[new_id] then
                        local tentative_g = gscore[cur_id] + 1
                        if gscore[new_id] == nil or tentative_g < gscore[new_id] then
                            gscore[new_id] = tentative_g
                            parent[new_id] = {row = cr, col = cc}
                            fscore[new_id] = tentative_g + map_util:heuristic(jump_point.row, jump_point.col, goal.row, goal.col)
                            open_heap:push(jump_point, fscore[new_id])
                        end
                    end
                end
            end
        end
    end

    return nil
end

return {JPS = JPS}

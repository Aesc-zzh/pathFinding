local directions = {
    {-1, 0},  -- up
    {-1, 1},  -- up-right
    { 1, 1},  -- down-right
    { 1, 0},  -- down
    { 1,-1},  -- down-left
    {-1,-1},  -- up-left
}

-- 沿六个方向之一进行直线检查
local function lineOfSight(map_util, a, b)
    local dr = b.row - a.row
    local dc = b.col - a.col
    for _, d in ipairs(directions) do
        local vr, vc = d[1], d[2]
        
        if vr == 0 and dc ~= 0 then 
            vr = 0
            vc = (dc > 0) and 1 or -1 
        end
        if vc == 0 and dr ~= 0 then 
            vc = 0
            vr = (dr > 0) and 1 or -1 
        end
        -- (dr,dc) 是否是 (vr,vc)的多倍
        if vr == 0 and dr == 0 and vc ~= 0 and dc % vc == 0 then
            local steps = math.abs(dc / vc)
            for i = 1, steps do
                local nr, nc = a.row + i*vr, a.col + i*vc
                if not map_util:isValidPosition(nr, nc) then 
                    return false 
                end
            end
            return true
        elseif vc == 0 and dc == 0 and vr ~= 0 and dr % vr == 0 then
            local steps = math.abs(dr / vr)
            for i = 1, steps do
                local nr, nc = a.row + i*vr, a.col + i*vc
                if not map_util:isValidPosition(nr, nc) then 
                    return false 
                end
            end
            return true
        elseif vr ~= 0 and vc ~= 0 and dr % vr == 0 and dc % vc == 0 and (dr/vr) == (dc/vc) then
            local steps = math.abs(dr / vr)
            for i = 1, steps do
                local nr, nc = a.row + i*vr, a.col + i*vc
                if not map_util:isValidPosition(nr, nc) then 
                    return false 
                end
            end
            return true
        end
    end
    return false
end

-- Floyd smoothing: 删除可见的中间点
local function smoothPath(map_util, path)
    if #path <= 2 then 
        return path 
    end
    local newPath = { path[1] }
    local i = 1
    while i < #path do
        local j = #path
        -- 从path[i]中找到最远的可视点
        while j > i + 1 do
            if lineOfSight(map_util, path[i], path[j]) then 
                break 
            end
            j = j - 1
        end
        table.insert(newPath, path[j])
        i = j
    end
    return newPath
end


local function AstarWithSmoothing(map_util, start, goal)
    local map_col = map_util.map_col
    local idx = function(r, c) return (r - 1) * map_col + c end

    local gscore = {}
    local fscore = {}
    local parent = {}
    local MinHeap = require("minHeap")
    local open_heap = MinHeap.new()

    local start_id = idx(start.row, start.col)
    gscore[start_id] = 0
    fscore[start_id] = map_util:heuristic(start.row, start.col, goal.row, goal.col)
    open_heap:push(start, fscore[start_id])

    local visited = {}

    while not open_heap:empty() do
        local current, _ = open_heap:pop()
        local cr, cc = current.row, current.col
        local cur_id = idx(cr, cc)
        if visited[cur_id] then
            
        else
            visited[cur_id] = true
            
            if cr == goal.row and cc == goal.col then
                local path = {}
                local cur = current
                while cur do
                    table.insert(path, 1, cur)
                    local current_id = idx(cur.row, cur.col)
                    cur = parent[current_id]
                end
                return smoothPath(map_util, path)
            end
            
            for _, d in ipairs(directions) do
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

return {
    AstarWithSmoothing = AstarWithSmoothing,
}
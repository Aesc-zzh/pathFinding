local MinHeap = {}
MinHeap.__index = MinHeap

function MinHeap.new()  -- 构造函数 .new 不传递self
    local heap = setmetatable({}, MinHeap)
    heap.heap = {}
    return heap
end

function MinHeap:push(node, key)
    local data = self.heap
    table.insert(data, {node = node, key = key})
    local i = #data
    -- 上浮
    while i > 1 do
        local parent = math.floor(i / 2)
        if data[parent].key <= data[i].key then break end
            
        data[parent], data[i] = data[i], data[parent]
        i = parent
    end
end

function MinHeap:pop()
    local data = self.heap
    if #data == 0 then return nil end
    local top = data[1]
    data[1] = data[#data]
    data[#data] = nil
    -- 下沉
    local i = 1
    while 2 * i <= #data do
        local left, right = 2 * i, 2 * i + 1
        local min = i
        if left <= #data and data[left].key < data[min].key then
            min = left
        end
        if right <= #data and data[right].key < data[min].key then
            min = right
        end
        if min == i then break end
        data[i], data[min] = data[min], data[i]
        i = min
    end
    return top.node, top.key
end

function MinHeap:empty()
    return #self.heap == 0
end

local function heuristic(r1, c1, r2, c2)
    local dr, dc = (r1 -r2), (c1 - c2)
    return math.sqrt(dr * dr + dc * dc)
end

function Astar()
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

    local idx = function(r, c) return (r - 1) * map_col + c end
    local gscore = {}  -- 代价函数
    local fscore = {}  -- 启发函数
    local parent = {}
    local open_heap = MinHeap.new()
    local start_id = idx(start.row, start.col)
    gscore[start_id] = 0
    fscore[start_id] = heuristic(start.row, start.col, goal.row, goal.col)
    open_heap:push(start, fscore[start_id])

    local closed = {}

    while not open_heap:empty() do
        local current, cur_fscore = open_heap:pop()
        local cr, cc = current.row, current.col
        local cur_id = idx(cr, cc)
        if closed[cur_id] then
            
        else
            closed[cur_id] = true
            if current.row == goal.row and current.col == goal.col then
                -- reconstruct path
                local path = {}
                local cur = current
                while cur do
                    table.insert(path, 1, cur)
                    local current_id = idx(cur.row, cur.col)
                    cur = parent[current_id]
                end
                return map, path
            end
            for _, d in ipairs(direction) do
                local new_row, new_col = current.row + d[1], cc + d[2]
                if new_row >= 1 and new_row <= map_row and new_col >= 1 and new_col <= map_col and not closed[idx(new_row, new_col)]
                                                                                                and map[new_row][new_col] == 0 then
                    local new_id = idx(new_row, new_col)
                    -- 代价计算 每步消耗为1
                    local tentative_g = gscore[cur_id] + 1
                    if gscore[new_id] == nil or tentative_g < gscore[new_id] then
                        gscore[new_id] = tentative_g
                        parent[new_id] = {row = cr, col = cc}
                        fscore[new_id] = tentative_g + heuristic(new_row, new_col, goal.row, goal.col)
                        open_heap:push({row = new_row, col = new_col}, fscore[new_id])
                    end
                end
            end
    
        end
    end
    return map, nil
end

return {Astar = Astar}
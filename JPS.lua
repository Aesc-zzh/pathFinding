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

function passable(map, map_row, map_col, r, c)
    return r >= 1 and r <= map_row and c >= 1 and c <= map_col and map[r][c] == 0
end

-- 强制邻居检测
-- 检查当前方向上是否存在forced neighbor
function forced_neighbor(map, map_row, map_col, r, c, dr, dc)
    -- 检查侧翼方向，若侧翼被阻塞，而侧翼前方通则为forced
    for _, side in ipairs(direction) do
        -- 侧翼方向 与主方向不共线
        if side[1] ~= dr or side[2] ~= dc then
            -- 侧翼方向与主方向正交
            if dr * side[1] + dc * side[2] == 0 then
                -- 如果侧翼方向被阻挡，而侧翼前方的方向是畅通的，则该位置被视为强制邻居。
                local sr, sc = r + side[1], c + side[2]  
                local jr, jc = r + dr + side[1], c + dc + side[2]
                if not passable(map, map_row, map_col, sr, sc) and passable(map, map_row, map_col, jr, jc) then
                    return true
                end
            end
        end
    end
    return false
end

function jump(map, map_row, map_col, r, c, dr, dc, gr, gc)
    local nr, nc = r + dr, c + dc
    if not passable(map, map_row, map_col, nr, nc) then
        return nil
    end
    if nr == gr and nc == gc then
        return {row = nr, col = nc}
    end
    if forced_neighbor(map, map_row, map_col, nr, nc, dr, dc) then
        return {row = nr, col = nc}
    end
    return jump(map, map_row, map_col, nr, nc, dr, dc, gr, gc)

end


function JPS()
    local start = {row = 1, col = 1}
    local goal = {row = 195, col = 20}

    direction = {
        {-1, 0},  -- up
        {-1, 1}, -- up right
        {1, 1},  -- down right
        {1, 0},  -- down
        {1, -1},  -- down left
        {-1, -1}  -- up left
    }
    local fileread = require("file_read")
    local map, map_row, map_col = fileread.read_map("map.bytes")



end
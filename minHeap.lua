local MinHeap = {}
MinHeap.__index = MinHeap

function MinHeap.new()
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

return MinHeap
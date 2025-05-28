local MapUtil = {}
MapUtil.__index = MapUtil

function MapUtil.new(fileName)
    local map = setmetatable({}, MapUtil)
    map.map, map.map_row, map.map_col = map:_read_map(fileName)
    return map
end

function MapUtil:_read_map(fileName)
    local file = io.open(fileName, "rb")
    if not file then
        error("not found:", fileName)
    end
    -- header
    local header = file:read(4)
    local max_row = ((string.byte(header, 1) * 256) + string.byte(header, 2))
    local max_col = ((string.byte(header, 3) * 256) + string.byte(header, 4))
    local grids = {}
    local size = max_col * max_row
    -- grids data
    local data = file:read(size)
    for i = 1, max_row do
        grids[i] = {}
        for j = 1, max_col do
            local index = (i - 1) * max_col + j
            grids[i][j] = string.byte(data, index)
        end
    end
    file:close()
    return grids, max_row, max_col
end

function MapUtil:printPath(filename, path)
    if not path then
        print("No path found")
        return
    end
    
    local file = assert(io.open(filename, "w"))
    local path_set = {}
    
    for _, p in ipairs(path) do
        path_set[(p.row - 1) * #self.map[1] + p.col] = true
    end
    for r = 1, #self.map do
        local cols = {}
        for c = 1, #self.map[1] do
            local idx = (r - 1) * #self.map[1] + c
            if path_set[idx] then
                cols[#cols + 1] = "x"
            elseif self.map[r][c] ~= 0 then
                cols[#cols + 1] = "#"
            else
                cols[#cols + 1] = " "
            end
        end
        file:write(table.concat(cols) .. "\n")
    end
    file:close()
end

function MapUtil:isValidPosition(r, c)
    return r >= 1 and r <= self.map_row and c >= 1 and c <= self.map_col and self.map[r][c] == 0
end

function MapUtil:heuristic(r1, c1, r2, c2)
    local dr, dc = (r1 -r2), (c1 - c2)
    return math.sqrt(dr * dr + dc * dc)
end

return MapUtil


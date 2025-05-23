function read_map(filename)
    local file = io.open(filename, "rb")
    if not file then
        error("not found:", filename)
    end
    -- header
    local header = file:read(4)
    local max_row = ((string.byte(header, 1) << 8) + string.byte(header, 2))
    local max_col = ((string.byte(header, 3) << 8) + string.byte(header, 4))
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

function printMap(grids, max_row, max_col)
    for i = 1, max_row do
        local line = ""
        for j = 1, max_col do
            line = line .. grids[i][j]
        end
        print(line)
    end
end

local filename = "map.bytes"
return {read_map = read_map, printMap = printMap}
-- grids, max_row, max_col = read_map(filename)
-- printMap(grids, max_row, max_col)
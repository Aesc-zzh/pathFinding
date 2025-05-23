function printPath(filename, map, path)
    local file = assert(io.open(filename, "w"))
    local path_set = {}
    if not path then
        print("No path found")
        file:close()
        return
    end
    for _, p in ipairs(path) do
        path_set[(p.row - 1) * #map[1] + p.col] = true
    end
    for r = 1, #map do
        local cols = {}
        for c = 1, #map[1] do
            local idx = (r - 1) * #map[1] + c
            if path_set[idx] then
                cols[#cols + 1] = "x"
            elseif map[r][c] ~= 0 then
                cols[#cols + 1] = "#"
            else
                cols[#cols + 1] = " "
            end
        end
        file:write(table.concat(cols) .. "\n")
    end
    file:close()
end

fileName = "bfs_path.csv"
local bfs = require("BFS")
local map, path = bfs.bfs()
printPath(fileName, map, path)
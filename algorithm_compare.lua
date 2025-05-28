local map_file = "map.bytes"
local start = {row = 1, col = 1}
local goal = {row = 222, col = 34}

local MapUtilClass = require("map_util")
local map_util = MapUtilClass.new(map_file)

local bfs_find = require("BFS").bfs
local Astar_find = require("Astar").Astar
local JPS_find = require("JPS").JPS

local fuc = {bfs_find, Astar_find, JPS_find}

local time_cost = {}
local path_length = {}

for i, find in ipairs(fuc) do
    local startTime = os.clock()
    local path = find(map_util, start, goal)
    local endTime = os.clock()
    if path then
        table.insert(time_cost, endTime - startTime)
        table.insert(path_length, #path)
    else
        print("algorithm " .. i .. " failed")
    end
end

local csv_file = io.open(".\\algorithm_compare.csv", "w")
csv_file:write("algorithm,time_cost,path_length\n")
local algorithms_name = {"BFS", "A*", "JPS"}
for i, name in ipairs(algorithms_name) do
    csv_file:write(string.format("%s,%f,%d\n", algorithms_name[i], time_cost[i], path_length[i]))
end

csv_file:close()

print("Results saved to results.csv")
local map_file = "map.bytes"
local start = {row = 1, col = 1}
local goal = {row = 196, col = 20}

local MapUtilClass = require("map_util")
local map_util = MapUtilClass.new(map_file)

local bfs_find = require("BFS").bfs
local greedy_bfs_find = require("greedyBFS").greedy_bfs
local dijkstra_find = require("Dijkstra").dijkstra
local Astar_find = require("Astar").Astar
local JPS_find = require("JPS").JPS
local AstarWithSmoothing_find = require("AstarWithSmoothing").AstarWithSmoothing

local fuc = {bfs_find, greedy_bfs_find, dijkstra_find, Astar_find, JPS_find, AstarWithSmoothing_find}

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
csv_file:write("algorithm,time_cost,Number of path nodes\t\n")
local algorithms_name = {"BFS", "Greedy BFS", "Dijkstra", "A*", "JPS", "A* with smoothing"}

for i, name in ipairs(algorithms_name) do
    csv_file:write(string.format("%s,%f,%d\t\n", algorithms_name[i], time_cost[i], path_length[i]))
end

csv_file:close()

print("Results saved to results.csv")
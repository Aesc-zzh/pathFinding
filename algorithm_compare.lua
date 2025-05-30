local map_file = "map.bytes"
local point = {
    {start = {row = 203, col = 183}, goal = {row = 715, col = 255}},
    {start = {row = 239, col = 1435}, goal = {row = 46, col = 1101}},
    {start = {row = 288, col = 1060}, goal = {row = 747, col = 1296}},
    {start = {row = 660, col = 811}, goal = {row = 1159, col = 787}},
    {start = {row = 1500, col = 736}, goal = {row = 89, col = 308}}
}

local MapUtilClass = require("map_util")
local map_util = MapUtilClass.new(map_file)

local bfs_find = require("BFS").bfs
local greedy_bfs_find = require("greedyBFS").greedy_bfs
local dijkstra_find = require("Dijkstra").dijkstra
local Astar_find = require("Astar").Astar
local JPS_find = require("JPS").JPS
local AstarWithSmoothing_find = require("AstarWithSmoothing").AstarWithSmoothing

local fuc = {bfs_find, greedy_bfs_find, dijkstra_find, Astar_find, JPS_find, AstarWithSmoothing_find}

local time_cost = {0, 0, 0, 0, 0, 0}
local path_length = {0, 0, 0, 0, 0, 0}

for k = 1, #point do
    local start = point[k].start
    local goal = point[k].goal
    
    for i, find in ipairs(fuc) do
        local startTime = os.clock()
        local path = find(map_util, start, goal)
        local endTime = os.clock()
        if path then
            time_cost[i] = time_cost[i] + endTime - startTime
            path_length[i] = path_length[i] + #path
        else
            print("algorithm " .. i .. " failed")
        end
    end


end

for i = 1, #fuc do
    time_cost[i] = time_cost[i] / #point
    path_length[i] = path_length[i] / #point
end

local csv_file = io.open(".\\algorithm_compare.csv", "w")
csv_file:write("algorithm,time_cost,Number of path nodes\t\n")
local algorithms_name = {"BFS", "Greedy BFS", "Dijkstra", "A*", "JPS", "A* with smoothing"}

for i, name in ipairs(algorithms_name) do
    csv_file:write(string.format("%s,%f,%f\t\n", name, time_cost[i], path_length[i]))
end

csv_file:close()

print("Results saved to results.csv")
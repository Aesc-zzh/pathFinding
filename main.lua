local arg = {...}
if #arg < 6 then
    print("Usage: lua main.lua <algorithm> <map_file> <start_row> <start_col> <goal_row> <goal_col>")
    return
end

local algorithm = arg[1]
local map_file = arg[2]
local start_row = tonumber(arg[3])
local start_col = tonumber(arg[4])
local goal_row = tonumber(arg[5])
local goal_col = tonumber(arg[6])

local MapUtilClass = require("map_util")
local map_util = MapUtilClass.new(map_file)

local start = {row = start_row, col = start_col}
local goal = {row = goal_row, col = goal_col}

if not map_util:isValidPosition(start.row, start.col) then
    print("Invalid start position")
    return
end
if not map_util:isValidPosition(goal.row, goal.col) then
    print("Invalid goal position")
    return
end

local findPath
if string.upper(algorithm) == "BFS" then
    findPath = require("BFS").bfs
elseif string.upper(algorithm) == "ASTAR" then
    findPath = require("ASTAR").Astar
elseif string.upper(algorithm) == "JPS" then
    findPath = require("JPS").JPS
elseif string.upper(algorithm) == "SMOOTHING" then
    findPath = require("AstarWithSmoothing").AstarWithSmoothing
else
    print("Invalid algorithm:" .. algorithm) 
    return
end

local path = findPath(map_util, start, goal)
local output_file = algorithm .. "_path.csv"
map_util:printPath(output_file, path)

-- 根据提供的位置范围随机生成5组有效点对
local function generate_valid_point_pairs(map_util, start_row, start_col, goal_row, goal_col, count)
    local rows = map_util.map_row
    local cols = map_util.map_col

    local point_pairs = {}
    local attempts = 0
    local max_attempts = count * 10  -- 最大尝试次数
    
    while #point_pairs < count and attempts < max_attempts do
        attempts = attempts + 1
        
        local start = {
            row = math.random(start_row-20, start_row+20),
            col = math.random(start_col-20, start_col+20)
        }
        local goal = {
            row = math.random(goal_row-20, goal_row+20),
            col = math.random(goal_col-20, goal_col+20)
        }
        
        if not (start.row == goal.row and start.col == goal.col) and
           map_util:isValidPosition(start.row, start.col) and
           map_util:isValidPosition(goal.row, goal.col) then
            
            local path = require("BFS").bfs(map_util, start, goal)
            if path then
                table.insert(point_pairs, {
                    start = start,
                    goal = goal,
                    path_length = #path
                })
            end
        end
    end
    
    return point_pairs
end

local function generate_start_goal_point(map_util, start_row, start_col, goal_row, goal_col)
    local rows = map_util.map_row
    local cols = map_util.map_col
    
    -- 生成5组有效点对
    local test_cases = generate_valid_point_pairs(map_util, start_row, start_col, goal_row, goal_col, 5)
    
    for i, case in ipairs(test_cases) do
        print(string.format("Case %d:", i))
        print(string.format("  Start: (%d, %d)", case.start.row, case.start.col))
        print(string.format("  Goal: (%d, %d)", case.goal.row, case.goal.col))
        print(string.format("  Path length: %d", case.path_length))
        print()
    end
    
    return test_cases
end

local map_file = "map.bytes"
local MapUtilClass = require("map_util")
local map_util = MapUtilClass.new(map_file)
local test_cases = generate_start_goal_point(map_util, 1493, 749, 91, 300)


-- return {
--     generate_start_goal_point = generate_start_goal_point
-- }
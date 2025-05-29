# pathFinding
## Overview
实现并比较了Breadth-First Search (BFS), Greedy BFS, Dijkstra, A*, Jump Point Search (JPS), 以及弗洛伊德路径平滑算法

## Directory Structure
- main.lua: 运行寻路算法的主脚本
- map_util.lua: 地图工具
- minheap.lua: 最小堆实现
- BFS.lua: BFS算法
- greedyBFS.lua: 贪心BFS算法
- Dijkstra.lua: 弗洛伊德路径平滑算法
- Astar.lua: A*算法
- JPS.lua: JPS算法
- AstarWithSmoothing.lua: 对A*进行弗洛伊德路径平滑优化
- BFS_path.csv: BFS寻路结果
- Astar_path.csv: A*寻路结果
- JPS_path.csv: JPS寻路结果
- Astar_smooth_path.csv: A*弗洛伊德平滑优化结果

## Running the Script
```bash
lua main.lua <algorithm> <map_file> <start_row> <start_col> <goal_row> <goal_col> 
```
Example:
```bash
lua main.lua Astar map.bytes 1 1 10 10
```

Algorithm Comparison Results

Summary Table
|Algorithm | Time Cost | Number of path nodes|
|----------|----------|------------|
|BFS|0.0618|190|
|Greedy BFS|0.0562|190|
|Dijkstra|0.078|190|
|A*|0.0014|190|
|JPS|0.0044|189.8|
|A* with Smoothing|0.001|3.6|
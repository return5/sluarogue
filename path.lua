local function getStartStopX(rand,rooms)
    local s_x = {}
    for i=1,#rooms, 1 do
        local x = 0
        local n = rand(0,8)
        if n < 3 then
            x = rooms[i].x
        elseif n < 6 then
            x = rooms[i].x + rooms[i].width
        else
            x = rand(rooms[i].x + 1,rooms[i].x + rooms[i].width - 1)
        end
        s_x[i] = x
    end
    return s_x
end

local function getStartStopY(rand,rooms,s_x)
    local s_y = {}
    for i=1,#s_x,1 do
        local y = 0
        if s_x[i] == rooms[i].x or s_x[i] == rooms[i].x + rooms[i].width then
            y = rand(rooms[i].y + 1, rooms[i].y + rooms[i].height - 1)
        else
            y = rand(0,9) < 5 and rooms[i].y or (rooms[i].y + rooms[i].height)
        end
        s_y[i] = y
    end
    return s_y
end

function makeStartStop(rooms)
    local rand    = math.random 
    local start_x = getStartStopX(rand,rooms)
    local start_y = getStartStopY(rand,rooms,start_x)
    local stop_x  = getStartStopX(rand,rooms)
    local stop_y  = getStartStopY(rand,rooms,stop_x)
    local start   = {}
    local stop    = {}
    for i=1,#start_x - 1, 1 do
        start[i] = {start_x[i] + 1,start_y[i] + 1}
        stop[i]  = {stop_x[i + 1] + 1,stop_y[i + 1] + 1}
    end
    --set the last start point to last room, and last stop to first room
    start[#start + 1] = {start_x[#start_x] + 1,start_y[#start_y] + 1} 
    stop[#stop + 1]   = {stop_x[1] + 1,stop_y[1] + 1}
    return start,stop
end

local function makePath(finder,start,stop,additem)
    local my_path = finder:getPath(start[1],start[2],stop[1],stop[2])
    local path    = {}
    for node,_ in my_path:nodes() do
        additem(path,{node:getX(),node:getY()})
    end
    return path
end

function makePaths(map,start,stop)
    local paths    = {}
    local makepath = makePath
    local Grid     = require("jumper.grid")
    local Pf       = require ("jumper.pathfinder") 
    local grid     = Grid(map)
    local finder   = Pf(grid,'DIJKSTRA',0)
    local additem  = table.insert
    finder:setMode("ORTHOGONAL")
    for i=1,#start,1 do
        additem(paths,makepath(finder,start[i],stop[i],additem))
    end
    return paths
end



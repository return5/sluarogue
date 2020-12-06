local Tile   = require("tile")
local Ncurse = require("sluacurses")


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
        start[i] = TILE:new(start_x[i],start_y[i],"=")
        stop[i]  = TILE:new(stop_x[i + 1],stop_y[i + 1],"=")
    end
    return start,stop
end

function makePaths(map,start,stop)
    local paths    = {}
    local rand     = math.random
    local additem  = table.insert
    local makepath = makePath
    for i=1,#start,1 do
        paths[i] = makepath(start,stop,rand,additem)
    end
    return paths
end



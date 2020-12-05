local Tile   = require("tile")
local Ncurse = require("sluacurses")


local function getStartStopX(rand,rooms,additem)
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
        additem(s_x,x)
    end
    return s_x
end

local function getStarStoptY(rand,rooms,s_x,additem)
    local s_y = {}
    for i=1,#s_x,1 do
        local y = 0
        if s_x[i] == rooms[i].x or s_x[i] == rooms[i]. + rooms[i].width then
            y = rand(rooms[i].y + 1, rooms[i].y + rooms[i].height - 1)
        else
            y = rand(0,9) < 5 and rooms[i].y or (rooms[i].y + rooms[i].height)
        end
        additem(s_y,y)
    end
    return s_y
end


local function makeStartStop(rooms)
    local rand    = math.random 
    local start_x = getStartStopX(rand,rooms,additem)
    local start_y = getStartStopY(rand,rooms,start_x,additem)
    local stop_x  = getStartStopX(rand,rooms,additem)
    local stop_y  = getStartStopY(rand,rooms,stop_x,additem)
    return start_x,start_y,stop_x,stop_y
end

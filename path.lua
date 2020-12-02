local Tile = require("tile")
local Ncurse = require("sluacurses")

local function checkVal(room_v,room_p,val)
    if val > room_v and val < (room_v + room_p) then
        return true
    end
    return false
end

local function getStartX(i,rand,rooms)
    local n = rand(0,8)
    local x 
    if n < 2 then
        x = rooms[i].x
    elseif n < 5 then
        x = rooms[i].x + rooms[i].width
    else
        x = rand(rooms[i].x + 1, rooms[i].x + rooms[i].width - 1)
    end
    return x
end

local function getStartY(i,x,rand,rooms)
    local y 
    if x == rooms[i].x or x == rooms[i].x + rooms[i].width then
        y = rand(rooms[i].y + 1, rooms[i].y + rooms[i].height - 1)
    else
        y = rand(0,9) < 5 and rooms[i].y or (rooms[i].y + rooms[i].height)
    end
    return y
end


local function getStartStopXY(rand,additem,rooms)
    local start = {}
    local stop  = {}
    local getx  = getStartX
    local gety  = getStartY
    for i=1,#rooms - 1,1 do
        local start_x = getx(i,rand,rooms) 
        local start_y = gety(i,start_x,rand,rooms)
        local stop_x  = getx(i + 1,rand,rooms) 
        local stop_y  = gety(i + 1,stop_x,rand,rooms)
        additem(start,TILE:new(start_x,start_y,"="))
        additem(stop,TILE:new(stop_x,stop_y,"="))
    end
    return start,stop
end

local function checkPath(x,y,path)
    for i=1, #path,1 do
        if x == path[i].x and y == path[i].y then
            return false
        end
    end
    return true
end

local function checkValid(x,y,stop,path)
    if x > WIDTH or x < 0 then
        return false
    end
    if y > HEIGHT or y < 0 then
        return false
    end
    if x == stop.x and y == stop.y then
        return true
    end
    if MAP[y + 1][x + 1].icon ~= "*" and MAP[y + 1][x + 1].icon ~= "=" then
        return false
    end
    return checkPath(x,y,path)
end

local function getValidTiles(x,y,stop,additem,map,checkvalid,path)
    local valid_tiles = {}
    if checkvalid(x+1,y,stop,path) then
        additem(valid_tiles,TILE:new(x + 1,y,"="))
    end
    if checkvalid(x - 1,y,stop,path) then
        additem(valid_tiles,TILE:new(x - 1, y,"="))
    end
    if checkvalid(x,y + 1,stop,path) then
        additem(valid_tiles,TILE:new(x,y + 1,"="))
    end
    if checkvalid(x,y - 1,stop,path) then
        additem(valid_tiles,TILE:new(x, y - 1,"="))
    end
    return valid_tiles
end

local function goStraightForStop(val,stop)
    if val < stop then
        val = val + 1
    elseif val > stop then
        val = val - 1
    end
    return val
end

local function makePath(start,stop,rand,getvalidtiles,additem,map,goforstop,checkvalid)
    local path        = {}
    local x           = start.x
    local y           = start.y
    local valid_tiles = {}
    additem(path,TILE:new(x,y,"="))
    map[y + 1][x + 1].icon = "="
    repeat
        local prev_x = x
        local prev_y = y
        x = goforstop(x,stop.x)
        if checkvalid(x,y,stop,path) == false then
            y = goforstop(y,stop.y)
            if checkvalid(prev_x,y,stop,path) == false then
                valid_tiles = getvalidtiles(prev_x,prev_y,stop,additem,map,checkvalid,path)
                local i = rand(1,#valid_tiles)
                x       = valid_tiles[i].x
                y       = valid_tiles[i].y
            end
        end
        additem(path,TILE:new(x,y,"="))
        mvprintw(y,x,"=")
        refresh()
        getch()
    until(x == stop.x and y == stop.y)
    getch()
    return path
end

function makePaths(map,rooms)
    local additem       = table.insert
    local rand          = math.random
    local makepath      = makePath
    local goforstop     = goStraightForStop
    local paths         = {}
    local checkvalid    = checkValid
    local start,stop    = getStartStopXY(rand,additem,rooms)
    local getvalidtiles = getValidTiles
   for i = 1,#stop,1 do
        mvprintw(start[i].y,start[i].x,"=")
        mvprintw(stop[i].y,stop[i].x,"=")
        additem(paths,makepath(start[i],stop[i],rand,getvalidtiles,additem,map,goforstop,checkvalid))
    end
    return paths
end




local Tile = require("tile")
local Room = require("room")

local function checkVal(room_v,room_p,val)
    if val > room_v and val < (room_v + room_p) then
        return true
    end
    return false
end

local function addPathToMap(path,map)
    for i=1,#path,1 do
        map[path[i].y][path[i].x].icon = path[i].icon
    end
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

local function addStartStopToMap(start,stop,map)
    for i = 1,#start,1 do
        map[start[i].y + 1][start[i].x + 1].icon = start[i].icon
        map[stop[i].y + 1][stop[i].x + 1].icon = stop[i].icon
    end
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

local function getValidTiles(x,y,stop,val,checkxy,checkval,additem,map,rooms)
    local valid_tiles = {}
    if checkxy(x + 1,y,stop,checkval,map,rooms) == false and (val or x < stop.x) then
        additem(valid_tiles,TILE:new(x + 1,y,"="))
    end
    if checkxy(x - 1,y,stop,checkval,map,rooms) == false and (val or x > stop.x) then
        additem(valid_tiles,TILE:new(x - 1, y,"="))
    end
    if checkxy(x,y + 1,stop,checkval,map,rooms) == false and (val or y < stop.y) then
        additem(valid_tiles,TILE:new(x,y + 1,"="))
    end
    if checkxy(x,y - 1,stop,checkval,map,rooms) == false and (val or y > stop.y) then
        additem(valid_tiles,TILE:new(x, y - 1,"="))
    end
    return valid_tiles
end

local function checkXY(x,y,stop,checkval,map,rooms)
    if x == stop.x and y == stop.y then
        return false
    end
    if x < 0 or y < 0 or y + 1 > HEIGHT or x + 1 > WIDTH then
        return true
    elseif map[y][x].icon == "-" or map[y][x].icon == "|" then
        return true
    end
    for i = 1, #rooms,1 do
        if checkval(rooms[i].x,rooms[i].width,x) and checkval(rooms[i].y,rooms[i].height,y)then
            return true
        end
    end
    return false
end

local function makePath(start,stop,rand,getvalidtiles,additem,checkxy,checkval,map,rooms)
    local path   = {}
    local x      = start.x
    local y      = start.y
    repeat
        local valid_tiles = getvalidtiles(x,y,stop,false,checkxy,checkval,additem,map,rooms)
        if #valid_tiles < 1 then
            valid_tiles = getvalidtiles(x,y,stop,true,checkxy,checkval,additem,map,rooms)
        end
        local i = rand(1,#valid_tiles)
        x       = valid_tiles[i].x
        y       = valid_tiles[i].y
        additem(path,valid_tiles[i])
      --  mvprintw(y+1,x+1,"=")
        --refresh()
    until(x == stop.x and y == stop.y)
    return path
end

function makePaths(map,rooms)
    local pathtomap  = addPathToMap
    local additem    = table.insert
    local rand       = math.random
    local getvalidtiles = getValidTiles
    local checkxy    = checkXY
    local makepath   = makePath
    local checkval   = checkVal
    local path       = {}
    local start,stop = getStartStopXY(rand,additem,rooms)
    addStartStopToMap(start,stop,map)
   for i = 1, #start,1 do
        --additem(path,makepath(start[i],stop[i],rand,getvalidtiles,additem,checkxy,checkval,map,rooms))
       -- pathtomap(path[i],map)
    end
    return map
end




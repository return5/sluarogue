--File contains functions for creating collision map and game map

local Path  = require("auxillary.path")
local Rooms = require("auxillary.room")

HEIGHT = 45
WIDTH  = 100

local MAP   = {}
MAP.__index = MAP

function MAP:new()
    local self    = setmetatable({},MAP)
    for i=1,HEIGHT,1 do
        self[i] = {}    
    end
    return self
end

local function addIconToMap(map,i,j,icon)
    map[i][j] = icon
end

--iterate through room by width. start at left and move right. each iteration is a column in room.
local function iterateRoomWidth(map,y,start_x,end_x,icon,addicon)
    for i=start_x,end_x,1 do
        addicon(map,y,i,icon)
    end
end

--loop through a room by its height. start at top and work way down to bottom. each iteration is a row in rom
local function iterateRoomHeight(map,start_y,end_y,start_x,end_x,icon,addicon,itwidth)
     for i=start_y,end_y,1 do
        itwidth(map,i,start_x,end_x,icon,addicon)
    end
end

--add each elelemnt fomr paths to the collision map
local function addPathsToCollisionMap(map,paths)
    for i=1,#paths,1 do
        for j=1,#paths[i],1 do
            map[paths[i][j][2]][paths[i][j][1]] = 4
        end
    end
end

local function convertToWalkable(map,i,j)
    if map[i][j] == 3 then
        map[i][j] = 4
    end
end

--take an icon form the collision map and convert it to the icon for game map
local function convertCollisionToMap(collision,i,j,map)
    local icon     = collision[i][j]
    local new_icon = "."
    if icon == 1 then
        new_icon = "-"
    elseif icon == 2 then
        new_icon = "|"
    elseif icon == 3 then
        new_icon = " "
    elseif icon == 4 then
        new_icon = "#"
    end
    map[i][j] = {icon = new_icon,visible = false}
end

--loop through a map table and call passed in funcion for each item
local function loopMap(map,fn,item)
    local func = fn
    for i=1,HEIGHT,1 do
        for j=1,WIDTH,1 do
            func(map,i,j,item)            
        end
    end
end

--loop through the rooms table. call the passed in function 'fn' on each room
local function loopRooms(map,rooms,fn,top,side,middle)
    local func = fn
    for i=1,#rooms,1 do
        func(map,rooms[i],top,side,middle)
    end
end

--add the doors of each room to the collision mp
local function addStartStopToCollision(collision_map,start,stop)
    for i = 1, #start,1 do
        collision_map[start[i][2]][start[i][1]] = 0
        collision_map[stop[i][2]][stop[i][1]]   = 0
    end
end

--add a room to the game map. 
local function addRoomToMap(map,room,top,side,middle)
    local addicon  = addIconToMap
    local y_limit  = room.y + room.height 
    local x_limit  = room.x + room.width
    local itwidth  = iterateRoomWidth
    local itheight = iterateRoomHeight
    itheight(map,room.y + 1,y_limit - 1,room.x + 1,x_limit - 1,middle,addicon,itwidth)
    itheight(map,room.y,y_limit,room.x,room.x,side,addicon,itwidth)
    itheight(map,room.y,y_limit,x_limit,x_limit,side,addicon,itwidth)
    itheight(map,room.y,room.y,room.x,x_limit,top,addicon,itwidth)
    itheight(map,y_limit,y_limit,room.x,x_limit,top,addicon,itwidth)
end

--if tile is within view of the player then switch it to visible.
function makeVisible(map,y,x)
    for i=y - 6,y + 6,1 do
        for j=x - 6,x + 6,1 do
            if i > 0 and i < HEIGHT and j > 0  and j < WIDTH then
                map[i][j].visible = true
            end
        end
    end
end

--make collision map for game
local function makeMap(rooms)
    local collision_map = MAP:new()
    local start,stop    = makeStartStop(rooms)
    loopMap(collision_map,addIconToMap,0)
    loopRooms(collision_map,rooms,addRoomToMap,1,2,3)
    addStartStopToCollision(collision_map,start,stop)
    local paths = makePaths(collision_map,start,stop)
    if paths == false then
        return true,nil
    end
    addPathsToCollisionMap(collision_map,paths)
  return false,collision_map
end

local function makeGameMap(collision_map)
    local game_map = MAP:new()
    loopMap(collision_map,convertCollisionToMap,game_map)
    return game_map
end

--convert all walkable tiles in collision map to a 4
local function updateCollisionMap(collision_map)
    loopMap(collision_map,convertToWalkable,nil)    
    return collision_map
end

--make game map, collision map, and rooms.
-- each iteration of the loop is the pathfinder trying to find a valid path to each door of each room.
function createMaps()
   local rooms,collision_map
   local keep_trying = true
   repeat
        rooms,collision_map        = nil
        rooms                      = makeRooms(8)
        keep_trying, collision_map = makeMap(rooms)
    until(keep_trying == false)
    game_map      = makeGameMap(collision_map)
    collision_map = updateCollisionMap(collision_map)
    return {rooms,game_map,collision_map}
end

--place the exit into a random room excluding the room the player strats in.
function makeExit(maps,i)
    local r
    local rand = math.random
    repeat
        r = rand(1,#maps[1])
    until(r ~- i)
    local room = maps[1][r]
    local x    = rand(room.x + 1,room.x + room.width - 1)
    local y    = rand(room.y + 1,room.y + room.height - 1)
    maps[2][y][x].icon = '&' 
end


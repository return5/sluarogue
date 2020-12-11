local Path  = require("path")
local Room  = require("room")

HEIGHT = 45
WIDTH  = 100

MAP = {{}}
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

local function iterateRoomWidth(map,y,start_x,end_x,icon,addicon)
    for i=start_x,end_x,1 do
        addicon(map,y + 1,i + 1,icon)
    end
end

local function iterateRoomHeight(map,start_y,end_y,start_x,end_x,icon,addicon,itwidth)
     for i=start_y,end_y,1 do
        itwidth(map,i,start_x,end_x,icon,addicon)
    end
end

local function printIcon(map,i,j)
    mvprintw(i - 1,j - 1,"%c",map[i][j])
end

local function addPathsToCollisionMap(map,paths)
    for i=1,#paths,1 do
        for j=1,#paths[i],1 do
            map[paths[i][j][2]][paths[i][j][1]] = 4
        end
    end
end

local function loopMap(map,fn,item)
    local func = fn
    for i=1,HEIGHT,1 do
        for j=1,WIDTH,1 do
            func(map,i,j,item)            
        end
    end
end

local function loopRooms(map,rooms,fn,top,side,middle)
    local func = fn
    for i=1,#rooms,1 do
        func(map,rooms[i],top,side,middle)
    end
end

local function addStartStopToCollision(collision_map,start,stop)
    for i = 1, #start,1 do
        collision_map[start[i][2]][start[i][1]] = 0
        collision_map[stop[i][2]][stop[i][1]]   = 0
    end
end

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


math.randomseed(os.time())      --seed random number generator

MAP           = MAP:new()
collision_map = MAP:new()
loopMap(MAP,addIconToMap," ")
loopMap(collision_map,addIconToMap,0)
local rooms   = makeRooms(2)
loopRooms(MAP,rooms,addRoomToMap,"-","|"," ")
loopRooms(collision_map,rooms,addRoomToMap,1,2,3)
local start,stop = makeStartStop(rooms)
addStartStopToCollision(collision_map,start,stop)
--for i,_ in ipairs(start) do
  --  io.write("start[",i,"]: ",start[i][1],start[i][2],"\n")
    --io.write("stop[",i,"]: ",stop[i][1],stop[i][2],"\n")
--end
local paths = makePaths(collision_map,start,stop)
addPathsToCollisionMap(collision_map,paths)
initscr()
refresh()
loopMap(collision_map,printIcon,nil)
getch()
endwin()


local Path  = require("path")
local Room = require("room")

HEIGHT = 35
WIDTH  = 80

MAP = {}
MAP.__index = MAP

function MAP:new()
    local self    = setmetatable({},MAP)
    local additem = table.insert
    for i = 0,HEIGHT,1 do
        local row = {}
        for j = 0,WIDTH,1 do
             additem(row,TILE:new(j,i,"*"))
        end
        additem(MAP,row)
    end
    return self
end

local function printMap()
    local mvp = mvprintw
    for i=1,HEIGHT,1 do
        for j=1,WIDTH,1 do
            mvp(MAP[i][j].y,MAP[i][j].x,MAP[i][j].icon)
        end
    end
end

local function addRoomToMap(room)
    local long = room.y + room.height
    local wide = room.x + room.width
    for i=room.y,long,1 do
        for j = room.x,wide,1 do
            if i == room.y or i == long then
                MAP[i + 1][j + 1].icon = "-"
            elseif j == room.x or j == wide then
                MAP[i + 1][j + 1].icon = "|"
            else
                MAP[i + 1][j + 1].icon = " "
            end
        end
    end
end

local function addPathsToMap(paths)
    for i=1,#paths,1 do
        for j = 1,#paths[i],1 do
            MAP[paths[i][j].y + 1][paths[i][j].x + 1].icon = paths[i][j].icon
        end
    end
end


local function addStartStopToMap(start,stop)
    for i=1,#start,1 do
        MAP[start[i].y][start[i].x] = start[i]
        MAP[stop[i].y][stop[i].x]   = stop[i]
    end
end

math.randomseed(os.time())      --seed random number generator

MAP = MAP:new()
local rooms = makeRooms(2)
local addroom = addRoomToMap
for i=1,#rooms,1 do
    addroom(rooms[i])
end
initscr()
refresh()
local start,stop = makeStartStop(rooms)
addStartStopToMap(start,stop)
local paths = makePaths(MAP,roomsmstart,stop)
addPathsToMap(paths)
printMap()
getch()
endwin()


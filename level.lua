local curse = require("sluacurses")
ROOM   = {room = {}, height = nil, width = nil,x = nil,y = nil}
ROOM.__index = ROOM
ROOMS  = {}
HEIGHT = 25
WIDTH  = 80

TILE = {x = nil, y = nil, icon=nil}
TILE.__index = TILE
PATH = {}
PATH.__index = PATH
CONNECTIONS = {}
CONNECTIONS.__index = CONNECTIONS


local function getStartStopXY()
    local start   = {}
    local stop    = {}
    local rand    = math.random
    local additem = table.insert
    for i=1,ROOMS.length - 1,1 do
        local start_x = rand(ROOMS[i].x,ROOMS[i].x + ROOMS[i].width)
        local start_y = rand(ROOMS[i].y,ROOMS[i].y + ROOMS[i].height)
        local stop_x = rand(ROOMS[i+1].x,ROOMS[i+1].x + ROOMS[i+1].wi+1dth)
        local stop_y = rand(ROOMS[i+1].y,ROOMS[i+1].y + ROOMS[i+1].hei+1ght)
        additem(start,TILE:new(start_x,start_y,"="))
        additem(stop,TILE:new(stop_x,stop_y,"="))
    end
    return start,stop
end

function CONNECTIONS:new()
    local self = setmetatable({},CONNECTIONS)
    local start,stop = getStartStopXY()
    local additem    = table.insert
    for i,_ in ipairs(start) do
        additem(self,PATH:NEW(start[i],stop[i]))
    end
    return self
end

local function makeNewTile(prev_x,prev_y,stop)

end

function PATH:new(start,stop)
    local self = setmetatable({},PATH)
    local additem = table.insert
    additem(self,start)
    local x = start.x
    local y = start.y
    repeat
        x,y = makeNewTile(x,y,stop)
        additem(self,TILE:new(x,y,"="))
    until(x == stop.x and y == stop.y)
    return self
end

function TITLE:new(x,y,icon)
    local self = setmetatable({},TILE)
    self.x     = x
    self.y     = y
    self.icon  = icon
    return self
end

local function makeRoom(h,w)
    local room = {}
    local str  = string.rep("-",w)
    table.insert(room,str)
    for i=1,h - 1,1 do
        str = "|" .. string.rep(" ",w - 2) .. "|"
        table.insert(room,str)
    end
    str  = string.rep("-",w)
    table.insert(room,str)
    return room
end

function ROOM:new(height,width,x,y)
    local self   = setmetatable({},ROOM)
    self.height  = height
    self.width   = width
    self.room    = makeRoom(height,width)
    self.x       = x
    self.y       = y
    return self
end

local function getY(h) 
    return math.random(0,HEIGHT - h)
end

local function getX(w)
    return math.random(0,WIDTH - w)
end

local function getWH()
    return math.random(4,8) 
end


local function checkY(room,y,h)
    if y > room.y and y < (room.y + room.height) then
        return true
    end
    if (y + h) > room.y and (y + h) < (room.y + room.height) then
        return true
    end
    return false
end

local function checkX(room,x,w)
    if x > room.x and x  < (room.x + room.width) then
        return true
    end
    if (x + w) > room.x and (x + w) < (room.x + room.width) then
        return true
    end
    return false
end

local function checkOverLap(h,w,x,y)
    for _,room in ipairs(ROOMS) do
        if checkX(room,x,w) then
            if checkY(room,y,h) then
                return true
            end
        end
    end
    return false
end

local function addRoom()
    local h,w,x,y
    repeat
        h = getWH() 
        w = getWH() 
        x = getX(w)
        y = getY(h)
    until(checkOverLap(h,w,x,y) == false)
    table.insert(ROOMS,ROOM:new(h,w,x,y))
end

local function printRoom(room) 
    for i,str in ipairs(room.room) do
        mvprintw(room.y + i - 1,room.x,str)
    end
end

math.randomseed(os.time())      --seed random number generator


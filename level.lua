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



local function getStartX(i,rand)
    local n = rand(0,2)
    local x
    if n == 0 then
        x = ROOMS[i].x
    elseif n == 1 then
        x = ROOMS[i].x + ROOMS[i].width - 1
    elseif n == 2 then
        x = rand(ROOMS[i].x + 1,ROOMS[i].x + ROOMS[i].width - 2)
    end
    return x
end

local function getStartY(i,x,rand)
    local y
    if x == ROOMS[i].x or x == ROOMS[i].x + ROOMS[i].width - 1 then
        y = rand(ROOMS[i].y + 1,ROOMS[i].y + ROOMS[i].height - 2)
    else
        y = rand(0,1) < 1 and ROOMS[i].y or (ROOMS[i].y + ROOMS[i].height)
    end
    return y
end

local function getStartStopXY()
    local start   = {}
    local stop    = {}
    local rand    = math.random
    local getx    = getStartX
    local gety    = getStartY
    local additem = table.insert
    for i=1,#ROOMS - 1,1 do
        local start_x = getx(i,rand) 
        local start_y = gety(i,start_x,rand)
        local stop_x  = getx(i + 1,rand) 
        local stop_y  = gety(i + 1,stop_x,rand)
        additem(start,TILE:new(start_x,start_y,"="))
        additem(stop,TILE:new(stop_x,stop_y,"="))
    end
    return start,stop
end


local function checkNewTile(x,y)
    for _,room in ipairs(ROOMS) do
        if x > room.x and x < room.x + room.width then
            if y > room. y and y < room.y + room.height then
                return true
            end
        end
    end
    return false
end

local function getNewXY(prev_x,prev_y,stop)
    local x = prev_x
    local y = prev_y
    if x < stop.x then
        x = prev_x + 1
    elseif prev_x > stop.x then
        x = prev_x - 1
    elseif prev_y < stop.y then
        y = prev_y + 1
    else 
        y = prev_y - 1
    end
    return x,y
end

local function getRandXY(prev_x,prev_y,rand)
    local x   = prev_x
    local y   = prev_y
    local dir = rand(0,3)
    if dir == 0 then
        x = x - 1
    elseif dir == 1 then
        x = x + 1
    elseif dir == 2 then
        y = y + 1
    elseif dir == 3 then
        y = y - 1
    end
    return x,y
end

local function makeNewXY(prev_x,prev_y,stop)
    local check   = checkNewTile
    local getrand = getRandXY 
    local rand    = math.random
    local x,y     = getNewXY(prev_x,prev_y,stop)
    while check(x,y) == true do
        x,y = getrand(prev_x,prev_y,rand)
    end
    return x,y
end

function PATH:new(start,stop)
    local self = setmetatable({},PATH)
    local additem = table.insert
    local newtile = makeNewXY
    additem(self,start)
    local x = start.x
    local y = start.y
    repeat
        x,y = newtile(x,y,stop)
        additem(self,TILE:new(x,y,"="))
    until(x == stop.x and y == stop.y)
    return self
end

function TILE:new(x,y,icon)
    local self = setmetatable({},TILE)
    self.x     = x
    self.y     = y
    self.icon  = icon
    return self
end

local function makeRoom(h,w)
    local room = {}
    local rep  = string.rep
    local str  = rep("-",w)
    local add  = table.insert
    add(room,str)
    for i=1,h - 1,1 do
        str = "|" .. rep(" ",w - 2) .. "|"
        add(room,str)
    end
    str  = rep("-",w)
    add(room,str)
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
    return math.random(4,10),math.random(3,6)
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
    local checkx = checkX
    local checky = checkY
    for _,room in ipairs(ROOMS) do
        if checkx(room,x,w) then
            if checky(room,y,h) then
                return true
            end
        end
    end
    return false
end

local function addRoom()
    local h,w,x,y
    local getx  = getX
    local gety  = getY
    local check = checkOverLap
    local getwh = getWH
    repeat
        w,h = getwh() 
        x   = getx(w)
        y   = gety(h)
    until(check(h,w,x,y) == false)
    table.insert(ROOMS,ROOM:new(h,w,x,y))
end

function CONNECTIONS:new()
    local self = setmetatable({},CONNECTIONS)
    local start,stop = getStartStopXY()
    local additem    = table.insert
    additem(self,start)
    additem(self,stop)
    --for i,_ in ipairs(start) do
  --      additem(self,PATH:new(start[i],stop[i]))
 --   end
    return self
end

local function printRoom(room) 
    local mvp = mvprintw
    for i,str in ipairs(room.room) do
        mvp(room.y + i - 1,room.x,str)
    end
end

local function printPaths()
    local mvp = mvprintw
    for _,path in ipairs(CONNECTIONS) do
        for _,tile in ipairs(path) do
            mvp(tile.y,tile.x,tile.icon)
        end
    end
end

local function printRooms()
    local pr = printRoom
    for _,room in ipairs(ROOMS) do
        pr(room)
    end
end

math.randomseed(os.time())      --seed random number generator

for i = 0,1,1 do
    addRoom()
end
CONNECTIONS = CONNECTIONS:new()

initscr()
refresh()
printRooms()
printPaths()
getch()
endwin()


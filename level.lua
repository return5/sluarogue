ROOM   = {room = {}, height = nil, width = nil,x = nil,y = nil}
ROOM.__index = ROOM
ROOMS  = {}
HEIGHT = 25
WIDTH  = 80

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
    return math.random(3,7) 
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

math.randomseed(os.time())      --seed random number generator

for i=0,4,1 do
    addRoom()
end

for _,room in ipairs(ROOMS) do
    io.write(room.x," ",room.y," ",room.width," ",room.height,"\n")
end


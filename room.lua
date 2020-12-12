local ROOM   = {height = nil, width = nil,x = nil,y = nil}
ROOM.__index = ROOM

function ROOM:new(height,width,x,y)
    local self   = setmetatable({},ROOM)
    self.height  = height
    self.width   = width
    self.x       = x
    self.y       = y
    return self
end

local function getY(h) 
    return math.random(1,HEIGHT - h - 2)
end

local function getX(w)
    return math.random(1,WIDTH - w - 2)
end

local function getWH()
    return math.random(4,14),math.random(3,8)
end

local function checkOverLap(val_start,val_end,room_start,room_end)
    if val_start >= room_start and val_start <= room_end then
        return true
    end
    if val_end >= room_start and val_end <= room_end then
        return true
    end
    return false
end
local function checkRoom(rooms,x,y,w,h,func_table)
    for i=1,#rooms,1 do
        --check if current room is located inside of a square covering rooms[i] exteding 4 blocks in x direction and 2 in y
        if func_table.overlap(x,x + w,rooms[i].x - 4,rooms[i].x + rooms[i].width + 4) and
            func_table.overlap(y,y + h,rooms[i].y - 2,rooms[i].y + rooms[i].height + 2) then
            return true
        end
        -- check if current room covers rooms[i]
        if func_table.underlap(x,0,rooms[i].x,rooms[i].x + rooms[i].width) and
            func_table.underlap(y,0,rooms[i].y,rooms[i].y + rooms[i].height) then
            return true
        end
    end
    return false
end

local function addRoom(rooms,i,func_table)
    local h,w,x,y
    repeat 
    w,h = func_table.getwh() 
    x   = func_table.getx(w)
    y   = func_table.gety(h)
    --keep trying random values until room no longer confliscts with another room
    until(func_table.checkroom(rooms,x,y,w,h,func_table) == false)
    return ROOM:new(h,w,x,y)
end


local function loopRooms(rooms,func_table,stop)
    for i=1,stop,1 do
        func_table.additem(rooms,func_table.addroom(rooms,i,func_table))
    end
end

function makeRooms(stop)
    local getx       = getX
    local gety       = getY
    local addroom    = addRoom
    local getwh      = getWH
    local additem    = table.insert
    local overlap    = checkOverLap
    local checkroom  = checkRoom
    local func_table = 
        {  
            getx = getx,gety = gety,getwh = getwh,additem = additem,overlap = overlap,
            underlap = overlap,checkroom = checkroom,addroom = addroom
        }
    local rooms      = {}
    loopRooms(rooms,func_table,stop)
    return rooms
end


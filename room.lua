ROOM   = {height = nil, width = nil,x = nil,y = nil}
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
    return math.random(4,10),math.random(3,6)
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

local function checkUnderLap(val,room_start,room_end)
    --if current room covers another room
    if room_start <= val and room_end >= val then
        return true
    end
    return false
end

local function checkProximity(val_start,val_end,room_start,room_end,offset)
    if val_start >= room_start - offset and val_start <= room_end + offset then
        return true
    end
    if val_end >= room_start - offset and val_end <= room_end + offset then
        return true
    end
    return false
end

local function checkRoom(rooms,x,y,w,h,func_table)
    for i=1,#rooms,1 do
        if func_table.overlap(x,x + w,rooms[i].x,rooms[i].x + rooms[i].width + 4) and
            func_table.overlap(y,y + h,rooms[i].y,rooms[i].y + rooms[i].height + 2) then
            return true
        end
        if func_table.underlap(x,rooms[i].x,rooms[i].x + rooms[i].width) and
            func_table.underlap(y,rooms[i].y,rooms[i].y + rooms[i].height) then
            return true
        end
        if func_table.checkprox(x,x + w,rooms[i].x, rooms[i].x + rooms[i].width, 4)  and 
            func_table.checkprox(y, y + h,rooms[i].y, rooms[i].y + rooms[i].height,2)then
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
    until(func_table.checkroom(rooms,x,y,w,h,func_table) == false)
    return ROOM:new(h,w,x,y)
end


local function loopRooms(rooms,fn,func_table,stop)
    local func = fn
    for i=1,stop,1 do
        func_table.additem(rooms,func(rooms,i,func_table))
    end
end

function makeRooms(stop)
    local getx       = getX
    local gety       = getY
    local addroom    = addRoom
    local getwh      = getWH
    local additem    = table.insert
    local overlap    = checkOverLap
    local underlap   = checkUnderLap
    local checkroom  = checkRoom
    local additem    = table.insert
    local checkprox  = checkProximity
    local func_table = {
            getx = getx,gety = gety,getwh = getwh,additem = additem,overlap = overlap,
            underlap = underlap,checkroom = checkroom, additem = additem,checkprox = checkprox
    }

    local rooms      = {}
    loopRooms(rooms,addRoom,func_table,stop)
    return rooms
end


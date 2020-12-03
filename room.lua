ROOM   = {height = nil, width = nil,x = nil,y = nil}
ROOM.__index = ROOM

local function checkVal(room_v,room_p,val,off,diff)
    if val > room_v and val < (room_v + room_p) + diff then
        return true
    end
    if (val + off) > room_v - diff and (val + off) < (room_v + room_p) then
        return true
    end
    return false
end

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

local function checkOverLap(h,w,x,y,rooms,checkval)
    if rooms ~= nil then
        for i=1,#rooms,1 do
            if checkval(rooms[i].x,rooms[i].width,x,w,4) then
                if checkval(rooms[i].y,rooms[i].height,y,h,2) then
                    return true
                end
            end
        end
    end
    return false
end

local function addRoom(getx,gety,check,getwh,rooms,checkval)
    local h,w,x,y
    repeat
        w,h = getwh() 
        x   = getx(w)
        y   = gety(h)
    until(check(h,w,x,y,rooms,checkval) == false)
    return ROOM:new(h,w,x,y)
end

function makeRooms(stop)
    local getx     = getX
    local gety     = getY
    local addroom  = addRoom
    local check    = checkOverLap
    local getwh    = getWH
    local additem  = table.insert
    local checkval = checkVal
    local rooms    = {}
    for i = 1,stop,1 do
        additem(rooms,addroom(getx,gety,check,getwh,rooms,checkval))
    end
    return rooms
end


ROOM   = {height = nil, width = nil,x = nil,y = nil}
ROOM.__index = ROOM
ROOMS  = {}


local function checkVal(room_v,room_p,val,off,diff)
    if val > room_v and val < (room_v + room_p) + diff then
        return true
    end
    if (val + off) > room_v - diff and (val + off) < (room_v + room_p) then
        return true
    end
    return false
end

local function addRoomToMap(x,y,h,w)
    local long = y + h
    local wide = x + w
    for i=y,long,1 do
        for j = x,wide,1 do
            if i == y or i == long then
                MAP[i + 1][j + 1].icon = "-"
            elseif j == x or j == wide then
                MAP[i + 1][j + 1].icon = "|"
            else
                MAP[i + 1][j + 1].icon = " "
            end
        end
    end
end

function ROOM:new(height,width,x,y)
    local self   = setmetatable({},ROOM)
    self.height  = height
    self.width   = width
    self.x       = x
    self.y       = y
    addRoomToMap(x,y,height,width)
    return self
end

local function getY(h) 
    return math.random(0,HEIGHT - h - 1)
end

local function getX(w)
    return math.random(1,WIDTH - w - 1)
end

local function getWH()
    return math.random(4,10),math.random(3,6)
end

local function checkOverLap(h,w,x,y)
    local checkval = checkVal
    for _,room in ipairs(ROOMS) do
        if checkval(room.x,room.width,x,w,4) then
            if checkval(room.y,room.height,y,h,2) then
                return true
            end
        end
    end
    return false
end

function addRoom()
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

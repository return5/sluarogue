CHARACTER = {x = nil, y = nil, health = nil, attack = nil, def = nil, inv = nil,icon = nil, name = nil }
CHARACTER.__index = CHARACTER

ENEMY_LIST = {}

function CHARACTER:new(x,y,h,a,d,inv,icon,name)
    local self   = setmetatable({},CHARACTER) 
    self.x       = x
    self.y       = y
    self.health  = h
    self.attack  = a
    self.def     = d
    self.inv     = inv
    self.icon    = icon
    self.name    = name
    return self
end


local function getNumberOfEnemy(room,rand,ceil)
    local size = room.width * room.height
    local prob = ceil(size / 15)
    local num  = rand(0,prob)
    return num
end

function makeEnemyList(rooms)
    local getnumenemy = getNumberOfEnemy
    local rand        = math.random
    local ceil        = math.ceil
    for i=1,#rooms,1 do
        local num = getnumenemy(rooms[i],rand,ceil)
        io.write(num,"\n")
    end
end

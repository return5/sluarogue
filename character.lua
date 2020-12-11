CHARACTER = {x = nil, y = nil, health = nil, attack = nil, def = nil, inv = nil,icon = nil, name = nil }
CHARACTER.__index = CHARACTER

ENEMY_LIST  = {}
local ENEMY_FUNCS  --holds list of functions which make enemy types

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

local function makeSwordsman()
end

local function makeBat()
end

local function makeSpearman()
end

local function makeWolf()
end

local function makeBear()
end

local function makeMonster()
end

local function makeMAge()
end

local function makeRogue()
end

local function getEnemyType(rand)
    return rand(1,#ENEMY_FUNCS)
end

local function getNumberOfEnemy(room,rand,ceil)
    local size = room.width * room.height
    local prob = ceil(size / 15)
    local num  = rand(0,prob)
    return num
end

local function makeEnemies(num,func_table)
    for i=1,num,1 do
        local e_type = func_table.getenemytype(func_table.rand)
        func_table.additem(ENEMY_LIST,ENEMY_FUNCS[e_type]())
    end
end

local function populateEnemyFuncs()
    --list of functions which create difffent enemy types
    ENEMY_FUNCS = {
        makeSwordsman,makeBat,makeSpearman,makeWolf,makeBear,makeMonster,makeMAge,makeRogue
    }
end

function populateEnemyList(rooms)
    populateEnemyFuncs()
    local getnumenemy = getNumberOfEnemy
    local ceil        = math.ceil
    local makeenemies = makeEnemies
    local func_table = {
        rand = math.random,additem = table.insert,
        makeanenemy = makeAnEnemy,getenemytype = getEnemyType
    }
    for i=1,#rooms,1 do
        local num = getnumenemy(rooms[i],func_table.rand,ceil)
        makeenemies(num,func_table)
    end
end

local INV = require("inventory")

local CHARACTER = {x = nil, y = nil, health = nil, attack = nil, def = nil, inv = nil,icon = nil, name = nil }
CHARACTER.__index = CHARACTER

local ENEMY_LIST  = {}
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

local function getXY(rand,room)
    local x  = rand(room.x + 1,room.x + room.width - 1)
    local y  = rand(room.y + 1,room.y + room.height - 1)
    return x,y
end

local function makeSwordsman(rand,room)
    local health  = rand(8,15)
    local attack  = rand(4,6)
    local defense = rand(1,3)
    local h_p     = rand(0,3)
    local gold    = rand(0,200)
    local m_p     = rand(0,3)
    local d_p     = rand(0,3)
    local inv     = INVENTORY:new(h_p,gold,m_p,d_p)
    local icon    = "S"
    local name    = "Swordsman"
    return CHARACTER:new(x,y,health,attack,defense,inv,icon,name)
end

local function makeBat(rand,room)
    local health  = rand(7,15)
    local attack  = rand(1,4)
    local defense = rand(1,2)
    local h_p     = 0 
    local gold    = rand(0,5)
    local m_p     = 0 
    local d_p     = 0 
    local inv     = INVENTORY:new(h_p,gold,m_p,d_p)
    local x,y     = getXY(rand,room)
    local icon    = "B"
    local name    = "Bat"
    return CHARACTER:new(x,y,health,attack,defense,inv,icon,name)
end

local function makeSpearman(rand,room)
    local health  = rand(5,10)
    local attack  = rand(6,9)
    local defense = rand(1,3)
    local h_p     = rand(0,4)
    local gold    = rand(0,250)
    local m_p     = rand(0,4)
    local d_p     = rand(0,4)
    local inv     = INVENTORY:new(h_p,gold,m_p,d_p)
    local x,y     = getXY(rand,room)
    local icon    = "E"
    local name    = "Spearman"
    return CHARACTER:new(x,y,health,attack,defense,inv,icon,name)
end

local function makeWolf(rand,room)
    local health  = rand(5,8)
    local attack  = rand(9,13)
    local defense = rand(1,2)
    local h_p     = 0
    local gold    = 0
    local m_p     = 0
    local d_p     = 0
    local inv     = INVENTORY:new(h_p,gold,m_p,d_p)
    local x,y     = getXY(rand,room)
    local icon    = "W"
    local name    = "Wolf"
    return CHARACTER:new(x,y,health,attack,defense,inv,icon,name)
end

local function makeBear(rand,room)
    local health  = rand(10,20)
    local attack  = rand(4,7)
    local defense = rand(3,5)
    local h_p     = 0
    local gold    = rand(0,10)
    local m_p     = 0
    local d_p     = 0
    local inv     = INVENTORY:new(h_p,gold,m_p,d_p)
    local x,y     = getXY(rand,room)
    local icon    = "D"
    local name    = "Bear"
    return CHARACTER:new(x,y,health,attack,defense,inv,icon,name)
end

local function makeMonster(rand,room)
    local health  = rand(7,12)
    local attack  = rand(5,8)
    local defense = rand(1,2)
    local h_p     = rand(0,1)
    local gold    = rand(0,100)
    local m_p     = rand(0,1)
    local d_p     = rand(0,1)
    local inv     = INVENTORY:new(h_p,gold,m_p,d_p)
    local x,y     = getXY(rand,room)
    local icon    = "M"
    local name    = "Monster"
    return CHARACTER:new(x,y,health,attack,defense,inv,icon,name)
end

local function makeMAge(rand,room)
    local health  = rand(5,8)
    local attack  = rand(2,6)
    local defense = rand(1,2)
    local h_p     = rand(0,6)
    local gold    = rand(0,400)
    local m_p     = rand(0,6)
    local d_p     = rand(0,3)
    local inv     = INVENTORY:new(h_p,gold,m_p,d_p)
    local x,y     = getXY(rand,room)
    local icon    = "V"
    local name    = "Mage"
    return CHARACTER:new(x,y,health,attack,defense,inv,icon,name)
end

local function makeRogue(rand,room)
    local health  = rand(4,9)
    local attack  = rand(5,7)
    local defense = rand(1,3)
    local h_p     = rand(0,4)
    local gold    = rand(0,150)
    local m_p     = rand(0,1)
    local d_p     = rand(0,2)
    local inv     = INVENTORY:new(h_p,gold,m_p,d_p)
    local x,y     = getXY(rand,room)
    local icon    = "R"
    local name    = "Rogue"
    return CHARACTER:new(x,y,health,attack,defense,inv,icon,name)
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

local function makeEnemies(num,func_table,room)
    for i=1,num,1 do
        local e_type = func_table.getenemytype(func_table.rand)
        func_table.additem(ENEMY_LIST,ENEMY_FUNCS[e_type](func_table.rand,room))
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
    local func_table  = {
        rand          = math.random,additem      = table.insert,
        makeanenemy   = makeAnEnemy,getenemytype = getEnemyType
    }
    for i=1,#rooms,1 do
        local num = getnumenemy(rooms[i],func_table.rand,ceil)
        makeenemies(num,func_table,rooms[i])
    end
    return ENEMY_LIST
end

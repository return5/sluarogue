--File contains functions for creating chracter objects.

local INV = require("inventory")

CHARACTER = {
        x = nil, y = nil, health = nil, max_health = nil, attack = nil, def = nil, inv = nil,icon = nil, 
        name = nil, base_def = nil, def_raised = nil, base_attack = nil, attack_raised = nil,
        magic = nil, max_magic = nil,spec = nil, turn = nil, special = nil,color = nil
    }

CHARACTER.__index = CHARACTER

local ENEMY_LIST  = {}
local ENEMY_FUNCS  --holds list of functions which make enemy types

function CHARACTER:new(x,y,h,a,d,m,inv,icon,name,special,color)
    local self         = setmetatable({},CHARACTER) 
    self.x             = x
    self.y             = y
    self.health        = h
    self.max_health    = h
    self.attack        = a
    self.def           = d
    self.base_def      = d
    self.base_attack   = a
    self.attack_raised = 0
    self.def_raised    = 0
    self.magic         = m
    self.max_magic     = m
    self.inv           = inv
    self.icon          = icon
    self.name          = name
    self.spec          = false
    self.turn          = 0
    self.color         = color
    self.special       = special
    return self
end

local function getXY(rand,room)
    local x  = rand(room.x + 1,room.x + room.width - 1)
    local y  = rand(room.y + 1,room.y + room.height - 1)
    return x,y
end


local function makeInventory(h_p_low,h_p_high,gold_low,gold_high,m_p_low,m_p_high,d_p_low,d_p_high,a_p_low,a_p_high,rand)
    local h_p  = rand(h_p_low,h_p_high)
    local gold = rand(gold_low,gold_high)
    local m_p  = rand(m_p_low,m_p_high)
    local d_p  = rand(d_p_low,d_p_high)
    local a_p  = rand(a_p_low,a_p_high)
    return INVENTORY:new(h_p,gold,m_p,d_p,a_p)
end

local function makeSwordsman(rand,room)
    local health  = rand(9,15)
    local attack  = rand(4,6)
    local defense = rand(1,3)
    local magic   = 0
    local inv     = makeInventory(0,3,0,200,0,3,0,3,0,3,rand)
    local icon    = "S"
    local name    = "Swordsman"
    local special = "power"
    local color   = COLORS.BLUE
    local x,y     = getXY(rand,room)
    return CHARACTER:new(x,y,health,attack,defense,magic,inv,icon,name,special,color)
end

local function makeFlyingThings(rand,room)
    local health  = rand(9,15)
    local attack  = rand(1,4)
    local defense = rand(1,2)
    local magic   = 0
    local inv     = makeInventory(0,0,0,0,0,5,0,0,0,0,rand)
    local x,y     = getXY(rand,room)
    local icon    = "B"
    local name    = "Flying Things"
    local special = "defense"
    local color   = COLORS.MAGENTA
    return CHARACTER:new(x,y,health,attack,defense,magic,inv,icon,name,special,color)
end

local function makeSpearman(rand,room)
    local health  = rand(9,15)
    local attack  = rand(6,9)
    local defense = rand(1,3)
    local magic   = 0
    local inv     = makeInventory(0,4,0,250,0,4,0,4,0,4,rand)
    local inv     = INVENTORY:new(h_p,gold,m_p,d_p,a_p)
    local x,y     = getXY(rand,room)
    local icon    = "E"
    local name    = "Spearman"
    local special = "throw"
    local color   = COLORS.YELLOW
    return CHARACTER:new(x,y,health,attack,defense,magic,inv,icon,name,special,color)
end

local function makeWolf(rand,room)
    local health  = rand(9,13)
    local attack  = rand(9,13)
    local defense = rand(1,2)
    local magic   = 0
    local inv     = makeInventory(0,0,0,0,0,0,0,0,0,0,rand)
    local x,y     = getXY(rand,room)
    local icon    = "W"
    local name    = "Wolf"
    local special = "power"
    local color   = COLORS.RED
    return CHARACTER:new(x,y,health,attack,defense,magic,inv,icon,name,special,color)
end

local function makeSkeleton(rand,room)
    local health  = rand(12,17)
    local attack  = rand(4,7)
    local defense = rand(3,5)
    local magic   = 0
    local inv     = makeInventory(0,0,0,10,0,0,0,0,0,0,rand)
    local x,y     = getXY(rand,room)
    local icon    = "D"
    local name    = "Skeleton"
    local special = "power"
    local color   = COLORS.YELLOW
    return CHARACTER:new(x,y,health,attack,defense,magic,inv,icon,name,special,color)
end

local function makeMonster(rand,room)
    local health  = rand(14,20)
    local attack  = rand(5,8)
    local defense = rand(1,2)
    local magic   = 0
    local inv     = makeInventory(0,1,0,100,0,1,0,1,0,1,rand)
    local x,y     = getXY(rand,room)
    local icon    = "M"
    local name    = "Monster"
    local special = "power"
    local color   = COLORS.GREEN
    return CHARACTER:new(x,y,health,attack,defense,magic,inv,icon,name,special,color)
end

local function makeMAge(rand,room)
    local health  = rand(9,12)
    local attack  = rand(2,6)
    local defense = rand(1,2)
    local magic   = rand(8,15)
    local inv     = makeInventory(0,6,0,400,0,6,0,3,0,2,rand)
    local x,y     = getXY(rand,room)
    local icon    = "V"
    local name    = "Mage"
    local special = "defense"
    local color   = COLORS.BLUE
    return CHARACTER:new(x,y,health,attack,defense,magic,inv,icon,name,special,color)
end

local function makeRogue(rand,room)
    local health  = rand(9,13)
    local attack  = rand(5,7)
    local defense = rand(1,3)
    local magic   = 0
    local inv     = makeInventory(0,4,0,150,0,1,0,2,0,3,rand)
    local x,y     = getXY(rand,room)
    local icon    = "R"
    local name    = "Rogue"
    local special = "throw"
    local color   = COLORS.GREEN
    return CHARACTER:new(x,y,health,attack,defense,magic,inv,icon,name,special,color)
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

function populateEnemyList(rooms)
    ENEMY_FUNCS = {
        makeSwordsman,makeFlyingThings,makeSpearman,makeWolf,
        makeSkeleton,makeMonster,makeMAge,makeRogue
    }
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

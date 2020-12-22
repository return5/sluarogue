--File contains functions for creating inventory and also functions to use inventory items
local printstuff = require("printstuff")

INVENTORY = {hp = nil, dp = nil, mp = nil, ap = nil, gold = nil}
INVENTORY.__index = INVENTORY

function INVENTORY:new(hp,gold,mp,dp,ap)
    self      = setmetatable({},INVENTORY)
    self.hp   = hp  --health potion
    self.dp   = dp  --defense potion
    self.mp   = mp  --magic potion
    self.gold = gold 
    self.ap   = ap   -- ttack potion
    return self
end

local function raiseDefense(character,value)
    character.prev_def   = character.def
    character.def        = character.def + value
    character.def_raised = 1
end

local function raiseAttack(character,value)
    character.prev_attack   = character.attack
    character.attack        = character.attack + value
    character.attack_raised = 1
end

local function raiseHealth(character,value)
    character.health = character.health + value
    if character.health > character.max_health then
        character.health = character.max_health
    end
end

local function raiseMAgic(character,value)
    character.magic = character.magic + value
    if character.magic > character.max_magic then
        character.magic = character.max_magic
    end
end

function useDefensePotion(character,prompt)
    if character.inv.dp > 0 and character.def_Raised == 0 then
        local value = 2
        raiseDefense(character,value)
        character.inv.dp = character.inv.dp - 1
        local str = ("%s uses a defense potion. raises their defense %d points."):format(character.name,value)
        printMessagePromptWin(prompt,str)
        return true
    end
    return false
end

function useAttackPotion(character,prompt)
    if character.inv.ap > 0 and character.attack_Raised == 0 then
        local value = 2
        raiseAttack(character,value)
        character.inv.ap = character.inv.ap - 1
        local str = ("%s uses an attack potion. raises their attack %d points."):format(character.name,value)
        printMessagePromptWin(prompt,str)
        return true
    end
    return false
end

function useHealthPotion(character,prompt)
    if character.inv.hp > 0  then
        local value = math.random(7,12)
        raiseHealth(character,value)
        character.inv.hp = character.inv.hp - 1
        local str = ("%s uses a health potion. restores their health %d points."):format(character.name,value)
        printMessagePromptWin(prompt,str)
        return true
    end
    return false
end

function useMagicPotion(character,prompt)
    if character.inv.mp > 0  then
        local value = math.random(7,12)
        raiseMAgic(character,value)
        character.inv.mp = character.inv.mp - 1
    local str = ("%s uses a magic potion. restores their magic %d points."):format(character.name,value)
    printMessagePromptWin(prompt,str)
        return true
    end
    return false
end



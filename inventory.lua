--File contains functions for creating inventory and also functions to use inventory items

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

local function raiseDefense(charater,value)
    character.prev_def   = character.def
    character.def        = character.def + value
    character.def_raised = 1
end

local function raiseAttack(charater,value)
    character.prev_attack   = character.attack
    character.attack        = character.attack + value
    character.attack_raised = 1
end

local function raiseHealth(charater,value)
    character.health = character.health + value
    if character.health > character.max_health then
        chracter.health = character.max_health
    end
end

local function raiseMAgic(charater,value)
    character.magic = character.magic + value
    if character.magic > character.max_magic then
        chracter.magic = character.max_magic
    end
end

function useDefensePotion(character)
    if character.inv.dp > 0 and character.def_Raised == 0 then
        raiseDefense(chracter,2)
        character.inv.dp = character.inv.dp - 1
        return true
    end
    return false
end

function useAttackPotion(character)
    if character.inv.ap > 0 and character.attack_Raised == 0 then
        raiseAttack(chracter,2)
        character.inv.ap = character.inv.ap - 1
        return true
    end
    return false
end

function useHealthPotion(character)
    if character.inv.hp > 0  then
        raiseHealth(chracter,math.rand(7,12))
        character.inv.hp = character.inv.hp - 1
        return true
    end
    return false
end

function useMagicPotion(character)
    if character.inv.mp > 0  then
        raiseMAgic(chracter,math.rand(7,12))
        character.inv.mp = character.inv.mp - 1
        return true
    end
    return false
end



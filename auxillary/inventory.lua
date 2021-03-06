--File contains functions for creating inventory and also functions to use inventory items
local printstuff = require("auxillary.printstuff")

INVENTORY = {hp = nil, dp = nil, mp = nil, ap = nil, gold = nil}
INVENTORY.__index = INVENTORY

function INVENTORY:new(hp,gold,mp,dp,ap)
    self      = setmetatable({},INVENTORY)
    self.hp   = hp  --health potion
    self.dp   = dp  --defense potion
    self.mp   = mp  --magic potion
    self.ap   = ap   -- ttack potion
    self.gold = gold 
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
    if character.def_raised == 0 then
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
    if character.attack_raised == 0 then
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
    local value = math.random(7,12)
    raiseHealth(character,value)
    character.inv.hp = character.inv.hp - 1
    local str = ("%s uses a health potion. restores their health %d points."):format(character.name,value)
    printMessagePromptWin(prompt,str)
end

function useMagicPotion(character,prompt)
    local value = math.random(7,12)
    raiseMAgic(character,value)
    character.inv.mp = character.inv.mp - 1
    local str = ("%s uses a magic potion. restores their magic %d points."):format(character.name,value)
    printMessagePromptWin(prompt,str)
end

function makeInventory(h_p_low,h_p_high,gold_low,gold_high,m_p_low,m_p_high,d_p_low,d_p_high,a_p_low,a_p_high,rand)
    local h_p  = rand(h_p_low,h_p_high)  --health potion
    local gold = rand(gold_low,gold_high)
    local m_p  = rand(m_p_low,m_p_high)  --magic potion
    local d_p  = rand(d_p_low,d_p_high)  --defense potion
    local a_p  = rand(a_p_low,a_p_high)  --attack potion
    return INVENTORY:new(h_p,gold,m_p,d_p,a_p)
end

local function makeInvList(player)
    local inv_list = {}
    local additem  = table.insert
    if player.inv.hp > 0 then
        additem(inv_list,{"health",player.inv.hp})
    end
    if player.inv.dp > 0 then
        additem(inv_list,{"defense",player.inv.dp})
    end
    if player.inv.mp > 0 then
        additem(inv_list,{"magic",player.inv.mp})
    end
    if player.inv.ap > 0 then
        additem(inv_list,{"attack",player.inv.ap})
    end
    return inv_list
end

local function playerChoice(inv_list,prompt)
    local choice = tonumber(mvwgetch(prompt,0 + #inv_list,5))
    if choice > #inv_list then
        return "none"
    end
    return inv_list[choice][1]
     
end

function playerInventory(player,prompt,info)
    local inv_list = makeInvList(player)
    printPlayerInventory(inv_list,prompt)
    local choice = playerChoice(inv_list,prompt)
    if choice == "magic" then
        useMagicPotion(player,prompt)
    elseif choice == "health" then
        useHealthPotion(player,prompt)
    elseif choice == "attack" then
        useAttackPotion(player,prompt)
    elseif choice == "defense" then
        useDefensePotion(player,prompt)
    else
        wclear(prompt)
        wrefresh(prompt)
        return false
    end
    updateInfoWin(player,info)
    return true
end




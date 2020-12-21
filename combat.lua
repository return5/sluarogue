--File contains functions for fighting between player and enemy characters

local Print = require("printstuff")
local Inv   = require("inventory")


local function applyDamage(attacker,defender,damage,counter)
    if damage > 0 then
        defender.health = defender.health - damage
    end
    if counter > 0 then
        attacker.health = attacker.health - counter
    end
    if attacker.health <= 0 or defender.health <= 0 then
        return false
    end
    return true 
end

local function normalAttack(rand,attacker,defender,prompt)
    local n       = rand(0,12)
    local damage  = 0
    local counter = 0
    local str
    if n < 5 then 
        damage = attacker.attack - defender.def
        if damage <= 0 then
            damage = 1
        end
        str    = ("%s attacks %s for %d damage"):format(attacker.name,defender.name,damage)
    elseif n < 8 then
        damage = (attacker.attack + 2) - defender.def
        if damage <= 0 then
            damage = 1
        end
        str    = ("%s scores crit attack on %s for %d damage."):format(attacker.name,defender.name,damage)
    elseif n < 11 then
        str    = ("%s missed."):format(attacker.name)
    else
        str     = ("%s dodges and counters dealing 2 damage to %s"):format(defender.name,attacker.name)
        counter = 2
    end
    printMessagePromptWin(prompt,str)
    return applyDamage(attacker,defender,damage,counter)
end

local function compUseItems(rand,character,prompt)
    if character.health < character.max_health / 2 then
        if useHealthPotion(character) == false then
            return compUseItems(rand,character)
        else
            return true
        end
    elseif character.magic < character.max_magic / 2 then
        if useMagicPotion(character) == false then
            return compUseItems(rand,character)
        else
            return true
        end
    elseif character.raise_def == 0 then
        if usedefensePotion(character) == false then
            return compUseItems(rand,character)
        else
            return true
        end
    elseif character.raise_attack == 0 then
        if useAttackPotion(character) == false then
            return compUseItems(rand,character)
        else
            return true
        end
    end
    return false
end


local function compAttack(i,items,rand)
    local n     = rand(0,10)
    local alive = true
    if n < 5 then
        alive = normalAttack(rand,items.e_list[i],items.player,items.prompt)
    elseif n < 8 then
        if compUseItems(rand,items.e_list[i],items.prompt) == false then
            alive = compAttack(i,items,rand)
        end
    else
        alive = specialAttack(rand,items.e_list[i],items.player,items.prompt)
    end
    return alive
end

local function getPlayerInput(i,items,rand)
    printPlayerPrompt(items.prompt)
    local alive = true
    input       = tonumber(getch())
    if input == 1 then
      alive = normalAttack(rand,items.player,items.e_list[i],items.prompt)
    elseif input == 2 then
        alive = specialAttack(rand,items.player,items.e_list[i],items.prompt)
    elseif input == 3 then
        alive = useItem(items,items.prompt)
    elseif input == 4 then
        alive = runAway(rand,items,items.prompt)
    else
        alive = getPlayerInput(i,items,rand)
    end
    return alive
end

local function restoreDef(char)
    char.def        = char.base_def
    char.def_raised = 0
end

local function restoreAttack(char)
    char.attack        = char.base_attack
    char.attack_raised = 0
end

local function restoreCharAttr(char)
    restoreDef(char)
    restoreAttack(char)
end

local function postCombat(i,items)
    items.play = items.player.health > 0
    if items.play then
        restoreCharAttr(items.player)
    end
    if items.e_list[i].health < 1 then
        table.remove(items.e_list,i)
    else
        restoreCharAttr(items.e_list[i])
    end
end

local function startCombat(i,items)
    local alive      = true
    local getinput   = getPlayerInput
    local rand       = math.random
    local compattack = compAttack
    local updateinfo = updateInfoWin
    printCombatScene(items.window,items.e_list[i].icon)
    updateinfo(items.player,items.info)
    repeat
        alive = getinput(i,items,rand)
        updateinfo(items.player,items.info)
        if alive == true then
            alive = compattack(i,items,rand)
        end
        updateinfo(items.player,items.info)
    until alive == false
    postCombat(i,items)
    updateinfo(items.player,items.info)
end


function checkForEngagement(i,items)
    items.play = true
    if items.player.x == items.e_list[i].x and
        items.player.y == items.e_list[i].y then
        startCombat(i,items)
    end
end


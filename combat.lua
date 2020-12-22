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
    else
        return true 
    end
end

local function defenseCounter(attacker,defender)
    local str     = ("%s tried to lower %s's defense with a spell.\n%s countered doing 2 damage to %s."):format(attacker.name,defender.name,defender.name,attacker.name)
    local counter = 2
    return 0,str,counter
end

local function defenseMiss(attacker,defender)
    local str = ("%s tried to cast a spell but failed."):format(attacker.name)
    return 0,str,0
end

local function defenseDown(attacker,defender)
   local str = ("%s cast a spell to lower %s's defense by 2."):format(attacker.name,defender.name) 
   attacker.spec = true
   defender.def  = defender.def - 2
   if defender.def < 0 then
       defender.def = 0
   end
   return 0,str,0
end

local function throwCounter(attacker,defender)
    local counter = 2
    local str     = ("%s tries to throw %s but %s punches %s for 2 damage instead."):format(attacker.name,defender.name,defender.name,attacker.name)
    return 0,str,counter
end

local function throwMiss(attacker,defender)
    local str = ("%s tries to throw %s but fails."):format(attacker.name,defender.name)
    return 0,str,0
end

local function throwAttack(attacker,defender)
    local damage  = 2
    attacker.spec = true
    defender.turn = 2
    local str     = ("%s throws %s to the ground.\n %s suffers 2 damage and is unconsious for 2 turns."):format(attacker.name,defender.name,defender.name)
    return damage,str,0
end

local function powerCounter(attacker,defender)
    local counter = 2
    local str     = ("%s tried a power attack against %s.\n%s dodges and counters doing 2 damage to %s"):format(attacker.name,defender.name,defender.name,attacker.name)
    return 0,str,counter
end

local function powerMiss(attacker,defender)
    local str = ("%s tried a power attack against %s but missed."):format(attacker.name,defender.name)
    return 0,str,0
end
local function powerAttack(attacker,defender)
    local damage = (attacker.attack - defender.def) + 4
    attacker.spec = true
    if damage <= 0 then
        damage = 1
    end
    local str = ("%s did a power attack against %s.\n %s suffered %d damage."):format(attacker.name,defender.name,defender.name,damage)
    return damage,str,0
end
local function specialAttack(attacker,defender,rand,prompt,func1,func2,func3)
    local n       = rand(0,11)
    local damage  = 0
    local counter = 0
    local str
    if n < 4 then
        damage,str,counter = func1(attacker,defender)
    elseif n < 9 then
        damage,str,counter = func2(attacker,defender)
    else
        damage,str,counter = func3(attacker,defender)
    end
    printMessagePromptWin(prompt,str)
    return applyDamage(attacker,defender,damage,counter)
end

local function useSpecialAttack(attacker,defender,rand,prompt)
    local func1,func2,func3
    if attacker.special == "power" then
        func1 = powerAttack
        func2 = powerMiss
        func3 = powerCounter
    elseif attacker.special == "throw" then
        func1 = throwAttack
        func2 = throwMiss
        func3 = throwCounter
    elseif attacker.special == "defense" then
        func1 = defenseDown
        func2 = defenseMiss
        func3 = defenseCounter
    end
        return specialAttack(attacker,defender,rand,prompt,func1,func2,func3)
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
        str = ("%s attacks %s for %d damage"):format(attacker.name,defender.name,damage)
    elseif n < 8 then
        damage = (attacker.attack + 2) - defender.def
        if damage <= 0 then
            damage = 1
        end
        str = ("%s scores crit attack on %s for %d damage."):format(attacker.name,defender.name,damage)
    elseif n < 11 then
        str = ("%s missed."):format(attacker.name)
    else
        str     = ("%s dodges and counters dealing 2 damage to %s"):format(defender.name,attacker.name)
        counter = 2
    end
    printMessagePromptWin(prompt,str)
    return applyDamage(attacker,defender,damage,counter)
end

local function compUseItems(rand,character,prompt)
    if character.health < (character.max_health / 2) then
        if useHealthPotion(character,prompt) == false then
            return compUseItems(rand,character)
        else
            return true
        end
    elseif character.magic < (character.max_magic / 2) then
        if useMagicPotion(character,prompt) == false then
            return compUseItems(rand,character)
        else
            return true
        end
    elseif character.raise_def == 0 then
        if usedefensePotion(character,prompt) == false then
            return compUseItems(rand,character)
        else
            return true
        end
    elseif character.raise_attack == 0 then
        if useAttackPotion(character,prompt) == false then
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
        if items.e_list[i].spec == false then
            alive = useSpecialAttack(items.e_list[i],items.player,rand,items.prompt)
        else
            alive = compAttack(i,items,rand)
        end
    end
    return alive
end

local function findValidLocation(items)
    local locations = {}
    for i=items.player.y - 2,items.player.y + 2,1 do
        for j = items.player.x - 2,items.player.x + 2,1 do
            if items.map[i][j] == 4 and i ~= items.player.y and j ~= items.player.x then
                table.insert(locations,{i,j})
            end
        end
    end
    return locations
end

local function playerRunAway(items,rand)
    local locations = findValidLocation(items)
    local i         = rand(1,#locations)
    items.player.y  = locations[i][1]
    items.player.x  = locations[i][2]
end

local function runAway(rand,items)
    local n = rand(0,9)
    local str
    local success
    if n < 6 then
        playerRunAway(items,rand)
        str = ("%s ran away from the battle."):format(items.player.name)
        success = true
    else
        str = ("%s tried to run away but failed."):format(items.player.name)
        success = false
    end
    printMessagePromptWin(items.prompt,str)
    return not success
end

local function getPlayerInput(i,items,rand)
    printPlayerPrompt(items.prompt)
    local alive = true
    input       = tonumber(getch())
    if input == 1 then
      alive = normalAttack(rand,items.player,items.e_list[i],items.prompt)
    elseif input == 2 then
        if items.player.spec == false then
            alive = useSpecialAttack(items.player,items.e_list[i],rand,items.prompt)
        else
            printMessagePromptWin(items.prompt,"Sorry, you have already used your special this battle.")
            alive = getPlayerInput(i,items,rand)
        end
    elseif input == 3 then
        alive = useItem(items)
    elseif input == 4 then
        alive = runAway(rand,items)
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
    char.spec = false
    char.turn = 0
end

local function postCombat(i,items)
    items.play = items.player.health > 0
    if items.play then
        restoreCharAttr(items.player)
        if items.e_list[i].health < 1 then
            table.remove(items.e_list,i)
        else
            restoreCharAttr(items.e_list[i])
        end
    end
    wclear(items.window)
    wclear(items.prompt)
end

local function missedTurn(prompt,char)
    local str = ("%s missed their turn."):format(char.name)
    char.turn = char.turn - 1
    printMessagePromptWin(prompt,str)
end

local function startCombat(i,items)
    local alive      = true
    local getinput   = getPlayerInput
    local rand       = math.random
    local compattack = compAttack
    local updateinfo = updateInfoWin
    local missturn   = missedTurn
    printCombatScene(items.window,items.e_list[i].icon)
    updateinfo(items.player,items.info)
    repeat
        if items.player.turn > 0 then
            missturn(items.prompt,items.player)
        else
            alive = getinput(i,items,rand)
            updateinfo(items.player,items.info)
        end
        if alive == true then
            if items.e_list[i].turn > 0 then
                missturn(items.prompt,items.e_list[i])
            else
                alive = compattack(i,items,rand)
            end
        end
        printMessagePromptWin(items.prompt,tostring(items.e_list[i].health))
        updateinfo(items.player,items.info)
    until (alive == false)
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


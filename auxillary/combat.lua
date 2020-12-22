--File contains functions for fighting between player and enemy characters

local Print = require("auxillary.printstuff")
local Inv   = require("auxillary.inventory")


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
    if character.health < (character.max_health / 2) and character.inv.hp > 0 then
        useHealthPotion(character,prompt)
        return true
    elseif character.magic < (character.max_magic / 2) and character.inv.mp > 0 then
        useMagicPotion(character,prompt)
        return true
    elseif character.raise_def == 0 and character.inv.dp > 0 then
        if usedefensePotion(character,prompt) == false then
            return compUseItems(rand,character)
        else
            return true
        end
    elseif character.raise_attack == 0 and character.inv.ap > 0 then
        if useAttackPotion(character,prompt) == false then
            return compUseItems(rand,character)
        else
            return true
        end
    end
    return false
end

local function compAttack(map,comp,player,prompt,rand)
    local n     = rand(0,10)
    local alive = true
    if n < 5 then
        alive = normalAttack(rand,comp,player,prompt)
    elseif n < 8 then
        if compUseItems(rand,comp,prompt) == false then
            return compAttack(map,comp,player,prompt,rand)
        end
    else
        if comp.spec == false then
            alive = useSpecialAttack(comp,player,rand,prompt)
        else
            return compAttack(map,comp,player,prompt,rand)
        end
    end
    return alive
end

local function findValidLocation(map,player)
    local locations = {}
    for i=player.y - 2,player.y + 2,1 do
        for j = player.x - 2,player.x + 2,1 do
            if map[i][j] == 4 and i ~= player.y and j ~= player.x then
                table.insert(locations,{i,j})
            end
        end
    end
    return locations
end

local function playerRunAway(map,player,rand)
    local locations = findValidLocation(map,player)
    local i         = rand(1,#locations)
    player.y        = locations[i][1]
    player.x        = locations[i][2]
end

local function runAway(map,player,prompt,rand)
    local n = rand(0,9)
    local str
    local success
    if n < 6 then
        playerRunAway(map,player,rand)
        str = ("%s ran away from the battle."):format(player.name)
        success = true
    else
        str     = ("%s tried to run away but failed."):format(player.name)
        success = false
    end
    printMessagePromptWin(prompt,str)
    return not success
end

local function getPlayerInput(map,player,comp,prompt,rand)
    printPlayerPrompt(player.name,prompt)
    local alive = true
    input       = tonumber(getch())
    if input == 1 then
      alive = normalAttack(rand,player,comp,prompt)
    elseif input == 2 then
        if player.spec == false then
            alive = useSpecialAttack(player,comp,rand,prompt)
        else
            printMessagePromptWin(prompt,"Sorry, you have already used your special this battle.")
            return getPlayerInput(map,player,comp,prompt,rand)
        end
    elseif input == 3 then
        alive = useItem(player)
    elseif input == 4 then
        alive = runAway(rand,player)
    else
        return getPlayerInput(map,player,comp,prompt,rand)
    end
    return alive
end

local function pickUpInventoryItems(player,enemy,prompt,rand)
    local pickedup = 0
    local str      = ("%s picked up items dropped by %s.\nitems picked up:"):format(player.name,enemy.name) 
    local hp       = rand(0,enemy.inv.hp)
    local dp       = rand(0,enemy.inv.dp)
    local mp       = rand(0,enemy.inv.mp)
    local gold     = rand(0,enemy.inv.gold)
    local ap       = rand(0,enemy.inv.ap)
    if hp > 0  then
        player.inv.hp = player.inv.hp + hp
        pickedup      = pickedup + hp
        str           = str .. ("\nhealth potion: %d"):format(hp)
    end
    if dp > 0  then
        player.inv.dp = player.inv.dp + dp
        pickedup      = pickedup + dp
        str           = str .. ("\ndefense potion: %d"):format(dp)
    end
    if mp > 0  then
        player.inv.mp = player.inv.mp + mp
        pickedup      = pickedup + mp
        str           = str .. ("\nmagic potion: %d"):format(mp)
    end
    if gold > 0  then
        player.inv.gold = player.inv.gold + gold
        pickedup        = pickedup + gold
        str             = str .. ("\ngold: %d"):format(gold)
    end
    if ap > 0  then
        player.inv.ap = player.inv.ap + ap
        pickedup      = pickedup + ap
        str           = str .. ("\nattack potion: %d"):format(ap)
    end
    if pickedup > 0 then
        printMessagePromptWin(prompt,str)
    end
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

local function postCombat(i,player,e_list,window,prompt,rand)
    play = player.health > 0
    if play then
        restoreCharAttr(player)
        if e_list[i].health < 1 then
            pickUpInventoryItems(player,e_list[i],prompt,rand)
            table.remove(e_list,i)
        else
            restoreCharAttr(e_list[i])
        end
    end
    wclear(window)
    wclear(prompt)
end

local function missedTurn(prompt,char)
    local str = ("%s missed their turn."):format(char.name)
    char.turn = char.turn - 1
    printMessagePromptWin(prompt,str)
end

local function combatTurn(map,rand,attacker,defender,prompt,charturn,missturn)
    local alive = true
    if attacker.turn > 0 then
        missturn(prompt,attacker)
    else
        alive = charturn(map,attacker,defender,prompt,rand)
    end
    return alive
end
    
local function flipJ(j)
    if j == 1 then
        j = 2
    else
        j = 1
    end
    return j
end

local function startCombat(i,items)
    local alive      = true
    local getinput   = getPlayerInput
    local rand       = math.random
    local compattack = compAttack
    local getinput   = getPlayerInput
    local updateinfo = updateInfoWin
    local missturn   = missedTurn
    local combatturn = combatTurn
    local funcs      = {getinput,compattack}
    local attacker   = {items.player,items.e_list[i]}
    local defender   = {items.e_list[i],items.player}
    local j          = 1
    local flipj      = flipJ
    printCombatScene(items.window,items.e_list[i].icon)
    updateinfo(items.player,items.info)
    repeat
        alive = combatturn(items.map,rand,attacker[j],defender[j],items.prompt,funcs[j],missturn)
        j     = flipj(j)
        updateinfo(items.player,items.info)
    until (alive == false)
    postCombat(i,items.player,items.e_list,items.window,items.prompt,rand)
    updateinfo(items.player,items.info)
    return items.player.health > 0
end

function checkForEngagement(i,items)
    local play = true
    if items.player.x == items.e_list[i].x and
        items.player.y == items.e_list[i].y then
        play = startCombat(i,items)
    end
    return play
end


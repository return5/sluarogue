local Print = require("printstuff")

local function normalAttack(rand,attacker,defender)
    local n       = rand(0,10)
    local damage  = 0
    local counter = 0
    local str
    if n < 4 then 
        damage = attacker.attack - defender.defense
        str    = ("%s attacks % for % damage"):format(attacker.name,defender.name,damage)
    elseif n < 6 then
        damage = (attacker.attack + 2) - defender.defense
        str    = ("%s scores crit attack on %s for %d damage."):format(attacker.name,defender.name,damage)
    elseif n < 8 then
        damage = 0
        str    = ("%s missed."):format(attacker.name)
    else
        str     = ("%s dodges and counters dealing 2 damage to %s"):format(defender.name,attacker.name)
        damage  = 0
        counter = 2
    end
    applyDamage(attacker,defender,damage,counter)
end

local function compAttack(i,items,rand)
    local n = rand(0,9)
    if n < 4 then
        normalAttack(rand,items.e_list[i],items.player)
    elseif n < 7 then
        if compUseItems(rand,items.e_list[i]) == false then
            compAttack(i,items,rand)
        end
    else
        specialAttack(rand,items.e_list[i],items.player)
    end
end

local function getInput(i,items,rand)
    printPlayerPrompt()
    input = getch()
    if input == 1 then
        normalAttack(rand,items.player,items.e_list[i])
    elseif input == 2 then
        specialAttack(rand,items.player,items.e_list[i])
    elseif input == 3 then
        useItem(items)
    elseif input == 4 then
        runAway(rand,items)
    else
        getInput(player,enemy)
    end
end

local function restoreDef(char)
    char.def        = char.pref_def
    char.def_raised = 0
end

local function restoreAttack(char)
    char.attack        = prev_Attack
    char.attack_raised = 0
end

local function resotrePlayerAttr(player)
    restoreDef(player)
    restoreAttack(player)
end

local function postCombat(i,items)
    items.play = items.player.health > 0
    if items.play then
        restorePlayerAttr(items.player)
    end
    if items.e_list[i].health < 1 then
        table.remove(items.e_list,i)
    end
end

local function startCombat(i,items)
    local printscene       = printCombatScene
    local updateplayerinfo = updatePlayerInfo
    local compattack       = compAttack
    local getinput         = getInput
    local play             = true
    local rand             = math.rand
    local player           = item.player
    local enemy            = item.e_list[i]
    while play == true and player.health > 0 and enemy.health > 0 do
        printscene(enemy)
        updateplayerinfo(player)
        play = getinput(i,items,rand) 
        if player.health > 0 and enemy.health > 0 and play then
            compattack(i,items,rand)
        end
    end
    postCombat(i,items)
end


function checkForEngagement(i,items)
    local alive = true
    if items.player.x == items.e_list[i].x and
        items.player.y == items.e_list[i].y then
        startCombat(i,items)
    end
end


--File contains functions for moving characters around the map

local combat = require("auxillary.combat")

local FUNC_TABLE

local ITEMS

--checks if new x,y is a walkable tile
local function checkXY(map,x,y)
    if map[y][x] == 4 then
       return true,x,y
   end
   return false,x,y
end

--checks the direction player tries to walk to make sure it is a walkable tile
local function checkNewLocation(dir)
    if dir == "w" then
        return checkXY(ITEMS.map,ITEMS.player.x,ITEMS.player.y - 1)
    elseif dir == "s" then
        return checkXY(ITEMS.map,ITEMS.player.x,ITEMS.player.y + 1)
    elseif dir == "a" then
        return checkXY(ITEMS.map,ITEMS.player.x - 1,ITEMS.player.y)
    elseif dir == "d" then
        return checkXY(ITEMS.map,ITEMS.player.x + 1,ITEMS.player.y)
    end
    return false, ITEMS.player.x,ITEMS.player.y
end

--move the computer player one tile towards player character
local function moveCompChar(i,items)
    local path = items.finder:getPath(items.e_list[i].x,items.e_list[i].y,items.player.x,items.player.y)
    local x    = path._nodes[2]:getX() 
    local y    = path._nodes[2]:getY() 
    return x,y
end

--move computer player then check to see if they can engage player in combat
local function compPlayerTurn(i,items,funcs)
    items.e_list[i].x,items.e_list[i].y = funcs.movecomp(i,items)
    return funcs.checkengage(i,items)
end

--is the player character within viewing distance of the computer player
local function isPlayerVisible(player,comp,abs)
    local x_dist = abs(player.x - comp.x)
    local y_dist = abs(player.y - comp.y)
    if x_dist <= 4 and y_dist <= 4 then
        return true
    end
    return false
end

--if player is visible then move computer player
local function enemyCharTurn(i,items,funcs)
    if funcs.visible(items.player,items.e_list[i],funcs.abs) then
       return funcs.compturn(i,items,funcs)
   end
   return true
end


--loop through the enemy list table and call a given function ofr each enemy
local function loopEnemyList(fn,items,funcs)
    local func = fn
    local play = true
    for i=#items.e_list,1,-1 do
        play = func(i,items,funcs)
        if play == false then
            return false
        end
    end
    return play
end


function moveCompPlayers()
    local funcs = FUNC_TABLE
    local items = ITEMS
    local play  = true
    return loopEnemyList(enemyCharTurn,items,funcs)
end

--make sure player input is valide
local function checkInput(input)
    if input == "w" or input == "s" or input == "d" or input == "a" then
        return true
    end
    return false
end

local function movePlayer(player,input)
    local mov,x,y = checkNewLocation(input)
    if mov == true then
        player.x = x
        player.y = y
    end 
    return true,mov
end

function confirmChoice(prompt)
    printMessagePromptWin(prompt,"are you sure you wish to exit?(y/n)",false)
    if getch() == "y" then
        return true
    else
        return true
    end
end

local function checkForExit(player)
    if ITEMS.game_map[player.y][player.x].icon == '&' then
        printMessagePromptWin(ITEMS.prompt,"do you want to move to next level?(y/n)",false)
        if getch() == "y" then
            return true
        end
    end
    return false
end

function playerTurn(player)
    local input     = getch()
    local play      = true
    local new_level = false
    if input == "i" then
        openInventory(player)
    elseif input == "q" and confirmChoice(ITEMS.prompt) == true then
        play = false
    elseif checkInput( input) == true then 
       local move = movePlayer(player,input)
        if move == false and play == true then
            return playerTurn(player,ITEMS.prompt)
        else
            new_level = checkForExit(player)
            play      = not new_level
            
        end
        if play == true then
           play = loopEnemyList(checkForEngagement,nil,ITEMS) 
        end
    else
        return playerTurn(player)
    end
    return play,new_level
end

--table to hold funcs to pass around to other functions.
--candidate for removal
function makeFuncTable()
    FUNC_TABLE = {
        movecomp    = moveCompChar,
        visible     = isPlayerVisible,
        compturn    = compPlayerTurn,
        checkengage = checkForEngagement,
        remove      = table.remove,
        abs         = math.abs
    }
end

--table of items to pass around to functions.
--candidate for removal
function makeItemTable(game_map,collision_map,finder,player,e_list,window,prompt,info)
    ITEMS = {
        game_map = game_map,
        map      = collision_map,
        finder   = finder,
        player   = player,
        e_list   = e_list,
        window   = window,
        prompt   = prompt,
        info     = info
    }
end



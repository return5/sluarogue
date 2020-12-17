--File contains functions for moving characters around the map

local ncurse = require("sluacurses")

local FUNC_TABLE = {}

local ITEMS = {}


local function checkXY(map,x,y)
    if map[y + 1][x + 1] == 4 then
       return true,x,y
   end
   return false,x,y
end

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

local function moveCompChar(i,items)
    local path = items.finder:getPath(items.e_list[i].x,items.e_list[i].y,items.player.x,items.player.y)
    local x    = path._nodes[2]:getX()
    local y    = path._nodes[2].getY()
    return x,y
end

local function compPlayerTurn(i,funcs,items)
    items.e_list[i].x,items.e_list[i].y = funcs.movecomp(i,items)
    return func_Table.checkForEngagement(i,items)
end

local function isPlayerVisible(player,comp,abs)
    local x_dist = abs(player.x - comp.x)
    local y_dist = abs(player.y - comp.y)
    if x_dist <= 4 and y_dist <= 4 then
        return true
    end
    return false
end

local function enemyCharTurn(i,funcs,items)
    if funcs.visible(items.player,items.e_list[i],funcs.abs) then
       if funcs.compturn(i,func_Table,items) == false then
            funcs.remove(items.e_list,i)
        end
    end
    items.play = items.player.health > 0
end

local function loopEnemyList(fn,funcs,items)
    local func = fn
    for i=#items.e_list,1,-1 do
        func(i,funcs,items)
        if items.play == false then
            return
        end
    end
end

function moveCompPlayers()
    local funcs = FUNC_TABLE
    local items = ITEMS
    items.play  = true
    loopEnemyList(enemyCharTurn,funcs,items)
    return items.play
end

local function checkInput(input)
    if input == "w" or input == "s" or input == "d" or input == "a" then
        return true
    end
    if input == "i" or input == "q" then
        return true
    end
    return false
end

local function movePlayer(input)
    local mov,x,y = checkNewLocation(input)
    if mov == true then
        ITEMS.player.x = x
        ITEMS.player.y = y
    end 
    return true,mov
end

function playerTurn()
    local input  = getch()
    ITEMS.play   = true
    if checkInput(input) == false then
        return ITEMS.playerTurn()
    elseif input == "i" then
        return openInventory(ITEMS.player)
    elseif input == "q" then
        ITEMS.play = false
    else 
       local move = movePlayer(input)
        if move == false and ITEMS.play == true then
            return ITEMS.playerTurn()
        end
    end
    return ITEMS.play
end

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

function makeItemTable(collision_map,finder,player,e_list)
    ITEMS = {
        map    = collision_map,
        finder = finder,
        player = player,
        play   = true,
        e_list = e_list
    }
end



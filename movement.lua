--File contains functions for moving characters around the map

local ncurse = require("sluacurses")

local FUNC_TABLE = {
    movecomp    = moveCompChar,
    visible     = isPlayerVisible,
    compturn    = compPlayerTurn,
    checkengage = checkForEngagement,
    remove      = table.remove,
    abs         = math.abs
}

local ITEM_TABLE = {
    map    = collision_map,
    finder = finder,
    player = player,
    play   = true,
    e_list = e_list
}

local function checkXY(map,x,y)
    if map[y][x] == 4 then
       return true,x,y
   end
   return false,x,y
end

local function checkNewLocation(map,x,y,dir)
    if dir == "w" then
        return checkXY(map,x - 1,y)
    elseif dir == "s" then
        return checkXY(map,x + 1,y)
    elseif dir == "a" then
        return checkXY(map,x,y - 1)
    elseif dir == "d" then
        return checkXY(map,x,y + 1)
    end
    return false, x,y
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
    if x_dist <= 8 and y_dist <= 8 then
        return true
    end
    return false
end

local function enemyCharTurn(i,funcs,items)
    if funcs.visible(items.player,items.e_list[i],funcs.abs) then
       if funcs.compTurn(i,func_Table,items) == false then
            funcs.remove(items.e_list,i)
        end
    end
    items.play = items.player.health > 0
end

local function loopEnemeyList(fn,funcs,items)
    local func = fn
    for i=#items.e_list,1,-1 do
        func(i,funcs,items)
        if items.play == false then
            return
        end
    end
end

function moveCompPlayers(collision_map,e_list,finder,player)
    local funcs = FUNC_TABLE
    local items = ITEM_TABLE
    loopEnemyList(enemyCharTurn,funcs,items)
    return items.play
end

function movePlayer(player,map,dir)
    local mov,x,y = checkNewLocation(map,player.x,player.y,dir)
    if mov == true then
        player.x = x
        player.y = y
    end
    return mov
end

local function checkInput(input)
    if input ~= w and input ~= s and input ~= d and input ~= a then
        return false
    end
    if input ~= i and input ~= q then
        return false
    end
    return true
end

local function movePlayer(player,map,e_list,input)
    local mov,x,y = checkNewLocation(map,player.x,player.y,input)
    if mov == true then
        player.x = x
        player.y = y
    end 
end

function playerTurn(player,map,e_list)
    local input  = getch()
    local play   = true
    if checkInput(input) == false then
        return playerTurn(player,map,e_list)
    end
    if input == "i" then
        return openInventory(player)
    elseif input == "q" then
        return false
    else 
        local alive,move = movePlayer(player,map,e_list,input)
        if alive == false then
            return false
        end
        if move == false then
            return playerTurn(player,map,e_list)
        end
    end
    return true
end

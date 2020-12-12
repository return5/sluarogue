local ncurse = require("sluacurses")

local function checkXY(map,x,y)
    if map[y][x] ~= 0 or then
       return false,x,y
   end
   return true,x,y
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

local function moveCompChar(i,item_table)
    local path = item_table.finder:getPath(item_Table.e_list[i].x,item_Table.e_list[i].y,item_table.player.x,item_table.player.y)
    local x    = path._nodes[2]:getX()
    local y    = path._nodes[2].getY()
    return x,y
end

local function compPlayerTurn(i,func_table,item_table)
    item_table.e_list[i].x,item_table.e_list[i].y = func_table.movecomp(i,item_table)
    return func_Table.checkForEngagement(i,item_table)
end

local function isPlayerVisible(player,comp,abs)
    local x_dist = abs(player.x - comp.x)
    local y_dist = abs(player.y - comp.y)
    if x_dist <= 8 and y_dist <= 8 then
        return true
    end
    return false
end

local function enemyCharTurn(i,func_table,item_table)
    if func_table.visible(item_table.player,item_table.e_list[i],func_table.abs) then
       if func_table.compTurn(i,func_Table,item_table) == false then
            func_table.remove(item_table.e_list,i)
        end
    end
    item_table.play = item_table.player.health > 0
end

local function loopEnemeyList(fn,func_table,item_table)
    local func = fn
    for i=#item_table.e_list,1,-1 do
        func(i,func_table,item_table)
        if item_table.play == false then
            return
        end
    end
end

function moveCompPlayers(collision_map,e_list,finder,player)
    local func_table = {
        movecomp    = moveCompChar,
        visible     = isPlayerVisible,
        compturn    = compPlayerTurn,
        checkengage = checkForEngagement
        remove      = table.remove,
        abs         = math.abs
    }
   local item_table = {
        map    = collision_map,
        finder = finder,
        player = player,
        play   = true
        e_list = e_list
    }
    loopEnemyList(enemyCharTurn,func_table,item_table)
    return item_table.play
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

function playerTurn(player,map,e_list)
    local input  = getch()
    local play   = true
    if checkinput(input) == false then
        return playerTurn(player,map,e_list)
    end
    if input == "i" then
        return openInventory(player)
    elseif input = "q" then
        return quitProgram()
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

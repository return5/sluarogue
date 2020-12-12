
local function checkXY(map,x,y)
    if map[y][x] ~= "#" or map[y][x] ~= " " then
       return false,x,y
   end
   return true,x,y
end

local function moveLocation(map,x,y,dir)
    if dir == 1 then
        return checkXY(map,x - 1,y)
    elseif dir == 2 then
        return checkXY(map,x + 1,y)
    elseif dir == 3 then
        return checkXY(map,x,y - 1)
    elseif dir == 4 then
        return checkXY(map,x,y + 1)
    end
    return false, x,y
end

local function moveCompChar(collision_map,comp,finder,player)
    local path = finder:getPath(comp.x,comp.y,player.x,player.y)
    local x    = path._nodes[2]:getX()
    local y    = path._nodes[2].getY()
    return x,y
end

local function compPlayerTurn(map,comp,finder,player,visible,movecomp,combat)
    comp.x,comp.y = movecomp(collision_map,comp,finder,player)
    local alive   = true
    if comp.x == player.x and comp.y == player.y then
        alive = combat(player,comp)
    end
    return alive
end

local function isPlayerVisible(player,comp,abs)
    local x_dist = abs(player.x - comp.x)
    local y_dist = abs(player.y - comp.y)
    if x_dist <= 8 and y_dist <= 8 then
        return true
    end
    return false
end

function moveCompPlayers(collision_map,e_list,finder,player)
    local movecomp = moveCompChar
    local visible  = isPlayerVisible
    local compturn = compPlayerTurn
    local combat   = startCombat
    local remove   = table.remove
    local abs      = math.abs
    for i=#e_list,1,-1 do
        if visible(player,e_list[i],abs) then
           if compTurn(collision_map,e_list[i],finder,player,visible,movecomp,combat) == false then
                remove(e_list,i)
            end
        end
    end
end

function movePlayer(player,map,dir)
    local mov,x,y = moveLocation(map,player.x,player.y,dir)
    if mov == true then
        player.x = x
        player.y = y
    end
    return mov
end


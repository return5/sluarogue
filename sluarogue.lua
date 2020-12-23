-- license

--[[

Copyright © 2020 <github.com/return5>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), 
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

--]]

local Map    = require("auxillary.map")
local Char   = require("auxillary.character")
local Move   = require("auxillary.movement")
local Pstuff = require("auxillary.printstuff")
local Ncurs  = require("auxillary.ncurses")

local LEVEL_COUNT

local function getI(rooms)
    return math.random(1,#rooms)
end

local function updatePlayerXY(player,room)
    player.x = math.random(room.x + 1, room.x + room.width - 1)
    player.y = math.random(room.y + 1, room.y + room.height - 1)
end

local function makeNewLevel(player,window)
    local i
    local maps     = createMaps()
    local e_list   = populateEnemyList(maps[1])
    local finder   = getFinder(maps[3],4)
    if player == nil then
        player,i  = makePlayer(maps[1],window)
    else
        i = getI(maps[1])
        updatePlayerXY(player,maps[1][i])
    end
    makeExit(maps,i)
    LEVEL_COUNT = LEVEL_COUNT - 1
    return player,maps,e_list,finder
end

local function gameLoop(game_map,collision_map,finder,e_list,player,window)
    local play            = true
    local new_level       = false
    local printmap        = printMap
    local printplayer     = printPlayer
    local printenemies    = printEnemyIcons
    local playerturn      = playerTurn
    local movecompplayers = moveCompPlayers
    local refreshw        = wrefresh
    local makevisible     = makeVisible
    repeat
        makevisible(game_map,player.y + 1, player.x + 1)
        printmap(game_map,window)
        printplayer(player,window)
        printenemies(game_map,e_list,window)
        refreshw(window)
        play,new_level = playerturn(player)
        if play == true then
            play = movecompplayers()
        end
    until(play == false)
    if new_level == true then
        makeNewLevel(player)
    else
        LEVEL_COUNT = 0
    end
end

local function levelLoop(game_win,info_win,prompt_win)
    repeat
        local player,maps,e_list,finder = makeNewLevel(player,game_win)
        makeFuncTable()
        makeItemTable(maps[2],maps[3],finder,player,e_list,game_win,prompt_win,info_win)
        gameLoop(maps[2],maps[3],finder,e_list,player,game_win)
    until(LEVEL_COUNT <= 0)
end


local function main()
    math.randomseed(os.time())
    LEVEL_COUNT = math.random(3,6)
    initNcurses()
    initColors()
    local game_win   = makeWindowWithBorder(HEIGHT,WIDTH,1,1)
    local info_win   = makeWindowWithBorder(4,12,1,WIDTH + 2)
    local prompt_win = makeWindowWithBorder(7,WIDTH,HEIGHT + 3,1)
    levelLoop(game_win,info_win,prompt_win)
    endwin()
end

main()


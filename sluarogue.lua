local Map    = require("auxillary.map")
local Char   = require("auxillary.character")
local Move   = require("auxillary.movement")
local Pstuff = require("auxillary.printstuff")
local Ncurs  = require("auxillary.ncurses")

local function gameLoop(game_map,collision_map,finder,e_list,player,window)
    local play            = true
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
        play = playerturn()
        if play == true then
            play = movecompplayers()
        end
    until(play == false)
end

local function main()
    math.randomseed(os.time())
    local maps     = createMaps()
    local e_list   = populateEnemyList(maps[1])
    local finder   = getFinder(maps[3],4)
    local player   = makePlayer(maps[1])
    initNcurses()
    initColors()
    local game_win   = makeWindowWithBorder(HEIGHT,WIDTH,1,1)
    local info_win   = makeWindowWithBorder(4,12,1,WIDTH + 2)
    local prompt_win = makeWindowWithBorder(7,WIDTH,HEIGHT + 3,1)
    makeFuncTable()
    makeItemTable(maps[3],finder,player,e_list,game_win,prompt_win,info_win)
    gameLoop(maps[2],maps[3],finder,e_list,player,game_win)
    endwin()
end

main()


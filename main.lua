local Map   = require("map")
local Char  = require("character")
local Rooms = require("room")
local Move  = require("movement")
local Printstuff = require("printstuff")

local function initNcurses()
    initscr()
    refresh()
    local window  = newwin("Game",HEIGHT,WIDTH,1,1)
    local b_win   = newwin("Border",HEIGHT + 2,WIDTH + 2,0,0)
	wborder(b_win,'|','|','-','-','+','+','+','+')
    wrefresh(b_win)
    return window
end

local function gameLoop(game_map,collision_map,finder,e_list,player,window)
    local play            = true
    local printmap        = printMap
    local printplayer     = printPlayer
    local printenemies    = printEnemies
    local playerturn      = playerTurn
    local movecompplayers = moveCompPlayers
    local refreshw        = wrefresh
    repeat
        printmap(game_map,window)
        printplayer(player,window)
        printenemies(e_list,window)
        refreshw(window)
        play = playerturn(player,collision_map,e_list)
        play = movecompplayers(collision_map,e_list,finder,player)
    until(play == false)
end

local function makePlayer(rooms)
    local i      = math.random(1,#rooms)
    local x      = math.random(rooms[i].x + 1,rooms[i].x + rooms[i].width - 1)
    local y      = math.random(rooms[i].y + 1, rooms[i].y + rooms[i].height - 1)
    local player = CHARACTER:new(x,y,10,10,10,10,nil,'@',"chris")
    return player
end

local function main()
    math.randomseed(os.time())
    local rooms                    = makeRooms(8)
    local game_map, collision_map  = makeMap(rooms)
    local e_list                   = populateEnemyList(rooms)
    local finder                   = getFinder(collision_map,4)
    local window                   = initNcurses()
    local player                   = makePlayer(rooms)
    gameLoop(game_map,collision_map,finder,e_list,player,window)
    endwin()
end
main()


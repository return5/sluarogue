local Map   = require("map")
local Char  = require("character")
local Rooms = require("room")

local function initNcurses()
    initscr()
    refresh()
    local window  = newwin("Game",HEIGHT,WIDTH,1,1)
    local b_win   = newwin("Border",HEIGHT + 2,WIDTH + 2,0,0)
	wborder(b_win,'|','|','-','-','+','+','+','+')
    wrefresh(b_win)
    return window
end

local function gameLoop(map,finder,e_list,player,window)
    local play = true
    repeat
        printMap(window)
        play = playerTurn(player,map,e_list)
        play = moveCompPlayers(map,e_list,finder,player)
    until(play == false)
end

local function main()
    math.randomseed(os.time())
    local rooms          = makeRooms(8)
    local collision_map  = makeMap(rooms)
    local e_list         = populateEnemyList(rooms)
    local finder         = getFinder(collision_map,4)
    local window         = initNcurses()
    printMap(window)
    getch()
    endwin()
end
main()


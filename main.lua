local Map   = require("map")
local Char  = require("character")
local Rooms = require("room")
local Move  = require("movement")
local Printstuff = require("printstuff")

COLORS = {
    BLACK   = 1,
    WHITE   = 2,
    GREEN   = 3,
    YELLOW  = 4,
    CYAN    = 5,
    RED     = 6,
    MAGENTA = 7,
    BLUE    = 8
}

local function initColors() 
	start_color()
	init_color(COLOR_YELLOW,700,700,98)
	init_pair(COLORS.BLACK,COLOR_BLACK,COLOR_BLACK)   
	init_pair(COLORS.WHITE,COLOR_WHITE,COLOR_BLACK)  
	init_pair(COLORS.GREEN,COLOR_GREEN,COLOR_BLACK)  
	init_pair(COLORS.YELLOW,COLOR_YELLOW,COLOR_BLACK)  
	init_pair(COLORS.CYAN,COLOR_CYAN,COLOR_BLACK)  
	init_pair(COLORS.RED,COLOR_RED,COLOR_BLACK)	
	init_pair(COLORS.MAGENTA,COLOR_MAGENTA,COLOR_BLACK)
	init_pair(COLORS.BLUE,COLOR_BLUE,COLOR_BLACK)
end

local function makeWindowWithBorder(name,height,width,x,y)
    local window  = newwin(name,height,width,y,x)
    local b_win   = newwin(name .. "_Border",height + 2,width + 2,x - 1, y - 1)
	wborder(b_win,'|','|','-','-','+','+','+','+')
    wrefresh(b_win)
    return window
end

local function initNcurses()
    initscr()
	noecho()	     --dont display key strokes
	cbreak()	     --disable line buffering
	curs_set(0)      --hide cursor
    refresh()
    local game_win = makeWindowWithBorder("GAME",HEIGHT,WIDTH,1,1)
    local info_win = makeWindowWithBorder("INFO",4,10,WIDTH + 2,1)
    return game_win,info_win
end

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
        play = movecompplayers()
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
    local game_win,info_win        = initNcurses()
    local player                   = makePlayer(rooms)
    initColors()
    makeFuncTable()
    makeItemTable(collision_map,finder,player,e_list)
    gameLoop(game_map,collision_map,finder,e_list,player,game_win)
    endwin()
end
main()


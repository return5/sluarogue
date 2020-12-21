local Map   = require("map")
local Char  = require("character")
local Rooms = require("room")
local Move  = require("movement")
local Printstuff = require("printstuff")
local Combat    = require("combat")

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

local function makeWindowWithBorder(height,width,y,x)
    local window  = newwin(height,width,y,x)
    local b_win   = newwin(height + 2,width + 2,y - 1, x - 1)
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
    local rand   = math.random
    local i      = rand(1,#rooms)
    local x      = rand(rooms[i].x + 1,rooms[i].x + rooms[i].width - 1)
    local y      = rand(rooms[i].y + 1, rooms[i].y + rooms[i].height - 1)
    local health = rand(15,25)
    local def    = rand(2,5)
    local attack = rand(4,7)
    local player = CHARACTER:new(x,y,health,attack,def,10,nil,'@',"chris")
    return player
end

local function testEncounter(player,e_list,map,window,prompt,info)
    local items = {
        window = window,
        player = player,
        e_list = e_list,
        map    = map,
        prompt = prompt,
        info   = info,
        play   = true
    }
    e_list[1].x = player.x
    e_list[1].y = player.y
    checkForEngagement(1,items)
end

local function main()
    math.randomseed(os.time())
    local rooms                    = makeRooms(8)
    local game_map, collision_map  = makeMap(rooms)
    local e_list                   = populateEnemyList(rooms)
    local finder                   = getFinder(collision_map,4)
    local player                   = makePlayer(rooms)
    initNcurses()
    initColors()
    local game_win   = makeWindowWithBorder(HEIGHT,WIDTH,1,1)
    local info_win   = makeWindowWithBorder(4,12,1,WIDTH + 2)
    local prompt_win = makeWindowWithBorder(6,WIDTH,HEIGHT + 3,1)
    --testEncounter(player,e_list,collision_map,game_win,prompt_win,info_win)
    makeFuncTable()
    makeItemTable(collision_map,finder,player,e_list,game_win,prompt_win,info_win)
    gameLoop(game_map,collision_map,finder,e_list,player,game_win)
    getch()
    endwin()
end
main()


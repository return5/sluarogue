--File contains functions for printing things to the screen

local Ncurs = require("sluacurses")

local function printHero(game_win) 
	wattron(game_win,COLOR_PAIR(COLORS.WHITE))
	mvwprintw(game_win,11,10,"\\") --sword
	mvwprintw(game_win,12,11,"\\") --sword
	wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
	wattron(game_win,COLOR_PAIR(COLORS.GREEN))
	mvwprintw(game_win,12,14,"|") --upper torso
	mvwprintw(game_win,13,14,"|") --lower torso
	wattroff(game_win,COLOR_PAIR(COLORS.GREEN))
	wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
	mvwprintw(game_win,11,14,"O") --head
	mvwprintw(game_win,12,12,"__") --arms
	mvwprintw(game_win,12,15,"__") --arms
	mvwprintw(game_win,14,13,"/ \\") --legs
	mvwprintw(game_win,15,12,"/   \\") --lowr legs
	wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))
	wattron(game_win,COLOR_PAIR(COLORS.RED))
	mvwprintw(game_win,12,17,"|") --sheild
	mvwprintw(game_win,13,17,"|") --sheild
	wattroff(game_win,COLOR_PAIR(COLORS.RED))
end

local function printSwordsman(game_win) 
	wattron(game_win,COLOR_PAIR(COLORS.GREEN))
	mvwprintw(game_win,11,27,"O") --head
	mvwprintw(game_win,12,25,"__") --left arm
	mvwprintw(game_win,12,28,"__") --right arm
	mvwprintw(game_win,14,26,"/ \\ ") --legs
	mvwprintw(game_win,15,25,"/   \\") --lower legs
	wattroff(game_win,COLOR_PAIR(COLORS.GREEN))
	wattron(game_win,COLOR_PAIR(COLORS.BLUE))
	mvwprintw(game_win,12,24,"|") --top of shield
	mvwprintw(game_win,13,24,"|") --bottom of shield
	wattroff(game_win,COLOR_PAIR(COLORS.BLUE))
	wattron(game_win,COLOR_PAIR(COLORS.RED))
	mvwprintw(game_win,12,27,"|") --top of torso
	mvwprintw(game_win,13,27,"|") --/bottom of torso
	wattroff(game_win,COLOR_PAIR(COLORS.RED))
	wattron(game_win,COLOR_PAIR(COLORS.WHITE))
	mvwprintw(game_win,11,31,"/") --top of sword
	mvwprintw(game_win,12,30,"/") --bottom of sword
	wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
end

local function printRogue(game_win) 
	wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
	mvwprintw(game_win,11,27,"O") --head
	wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))
	wattron(game_win,COLOR_PAIR(COLORS.WHITE))
	mvwprintw(game_win,12,24,"\\") --daggers
	mvwprintw(game_win,13,30,"\\") --daggers
	wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
	wattron(game_win,COLOR_PAIR(COLORS.GREEN))
	mvwprintw(game_win,12,25,"__|__") --upperbody
	mvwprintw(game_win,13,27,"|") --lowerbody
	mvwprintw(game_win,14,25," / \\") --legs
	mvwprintw(game_win,15,25,"/   \\") --lower legs
	wattroff(game_win,COLOR_PAIR(COLORS.GREEN))
end
	
local function printSpearman(game_win) 
	wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
	mvwprintw(game_win,13,26,"____ _ _ __") --spear
	wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))	
	wattron(game_win,COLOR_PAIR(COLORS.WHITE))
	mvwprintw(game_win,11,32,"O") --head
	mvwprintw(game_win,12,30,"__|__") --upper torso and arms
	mvwprintw(game_win,13,25,"_") --spearpoint
	mvwprintw(game_win,13,32,"|") --lower torso
	mvwprintw(game_win,13,30,"\\") --hands
	mvwprintw(game_win,13,34,"/") --other hands
	mvwprintw(game_win,14,31,"/ \\") --legs
	mvwprintw(game_win,15,30,"/   \\") --lower legs
	wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
end
local function printSkeleton(game_win) 
	wattron(game_win,COLOR_PAIR(COLORS.CYAN))
	mvwprintw(game_win,10,26,"|") --sword handle
	mvwprintw(game_win,11,26,"|") --sword handle
	wattroff(game_win,COLOR_PAIR(COLORS.CYAN))
	wattron(game_win,COLOR_PAIR(COLORS.BLUE))
	mvwprintw(game_win,10,25,"-") --handgaurd
	mvwprintw(game_win,10,27,"-") --handgaurd
	wattroff(game_win,COLOR_PAIR(COLORS.BLUE))
	wattron(game_win,COLOR_PAIR(COLORS.WHITE))
	mvwprintw(game_win,7,26,"|") --sword blade
	mvwprintw(game_win,8,26,"|") --sword blade
	mvwprintw(game_win,9,26,"|") --sword blade
	mvwprintw(game_win,10,29,"0") --head
	mvwprintw(game_win,11,27,"--|") --upper torso and arms
	mvwprintw(game_win,12,29,"|") --lower torso
	mvwprintw(game_win,13,28,"/ \\") --leg
	mvwprintw(game_win,14,27,"/   \\") --lower leg
	wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
end

 local function printWolf(game_win) 
	wattron(game_win,COLOR_PAIR(COLORS.WHITE))
	mvwprintw(game_win,12,26,"_") --top of head
	mvwprintw(game_win,13,25,"<") --snout
	wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
	wattron(game_win,COLOR_PAIR(COLORS.RED))
	mvwprintw(game_win,13,26,"=") --eyes?
	wattroff(game_win,COLOR_PAIR(COLORS.RED))	
	wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
	mvwprintw(game_win,12,27,"/") --ears
	mvwprintw(game_win,13,27,"\\_______/") --upperbody
	mvwprintw(game_win,14,28,"/\\    /\\") --upper legs
	mvwprintw(game_win,15,27,"/  \\  /  \\") --lower legs
	wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))	
end

local function printMage(game_win)  
	wattron(game_win,COLOR_PAIR(COLORS.BLUE))
	mvwprintw(game_win,11,27,"O") --head
	mvwprintw(game_win,12,25,"__|__") --upper torso and arms
	mvwprintw(game_win,13,27,"|") --lower torso
	mvwprintw(game_win,14,26,"/ \\") --upper legs
	mvwprintw(game_win,15,25,"/   \\") --lower legs
	wattroff(game_win,COLOR_PAIR(COLORS.BLUE))
	wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
	wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))
	wattron(game_win,COLOR_PAIR(COLORS.WHITE))
	mvwprintw(game_win,12,30,"|") --staff handle
	mvwprintw(game_win,13,30,"|") --staff handle
	mvwprintw(game_win,14,30,"|") --staff handle
	mvwprintw(game_win,15,30,"|") --staff handle
	wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
	wattron(game_win,COLOR_PAIR(COLORS.CYAN))
	mvwprintw(game_win,11,30,"+") --staff head
	wattroff(game_win,COLOR_PAIR(COLORS.CYAN))
end

local function printMonsterHead(game_win,x) 
	wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
	mvwprintw(game_win,9,26+x,"(   )") --facce
	wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))
	wattron(game_win,COLOR_PAIR(COLORS.WHITE))
	mvwprintw(game_win,9,27+x,". .") --eyes
	wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
	wattron(game_win,COLOR_PAIR(COLORS.RED))
	mvwprintw(game_win,9,28+x,"_") --mouth
	wattroff(game_win,COLOR_PAIR(COLORS.RED))
end

local function printMonsterBody(game_win) 
	wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
	mvwprintw(game_win,10,25,"____\\----/____")
	mvwprintw(game_win,11,29,"|____|")
	mvwprintw(game_win,12,28,"/      \\")
	mvwprintw(game_win,13,27,"/        \\")
	mvwprintw(game_win,14,26,"/          \\")
    wattroff(game_win,COLOR_:AIR(COLORS.YELLOW))
end

local function printMonsterSeveredHead(game_win,y,x) 
	wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
	mvwprintw(game_win,16+y,20+x,"(   )") --severed head face
	wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))
	wattron(game_win,COLOR_PAIR(COLORS.WHITE))
	mvwprintw(game_win,16+y,21+x,". .") --severed head eyes
	wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
	wattron(game_win,COLOR_PAIR(COLORS.RED))
	mvwprintw(game_win,16+y,22+x,"-") --severed head mouth
	wattroff(game_win,COLOR_PAIR(COLORS.RED))
end

--two headed monster
local function printMonster(game_win) 
	printMonsterHead(game_win,0)
	printMonsterHead(game_win,7)
	printMonsterBody(game_win)
end

local function printMonsterL(game_win) 
	printMonsterHead(game_win7)
	printMonsterBody(game_win)
	printMonsterSeveredHead(game_win,0,0)
end

local function printMonsterR(game_win) 
	printMonsterHead(game_win,0)
	printMonsterBody(game_win)
	printMonsterSeveredHead(game_win,-1,20)
end

function printEnemyCombat(game_win,enemy_type)
    if enemy_type == "S" then
        printSwordsman(game_win)
    elseif enemy_type == "B" then
        printBat(game_win)
    elseif enemy_type == "E" then
        printSpearman(game_win)
    elseif enemy_type == "W" then
        printWolf(game_win)
    elseif enemy_type == "D" then
        printSkeleton(game_win)
    elseif enemy_type == "M" then
        printMonster(game_win)
    elseif enemy_type == "v" then
        printMage()
    elseif enemy_type == "R" then
        printRogue(game_win)
    end 
end

function printPlayerPrompt(prompt)
    wclear(prompt)
    wprintw(prompt,"Player turn. select option:\n")
    wprintw(prompt,"\t1)regular atttack.\n")
    wprintw(prompt,"\t2)special attack.\n")
    wprintw(prompt,"\t3)use item.\n")
    wprintw(prompt,"\t4)run away.")
    wrefresh(prompt)
end

function printMessagePromptWin(prompt,str)
    wclear(prompt)
    wprintw(prompt,str)
    wrefresh(prompt)
    getch()
end

function printCombatScene(game_win,enemy_type)
    wclear(game_win)
    printHero(game_win)
    printEnemyCombat(game_win,enemy_type)
    wrefresh(game_win)
end

function updateInfoWin(player,info_win)
    wclear(info_win)
    wprintw(info_win,("health: %s\n"):format(player.health))
    wprintw(info_win,("attack: %s\n"):format(player.attack))
    wprintw(info_win,("defense: %s\n"):format(player.def))
    wrefresh(info_win)
end

function printPlayer(player,window)
    wattron(window,COLOR_PAIR(COLORS.CYAN))
    mvwprintw(window,player.y - 1,player.x - 1,player.icon)
    wattroff(window,COLOR_PAIR(COLORS.CYAN))
end

function printEnemyIcons(map,e_list,window)
    local print_e = mvwprintw
    for i = 1,#e_list,1 do
        if map[e_list[i].y + 1][e_list[i].x + 1].visible == true then
            wattron(window,COLOR_PAIR(e_list[i].color))
            print_e(window,e_list[i].y - 1,e_list[i].x - 1,e_list[i].icon)
            wattroff(window,COLOR_PAIR(e_list[i].color))
        end
    end
end

function printMap(map,window)
    local printicon = printIcon
    local width     = #map[1]
    local print_i   = mvwprintw
    for i = 1,#map,1 do
        for j = 1,width,1 do
            if map[i][j].visible == true then
                print_i(window,i - 1,j - 1,map[i][j].icon)
            end
        end
    end
end


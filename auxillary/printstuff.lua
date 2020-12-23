--File contains functions for printing things to the screen

local function printHero(game_win) 
    local top  = HEIGHT - 8
    local side = 1
    wattron(game_win,COLOR_PAIR(COLORS.WHITE))
    mvwprintw(game_win,top + 0,side + 0,"\\") --sword
    mvwprintw(game_win,top + 1,side + 1,"\\") --sword
    wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
    wattron(game_win,COLOR_PAIR(COLORS.GREEN))
    mvwprintw(game_win,top + 1,side + 4,"|") --upper torso
    mvwprintw(game_win,top + 2,side + 4,"|") --lower torso
    wattroff(game_win,COLOR_PAIR(COLORS.GREEN))
    wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
    mvwprintw(game_win,top + 0,side + 4,"O") --head
    mvwprintw(game_win,top + 1,side + 2,"__") --arms
    mvwprintw(game_win,top + 1,side + 5,"__") --arms
    mvwprintw(game_win,top + 3,side + 3,"/ \\") --legs
    mvwprintw(game_win,top + 4,side + 2,"/   \\") --lowr legs
    wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))
    wattron(game_win,COLOR_PAIR(COLORS.RED))
    mvwprintw(game_win,top + 1,side + 7,"|") --sheild
    mvwprintw(game_win,top + 2,side + 7,"|") --sheild
    wattroff(game_win,COLOR_PAIR(COLORS.RED))
end

local function printSwordsman(game_win) 
    local top  = HEIGHT - 8
    local side = 14
    wattron(game_win,COLOR_PAIR(COLORS.GREEN))
    mvwprintw(game_win,top + 0,side + 3,"O") --head
    mvwprintw(game_win,top + 1,side + 1,"__") --left arm
    mvwprintw(game_win,top + 1,side + 4,"__") --right arm
    mvwprintw(game_win,top + 3,side + 2,"/ \\ ") --legs
    mvwprintw(game_win,top + 4,side + 1,"/   \\") --lower legs
    wattroff(game_win,COLOR_PAIR(COLORS.GREEN))
    wattron(game_win,COLOR_PAIR(COLORS.BLUE))
    mvwprintw(game_win,top + 1,side + 0,"|") --top of shield
    mvwprintw(game_win,top + 2,side + 0,"|") --bottom of shield
    wattroff(game_win,COLOR_PAIR(COLORS.BLUE))
    wattron(game_win,COLOR_PAIR(COLORS.RED))
    mvwprintw(game_win,top + 1,side + 3,"|") --top of torso
    mvwprintw(game_win,top + 2,side + 3,"|") --/bottom of torso
    wattroff(game_win,COLOR_PAIR(COLORS.RED))
    wattron(game_win,COLOR_PAIR(COLORS.WHITE))
    mvwprintw(game_win,top + 0,side + 7,"/") --top of sword
    mvwprintw(game_win,top + 1,side + 6,"/") --bottom of sword
    wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
end

local function printRogue(game_win) 
    local top  = HEIGHT - 8
    local side = 12
    wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
    mvwprintw(game_win,top + 0,side + 3,"O") --head
    wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))
    wattron(game_win,COLOR_PAIR(COLORS.WHITE))
    mvwprintw(game_win,top + 1,side + 0,"\\") --daggers
    mvwprintw(game_win,top + 2,side + 6,"\\") --daggers
    wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
    wattron(game_win,COLOR_PAIR(COLORS.GREEN))
    mvwprintw(game_win,top + 1,side + 1,"__|__") --upperbody
    mvwprintw(game_win,top + 2,side + 3,"|") --lowerbody
    mvwprintw(game_win,top + 3,side + 1," / \\") --legs
    mvwprintw(game_win,top + 4,side + 1,"/   \\") --lower legs
    wattroff(game_win,COLOR_PAIR(COLORS.GREEN))
end
    
local function printSpearman(game_win) 
    local top  = HEIGHT - 8
    local side = 14
    wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
    mvwprintw(game_win,top + 2,side + 1,"____ _ _ __") --spear
    wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))    
    wattron(game_win,COLOR_PAIR(COLORS.WHITE))
    mvwprintw(game_win,top + 0,side + 7 ,"O") --head
    mvwprintw(game_win,top + 1,side + 5 ,"__|__") --upper torso and arms
    mvwprintw(game_win,top + 2,side + 0,"_") --spearpoint
    mvwprintw(game_win,top + 2,side + 7 ,"|") --lower torso
    mvwprintw(game_win,top + 2,side + 5 ,"\\") --hands
    mvwprintw(game_win,top + 2,side + 9,"/") --other hands
    mvwprintw(game_win,top + 3,side + 6 ,"/ \\") --legs
    mvwprintw(game_win,top + 4,side + 5 ,"/   \\") --lower legs
    wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
end
local function printSkeleton(game_win) 
    local top  = HEIGHT - 10
    local side = 13
    wattron(game_win,COLOR_PAIR(COLORS.CYAN))
    mvwprintw(game_win,top + 3,side + 1,"|") --sword handle
    mvwprintw(game_win,top + 4,side + 1,"|") --sword handle
    wattroff(game_win,COLOR_PAIR(COLORS.CYAN))
    wattron(game_win,COLOR_PAIR(COLORS.BLUE))
    mvwprintw(game_win,top + 3,side + 0,"-") --handgaurd
    mvwprintw(game_win,top + 3,side + 2,"-") --handgaurd
    wattroff(game_win,COLOR_PAIR(COLORS.BLUE))
    wattron(game_win,COLOR_PAIR(COLORS.WHITE))
    mvwprintw(game_win,top + 0,side + 1    ,"|") --sword blade
    mvwprintw(game_win,top + 1,side + 1,"|") --sword blade
    mvwprintw(game_win,top + 2,side + 1,"|") --sword blade
    mvwprintw(game_win,top + 3,side + 4,"0") --head
    mvwprintw(game_win,top + 4,side + 2,"--|") --upper torso and arms
    mvwprintw(game_win,top + 5,side + 4,"|") --lower torso
    mvwprintw(game_win,top + 6,side + 3,"/ \\") --leg
    mvwprintw(game_win,top + 7,side + 2,"/   \\") --lower leg
    wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
end

 local function printWolf(game_win) 
     local top  = HEIGHT - 7
     local side = 14
    wattron(game_win,COLOR_PAIR(COLORS.WHITE))
    mvwprintw(game_win,top + 0,side + 1,"_") --top of head
    mvwprintw(game_win,top + 1,side + 0,"<") --snout
    wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
    wattron(game_win,COLOR_PAIR(COLORS.RED))
    mvwprintw(game_win,top + 1,side + 1,"=") --eyes?
    wattroff(game_win,COLOR_PAIR(COLORS.RED))    
    wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
    mvwprintw(game_win,top + 0,side + 2,"/") --ears
    mvwprintw(game_win,top + 1,side + 2,"\\_______/") --upperbody
    mvwprintw(game_win,top + 2,side + 3,"/\\    /\\") --upper legs
    mvwprintw(game_win,top + 3,side + 2,"/  \\  /  \\") --lower legs
    wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))    
end

local function printMage(game_win)  
    local top  = HEIGHT - 8
    local side = 16
    wattron(game_win,COLOR_PAIR(COLORS.BLUE))
    mvwprintw(game_win,top + 0,side + 2,"O") --head
    mvwprintw(game_win,top + 1,side + 0,"__|__") --upper torso and arms
    mvwprintw(game_win,top + 2,side + 2,"|") --lower torso
    mvwprintw(game_win,top + 3,side + 1,"/ \\") --upper legs
    mvwprintw(game_win,top + 4,side + 0,"/   \\") --lower legs
    wattroff(game_win,COLOR_PAIR(COLORS.BLUE))
    wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
    wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))
    wattron(game_win,COLOR_PAIR(COLORS.WHITE))
    mvwprintw(game_win,top + 1,side + 5,"|") --staff handle
    mvwprintw(game_win,top + 2,side + 5,"|") --staff handle
    mvwprintw(game_win,top + 3,side + 5,"|") --staff handle
    mvwprintw(game_win,top + 4,side + 5,"|") --staff handle
    wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
    wattron(game_win,COLOR_PAIR(COLORS.CYAN))
    mvwprintw(game_win,top + 0,side + 5,"+") --staff head
    wattroff(game_win,COLOR_PAIR(COLORS.CYAN))
end

local function printFlyingThings(game_win)
    local top  = HEIGHT - 10
    local side = 11
    wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
    mvwprintw(game_win,top + 0,side + 8 ,'^') --top of head
    mvwprintw(game_win,top + 1,side + 2 ,'^') --top of head
    mvwprintw(game_win,top + 1,side + 13,'^') --top of head
    wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))
    wattron(game_win,COLOR_PAIR(COLORS.BLUE))
    mvwprintw(game_win,top + 1,side + 6 ,"<") --left side of body
    mvwprintw(game_win,top + 2,side + 0 ,"<") --left side of body
    mvwprintw(game_win,top + 2,side + 11,"<") --left side of body
    wattroff(game_win,COLOR_PAIR(COLORS.BLUE))
    wattron(game_win,COLOR_PAIR(COLORS.BLUE))
    mvwprintw(game_win,top + 1,side + 10,">") --right side of body
    mvwprintw(game_win,top + 2,side + 4 ,">") --right side of body
    mvwprintw(game_win,top + 2,side + 15,">") --right side of body
    wattroff(game_win,COLOR_PAIR(COLORS.BLUE))
    wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
    mvwprintw(game_win,top + 2,side + 8 ,"v") --bottom of head
    mvwprintw(game_win,top + 3,side + 2 ,"v") --bottom of head
    mvwprintw(game_win,top + 3,side + 13,"v") --bottom of head
    wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))
    wattron(game_win,COLOR_PAIR(COLORS.RED))
    mvwprintw(game_win,top + 1,side + 7 ,"' '") --eyes
    mvwprintw(game_win,top + 2,side + 1 ,"' '") --eyes
    mvwprintw(game_win,top + 2,side + 12,"' '") --eyes
    wattroff(game_win,COLOR_PAIR(COLORS.RED))
    mvwprintw(game_win,top + 2,side + 13,".") --mouth
    mvwprintw(game_win,top + 2,side + 2 ,".") --mouth
    mvwprintw(game_win,top + 1,side + 8 ,".") --mouth
end

local function printMonsterHead(game_win,top,side) 
    wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
    mvwprintw(game_win,top + 0,side + 1,"(   )") --face
    wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))
    wattron(game_win,COLOR_PAIR(COLORS.WHITE))
    mvwprintw(game_win,top + 0,side + 2,". .") --eyes
    wattroff(game_win,COLOR_PAIR(COLORS.WHITE))
    wattron(game_win,COLOR_PAIR(COLORS.RED))
    mvwprintw(game_win,top + 0,side + 3,"_") --mouth
    wattroff(game_win,COLOR_PAIR(COLORS.RED))
end

local function printMonsterBody(game_win,top,side) 
    wattron(game_win,COLOR_PAIR(COLORS.YELLOW))
    mvwprintw(game_win,top + 1,side + 0,"____\\----/____")
    mvwprintw(game_win,top + 2,side + 4,"|____|")
    mvwprintw(game_win,top + 3,side + 3,"/      \\")
    mvwprintw(game_win,top + 4,side + 2,"/        \\")
    mvwprintw(game_win,top + 5,side + 1,"/          \\")
    wattroff(game_win,COLOR_PAIR(COLORS.YELLOW))
end

--two headed monster
local function printMonster(game_win) 
    local top  = HEIGHT - 9
    local side = 14
    printMonsterHead(game_win,top,side)
    printMonsterHead(game_win,top,side + 7)
    printMonsterBody(game_win,top,side)
end

--when starting combat print the enemy character to the screen based on type
function printEnemyCombat(game_win,enemy_type)
    if enemy_type == "S" then
        printSwordsman(game_win)
    elseif enemy_type == "B" then
        printFlyingThings(game_win)
    elseif enemy_type == "E" then
        printSpearman(game_win)
    elseif enemy_type == "W" then
        printWolf(game_win)
    elseif enemy_type == "D" then
        printSkeleton(game_win)
    elseif enemy_type == "M" then
        printMonster(game_win)
    elseif enemy_type == "V" then
        printMage(game_win)
    elseif enemy_type == "R" then
        printRogue(game_win)
    end 
end

--combat prompt for player
function printPlayerPrompt(name,prompt)
    wclear(prompt)
    wprintw(prompt,name .. "'s turn.select option:\n")
    wprintw(prompt,"\t1)regular atttack.\n")
    wprintw(prompt,"\t2)special attack.\n")
    wprintw(prompt,"\t3)use item.\n")
    wprintw(prompt,"\t4)run away.")
    wrefresh(prompt)
end

--print a message to the prompt window.
--optionally send true to keep form calling getch at the end
function printMessagePromptWin(prompt,str,confirm)
    wclear(prompt)
    wprintw(prompt,str)
    wrefresh(prompt)
    if confirm ~= false then
        getch()
    end
end

--when combat starts print the player and enemy to screen
function printCombatScene(game_win,enemy_type)
    wclear(game_win)
    printHero(game_win)
    printEnemyCombat(game_win,enemy_type)
    wrefresh(game_win)
end

--update the info win with player info
function updateInfoWin(player,info_win)
    wclear(info_win)
    wprintw(info_win,("health: %s\n"):format(player.health))
    wprintw(info_win,("attack: %s\n"):format(player.attack))
    wprintw(info_win,("defense: %s\n"):format(player.def))
    wrefresh(info_win)
end

--print player icon to the map
function printPlayer(player,window)
    wattron(window,COLOR_PAIR(COLORS.CYAN))
    mvwprintw(window,player.y - 1,player.x - 1,player.icon)
    wattroff(window,COLOR_PAIR(COLORS.CYAN))
end

--for each visible enemy print its icon to map.
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

--print the game map to screen
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

function printPlayerInventory(inv_list,prompt)
    wclear(prompt)
    local print_inv = mvwprintw
    print_inv(prompt,0,5,"input|potion|total in inv.|")
    for i=1,#inv_list,1 do
        print_inv(prompt,i,5,("%d)%s  %d"):format(i,inv_list[i][1],inv_list[i][2]))
    end
    print_inv(prompt,#inv_list + 1,5,"any other number to cancel")
    wrefresh(prompt)
end


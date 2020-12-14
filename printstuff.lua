--File contains functions for printing things to the screen

local Ncurs = require("sluacurses")

function printPlayer(player,window)
    wmvprintw(window,player.y,player.x,player.icon)
end

function printEnemies(e_list,window)
    local print_e = wmvprintw
    for i = 1,#e_list,1 do
        print_e(window,e_list[i].y,e_list[i].x,e_list[i].icon)
    end
end

function printMap(map,window)
    local printicon = printIcon
    local width     = #map[1]
    local print_i   = wmvprintw
    for i = 1,#map,1 do
        for j = 1,width,1 do
            print_i(window,i - 1,j - 1,map[i][j].icon)
        end
    end
end

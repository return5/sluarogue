--File contains functions for initializing and working with ncurses
local ncurs = require("sluacurses")

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

function initColors() 
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

--make a new ncurses window and include a border around it
function makeWindowWithBorder(height,width,y,x)
    local window  = newwin(height,width,y,x)
    local b_win   = newwin(height + 2,width + 2,y - 1, x - 1)
    wborder(b_win,'|','|','-','-','+','+','+','+')
    wrefresh(b_win)
    return window
end

function initNcurses()
    initscr()
    noecho()         --dont display key strokes
    cbreak()         --disable line buffering
    curs_set(0)      --hide cursor
    refresh()
end


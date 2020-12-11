local Map = require("map")

local function main()
    makeMap(8)
    initscr()
    refresh()
    printMap()
    getch()
    endwin()
end
main()


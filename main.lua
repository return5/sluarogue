local Map = require("map")
local Char = require("character")

local function main()
    math.randomseed(os.time())
    local rooms = makeMap(8)
    makeEnemyList(rooms)
   -- initscr()
  --  refresh()
  --  printMap()
  --  getch()
 --   endwin()
end
main()


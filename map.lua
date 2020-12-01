local Path  = require("path")
local Room = require("room")

HEIGHT = 35
WIDTH  = 80

MAP = {}
MAP.__index = MAP

function MAP:new()
    local self    = setmetatable({},MAP)
    local additem = table.insert
    for i = 0,HEIGHT,1 do
        local row = {}
        for j = 0,WIDTH,1 do
             additem(row,TILE:new(j,i,"*"))
        end
        additem(MAP,row)
    end
    return self
end

local function printMap()
    local mvp = mvprintw
    for i=1,HEIGHT,1 do
        for j=1,WIDTH,1 do
            mvp(MAP[i][j].y,MAP[i][j].x,MAP[i][j].icon)
        end
    end
end

local function addPathsToMap(paths)
    for _,path in ipairs(paths) do
        for j = 1,#path,1 do
            MAP[path[j].y + 1][path[j].x + 1].icon = path[i].icon
        end
    end
end

math.randomseed(os.time())      --seed random number generator

MAP = MAP:new()
for i = 0,1,1 do
    addRoom()
end
initscr()
refresh()
local paths = makePaths(MAP,ROOMS)
addPathsToMap(paths)
printMap()
getch()
endwin()


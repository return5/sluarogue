
TILE = {x = nil, y = nil, icon=nil}
TILE.__index = TILE

function TILE:new(x,y,icon)
    local self = setmetatable({},TILE)
    self.x     = x
    self.y     = y
    self.icon  = icon
    return self
end


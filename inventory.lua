INVENTORY = {hp = nil, dp = nil, mp = nil, gold = nil}
INVENTORY.__index = INVENTORY

function INVENTORY:new(hp,dp,mp,gold)
    self      = setmetatable({},INVENTORY)
    self.hp   = hp
    self.dp   = dp
    self.mp   = mp
    self.gold = gold
    return self
end

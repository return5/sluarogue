INVENTORY = {hp = nil, dp = nil, mp = nil, ap = nil, gold = nil}
INVENTORY.__index = INVENTORY

function INVENTORY:new(hp,gold,mp,dp,ap)
    self      = setmetatable({},INVENTORY)
    self.hp   = hp
    self.dp   = dp
    self.mp   = mp
    self.gold = gold
    self.ap   = ap
    return self
end

local function raiseDefense(charater,value)
    if character.def_raised == 0 then
        character.prev_def = character.def
        character.def = character.def + value
        character.def_raised = 1
    end
end


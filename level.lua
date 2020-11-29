ROOM = {room = nil, height = nil, width = nil}


local function makeRoom(h,w)
    local room = {}
    local str = nil
    for i=1,h+1,1 do
        if i == 1 or i == h then
            str = string.rep("-",w)
        else
            str = "|" .. string.rep(" ",w - 2) .. "|"
        end
        table.insert(room,str)
    end
    return room
end

function ROOM:new(height,width)
        local o = o or {}
        setmetatable(o,self)
        self.__index = self
        self.height  = height
        self.width   = width
        self.room    = makeRoom(height,width)
        return o
end


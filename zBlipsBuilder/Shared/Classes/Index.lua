local random = math.random;
Enums = {};

--- Fowlmas resource main table (Client, Server, Shared)
FW = {};

---@type Shared
Shared = Class.new(function(class)

    ---@class Shared: BaseObject
    local self = class;

    function self:Constructor()

        self.colors = {
            blue = "~b~",
            purple = "~p~",
            yellow = "~y~",
            green = "~g~",
            red = "~r~",
            black = "~c~",
            orange = "~o~"
        };

    end

    ---Get user defined server color
    ---@return string
    function self:ServerColor()
        return self.colors[Config["ServerColor"]] or "~s~";
    end

    return self;

end)();

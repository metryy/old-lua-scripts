--[[
    Tool Class
    © Written by metry
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = require(ReplicatedStorage.Libraries.Class)

local Tool = Class.new("Tool")

function Tool.new(character, instance, data)
    local self = setmetatable({
        Name = instance.Name,
        Instance = instance,
        Player = game:GetService("Players"):GetPlayerFromCharacter(character),
    }, {__index = Tool})

    self.States = {}

    return self
end

function Tool:Destroy()
    self.Maid:Destroy()
    self = nil
end


return Tool

-[[
    Tool Controller
    © Written by metry
--]]

local ToolController = {}

local ContextActionService = game:GetService("ContextActionService")
local ToolCache = setmetatable({}, {mode = "k"})

function ToolController:Init()
end

function ToolController:Start()
    ContextActionService.LocalToolEquipped:Connect(function(tool)
        local Data = self.Constants.Tools.Weapons.Guns[tool.Name]

        if Data then
            local Gun = ToolCache[tool]

            if not Gun then
                ToolCache[tool] = self.Classes.Gun.new(self.Player.Character, tool, Data)
                Gun = ToolCache[tool]
            end

            Gun.Equipped = true
            Gun:Bind()

        end
    end)

    ContextActionService.LocalToolUnequipped:Connect(function(tool)
        if ToolCache[tool] then
            ToolCache[tool]:Unbind()
        end
    end)
end

return ToolController

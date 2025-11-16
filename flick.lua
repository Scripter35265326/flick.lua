-- Flick.lua
-- Project Yoda Hub Flick Script with Starlight UI
-- Icon Asset ID: 107232731410445

local Flick = {}

-- Settings
Flick.Enabled = false
Flick.FlickSpeed = 0.15 -- seconds to snap

-- Utility: Find the nearest target
local function getNearestTarget()
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("Head") then return nil end

    local closest, dist = nil, math.huge
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local magnitude = (head.Position - localPlayer.Character.Head.Position).Magnitude
            if magnitude < dist then
                dist = magnitude
                closest = head
            end
        end
    end
    return closest
end

-- Core flick function
function Flick:DoFlick()
    if not self.Enabled then return end
    local target = getNearestTarget()
    if target then
        local camera = workspace.CurrentCamera
        local goal = CFrame.new(camera.CFrame.Position, target.Position)
        camera.CFrame = camera.CFrame:Lerp(goal, self.FlickSpeed)
        print("Flicked to:", target.Parent.Name)
    end
end

-- Toggle flick on/off
function Flick:Toggle(state)
    self.Enabled = state
    print("Flick Enabled:", state)
end

---------------------------------------------------
-- Starlight UI Integration
---------------------------------------------------
local FlickTab = Starlight:CreateWindow({
    Title = "Flick Controls",
    SubTitle = "Precision Aim Assist",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 300),
    FileSettings = {
        RootFolder = "ProjectYodaHub",
        ConfigFolder = "Configs",
    },
}):CreateTab("Flick", "rbxassetid://107232731410445")

local FlickBox = FlickTab:CreateGroupbox({Name = "Flick Settings"}, "FlickBox")

FlickBox:CreateToggle({
    Name = "Enable Flick",
    CurrentValue = false,
    Callback = function(state)
        Flick:Toggle(state)
    end,
}, "FlickToggle")

FlickBox:CreateSlider({
    Name = "Flick Speed",
    Range = {0.05, 0.5},
    Increment = 0.05,
    CurrentValue = Flick.FlickSpeed,
    Callback = function(value)
        Flick.FlickSpeed = value
        print("Flick Speed set to:", value)
    end,
}, "FlickSpeedSlider")

-- Bind flick to mouse click
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Flick:DoFlick()
    end
end)

return Flick

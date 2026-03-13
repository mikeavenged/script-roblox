repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local HUDGui = PlayerGui:WaitForChild("HUDGui")
local Characters = Workspace:WaitForChild("Characters")

task.wait(2)

-- ป้องกันตกน้ำ
local lakesFolder = Workspace:WaitForChild("Interactions"):WaitForChild("Lakes")
for _, object in pairs(lakesFolder:GetDescendants()) do
    if object:IsA("BasePart") then
        object.CanCollide = true
    end
end

-- UI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "KRAKEN",
    Icon = "rbxassetid://2007771339",
    Author = "Create by : M4 Karlett",
    Folder = "KRAKENX",
    Size = UDim2.fromOffset(600,500),
    Theme = "Dark"
})

Window:SetToggleKey(Enum.KeyCode.X)

local MainTab = Window:Tab({
    Title = "General",
    Icon = "airplay"
})

MainTab:Section({
    Title = "// Main"
})

-- Input functions
local function pressKey(key)
    VirtualInputManager:SendKeyEvent(true,key,false,game)
    task.wait(0.2)
    VirtualInputManager:SendKeyEvent(false,key,false,game)
end

local function clickMouse()
    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
    task.wait(0.2)
    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
end

-- ตัวละคร
local function getMyChar()
    return Characters:FindFirstChild(LocalPlayer.Name) or LocalPlayer.Character
end

-- หา object ใกล้สุด
local function getClosest(folder,name)
    local closest
    local dist = math.huge

    local char = getMyChar()
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _,v in pairs(folder:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == name then
            local d = (root.Position - v.Position).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end

    return closest
end

_G.AutoFarm = false
local hasTeleported = false
local foodMode = "Water"
local foodToggleTime = 0

task.spawn(function()
    while task.wait(0.2) do

        if not _G.AutoFarm then
            hasTeleported = false
            continue
        end

        pcall(function()

            local char = getMyChar()
            if not char then return end

            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local hud = HUDGui:WaitForChild("MissionsFrame"):WaitForChild("Other")

            local qDrink = hud:FindFirstChild("EatFoodDrinkWater")

            if qDrink and qDrink.Visible then

                if tick() - foodToggleTime >= 10 then
                    foodToggleTime = tick()
                    foodMode = (foodMode=="Water") and "Food" or "Water"
                    hasTeleported = false
                end

                if foodMode == "Water" then

                    local target = getClosest(Workspace.Interactions.Lakes,"SurfaceMask")

                    if target then
                        if not hasTeleported then

                            local myPos = root.Position
                            local waterPos = target.Position

                            local direction = (waterPos - myPos).Unit
                            local standPos = waterPos - direction*12
                            standPos = standPos + Vector3.new(0,3,0)

                            root.CFrame = CFrame.lookAt(standPos,waterPos)

                            hasTeleported = true
                        end

                        task.wait(0.3)
                        pressKey(Enum.KeyCode.E)

                    end

                end

            end

        end)

    end
end)

MainTab:Toggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(v)
        _G.AutoFarm = v
    end
})

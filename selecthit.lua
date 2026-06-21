local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

_G.Hitbox = false
_G.PlayerESP = false
_G.SpeedHack = false
_G.SpeedValue = 5
_G.HitboxPlayer = ""

local Window = WindUI:CreateWindow({
    Title = "KRAKEN Lite",
    Icon = "rbxassetid://2007771339",
    Author = "Optimized",
    Size = UDim2.fromOffset(600, 500),
    Theme = "Dark"
})

local MainTab = Window:Tab({
    Title = "General",
    Icon = "airplay"
})

-- =========================
-- SPEED HACK
-- =========================
task.spawn(function()
    while task.wait(0.05) do
        if not _G.SpeedHack then continue end

        local char = LocalPlayer.Character
        if not char then continue end

        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        local moveDir = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDir += workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDir -= workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDir -= workspace.CurrentCamera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDir += workspace.CurrentCamera.CFrame.RightVector
        end

        if moveDir.Magnitude > 0 then
            root.CFrame += moveDir.Unit * _G.SpeedValue
        end
    end
end)

-- =========================
-- HITBOX
-- =========================
task.spawn(function()
    while task.wait(1) do -- จาก 0.2 เป็น 1 วิ เบาลงเยอะ
        if not _G.Hitbox then continue end

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Name:lower():find(_G.HitboxPlayer:lower()) then
                local char = player.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Size = Vector3.new(15,15,15)
                        root.Transparency = 0.5
                        root.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- =========================
-- PLAYER ESP
-- =========================
local function createESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if root:FindFirstChild("ESP") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.Parent = root

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.new(1,0,0)
    text.TextScaled = true
    text.Parent = billboard

    task.spawn(function()
        while billboard.Parent and _G.PlayerESP do
            task.wait(1)
            text.Text = player.Name
        end
        if billboard then
            billboard:Destroy()
        end
    end)
end

task.spawn(function()
    while task.wait(2) do
        if _G.PlayerESP then
            for _, player in pairs(Players:GetPlayers()) do
                createESP(player)
            end
        end
    end
end)

-- =========================
-- UI
-- =========================
MainTab:Dropdown({
    Title = "Select Player",
    Values = (function()
        local t = {}
        for _,v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then
                table.insert(t,v.Name)
            end
        end
        return t
    end)(),
    Callback = function(v)
        _G.HitboxPlayer = v
    end
})

MainTab:Toggle({
    Title = "Hitbox",
    Callback = function(v)
        _G.Hitbox = v
    end
})

MainTab:Toggle({
    Title = "Player ESP",
    Callback = function(v)
        _G.PlayerESP = v
    end
})

MainTab:Toggle({
    Title = "Speed Hack",
    Callback = function(v)
        _G.SpeedHack = v
    end
})

-- =========================
-- TELEPORTS
-- =========================
local teleports = {
    ["Oasis"] = CFrame.new(-1295,292,787),
    ["Volcano"] = CFrame.new(2122,398,850),
    ["กลางแมพ"] = CFrame.new(8,254,-105),
    ["Jungle"] = CFrame.new(2000,211,-705),
    ["Snow"] = CFrame.new(-1666,659,-1132),
    ["Swamp"] = CFrame.new(731,185,-2609),
    ["Forgotten Shore"] = CFrame.new(-1626,240,2460)
}

for name, pos in pairs(teleports) do
    MainTab:Button({
        Title = "Teleport "..name,
        Callback = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = pos
            end
        end
    })
end

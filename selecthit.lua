
-- ================== Windows  ================== --
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Folder = "KRAKENX"
local AutoLoadFile = Folder .. "/autoload.txt"
local Window = WindUI:CreateWindow({
    Title = "KRAKEN",
    Icon = "rbxassetid://2007771339",
    Author = "Create by : M4 Karlett",
    Folder = Folder,
    
    Size = UDim2.fromOffset(600, 500),
    MinSize = Vector2.new(600, 500),
    MaxSize = Vector2.new(600, 500),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    Background =  nil,
    BackgroundImageTransparency = 0.98,
    HideSearchBar = true,
    ScrollBarEnabled = false,
})
Window:Tag({
    Title = "Map : Creature of Sonaria ",
    Color = Color3.fromHex("#1e1e1e"),
    Radius = 80,
})
Window:SetToggleKey(Enum.KeyCode.X)
-- ================== Windows  ================== --







-- ================== Tab  ================== --

local MainTab = Window:Tab({
    Title = "General ",
    Icon = "airplay",
    Locked = false,
})


MainTab:Section({
    Title = "// Main "
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local HitboxPlayer = nil
local function FindPlayerByText(text)
    if not text or text == "" then
        return nil
    end

    text = text:lower()

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if plr.Name:lower():find(text, 1, true) then
                return plr
            end
        end
    end

    return nil
end


_G.Hitbox = false
_G.PlayerESP = false
_G.SpeedHack = false
_G.SpeedValue = 5 -- ปรับความแรง (แนะนำ 3 - 10)



local function createESP(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if root:FindFirstChild("PlayerESP") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerESP"
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.Parent = root
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.new(1,0,0)
    text.TextStrokeTransparency = 0
    text.Font = Enum.Font.SourceSansBold
    text.TextScaled = true
    text.Parent = billboard
    
    task.spawn(function()
        while billboard.Parent and _G.PlayerESP do
            task.wait(0.3)
            
            local myChar = LocalPlayer.Character
            if not myChar then continue end
            
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local dist = (root.Position - myRoot.Position).Magnitude
                text.Text = player.Name.." | "..math.floor(dist).."m"
            end
        end
        
        billboard:Destroy()
    end)
end

task.spawn(function()
    while task.wait(1) do
        if _G.PlayerESP then
            for _,v in pairs(Players:GetPlayers()) do
                createESP(v)
            end
        end
    end
end)


task.spawn(function()
    while task.wait(0.5) do

        local targetPlayer = FindPlayerByText(HitboxPlayer)

        for _,char in pairs(Workspace.Characters:GetChildren()) do

            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then
                continue
            end

          if targetPlayer
and targetPlayer ~= LocalPlayer
and targetPlayer.Character
and char == targetPlayer.Character
and _G.Hitbox then

                root.Size = Vector3.new(100,200,100)
                root.Transparency = 0.6
                root.CanCollide = false
                root.Massless = true

            else

                root.Size = Vector3.new(2,2,1)
                root.Transparency = 1
                root.CanCollide = true

            end

        end
    end
end)


MainTab:Button({
Title = "Copy Position",
Callback = function()
local pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
setclipboard("CFrame.new("..pos.X..","..pos.Y..","..pos.Z..")")
print("Copied Position")
end
})
MainTab:Section({
    Title = "// Teleport Islands"
})
MainTab:Button({
    Title = "Teleport Oasis",
    Desc = "วาปไปโอเอซิส",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-1295.0789794921875,292.3437194824219,787.1272583007812)
        end
    end
})
MainTab:Button({
Title = "Teleport ภูเขาไฟ",
Desc = "วาปไปภูเขาไฟ",
Callback = function()
local char = game.Players.LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") then
char.HumanoidRootPart.CFrame = CFrame.new(2122,398,850)
end
end
})
MainTab:Button({
Title = "Teleport หน้าผากลาง",
Desc = "วาปไปหน้าผากลาง",
Callback = function()
local char = game.Players.LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") then
char.HumanoidRootPart.CFrame = CFrame.new(8.342073440551758,254.5718536376953,-105.14787292480469)
end
end
})
MainTab:Button({
Title = "Teleport ป่าดงดิบ",
Desc = "วาปไปป่าดงดิบ",
Callback = function()
local char = game.Players.LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") then
char.HumanoidRootPart.CFrame = CFrame.new(2000.1488037109375,211.26702880859375,-705.1337280273438)
end
end
})
MainTab:Button({
Title = "Teleport หิมะ",
Desc = "วาปไปหิมะ",
Callback = function()
local char = game.Players.LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") then
char.HumanoidRootPart.CFrame = CFrame.new(-1666,659,-1132)
end
end
})
MainTab:Button({
Title = "Teleport บึงกลวง",
Desc = "วาปไปบึงกลวง",
Callback = function()
local char = game.Players.LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") then
char.HumanoidRootPart.CFrame = CFrame.new(731.9264526367188,185.1005096435547,-2609.9677734375)
end
end
})
MainTab:Button({
Title = "Teleport ชายฝั่งที่ลืม",
Desc = "วาปไปชายฝั่งที่ลืม",
Callback = function()
local char = game.Players.LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") then
char.HumanoidRootPart.CFrame = CFrame.new(-1626.9925537109375,240.81964111328125,2460.16845703125)
end
end
})


MainTab:Toggle({
    Title = "Hitbox",
    Desc = "ขยาย Hitbox ศัตรู",
    Default = false,
    Callback = function(Value)
        _G.Hitbox = Value
    end
})
MainTab:Toggle({
    Title = "Player ESP",
    Desc = "เห็นผู้เล่นทุกคนในแมพ",
    Default = false,
    Callback = function(Value)
        _G.PlayerESP = Value
    end
})

MainTab:Toggle({
    Title = "Speed Hack (Real)",
    Desc = "วิ่งไวแบบใช้ได้จริง",
    Default = false,
    Callback = function(Value)
        _G.SpeedHack = Value
    end
})

MainTab:Input({
    Title = "Hitbox Target",
    Placeholder = "พิมพ์ชื่อผู้เล่น",
    Callback = function(text)
        HitboxPlayer = text
    end
})


local lakesFolder = workspace.Interactions.Lakes
for _, object in pairs(lakesFolder:GetDescendants()) do
    if object:IsA("BasePart") then
        object.CanCollide = true
    end
end


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




-- ================== ConfigFile  ================== --
local ConfigManager = Window.ConfigManager
local MyConfig = ConfigManager:CreateConfig("DefaultConfig")
-- ================== ConfigFile  ================== --




-- ================== Tab  ================== --

local MainTab = Window:Tab({
    Title = "General ",
    Icon = "airplay",
    Locked = false,
})

-- ================== Tab  ================== --



MainTab:Section({
    Title = "// Main "
})

local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local AttackRemote = game.ReplicatedStorage:FindFirstChild("Attack")
local HitboxPlayer = nil
local HitboxDropdown
local function GetPlayerList()
    local t = {}
    for _,plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            table.insert(t, plr.Name)
        end
    end
    table.sort(t)
    return t
end


_G.RemoteAttack = false
_G.Hitbox = false
_G.PlayerESP = false
_G.FastHunger = false
_G.AutoShoom = false
_G.SpeedHack = false
_G.AntiBoneBreak = false
_G.SpeedValue = 5 -- ปรับความแรง (แนะนำ 3 - 10)
_G.UnlimitedBreath = false
-- ================== Ultimate Fix Logic ================== --

-- 3. ระบบ Bypass Movement (สำหรับกระดูกแตกแล้วเดินไม่ออก)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AntiBoneBreak then
            pcall(function()
                local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = 16 -- บังคับความเร็วเดินพื้นฐานตลอดเวลา
                    hum.JumpPower = 50 -- บังคับการกระโดด
                end
            end)
        end
    end
end)
local UIS = game:GetService("UserInputService")


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
    while task.wait(0.1) do
        
        if not _G.RemoteAttack then
            continue
        end
        
        if AttackRemote then
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer then
                    
                    local char = v.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        AttackRemote:FireServer(
                            char,
                            char.HumanoidRootPart.Position
                        )
                    end
                    
                end
            end
        end
        
    end
end)

local function getMyChar()
    return Workspace.Characters:FindFirstChild(LocalPlayer.Name) or LocalPlayer.Character
end


task.spawn(function()
    while task.wait(0.2) do

        for _,char in pairs(Workspace.Characters:GetChildren()) do

            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then continue end

            if HitboxPlayer and char.Name == HitboxPlayer then

                if _G.Hitbox then
                    root.Size = Vector3.new(50,200,50)
                    root.Transparency = 0.6
                    root.CanCollide = false
                    root.Massless = true
                else
                    root.Size = Vector3.new(2,2,1)
                    root.Transparency = 1
                    root.CanCollide = true
                end

            else
                -- รีเซ็ตคนอื่นให้ปกติ
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
MainTab:Section({
    Title = "// Token"
})

local function getTokens()
    local tokens = {}
    
    for _,v in pairs(workspace:GetDescendants()) do
        if string.find(v.Name:lower(),"token") and v:IsA("BasePart") then
            table.insert(tokens,v)
        end
    end
    
    return tokens
end


MainTab:Button({
    Title = "Teleport All Tokens",
    Desc = "วาปไปเก็บ Token ทุกอันในแมพ",
    Callback = function()
        
        local char = game.Players.LocalPlayer.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local tokens = getTokens()
        
        for _,token in pairs(tokens) do
            if token and token.Parent then
                root.CFrame = token.CFrame + Vector3.new(0,5,0)
                task.wait(0.6)
            end
        end
        
        print("Collected all tokens")
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

HitboxDropdown = MainTab:Dropdown({
    Title = "Hitbox Target",
    Values = GetPlayerList(),
    Callback = function(v)
        HitboxPlayer = v
    end
})
local function RefreshPlayers()
    local list = GetPlayerList()

    pcall(function()
        if HitboxDropdown.Refresh then
            HitboxDropdown:Refresh(list)
        elseif HitboxDropdown.SetValues then
            HitboxDropdown:SetValues(list)
        end
    end)

    if HitboxPlayer and not Players:FindFirstChild(HitboxPlayer) then
        HitboxPlayer = nil
    end
end

Players.PlayerAdded:Connect(function()
    task.wait(1)
    RefreshPlayers()
end)

Players.PlayerRemoving:Connect(function()
    RefreshPlayers()
end)

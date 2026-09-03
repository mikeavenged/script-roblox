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
    Background = nil,
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

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local AttackRemote = game.ReplicatedStorage:FindFirstChild("Attack")
local UIS = game:GetService("UserInputService")

_G.RemoteAttack = false
_G.Hitbox = false
_G.HitboxPlayer = ""
_G.PlayerESP = false
_G.FastHunger = false
_G.SpeedHack = false
_G.AntiBoneBreak = false
_G.SpeedValue = 5
_G.UnlimitedBreath = false

-- ================== Ultimate Fix Logic ================== --
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            local player = game.Players.LocalPlayer
            local char = player.Character
            if not char then return end

            -- 1. จัดการ Unlimited Breath
            if _G.UnlimitedBreath then
                for name, _ in pairs(char:GetAttributes()) do
                    if string.find(name:lower(), "stamina") or string.find(name:lower(), "breath") then
                        char:SetAttribute(name, 100)
                    end
                end
                
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("NumberValue") and (v.Name:lower():find("breath") or v.Name:lower():find("stamina")) then
                        v.Value = 100
                    end
                end
            end

            -- 2. จัดการ Anti Bone Break
            if _G.AntiBoneBreak then
                local status = char:FindFirstChild("StatusEffects") or char:FindFirstChild("Effects")
                if status then
                    for _, effect in pairs(status:GetChildren()) do
                        local n = effect.Name:lower()
                        if n:find("bone") or n:find("broken") or n:find("injury") or n:find("wound") or n:find("tear") or n:find("bleed") then
                            effect:Destroy()
                        end
                    end
                end
                
                for name, _ in pairs(char:GetAttributes()) do
                    local n = name:lower()
                    if n:find("broken") or n:find("injury") or n:find("bleeding") then
                        char:SetAttribute(name, 0)
                        char:SetAttribute(name, false)
                    end
                end
            end
        end)
    end
end)

-- 3. ระบบ Bypass Movement
task.spawn(function()
    while task.wait(0.5) do
        if _G.AntiBoneBreak then
            pcall(function()
                local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = 16
                    hum.JumpPower = 50
                end
            end)
        end
    end
end)

-- 4. SpeedHack
task.spawn(function()
    while task.wait(0.03) do
        if not _G.SpeedHack then continue end
        
        local char = game.Players.LocalPlayer.Character
        if not char then continue end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        
        local moveDir = Vector3.zero
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector
        end
        
        if moveDir.Magnitude > 0 then
            root.CFrame = root.CFrame + (moveDir.Unit * _G.SpeedValue)
        end
    end
end)

-- 5. Fast Hunger (Client UI)
task.spawn(function()
    while task.wait(0.1) do
        if not _G.FastHunger then continue end
        
        pcall(function()
            local player = game.Players.LocalPlayer
            local stats = player.PlayerGui.HUDGui.StatsFrame
            
            local hunger = stats:FindFirstChild("Hunger")
            local thirst = stats:FindFirstChild("Thirst")
            
            if hunger and hunger:FindFirstChild("Value") and hunger.Value.Value > 0 then
                hunger.Value.Value = hunger.Value.Value - 2
            end
            
            if thirst and thirst:FindFirstChild("Value") and thirst.Value.Value > 0 then
                thirst.Value.Value = thirst.Value.Value - 2
            end
        end)
    end
end)

-- ESP Function
local function createESP(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root or root:FindFirstChild("PlayerESP") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerESP"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = root
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.new(1, 0, 0)
    text.TextStrokeTransparency = 0
    text.Font = Enum.Font.SourceSansBold
    text.TextScaled = true
    text.Parent = billboard
    
    task.spawn(function()
        while billboard.Parent and _G.PlayerESP do
            task.wait(0.3)
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") and root and root.Parent then
                local dist = (root.Position - myChar.HumanoidRootPart.Position).Magnitude
                text.Text = player.Name .. " | " .. math.floor(dist) .. "m"
            end
        end
        billboard:Destroy()
    end)
end

task.spawn(function()
    while task.wait(1) do
        if _G.PlayerESP then
            for _, v in pairs(Players:GetPlayers()) do
                createESP(v)
            end
        end
    end
end)

-- Remote Attack
task.spawn(function()
    while task.wait(0.1) do
        if not _G.RemoteAttack then continue end
        
        if AttackRemote then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    AttackRemote:FireServer(v.Character, v.Character.HumanoidRootPart.Position)
                end
            end
        end
    end
end)

local function getMyChar()
    return (Workspace:FindFirstChild("Characters") and Workspace.Characters:FindFirstChild(LocalPlayer.Name)) or LocalPlayer.Character
end

-- Hitbox Expansion
task.spawn(function()
    while task.wait(0.2) do
        local targetFolder = Workspace:FindFirstChild("Characters")
        if targetFolder then
            for _, char in pairs(targetFolder:GetChildren()) do
                if char ~= getMyChar() then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local enableHitbox = false
                        local player = Players:FindFirstChild(char.Name)

                        if _G.Hitbox and player and _G.HitboxPlayer ~= "" then
                            if string.find(string.lower(player.Name), string.lower(_G.HitboxPlayer)) then
                                enableHitbox = true
                            end
                        end

                        if enableHitbox then
                            root.Size = Vector3.new(100, 300, 100)
                            root.Transparency = 0.6
                            root.CanCollide = false
                            root.Massless = true
                        else
                            root.Size = Vector3.new(2, 2, 1)
                            root.Transparency = 1
                            root.CanCollide = true
                        end
                    end
                end
            end
        end
    end
end)

-- UI Buttons
MainTab:Button({
    Title = "Copy Position",
    Callback = function()
        local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            setclipboard("CFrame.new(" .. root.Position.X .. "," .. root.Position.Y .. "," .. root.Position.Z .. ")")
            print("Copied Position")
        end
    end
})

MainTab:Section({
    Title = "// Teleport Islands"
})

local locations = {
    {"Teleport Oasis", "วาปไปโอเอซิส", CFrame.new(-1295.0789794921875, 292.3437194824219, 787.1272583007812)},
    {"Teleport ภูเขาไฟ", "วาปไปภูเขาไฟ", CFrame.new(2122, 398, 850)},
    {"Teleport หน้าผากลาง", "วาปไปหน้าผากลาง", CFrame.new(8.342073440551758, 254.5718536376953, -105.14787292480469)},
    {"Teleport ป่าดงดิบ", "วาปไปป่าดงดิบ", CFrame.new(2000.1488037109375, 211.26702880859375, -705.1337280273438)},
    {"Teleport หิมะ", "วาปไปหิมะ", CFrame.new(-1666, 659, -1132)},
    {"Teleport บึงกลวง", "วาปไปบึงกลวง", CFrame.new(731.9264526367188, 185.1005096435547, -2609.9677734375)},
    {"Teleport ชายฝั่งที่ลืม", "วาปไปชายฝั่งที่ลืม", CFrame.new(-1626.9925537109375, 240.81964111328125, 2460.16845703125)}
}

for _, loc in pairs(locations) do
    MainTab:Button({
        Title = loc[1],
        Desc = loc[2],
        Callback = function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = loc[3]
            end
        end
    })
end

MainTab:Section({
    Title = "// Token"
})

local function getTokens()
    local tokens = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if string.find(v.Name:lower(), "token") and v:IsA("BasePart") then
            table.insert(tokens, v)
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
        for _, token in pairs(tokens) do
            if token and token.Parent then
                root.CFrame = token.CFrame + Vector3.new(0, 5, 0)
                task.wait(0.6)
            end
        end
        print("Collected all tokens")
    end
})

MainTab:Dropdown({
    Title = "Select Player",
    Values = (function()
        local t = {}
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer then
                table.insert(t, v.Name)
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
    Title = "Hitbox Player",
    Desc = "พิมพ์ชื่อผู้เล่น",
    Placeholder = "Player Name",
    Callback = function(text)
        _G.HitboxPlayer = text
    end
})

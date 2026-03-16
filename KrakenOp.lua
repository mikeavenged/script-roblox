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
    Title = "Map : Creature of Sanaria ",
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
_G.RemoteAttack = false
_G.Hitbox = false
_G.KillAura = false
_G.PlayerESP = false
_G.GodMode = false
_G.Invisible = false
_G.FastHunger = false

task.spawn(function()
    while task.wait(2) do
        if _G.FastHunger then
            local char = game.Players.LocalPlayer.Character
            if char then
                local stats = char:FindFirstChild("PlayerStats") or char:FindFirstChild("Status") or char:FindFirstChild("Values")
                if stats then
                    local hunger = stats:FindFirstChild("Hunger")
                    if hunger then
                        hunger.Value = hunger.Value - 200
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        if _G.GodMode then
            local char = game.Players.LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Health = hum.MaxHealth
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(1) do
        local char = game.Players.LocalPlayer.Character
        if char then
            for _,v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                    if _G.Invisible then
                        v.Transparency = 1
                    else
                        v.Transparency = 0
                    end
                end
            end
        end
    end
end)



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

local function pressKey(keyCode)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    task.wait(0.25)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
    task.wait(0.25)
end

local function clickMouse()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.25)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    task.wait(0.25)
end

task.spawn(function()
    while task.wait(1) do
        for _,char in pairs(Workspace.Characters:GetChildren()) do
            if char ~= getMyChar() then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    
                    if _G.Hitbox then
                        root.Size = Vector3.new(80,80,80)
                        root.Transparency = 0.5
                        root.CanCollide = false
                    else
                        root.Size = Vector3.new(2,2,1)
                        root.Transparency = 1
                        root.CanCollide = true
                    end
                    
                end
            end
        end
    end
end)

local radius = 800

task.spawn(function()
    while task.wait(0.15) do
             if not _G.KillAura then
            continue
        end

        for _,v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then
                
                local char = v.Character
                local myChar = LocalPlayer.Character
                
                if char and myChar
                and char:FindFirstChild("HumanoidRootPart")
                and myChar:FindFirstChild("HumanoidRootPart") then
                    
                    local dist = (char.HumanoidRootPart.Position - myChar.HumanoidRootPart.Position).Magnitude
                    
                    if dist <= radius then
                        
                        local enemyPos = char.HumanoidRootPart.Position
                        local myRoot = myChar.HumanoidRootPart
                        
                        myRoot.CFrame =
                            CFrame.lookAt(
                                enemyPos + Vector3.new(0,2,3),
                                enemyPos
                            )

                        clickMouse()
                    end
                    
                end
            end
        end
    end
end)

_G.AutoFarm = false
local currentTask = nil 
local hasTeleported = false 
local foodToggleTime = 0
local foodMode = "Water"
local idleIndex = 1
local lastIdleTime = 0
local lastPosBeforeAttack = nil
local lastSniffTime = 0

local idleCFrames = {
    CFrame.new(393.017365, 571.791687, -5.18445492, 0.0557625704, 6.04802486e-10, 0.99844408, -1.52293855e-11, 1, -6.04894468e-10, -0.99844408, 1.85247807e-11, 0.0557625704),
    CFrame.new(1997.70007, 441.18454, -680.129395, 0.507577777, 0.00243278989, -0.861602485, 7.87882968e-08, 0.999996006, 0.00282359915, 0.861605942, -0.00143326411, 0.50757575),
    CFrame.new(2122.60938, 398.156738, 850.940125, -0.997617602, -0.0119449981, -0.0679439902, 1.93523434e-07, 0.984894812, -0.173153803, 0.0689860061, -0.172741294, -0.982548416),
    CFrame.new(456.240112, 509.997711, 1701.30505, -0.285366416, 0.208944499, 0.93536526, -0.257968038, 0.923184574, -0.284925848, -0.923048496, -0.32260263, -0.209544867),
    CFrame.new(-1477.31702, 360.695801, 2778.80518, -0.358562618, -8.29175042e-05, 0.933505654, 5.28495038e-05, 1, 0.000109123452, -0.933505654, 8.84629044e-05, -0.358562618),
    CFrame.new(-1991.56909, 617.171997, 1261.29248, 0.998566926, 0.0483029932, -0.0230410732, -0.0485682711, 0.998758256, -0.0110957762, 0.0224765018, 0.0121989399, 0.999672949),
    CFrame.new(-1666.97107, 659.591675, -1132.51355, 0.660012424, -0.723222077, -0.203306273, 0.73556149, 0.677136838, -0.0208581146, 0.152751207, -0.135777652, 0.978892982),
    CFrame.new(-1020.27228, 388.206116, -2543.24268, 0.950728178, -0.30985716, 0.0102210632, 0.304852724, 0.94035393, 0.150994495, -0.0563981421, -0.140438795, 0.98848176),
    CFrame.new(-681.817078, 75.0634308, -3028.96777, -0.980617046, 0.0334055759, -0.193065256, 0.0298160873, 0.999324799, 0.0214686729, 0.193652064, 0.0152960978, -0.980951071)
}


local function getClosestPart(parentFolder, modelName, partName)
    local closest = nil
    local dist = math.huge
    local myRoot = getMyChar() and getMyChar():FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    for _, model in pairs(parentFolder:GetChildren()) do
        if model.Name == modelName then
            local p = model:FindFirstChild(partName)
            if p and p:IsA("BasePart") then
                local d = (myRoot.Position - p.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = p
                end
            end
        end
    end
    return closest
end

local function getClosest(folder, name)
    local closest = nil
    local dist = math.huge
    local myRoot = getMyChar() and getMyChar():FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    for _, v in pairs(folder:GetDescendants()) do
        if v.Name == name and v:IsA("BasePart") then
            local d = (myRoot.Position - v.Position).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end
    return closest
end

task.spawn(function()
    while true do
        task.wait(0.2) 
        if not _G.AutoFarm then 
            currentTask = nil
            hasTeleported = false
            continue 
        end
        pcall(function()
            local myRoot = getMyChar():FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
                    -- Auto Sniff ทุก 15 วิ
if tick() - lastSniffTime >= 15 then
    pressKey(Enum.KeyCode.H)
    lastSniffTime = tick()
end

            local hud = LocalPlayer.PlayerGui.HUDGui.MissionsFrame.Other
            local qMud = hud:FindFirstChild("ConcealScent")
            local qDrink = hud:FindFirstChild("EatFoodDrinkWater")
            local qSniff = hud:FindFirstChild("Sniff")
            local qAttack = hud:FindFirstChild("AttackOrHealCreatureOrNPC")
            
            if currentTask == "Mud" and (not qMud or not qMud.Visible) then currentTask = nil end
            if currentTask == "Drink" and (not qDrink or not qDrink.Visible) then currentTask = nil end
            if currentTask == "Sniff" and (not qSniff or not qSniff.Visible) then currentTask = nil end
            
            if currentTask == "Attack" and (not qAttack or not qAttack.Visible) then 
                if lastPosBeforeAttack then
                    myRoot.CFrame = lastPosBeforeAttack
                    lastPosBeforeAttack = nil
                end
                currentTask = nil 
            end
            
            if currentTask == nil then
                local taskPool = {}
                if qMud and qMud.Visible then table.insert(taskPool, "Mud") end
                if qDrink and qDrink.Visible then table.insert(taskPool, "Drink") end
                if qSniff and qSniff.Visible then table.insert(taskPool, "Sniff") end
                if qAttack and qAttack.Visible then table.insert(taskPool, "Attack") end
                
                if #taskPool > 0 then
                    currentTask = taskPool[math.random(1, #taskPool)]
                    hasTeleported = false 
                    foodToggleTime = tick()
                    foodMode = "Water"
                    if currentTask == "Attack" then
                        lastPosBeforeAttack = myRoot.CFrame
                    end
                else
                    if myRoot and tick() - lastIdleTime >= 5 then
                        myRoot.CFrame = idleCFrames[idleIndex]
                        idleIndex = (idleIndex % #idleCFrames) + 1
                        lastIdleTime = tick()
                    end
                end
            end
            
            if currentTask == "Mud" then
                local target = getClosest(Workspace.Interactions.Mud, "Mud")
                if target then
                    if not hasTeleported then
                        myRoot.CFrame = target.CFrame * CFrame.new(0, 40, 0)
                        hasTeleported = true
                    end
                    pressKey(Enum.KeyCode.E)
                end
            elseif currentTask == "Drink" then
                if tick() - foodToggleTime >= 10 then
                    foodToggleTime = tick()
                    foodMode = (foodMode == "Water") and "Food" or "Water"
                    hasTeleported = false
                end
                if foodMode == "Water" then
                    local target = getClosest(Workspace.Interactions.Lakes, "SurfaceMask")
                    if target then
                        if not hasTeleported then
                            myRoot.CFrame = target.CFrame * CFrame.new(0, 40, 0)
                            hasTeleported = true
                        end
                        pressKey(Enum.KeyCode.E)
                    end
                else
                    local target = getClosestPart(Workspace.Interactions.Food, "Ribs", "Food")
                    if target then
                        if not hasTeleported then
                           local lookPos = target.Position
local direction = (lookPos - myRoot.Position).Unit
local telePos = lookPos - (direction * 7) + Vector3.new(0,3,0)

myRoot.CFrame = CFrame.lookAt(telePos, lookPos)
Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, lookPos)
                            hasTeleported = true
                        end
                        pressKey(Enum.KeyCode.E)
                    end
                end
            elseif currentTask == "Sniff" then
                        if tick() - lastSniffTime >= 15 then
                pressKey(Enum.KeyCode.H)
                            lastSniffTime = tick()
    end
            elseif currentTask == "Attack" then
                local chars = Workspace.Characters:GetChildren()
                local enemy = nil
                if #chars > 1 then
                    for i = 1, 10 do 
                        local temp = chars[math.random(1, #chars)]
                        if temp ~= getMyChar() and temp:FindFirstChild("HumanoidRootPart") then
                            enemy = temp
                            break
                        end
                    end
                end
                if enemy then
                    myRoot.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                    clickMouse()
                end
            end
        end)
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
local AutoFarmToggle = MainTab:Toggle({
    Title = "Auto Farm ",
    Desc = "ฟาร์มโหดๆ555 ",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        if not Value then 
            currentTask = nil 
            hasTeleported = false 
            lastPosBeforeAttack = nil
        end
    end
})
local SelectedPlayer = nil

MainTab:Dropdown({
    Title = "Select Player",
    Values = (function()
        local t = {}
        for _,v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer then
                table.insert(t,v.Name)
            end
        end
        return t
    end)(),
    Callback = function(v)
        SelectedPlayer = v
    end
})
_G.KillPlayer = false

MainTab:Toggle({
    Title = "Kill Selected Player",
    Desc = "เปิด / ปิด ไล่ฆ่าคนที่เลือก",
    Default = false,
    Callback = function(Value)
        _G.KillPlayer = Value
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
    Title = "Kill Aura",
    Desc = "ตีทุกคนในระยะ",
    Default = false,
    Callback = function(Value)
        _G.KillAura = Value
    end
})
MainTab:Toggle({
    Title = "God Mode",
    Desc = "อมตะ ไม่โดนดาเมจ",
    Default = false,
    Callback = function(Value)
        _G.GodMode = Value
    end
})
MainTab:Toggle({
    Title = "Invisible",
    Desc = "ทำให้ตัวละครล่องหน",
    Default = false,
    Callback = function(Value)
        _G.Invisible = Value
    end
})
MainTab:Toggle({
    Title = "Fast Hunger",
    Desc = "หิวเร็วขึ้น",
    Default = false,
    Callback = function(Value)
        _G.FastHunger = Value
    end
})

task.spawn(function()
    while true do
        task.wait(0.3)

        if not _G.KillPlayer then
            continue
        end

        if not SelectedPlayer then
            continue
        end
        
        local target = game.Players:FindFirstChild(SelectedPlayer)
        if not target then
            continue
        end
        
        local myChar = game.Players.LocalPlayer.Character
        local enemyChar = target.Character
        
        if not myChar or not enemyChar then
            continue
        end
        
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        local enemyRoot = enemyChar:FindFirstChild("HumanoidRootPart")
        
        if not myRoot or not enemyRoot then
            continue
        end

        myRoot.CFrame = enemyRoot.CFrame * CFrame.new(0,0,2)

        VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)

    end
end)

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

_G.AutoFarm = false
local currentTask = nil 
local hasTeleported = false 
local foodToggleTime = 0
local foodMode = "Water"
local idleIndex = 1
local lastIdleTime = 0
local lastPosBeforeAttack = nil

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

local function getMyChar()
    return Workspace.Characters:FindFirstChild(LocalPlayer.Name) or LocalPlayer.Character
end

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
        local edgeOffset = target.CFrame.LookVector * -25
        local pos = target.Position + edgeOffset + Vector3.new(0,5,0)

        myRoot.CFrame = CFrame.lookAt(pos, target.Position)

        hasTeleported = true
    end
    pressKey(Enum.KeyCode.E)
end
                else
                    local target = getClosestPart(Workspace.Interactions.Food, "Ribs", "Food")
                   if target then
    if not hasTeleported then
        local randomOffset = Vector3.new(math.random(-6,6), 3, math.random(-6,6))
        local telePos = target.Position + randomOffset

        myRoot.CFrame = CFrame.lookAt(telePos, target.Position)
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)

        hasTeleported = true
    end
    pressKey(Enum.KeyCode.E)
end
                end
            elseif currentTask == "Sniff" then
                pressKey(Enum.KeyCode.H)
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

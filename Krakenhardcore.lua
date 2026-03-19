-- HARDCORE AUTO FARM (TOGGLE UI)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

_G.AutoFarm = false -- เริ่มปิดก่อน
_G.WaterWalk = true -- เปิด/ปิดได้

task.spawn(function()
    while task.wait(1) do
        if not _G.WaterWalk then continue end

        local interactions = Workspace:FindFirstChild("Interactions")
        if not interactions then continue end

        local lakes = interactions:FindFirstChild("Lakes")
        if not lakes then continue end

        for _,v in pairs(lakes:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
                v.Transparency = 0.3 -- ปรับได้ (0 = มองเห็น, 1 = ใส)
            end
        end
    end
end)

local currentTask = nil
local hasTeleported = false
local lastSniff = 0
local foodMode = "Water"
local switchTime = 0

-- 🔥 Safe Spots
local safeSpots = {
    CFrame.new(393,571,-5),
    CFrame.new(1997,441,-680),
    CFrame.new(2122,398,850),
    CFrame.new(456,509,1701),
    CFrame.new(-1477,360,2778),
    CFrame.new(-1991,617,1261),
    CFrame.new(-1666,659,-1132),
    CFrame.new(-1020,388,-2543),
    CFrame.new(-681,75,-3028)
}

local safeIndex = 1

-- ================= UI TOGGLE =================

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.X then
        _G.AutoFarm = not _G.AutoFarm
        print("AutoFarm:", _G.AutoFarm and "ON" or "OFF")
    end
end)

-- ================= FUNCTION =================

local function getChar()
    return LocalPlayer.Character
end

local function pressE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.2)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function pressH()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.H, false, game)
    task.wait(0.2)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.H, false, game)
end

local function getClosest(folder, name)
    if not folder then return nil end

    local root = getChar() and getChar():FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closest, dist = nil, math.huge

    for _,v in pairs(folder:GetDescendants()) do
        if v.Name == name and v:IsA("BasePart") then
            local d = (root.Position - v.Position).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end

    return closest
end

-- ================= LOOP =================

task.spawn(function()
    while task.wait(0.2) do
        if not _G.AutoFarm then continue end

        pcall(function()
            local char = getChar()
            if not char then return end

            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            -- 🔥 Auto Sniff
            if tick() - lastSniff > 20 then
                pressH()
                lastSniff = tick()
            end

            -- 🔥 HUD SAFE
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if not playerGui then return end

            local hudGui = playerGui:FindFirstChild("HUDGui")
            if not hudGui then return end

            local missions = hudGui:FindFirstChild("MissionsFrame")
            if not missions then return end

            local other = missions:FindFirstChild("Other")
            if not other then return end

            local qMud = other:FindFirstChild("ConcealScent")
            local qDrink = other:FindFirstChild("EatFoodDrinkWater")
            local qSniff = other:FindFirstChild("Sniff")

            -- reset
            if currentTask == "Mud" and (not qMud or not qMud.Visible) then currentTask = nil end
            if currentTask == "Drink" and (not qDrink or not qDrink.Visible) then currentTask = nil end
            if currentTask == "Sniff" and (not qSniff or not qSniff.Visible) then currentTask = nil end

            -- select task
            if not currentTask then
                if qMud and qMud.Visible then
                    currentTask = "Mud"
                elseif qDrink and qDrink.Visible then
                    currentTask = "Drink"
                elseif qSniff and qSniff.Visible then
                    currentTask = "Sniff"
                else
                    root.CFrame = safeSpots[safeIndex]
                    safeIndex = (safeIndex % #safeSpots) + 1
                    return
                end

                hasTeleported = false
                switchTime = tick()
            end

            -- ================= TASK =================

            if currentTask == "Mud" then
                local mud = getClosest(Workspace:FindFirstChild("Interactions") and Workspace.Interactions:FindFirstChild("Mud"), "Mud")
                if mud then
                    if not hasTeleported then
                        root.CFrame = mud.CFrame + Vector3.new(0,40,0)
                        hasTeleported = true
                    end
                    pressE()
                end

            elseif currentTask == "Drink" then
                if tick() - switchTime > 8 then
                    foodMode = (foodMode == "Water") and "Food" or "Water"
                    switchTime = tick()
                    hasTeleported = false
                end

                if foodMode == "Water" then
                    local lake = getClosest(Workspace:FindFirstChild("Interactions") and Workspace.Interactions:FindFirstChild("Lakes"), "SurfaceMask")
                    if lake then
                        if not hasTeleported then
                            root.CFrame = lake.CFrame + Vector3.new(0,40,0)
                            hasTeleported = true
                        end
                        pressE()
                    end
                else
                    local food = getClosest(Workspace:FindFirstChild("Interactions") and Workspace.Interactions:FindFirstChild("Food"), "Food")
                    if food then
                        if not hasTeleported then
                            root.CFrame = food.CFrame + Vector3.new(0,5,0)
                            hasTeleported = true
                        end
                        pressE()
                    end
                end

            elseif currentTask == "Sniff" then
                pressH()
            end

        end)
    end
end)

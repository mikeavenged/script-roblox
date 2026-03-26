-- // Settings (ตัวแปรควบคุม เปิด/ปิด)
_G.AutoFarm = false
_G.AutoCollect = false
_G.AutoEgg = false
_G.SelectedEgg = "Egg 1" -- ชื่อไข่เริ่มต้น

-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = ReplicatedStorage:WaitForChild("Network")

-- // Remotes (ระวัง: ชื่อเหล่านี้อาจเปลี่ยนตามการอัปเดตเกม)
local Remote_Egg = Network:WaitForChild("Eggs_RequestPurchase")
local Remote_Hit = Network:WaitForChild("Coins_Hit")
local Remote_Collect = Network:WaitForChild("Orbs_Collect")

-- // [3] ระบบสุ่มไข่อัตโนมัติ
task.spawn(function()
    while task.wait(0.5) do
        if not _G.AutoEgg then continue end
        
        -- โครงสร้าง Args ของการซื้อไข่
        local args = {
            [1] = _G.SelectedEgg, -- ชื่อไข่ที่เลือก
            [2] = 1 -- จำนวนที่สุ่ม (เช่น 1, 3, 8 ตามบัตรผ่านที่เรามี)
        }
        
        -- ใช้ InvokeServer เพราะต้องการรอการตอบกลับจากเซิร์ฟเวอร์
        Remote_Egg:InvokeServer(unpack(args))
    end
end)

-- // [1] ระบบเก็บของอัตโนมัติ (Auto Collect)
task.spawn(function()
    while task.wait(0.3) do
        if not _G.AutoCollect then continue end -- ถ้าปิดอยู่ให้ข้ามไป
        
        local collectibles = workspace:FindFirstChild("Collectibles")
        if collectibles then
            local orbIds = {}
            for _, orb in pairs(collectibles:GetChildren()) do
                table.insert(orbIds, orb.Name)
                orb:Destroy() -- ลบในเครื่องเราเพื่อลด Lag
            end
            
            if #orbIds > 0 then
                Remote_Collect:FireServer(orbIds)
            end
        end
    end
end)

-- // [2] ระบบตีเหรียญอัตโนมัติ (Auto Farm)
task.spawn(function()
    while task.wait(0.5) do
        if not _G.AutoFarm then continue end
        
        -- หาเหรียญที่อยู่ใกล้ตัวเราที่สุด หรือในโซนที่กำหนด
        local activeCoins = workspace:FindFirstChild("ActiveCoins", true)
        if activeCoins then
            for _, coin in pairs(activeCoins:GetChildren()) do
                if _G.AutoFarm == false then break end -- เช็คอีกรอบเพื่อความรวดเร็วในการหยุด
                
                Remote_Hit:FireServer({[1] = coin.Name})
                -- หมายเหตุ: PS99 มีระบบกันสแปม บางครั้งต้องใส่ task.wait(0.01) เล็กน้อย
            end
        end
    end
end)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "My PS99 Script",
   LoadingTitle = "Starting...",
   ConfigurationSaving = { Enabled = true, Folder = "PS99_Config" }
})

local Tab = Window:CreateTab("Main Farm", 4483362458) -- ไอคอน

Tab:CreateToggle({
   Name = "Auto Farm Coins",
   CurrentValue = false,
   Flag = "FarmCoinsToggle", -- ชื่อที่ใช้เก็บค่า (ห้ามซ้ำกัน)
   Callback = function(Value)
      _G.AutoFarm = Value
   end,
})

Tab:CreateToggle({
   Name = "Auto Collect Orbs",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoCollect = Value
   end,
})
local EggTab = Window:CreateTab("Auto Egg", 4483362458)

EggTab:CreateDropdown({
   Name = "Select Egg",
   Options = {"Egg 1", "Egg 2", "Egg 3", "Egg 100"},
   CurrentOption = "Egg 1",
   Flag = "SelectedEggDropdown", -- ชื่อที่ใช้เก็บค่า
   Callback = function(Option)
      _G.SelectedEgg = Option[1]
   end,
})

EggTab:CreateToggle({
   Name = "Auto Open Egg",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoEgg = Value
   end,
})

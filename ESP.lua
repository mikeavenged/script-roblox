local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- ค่าตั้งค่าสีและจำนวน Highlight
local CONFIG = {
    MaxHighlights = 30, -- จำกัดไว้ไม่เกิน 31 ตัวตามระบบ Roblox
    FillColor = Color3.fromRGB(255, 60, 140),    -- สีเรืองแสงด้านใน (ชมพูนีออน)
    FillTransparency = 0.5,
    OutlineColor = Color3.fromRGB(255, 255, 255), -- สีขอบเรืองแสง (ขาว)
    OutlineTransparency = 0,
}

local espData = {}

-- ฟังก์ชันสร้าง Highlight ติดตัวละคร
local function createESP(player)
    local char = player.Character
    if not char then return end
    
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hrp or not hum then return end

    -- ลบ Highlight เดิมหากมีค้างอยู่
    if char:FindFirstChild("ESPHighlight") then
        char.ESPHighlight:Destroy()
    end

    local hl = Instance.new("Highlight")
    hl.Name = "ESPHighlight"
    hl.Adornee = char
    hl.FillColor = CONFIG.FillColor
    hl.FillTransparency = CONFIG.FillTransparency
    hl.OutlineColor = CONFIG.OutlineColor
    hl.OutlineTransparency = CONFIG.OutlineTransparency
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = false -- ให้ RenderStepped เปิด-ปิดตามระยะห่าง
    hl.Parent = char

    espData[player] = {
        Character = char,
        HRP = hrp,
        Humanoid = hum,
        Highlight = hl
    }
end

local function removeESP(player)
    espData[player] = nil
end

local function setupPlayer(player)
    if player == localPlayer then return end
    
    if player.Character then
        task.spawn(createESP, player)
    end
    
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        createESP(player)
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    setupPlayer(p)
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(removeESP)

-- คำนวณระยะห่างและเปิด Highlight เฉพาะ 30 คนที่อยู่ใกล้ตัวเราที่สุด
RunService.RenderStepped:Connect(function()
    local myChar = localPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")

    local list = {}

    for player, data in pairs(espData) do
        if data.Character and data.Character.Parent and data.HRP and data.HRP.Parent and data.Humanoid and data.Humanoid.Health > 0 then
            local dist = myHRP and (myHRP.Position - data.HRP.Position).Magnitude or 999999
            table.insert(list, {Data = data, Distance = dist})
        else
            if data.Highlight then data.Highlight.Enabled = false end
        end
    end

    -- เรียงลำดับจากใกล้ไปไกล
    table.sort(list, function(a, b)
        return a.Distance < b.Distance
    end)

    -- เปิด Highlight เฉพาะตัวที่อยู่ใกล้ที่สุด
    for index, item in ipairs(list) do
        item.Data.Highlight.Enabled = (index <= CONFIG.MaxHighlights)
    end
end)

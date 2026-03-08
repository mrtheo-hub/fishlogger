-- Fish Logger PRO – Safe Version

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

-- ======================
-- WAIT UNTIL PLAYER READY
-- ======================
local player = Players.LocalPlayer
repeat task.wait() until player and player:FindFirstChild("Backpack") and player:FindFirstChild("PlayerGui")

-- ======================
-- CONFIG
-- ======================
local CONFIG = {
    WEBHOOK_URL = "YOUR_DISCORD_WEBHOOK", -- isi webhook kamu
    QUEUE_DELAY = 1, -- delay antar request
}

-- ======================
-- FISH DATABASE
-- ======================
local fishDB = {
    Salmon = {rarity="Common", color=Color3.fromRGB(180,180,180), icon="rbxassetid://12345678"},
    Tuna = {rarity="Uncommon", color=Color3.fromRGB(80,220,120), icon="rbxassetid://12345679"},
    Swordfish = {rarity="Rare", color=Color3.fromRGB(0,170,255), icon="rbxassetid://12345680"},
    GoldenTuna = {rarity="Legendary", color=Color3.fromRGB(255,200,0), icon="rbxassetid://12345681"},
    MythicShark = {rarity="Mythic", color=Color3.fromRGB(255,0,255), icon="rbxassetid://12345682"},
}

-- ======================
-- QUEUE SYSTEM
-- ======================
local WebhookQueue = {}
local IsProcessingQueue = false

local function processQueue()
    if IsProcessingQueue then return end
    IsProcessingQueue = true
    while #WebhookQueue > 0 do
        local data = table.remove(WebhookQueue,1)
        local req = (syn and syn.request) or request or http_request
        if req then
            pcall(function()
                req({
                    Url = CONFIG.WEBHOOK_URL,
                    Method = "POST",
                    Headers = {["Content-Type"]="application/json"},
                    Body = HttpService:JSONEncode(data)
                })
            end)
        end
        task.wait(CONFIG.QUEUE_DELAY)
    end
    IsProcessingQueue = false
end

-- ======================
-- GUI
-- ======================
local gui = Instance.new("ScreenGui")
gui.Name = "FishLoggerPRO"
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,380,0,260)
frame.Position = UDim2.new(0,30,0,30)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,36)
title.Text = "Fish Logger PRO"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-20,1,-50)
scroll.Position = UDim2.new(0,10,0,40)
scroll.BackgroundTransparency = 1
scroll.Parent = frame
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,4)
layout.Parent = scroll

-- ======================
-- ADD LOG ENTRY
-- ======================
local function addLog(name,rarity,weight,icon)
    local fish = fishDB[name] or {color=Color3.fromRGB(200,200,200)}
    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1,0,0,40)
    entry.BackgroundTransparency = 1
    entry.Parent = scroll

    local image = Instance.new("ImageLabel")
    image.Size = UDim2.new(0,30,0,30)
    image.Position = UDim2.new(0,0,0,5)
    image.Image = icon or ""
    image.BackgroundTransparency = 1
    image.Parent = entry

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,-40,1,0)
    text.Position = UDim2.new(0,40,0,0)
    text.BackgroundTransparency = 1
    text.Text = name.." ("..rarity..") "..weight.."kg"
    text.TextColor3 = fish.color
    text.Font = Enum.Font.Gotham
    text.TextSize = 14
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = entry

    scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end

-- ======================
-- LOG FISH FUNCTION
-- ======================
local function logFish(name,weight)
    local fish = fishDB[name]
    if not fish then return end
    local plr = Players.LocalPlayer -- ambil player di dalam function supaya nil error ga muncul
    addLog(name,fish.rarity,weight,fish.icon)

    local data = {
        username="Fish Logger PRO",
        embeds={{
            title=name,
            color=3447003,
            thumbnail={url=fish.icon},
            fields={
                {name="Player",value=plr.Name,inline=true},
                {name="Weight",value=tostring(weight).."kg",inline=true},
                {name="Rarity",value=fish.rarity,inline=true}
            },
            timestamp=DateTime.now():ToIsoDate()
        }}
    }

    table.insert(WebhookQueue,data)
    processQueue()
end

-- ======================
-- WATCH INVENTORY
-- ======================
local function watchInventory(container)
    container.ChildAdded:Connect(function(item)
        if fishDB[item.Name] then
            local weight = math.random(1,20)
            logFish(item.Name,weight)
        end
    end)
end

local backpack = player:WaitForChild("Backpack")
watchInventory(backpack)

-- ======================
-- GLOBAL ACCESS
-- ======================
_G.logFish = logFish

-- ======================
-- TEST LOGS
-- ======================
task.wait(2)
logFish("GoldenTuna",12)
logFish("MythicShark",20)

print("🎣 Fish Logger PRO Ready")

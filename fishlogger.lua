-- Fish Logger Advanced

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local webhook = "PASTE_WEBHOOK_DISCORD"

--========================
-- FISH DATABASE (sample)
--========================

local fishDB = {

Salmon = {rarity="Common", color=Color3.fromRGB(120,255,120), embed=65280, icon="🐟"},
Tuna = {rarity="Uncommon", color=Color3.fromRGB(120,200,255), embed=3447003, icon="🐠"},
Swordfish = {rarity="Rare", color=Color3.fromRGB(160,120,255), embed=10181046, icon="🐡"},
GoldenTuna = {rarity="Legendary", color=Color3.fromRGB(255,200,0), embed=16766720, icon="✨"},
MythicShark = {rarity="Mythic", color=Color3.fromRGB(255,0,200), embed=16711935, icon="🦈"}

}

--========================
-- GUI
--========================

local gui = Instance.new("ScreenGui")
gui.Name = "FishLogger"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,320,0,260)
frame.Position = UDim2.new(0,20,0,20)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.fromRGB(40,40,40)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(15,15,15))
}
gradient.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Text = "Fish Logger"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-10,1,-40)
scroll.Position = UDim2.new(0,5,0,35)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll

--========================
-- LOG GUI
--========================

local function addLog(text,color)

local label = Instance.new("TextLabel")

label.Size = UDim2.new(1,0,0,22)
label.Text = text
label.TextColor3 = color
label.BackgroundTransparency = 1
label.TextXAlignment = Enum.TextXAlignment.Left

label.Parent = scroll

scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)

end

--========================
-- DISCORD WEBHOOK
--========================

local lastSend = 0
local cooldown = 2

local function sendWebhook(name,weight)

if tick()-lastSend < cooldown then return end
lastSend = tick()

local fish = fishDB[name]
if not fish then return end

local data = {

username="Fish Logger",
avatar_url="https://i.imgur.com/3V9sH.png",

embeds={{

title = fish.icon.." "..name,
description = player.Name.." caught a fish!",
color = fish.embed,

thumbnail = {
url = "https://i.imgur.com/3V9sH.png"
},

fields = {

{name="Weight",value=weight.." kg",inline=true},
{name="Rarity",value=fish.rarity,inline=true}

},

footer = {
text = "Fish Logger"
},

timestamp = DateTime.now():ToIsoDate()

}}

}

local req = (syn and syn.request) or request or http_request

if req then
req({
Url=webhook,
Method="POST",
Headers={["Content-Type"]="application/json"},
Body=HttpService:JSONEncode(data)
})
end

end

--========================
-- MAIN LOGGER
--========================

local function logFish(name,weight)

local fish = fishDB[name]
if not fish then return end

addLog(
fish.icon.." "..name.." ("..fish.rarity..")",
fish.color
)

sendWebhook(name,weight)

end

--========================
-- INVENTORY WATCHER
--========================

local backpack = player:WaitForChild("Backpack")

backpack.ChildAdded:Connect(function(item)

if fishDB[item.Name] then

local weight = math.random(1,20)

logFish(item.Name,weight)

end

end)

-- test
task.wait(2)
logFish("GoldenTuna",12)--========================
-- GUI
--========================

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local blur = Instance.new("BlurEffect")
blur.Size = 8
blur.Parent = Lighting

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,320,0,240)
frame.Position = UDim2.new(0,20,0,20)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Text = "Fish Logger"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-10,1,-40)
scroll.Position = UDim2.new(0,5,0,35)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll

--========================
-- LOG FUNCTION
--========================

local function addLog(text,color)

local label = Instance.new("TextLabel")

label.Size = UDim2.new(1,0,0,20)
label.Text = text
label.TextColor3 = color
label.BackgroundTransparency = 1
label.TextXAlignment = Enum.TextXAlignment.Left

label.Parent = scroll

scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)

end

--========================
-- DISCORD WEBHOOK
--========================

local lastSend = 0
local cooldown = 3

local function sendWebhook(name,weight)

if tick()-lastSend < cooldown then return end
lastSend = tick()

local fish = fishDB[name]
if not fish then return end

local data = {

username="Fish Logger",
avatar_url="https://i.imgur.com/3V9sH.png",

embeds={{

title = fish.icon.." "..name,
color = fish.color,

fields = {

{name="Player",value=player.Name,inline=true},
{name="Weight",value=weight.."kg",inline=true},
{name="Rarity",value=fish.rarity,inline=true}

},

timestamp = DateTime.now():ToIsoDate()

}}

}

local req = (syn and syn.request) or request or http_request

if req then
req({
Url=webhook,
Method="POST",
Headers={["Content-Type"]="application/json"},
Body=HttpService:JSONEncode(data)
})
end

end

--========================
-- MAIN LOGGER
--========================

local function logFish(name,weight)

local fish = fishDB[name]
if not fish then return end

stats[fish.rarity]+=1

addLog(
fish.icon.." "..name.." ("..fish.rarity..")",
Color3.fromRGB(255,255,255)
)

sendWebhook(name,weight)

end

-- example test
task.wait(2)
logFish("GoldenTuna",12)

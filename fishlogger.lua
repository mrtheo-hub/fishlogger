-- Premium Fish Logger UI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

repeat task.wait() until player:FindFirstChild("PlayerGui")

--========================
-- FISH DATABASE
--========================

local fishDB = {

Salmon = {rarity="Common",color=Color3.fromRGB(180,180,180),icon="🐟"},
Tuna = {rarity="Uncommon",color=Color3.fromRGB(80,220,120),icon="🐠"},
Swordfish = {rarity="Rare",color=Color3.fromRGB(0,170,255),icon="🐡"},
GoldenTuna = {rarity="Legendary",color=Color3.fromRGB(255,200,0),icon="✨"},
MythicShark = {rarity="Mythic",color=Color3.fromRGB(255,0,255),icon="🦈"}

}

--========================
-- RARITY STATS
--========================

local stats = {

Common = 0,
Uncommon = 0,
Rare = 0,
Legendary = 0,
Mythic = 0

}

--========================
-- BLUR EFFECT
--========================

local blur = Instance.new("BlurEffect")
blur.Size = 10
blur.Parent = Lighting

--========================
-- GUI SETUP
--========================

local gui = Instance.new("ScreenGui")
gui.Name = "FishLogger"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- MAIN WINDOW

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,360,0,260)
frame.Position = UDim2.new(0,30,0,30)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,10)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70,70,70)
stroke.Thickness = 1.2
stroke.Parent = frame

-- TITLE

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,36)
title.Text = "Fish Logger"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = frame

-- SCROLL AREA

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-20,1,-70)
scroll.Position = UDim2.new(0,10,0,45)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,4)
layout.Parent = scroll

--========================
-- TOGGLE BUTTON
--========================

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,110,0,30)
toggle.Position = UDim2.new(1,-120,0,10)
toggle.Text = "Hide Logger"
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 14
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Parent = gui

Instance.new("UICorner",toggle)

local visible = true

toggle.MouseButton1Click:Connect(function()

visible = not visible

local goal = {}

if visible then
goal.Position = UDim2.new(0,30,0,30)
toggle.Text = "Hide Logger"
else
goal.Position = UDim2.new(-1,0,0,30)
toggle.Text = "Show Logger"
end

TweenService:Create(
frame,
TweenInfo.new(0.4,Enum.EasingStyle.Quint),
goal
):Play()

end)

--========================
-- NOTIFICATION SYSTEM
--========================

local function notify(text)

local notif = Instance.new("TextLabel")

notif.Size = UDim2.new(0,260,0,40)
notif.Position = UDim2.new(1,-280,1,-60)
notif.BackgroundColor3 = Color3.fromRGB(30,30,30)
notif.TextColor3 = Color3.new(1,1,1)
notif.Font = Enum.Font.GothamBold
notif.TextSize = 14
notif.Text = text
notif.Parent = gui

Instance.new("UICorner",notif)

TweenService:Create(
notif,
TweenInfo.new(0.3),
{Position = UDim2.new(1,-280,1,-110)}
):Play()

task.delay(3,function()

TweenService:Create(
notif,
TweenInfo.new(0.3),
{Position = UDim2.new(1,-280,1,-60)}
):Play()

task.wait(0.3)
notif:Destroy()

end)

end

--========================
-- ADD LOG
--========================

local function addLog(text,color)

local label = Instance.new("TextLabel")

label.Size = UDim2.new(1,0,0,20)
label.Text = text
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.TextColor3 = color
label.BackgroundTransparency = 1
label.TextXAlignment = Enum.TextXAlignment.Left

label.Parent = scroll

scroll.CanvasSize = UDim2.new(
0,
0,
0,
layout.AbsoluteContentSize.Y
)

end

--========================
-- MAIN LOGGER FUNCTION
--========================

function logFish(name,weight)

local fish = fishDB[name]

if not fish then
addLog("Unknown fish: "..name,Color3.fromRGB(200,200,200))
return
end

stats[fish.rarity] += 1

local text = fish.icon.." "..name.." ("..fish.rarity..") "..weight.."kg"

addLog(text,fish.color)

notify("Caught "..name.."!")

end

--========================
-- TEST DATA
--========================

task.wait(2)

logFish("Salmon",3)
logFish("GoldenTuna",12)
logFish("MythicShark",20)
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

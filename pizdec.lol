local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Settings = {
BoxOrbitRadius = 20,
BoxOrbitSpeed = 2,
NameOrbitRadius = 35,
NameOrbitSpeed = -1.5,
TextSize = 14
}
local ESPObjects = {}
local function getCharacterSize(model)
if not model then return Vector2.new(4, 6) end

local minY, maxY = math.huge, -math.huge
local minX, maxX = math.huge, -math.huge

for _, part in pairs(model:GetDescendants()) do
if part:IsA("BasePart") then
local pos = part.Position
local size = part.Size
minY = math.min(minY, pos.Y - size.Y/2)
maxY = math.max(maxY, pos.Y + size.Y/2)
minX = math.min(minX, pos.X - size.X/2)
maxX = math.max(maxX, pos.X + size.X/2)
end
end

return Vector2.new(maxX - minX + 2, maxY - minY + 2)
end
local function getRainbowColor(offset, speed)
local tick = tick() * speed + offset
return Color3.fromHSV(tick % 1, 1, 1)
end
local function getOppositeColor(color)
return Color3.new(1 - color.R, 1 - color.G, 1 - color.B)
end
local function createESPForPlayer(player)
if player == LocalPlayer then return end

local espBox = Drawing.new("Square")
espBox.Thickness = 2
espBox.Filled = false
espBox.Visible = false

local espName = Drawing.new("Text")
espName.Text = "pizdec.lua"
espName.Size = Settings.TextSize
espName.Center = true
espName.Outline = true
espName.Visible = false

ESPObjects[player] = {
box = espBox,
name = espName,
boxAngle = math.random() * math.pi * 2,
nameAngle = math.random() * math.pi * 2,
colorOffset = math.random() * 10, -- Random color offset
colorSpeed = 0.5 + math.random() -- Random color speed
}
end
local function updateESP()
for player, objects in pairs(ESPObjects) do
if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
objects.box.Visible = false
objects.name.Visible = false
continue
end

local rootPos = player.Character.HumanoidRootPart.Position
local screenPos, onScreen = Camera:WorldToViewportPoint(rootPos)

if not onScreen then
objects.box.Visible = false
objects.name.Visible = false
continue
end

-- Update sizes and colors with unique offsets
local boxSize = getCharacterSize(player.Character)
local boxColor = getRainbowColor(objects.colorOffset, objects.colorSpeed)
local nameColor = getOppositeColor(boxColor)

objects.boxAngle = objects.boxAngle + Settings.BoxOrbitSpeed * RunService.RenderStepped:Wait()
objects.nameAngle = objects.nameAngle + Settings.NameOrbitSpeed * RunService.RenderStepped:Wait()

local boxOffset = Vector2.new(
math.cos(objects.boxAngle) * Settings.BoxOrbitRadius,
math.sin(objects.boxAngle) * Settings.BoxOrbitRadius
)

local nameOffset = Vector2.new(
math.cos(objects.nameAngle) * Settings.NameOrbitRadius,
math.sin(objects.nameAngle) * Settings.NameOrbitRadius
)

objects.box.Size = Vector2.new(boxSize.X * 10, boxSize.Y * 10)
objects.box.Position = Vector2.new(screenPos.X + boxOffset.X - objects.box.Size.X/2,
screenPos.Y + boxOffset.Y - objects.box.Size.Y/2)
objects.box.Color = boxColor
objects.box.Visible = true

objects.name.Position = Vector2.new(screenPos.X + nameOffset.X,
screenPos.Y + nameOffset.Y)
objects.name.Color = nameColor
objects.name.Visible = true
end
end
for _, player in ipairs(Players:GetPlayers()) do
createESPForPlayer(player)
end
Players.PlayerAdded:Connect(createESPForPlayer)
Players.PlayerRemoving:Connect(function(player)
if ESPObjects[player] then
ESPObjects[player].box:Remove()
ESPObjects[player].name:Remove()
ESPObjects[player] = nil
end
end)
RunService.RenderStepped:Connect(updateESP)

local workspace = game:GetService("Workspace")
local parts = {}  --A table to hold the parts we'll modify

--Pre-filter parts to improve performance
for _, part in pairs(workspace:GetDescendants()) do
    if part:IsA("BasePart") then
        table.insert(parts, part)
    end
end


local colorList = {
    Color3.fromRGB(255, 0, 0),     -- Red
    Color3.fromRGB(0, 255, 0),     -- Green
    Color3.fromRGB(0, 0, 255),     -- Blue
    Color3.fromRGB(255, 255, 0),   -- Yellow
    Color3.fromRGB(255, 0, 255),   -- Magenta
    Color3.fromRGB(0, 255, 255),   -- Cyan
    Color3.fromRGB(255, 165, 0),   -- Orange
    Color3.fromRGB(128, 0, 128),   -- Purple
    Color3.fromRGB(255, 255, 255), -- White
    Color3.fromRGB(0, 0, 0)       -- Black
}

local currentIndex = 1

while true do
    local newColor = colorList[currentIndex]
    for _, part in pairs(parts) do
        part.Color = newColor  --Directly setting the Color property
    end
    currentIndex = currentIndex + 1
    if currentIndex > #colorList then
        currentIndex = 1
    end
    wait(0.1)  -- Adjust the wait time to control the speed of the color change
end

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local rainbowColors = {
    Color3.fromRGB(255, 0, 0),     -- Red
    Color3.fromRGB(255, 165, 0),   -- Orange
    Color3.fromRGB(255, 255, 0),   -- Yellow
    Color3.fromRGB(0, 255, 0),     -- Green
    Color3.fromRGB(0, 0, 255),     -- Blue
    Color3.fromRGB(75, 0, 130),    -- Indigo (approximation)
    Color3.fromRGB(148, 0, 211)    -- Violet
}
local currentIndex = 1

local function updateChams(character)
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency ~= 1 then  --Consider only non-transparent parts
                part.Color = rainbowColors[currentIndex]
            end
        end
    end
end

local function onCharacterAdded(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("BasePart") and child.Transparency ~= 1 then
          child.Color = rainbowColors[currentIndex]
        end
    end)

    updateChams(character)
end


Players.PlayerAdded:Connect(function(player)
    if player ~= localPlayer then  -- Ignore the local player
        player.CharacterAdded:Connect(onCharacterAdded)
    end
end)


local function updateRainbow()
    currentIndex = currentIndex + 1
    if currentIndex > #rainbowColors then
        currentIndex = 1
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            updateChams(player.Character)
        end
    end

end

game:GetService("RunService").Heartbeat:Connect(updateRainbow)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local runService = game:GetService("RunService")

local rainbowColors = {
    Color3.fromRGB(255, 0, 0),     -- Red
    Color3.fromRGB(255, 165, 0),   -- Orange
    Color3.fromRGB(255, 255, 0),   -- Yellow
    Color3.fromRGB(0, 255, 0),     -- Green
    Color3.fromRGB(0, 0, 255),     -- Blue
    Color3.fromRGB(75, 0, 130),    -- Indigo (approximation)
    Color3.fromRGB(148, 0, 211)    -- Violet
}

local currentIndex = 1

local function makeRainbowForceField(part)
    if part and part:IsA("BasePart") then
        part.Material = Enum.Material.ForceField
        part.Transparency = 0.5
        part.Color = rainbowColors[currentIndex]
    end
end

local function applyRainbowForceField(character)
    if character then
        for _, part in pairs(character:GetChildren()) do
            makeRainbowForceField(part)
        end
        character.ChildAdded:Connect(function(child)
            makeRainbowForceField(child)
        end)
    end
end

localPlayer.CharacterAdded:Connect(applyRainbowForceField)

local function updateRainbow()
    currentIndex = currentIndex + 1
    if currentIndex > #rainbowColors then
        currentIndex = 1
    end
    if localPlayer.Character then
      for _, part in pairs(localPlayer.Character:GetChildren()) do
        if part:IsA("BasePart") then
          part.Color = rainbowColors[currentIndex]
        end
      end
    end
end

runService.Heartbeat:Connect(updateRainbow)

local workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local runService = game:GetService("RunService")

local rainbowColors = {
    Color3.fromRGB(255, 0, 0),     -- Red
    Color3.fromRGB(255, 165, 0),   -- Orange
    Color3.fromRGB(255, 255, 0),   -- Yellow
    Color3.fromRGB(0, 255, 0),     -- Green
    Color3.fromRGB(0, 0, 255),     -- Blue
    Color3.fromRGB(75, 0, 130),    -- Indigo
    Color3.fromRGB(148, 0, 211)    -- Violet
}

local currentIndex = 1
local parts = {}

-- Collect all BaseParts except those belonging to players' characters
for _, obj in pairs(workspace:GetDescendants()) do
    local isPlayerCharacterPart = false
    for _, player in pairs(Players:GetPlayers()) do
      if obj.Parent and obj.Parent.Parent and obj.Parent.Parent == player.Character then
        isPlayerCharacterPart = true
        break
      end
    end
    if obj:IsA("BasePart") and not isPlayerCharacterPart then
        table.insert(parts, obj)
        obj.Material = Enum.Material.ForceField
    end
end


local function updateRainbow()
    currentIndex = currentIndex % #rainbowColors + 1
    for _, part in ipairs(parts) do
        part.Color = rainbowColors[currentIndex]
        part.Transparency = 0.5 -- Adjust transparency if needed
    end
end

-- Make players' characters neon
local function makePlayersNeon(character)
  if character then
    for _, part in pairs(character:GetChildren()) do
      if part:IsA("BasePart") then
          part.Material = Enum.Material.Neon
      end
    end
    character.ChildAdded:Connect(function(child)
        if child:IsA("BasePart") then
            child.Material = Enum.Material.Neon
        end
    end)
  end
end

Players.PlayerAdded:Connect(function(player)
  player.CharacterAdded:Connect(makePlayersNeon)
end)


runService.Heartbeat:Connect(updateRainbow)

local workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")

local rainbowColors = {
    Color3.fromRGB(255, 0, 0),     -- Red
    Color3.fromRGB(255, 165, 0),   -- Orange
    Color3.fromRGB(255, 255, 0),   -- Yellow
    Color3.fromRGB(0, 255, 0),     -- Green
    Color3.fromRGB(0, 0, 255),     -- Blue
    Color3.fromRGB(75, 0, 130),    -- Indigo (approximation)
    Color3.fromRGB(148, 0, 211)    -- Violet
}

local currentIndex = 1
local parts = {}

--Efficiently collect all BaseParts once at the start
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        table.insert(parts, obj)
        obj.Material = Enum.Material.Neon
    end
end

local function updateRainbow()
    currentIndex = currentIndex + 1
    if currentIndex > #rainbowColors then
        currentIndex = 1
    end
    for _, part in ipairs(parts) do
        part.Color = rainbowColors[currentIndex]
    end
end

runService.Heartbeat:Connect(updateRainbow)

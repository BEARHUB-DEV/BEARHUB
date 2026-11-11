local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/aboutsibah113/Library/refs/heads/main/Sibah2xZcu_Library.lua?v=2"
))()

local Window = Library:CreateWindow({
    Title          = "Bear Hub",
    Description    = "v2.0 Updated",
    isVerified     = true,
    OpenCloseImage = "92530824918913",
    Icon           = "rbxthumb://type=Asset&id=130008176530837&w=420&h=420",
    Keybind        = Enum.KeyCode.RightControl,
    SizeUi         = UDim2.fromOffset(480, 300),
    Tags           = { "Beta", "Free" },
})

Window:SetColor(Color3.fromRGB(88, 166, 255))

local DisableNotify = false
local oldNotify = Window.Notify
Window.Notify = function(self, text, duration)
    if not DisableNotify then
        oldNotify(self, text, duration)
    end
end

Window:Notify("Bear Hub loaded successfully!", 4)

local MainTab = Window:CreateTab({ "Main", "" })
local MainSection = MainTab:AddSection("Settings", true)

MainSection:AddToggle({
    Title    = "Disable Notify",
    Content  = "Disables all custom script notifications",
    Default  = false,
    Callback = function(Value)
        DisableNotify = Value
        print("Disable Notify:", Value)
    end,
})

local EspTab = Window:CreateTab({ "ESP", "" })
local EspSection = EspTab:AddSection("ESP Features", true)

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local opahEspEnabled = false
local opahEspStorage = {}
local TARGET_NAME = "Opah"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BearHub_ESP_Gui"
ScreenGui.ResetOnSpawn = false
local parentGui = (syn and syn.protect_gui) and CoreGui or ScreenGui
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = CoreGui

local function createOpahESP(instance)
    if instance.Name ~= TARGET_NAME then return end
    if opahEspStorage[instance] then return end

    local primaryPart = instance:IsA("Model") and (instance.PrimaryPart or instance:FindFirstChildWhichIsA("BasePart")) or (instance:IsA("BasePart") and instance)
    if not primaryPart then return end

    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "OpahESP_Tag"
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.new(0, 200, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
    BillboardGui.Adornee = primaryPart
    BillboardGui.Enabled = opahEspEnabled
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = TARGET_NAME
    TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    TextLabel.TextSize = 16
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextStrokeTransparency = 0 
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.Parent = BillboardGui

    BillboardGui.Parent = ScreenGui
    opahEspStorage[instance] = BillboardGui
end

local function removeOpahESP(instance)
    if opahEspStorage[instance] then
        opahEspStorage[instance]:Destroy()
        opahEspStorage[instance] = nil
    end
end

for _, desc in ipairs(Workspace:GetDescendants()) do
    createOpahESP(desc)
end

Workspace.DescendantAdded:Connect(createOpahESP)
Workspace.DescendantRemoving:Connect(removeOpahESP)

EspSection:AddToggle({
    Title    = "Enable ESP Opah",
    Content  = "Highlights Opah",
    Default  = false,
    Callback = function(Value)
        opahEspEnabled = Value
        for _, billboard in pairs(opahEspStorage) do
            if billboard and billboard:IsA("BillboardGui") then
                billboard.Enabled = opahEspEnabled
            end
        end
    end,
})

local targetFolder = Workspace:WaitForChild("PuzzleItems", 5)
local keyEspEnabled = false
local keyEspStorage = {}

local function createKeyESP(model)
    if not model:IsA("Model") and not model:IsA("BasePart") then return end
    if keyEspStorage[model] then return end

    local primaryPart = model:IsA("Model") and (model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")) or model
    if not primaryPart then return end

    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "PuzzleESP"
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.new(0, 200, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 2, 0) 
    BillboardGui.Adornee = primaryPart
    BillboardGui.Enabled = keyEspEnabled
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = model.Name
    TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0) 
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextStrokeTransparency = 0 
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.Parent = BillboardGui

    BillboardGui.Parent = ScreenGui
    keyEspStorage[model] = BillboardGui
end

local function removeKeyESP(model)
    if keyEspStorage[model] then
        keyEspStorage[model]:Destroy()
        keyEspStorage[model] = nil
    end
end

if targetFolder then
    for _, item in ipairs(targetFolder:GetChildren()) do
        createKeyESP(item)
    end
    targetFolder.ChildAdded:Connect(createKeyESP)
    targetFolder.ChildRemoved:Connect(removeKeyESP)
end

EspSection:AddToggle({
    Title    = "Enable ESP Key & Code",
    Content  = "Highlights puzzle items",
    Default  = false,
    Callback = function(Value)
        keyEspEnabled = Value
        for _, billboard in pairs(keyEspStorage) do
            if billboard and billboard:IsA("BillboardGui") then
                billboard.Enabled = keyEspEnabled
            end
        end
    end,
})

local SpeedTab = Window:CreateTab({ "Speed", "" })
local SpeedSection = SpeedTab:AddSection("Stamina Settings", true)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local sprintConfig = nil
local originalDrain = 0
local infStaminaEnabled = false

pcall(function()
    local sprintSystem = ReplicatedStorage:WaitForChild("SprintSystem", 5)
    if sprintSystem then
        local configModule = sprintSystem:WaitForChild("SprintConfig", 5)
        if configModule then
            sprintConfig = require(configModule)
            originalDrain = sprintConfig.DrainPerSecond or 0
        end
    end
end)

local function updateStaminaState()
    if sprintConfig then
        if infStaminaEnabled then
            sprintConfig.DrainPerSecond = 0
        else
            sprintConfig.DrainPerSecond = originalDrain
        end
    end
end

SpeedSection:AddToggle({
    Title    = "Infinite Stamina",
    Content  = "Keeps stamina full",
    Default  = false,
    Callback = function(Value)
        infStaminaEnabled = Value
        updateStaminaState()
    end,
})

RunService.Heartbeat:Connect(function()
    if infStaminaEnabled and sprintConfig then
        local character = localPlayer.Character
        if character then
            character:SetAttribute("Stamina", sprintConfig.MaxStamina or 100)
        end
    end
end)

local PlayerTab = Window:CreateTab({ "Player", "" })
local PlayerSection = PlayerTab:AddSection("Player Settings", true)

local invis_on = false

local function makeTransparent(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = invis_on and 0.5 or 0
        end
    end
end

local function toggleInvisibility()
    invis_on = not invis_on
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if invis_on then
        local savedpos = character.HumanoidRootPart.CFrame
        task.wait()
        character:MoveTo(Vector3.new(-25.95, 84, 3537.55))
        task.wait(0.15)

        local Seat = Instance.new('Seat', game.Workspace)
        Seat.Anchored = false
        Seat.CanCollide = false
        Seat.Name = 'invischair'
        Seat.Transparency = 1
        Seat.Position = Vector3.new(-25.95, 84, 3537.55)

        local Weld = Instance.new("Weld", Seat)
        Weld.Part0 = Seat
        Weld.Part1 = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        task.wait()

        Seat.CFrame = savedpos
    else
        local invisChair = workspace:FindFirstChild('invischair')
        if invisChair then
            invisChair:Destroy()
        end
    end

    makeTransparent(character)
end

PlayerSection:AddToggle({
    Title    = "Toggle Invisible",
    Content  = "kamu harus diam ditempat yang aman dan nyalakan ini, dan kamu bisa berkeliling tanpa ketahuan opah",
    Default  = false,
    Callback = function(Value)
        if invis_on ~= Value then
            toggleInvisibility()
        end
    end,
})

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    if invis_on then
        makeTransparent(character)
    end
end)

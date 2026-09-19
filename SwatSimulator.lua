local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/aboutsibah113/Library/refs/heads/main/Sibah2xZcu_Library.lua?v=2"
))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Window = Library:CreateWindow({
    Title          = "Bear Hub",
    Description    = "v2.1 Pro Optimized",
    isVerified     = true,
    OpenCloseImage = "92530824918913",
    Icon           = "rbxthumb://type=Asset&id=139365761909290&w=420&h=420",
    Keybind        = Enum.KeyCode.RightControl,
    SizeUi         = UDim2.fromOffset(500, 340),
    Tags           = { "Beta", "OP" },
})

Window:SetColor(Color3.fromRGB(88, 166, 255))

local DisableNotify = false
local oldNotify = Window.Notify
Window.Notify = function(self, text, duration)
    if not DisableNotify then
        oldNotify(self, text, duration)
    end
end

Window:Notify("Bear Hub v2.1 Loaded!", 4)

local MainTab       = Window:CreateTab({ "Main", "" })
local EspTab        = Window:CreateTab({ "ESP", "" })
local HitboxTab     = Window:CreateTab({ "Hitbox", "" })
local CombatTab     = Window:CreateTab({ "Combat", "" })
local ProximityTab  = Window:CreateTab({ "Proximity", "" })
local MiscTab       = Window:CreateTab({ "Misc", "" })
local ExtrasTab     = Window:CreateTab({ "Extras", "" })
local InfoTab       = Window:CreateTab({ "Info", "" })

local MainSection       = MainTab:AddSection("Settings", true)
local EspSection        = EspTab:AddSection("ESP Settings", true)
local HitboxSection     = HitboxTab:AddSection("Hitbox Settings", true)
local CombatSection     = CombatTab:AddSection("Combat Settings", true)
local ProximitySection  = ProximityTab:AddSection("Proximity Settings", true)
local MiscSection       = MiscTab:AddSection("Misc Settings", true)
local VisualsSection    = ExtrasTab:AddSection("Visuals")
local InfoSection       = InfoTab:AddSection("About")

MainSection:AddToggle({
    Title    = "Disable Notify",
    Content  = "Disables all custom script notifications",
    Default  = false,
    Callback = function(Value)
        DisableNotify = Value
    end,
})

local Config = {
    EspAll = false,
    EspHostile = false,
    EspCivilian = false,
    EspDistance = 150,
    ShowName = true,
    ShowHealth = true,
    ShowDistance = true,
    ShowTracers = false,
    ShowWeapon = true,
    
    HitboxEnabled = false,
    HitboxSize = 2,
    HitboxHostileOnly = true,
    
    InfiniteJump = false,
    NoClip = false,
    AntiAfk = false,
    
    InstantPrompt = false,
    AutoPrompt = false,
    PromptDistance = 25,
}

EspSection:AddToggle({
    Title = "Toggle ESP", Content = "ESP for all NPC models", Default = false,
    Callback = function(v) Config.EspAll = v end
})
EspSection:AddToggle({
    Title = "Toggle ESP Hostile", Content = "ESP for Hostile NPCs (Glock/AK47 tool)", Default = false,
    Callback = function(v) Config.EspHostile = v end
})
EspSection:AddToggle({
    Title = "Toggle ESP Civilians", Content = "ESP for Civilian NPCs (No gun tool)", Default = false,
    Callback = function(v) Config.EspCivilian = v end
})
EspSection:AddSlider({
    Title = "ESP Max Distance", Content = "Max render distance for ESP", Increment = 10, Min = 20, Max = 500, Default = 150,
    Callback = function(v) Config.EspDistance = v end
})
EspSection:AddToggle({
    Title = "Show Health & Weapon", Content = "Display health bar and weapon info", Default = true,
    Callback = function(v) Config.ShowHealth = v; Config.ShowWeapon = v end
})
EspSection:AddToggle({
    Title = "Tracers", Content = "Draw line to NPCs", Default = false,
    Callback = function(v) Config.ShowTracers = v end
})

HitboxSection:AddToggle({
    Title = "Toggle Hitbox", Content = "Expand NPC Hitboxes", Default = false,
    Callback = function(v) Config.HitboxEnabled = v end
})
HitboxSection:AddToggle({
    Title = "Hostile Only Hitbox", Content = "Only expand hitboxes for armed NPCs", Default = true,
    Callback = function(v) Config.HitboxHostileOnly = v end
})
HitboxSection:AddSlider({
    Title = "Hitbox Size", Content = "Max 50", Increment = 1, Min = 2, Max = 50, Default = 2,
    Callback = function(v) Config.HitboxSize = v end
})

CombatSection:AddToggle({
    Title = "Infinite Jump", Content = "Jump infinitely in the air", Default = false,
    Callback = function(v) Config.InfiniteJump = v end
})
CombatSection:AddToggle({
    Title = "NoClip", Content = "Walk through walls", Default = false,
    Callback = function(v) Config.NoClip = v end
})

ProximitySection:AddToggle({
    Title = "Instant Prompt", Content = "Set HoldDuration to 0 instantly", Default = false,
    Callback = function(v) Config.InstantPrompt = v end
})
ProximitySection:AddToggle({
    Title = "Auto Trigger Prompt", Content = "Automatically trigger prompts in range", Default = false,
    Callback = function(v) Config.AutoPrompt = v end
})
ProximitySection:AddSlider({
    Title = "Prompt Max Distance", Content = "Radius for prompt triggers", Increment = 1, Min = 5, Max = 100, Default = 25,
    Callback = function(v) Config.PromptDistance = v end
})

MiscSection:AddToggle({
    Title = "Anti-AFK", Content = "Prevents getting kicked for inactivity", Default = false,
    Callback = function(v) Config.AntiAfk = v end
})
MiscSection:AddButton({
    Title = "Rejoin Server", Content = "Rejoin the current server", Style = "Danger",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})
MiscSection:AddButton({
    Title = "Server Hop", Content = "Hop to a different server", Style = "Danger",
    Callback = function()
        Window:Notify("Searching for another server...", 2)
    end,
})

VisualsSection:AddColorPicker({
    "Accent Color", Color3.fromRGB(88, 166, 255),
    function(Color) Window:SetColor(Color) end
})

InfoSection:AddReadMe({"Bear Hub v2.1", "Optimized event-driven architecture with clean performance.", "Accordion", Open = true})

local trackedNPCs = {}
local cachedPrompts = {}

local function CheckWeapon(npcModel)
    for _, child in ipairs(npcModel:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if n:find("glock") or n:find("ak47") then
                return true, child.Name
            end
        end
    end
    return false, nil
end

local function RegisterNPC(model)
    if model:IsA("Model") and model.Name:lower() == "npc" and not trackedNPCs[model] then
        local hasGun, weaponName = CheckWeapon(model)
        
        local highlight = Instance.new("Highlight")
        highlight.Parent = model
        highlight.Enabled = false
        
        local billboard = Instance.new("BillboardGui")
        billboard.Parent = model
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Enabled = false
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Parent = billboard
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextSize = 13
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextWrapped = true
        
        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Thickness = 1.5
        
        local data = {
            Model = model,
            Highlight = highlight,
            Billboard = billboard,
            TextLabel = textLabel,
            Tracer = tracer,
            IsHostile = hasGun,
            WeaponName = weaponName,
            ChildAddedConn = nil,
            ChildRemovedConn = nil
        }
        
        data.ChildAddedConn = model.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                local h, w = CheckWeapon(model)
                data.IsHostile = h
                data.WeaponName = w
            end
        end)
        
        data.ChildRemovedConn = model.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then
                local h, w = CheckWeapon(model)
                data.IsHostile = h
                data.WeaponName = w
            end
        end)
        
        trackedNPCs[model] = data
    end
end

local function UnregisterNPC(model)
    local data = trackedNPCs[model]
    if data then
        if data.ChildAddedConn then data.ChildAddedConn:Disconnect() end
        if data.ChildRemovedConn then data.ChildRemovedConn:Disconnect() end
        if data.Highlight then data.Highlight:Destroy() end
        if data.Billboard then data.Billboard:Destroy() end
        if data.Tracer then data.Tracer:Remove() end
        trackedNPCs[model] = nil
    end
end

-- Init existing NPCs and Prompts
for _, obj in ipairs(Workspace:GetDescendants()) do
    RegisterNPC(obj)
    if obj:IsA("ProximityPrompt") then
        cachedPrompts[obj] = obj.Parent
    end
end

Workspace.DescendantAdded:Connect(function(obj)
    RegisterNPC(obj)
    if obj:IsA("ProximityPrompt") then
        cachedPrompts[obj] = obj.Parent
    end
end)

Workspace.DescendantRemoving:Connect(function(obj)
    UnregisterNPC(obj)
    if obj:IsA("ProximityPrompt") then
        cachedPrompts[obj] = nil
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

LocalPlayer.Idled:Connect(function()
    if Config.AntiAfk then
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end
end)

-- Throttle loop untuk update state berat (ESP text, Hitbox size, Proximity check) agar hemat CPU
task.spawn(function()
    while true do
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        
        if Config.InstantPrompt or Config.AutoPrompt then
            for prompt, parentPart in pairs(cachedPrompts) do
                if prompt and prompt.Parent then
                    if Config.InstantPrompt then
                        prompt.HoldDuration = 0
                    end
                    if Config.AutoPrompt and rootPart and parentPart and parentPart:IsA("BasePart") then
                        if (parentPart.Position - rootPart.Position).Magnitude <= Config.PromptDistance then
                            fireproximityprompt(prompt)
                        end
                    end
                else
                    cachedPrompts[prompt] = nil
                end
            end
        end

        for model, data in pairs(trackedNPCs) do
            if model and model.Parent then
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
                
                if humanoid and hrp and humanoid.Health > 0 then
                    local dist = rootPart and (hrp.Position - rootPart.Position).Magnitude or 0
                    local isHostile = data.IsHostile
                    local isCivilian = not isHostile
                    
                    local showEsp = (dist <= Config.EspDistance) and (
                        Config.EspAll or 
                        (Config.EspHostile and isHostile) or 
                        (Config.EspCivilian and isCivilian)
                    )
                    
                    if showEsp then
                        local color = isHostile and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 255, 50)
                        data.Highlight.FillColor = color
                        data.Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        data.Highlight.Enabled = true
                        
                        local infoText = "NPC [" .. math.floor(dist) .. "m]\nHP: " .. math.floor(humanoid.Health)
                        if isHostile and data.WeaponName then
                            infoText = infoText .. " | " .. data.WeaponName
                        end
                        data.TextLabel.Text = infoText
                        data.Billboard.Enabled = true
                    else
                        data.Highlight.Enabled = false
                        data.Billboard.Enabled = false
                    end
                    
                    if Config.HitboxEnabled then
                        if (not Config.HitboxHostileOnly) or isHostile then
                            hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                            hrp.Transparency = 0.6
                            hrp.CanCollide = false
                        else
                            hrp.Size = Vector3.new(2, 2, 1)
                            hrp.Transparency = 1
                        end
                    else
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                    end
                else
                    data.Highlight.Enabled = false
                    data.Billboard.Enabled = false
                end
            else
                UnregisterNPC(model)
            end
        end
        
        task.wait(0.2)
    end
end)

-- RenderStepped khusus untuk visual ringan yang butuh fps tinggi (NoClip & Tracers)
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    
    if Config.NoClip and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    for _, data in pairs(trackedNPCs) do
        if data.Billboard.Enabled and Config.ShowTracers then
            local hrp = data.Model:FindFirstChild("HumanoidRootPart") or data.Model:FindFirstChild("Torso")
            if hrp then
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    data.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    data.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    data.Tracer.Color = data.Highlight.FillColor
                    data.Tracer.Visible = true
                else
                    data.Tracer.Visible = false
                end
            else
                data.Tracer.Visible = false
            end
        else
            data.Tracer.Visible = false
        end
    end
end)

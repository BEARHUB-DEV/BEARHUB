-- yang nyolong ga punya kelamin & keturunan
local WindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
))()

local Window = WindUI:CreateWindow({
    Title = "Prison Escape V2",
    Icon = "rbxassetid://139365761909290",
    Theme = "Dark",
    Author = "Bear Hub",
    Folder = "PrisonEscapeV2",
    Transparent = true,
    KeySystem = false,
})

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

WindUI:Notify({
    Title = "Prison Escape V2",
    Content = "Script successfully loaded!",
    Duration = 4,
})

local MainTab = Window:Tab({ Title = "Main", Icon = "settings" })
local TeleportsTab = Window:Tab({ Title = "Teleports", Icon = "map-pin" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local VisualTab = Window:Tab({ Title = "Visual", Icon = "eye" })
local InteractTab = Window:Tab({ Title = "Interact", Icon = "hand" })
local AimbotTab = Window:Tab({ Title = "Aimbot", Icon = "crosshair" })
local UtilityTab = Window:Tab({ Title = "Utility", Icon = "cpu" })
local AutoFarmTab = Window:Tab({ Title = "Auto Farm", Icon = "dollar-sign" })

local DisableNotify = false
MainTab:Toggle({
    Title = "Disable Notify",
    Description = "Disables all custom script notifications",
    Default = false,
    Callback = function(Value)
        DisableNotify = Value
    end,
})

local function teleportTo(targetName)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local targetObj = Workspace:FindFirstChild(targetName, true)
        if targetObj then
            local pos
            if targetObj:IsA("Model") then
                pos = targetObj:GetPivot().Position
            elseif targetObj:IsA("Folder") and targetObj.PrimaryPart then
                pos = targetObj.PrimaryPart.Position
            elseif targetObj:IsA("BasePart") then
                pos = targetObj.Position
            end
            
            if pos then
                character:PivotTo(CFrame.new(pos + Vector3.new(0, 3, 0)))
                if not DisableNotify then
                    WindUI:Notify({ Title = "Teleport", Content = "Teleported to " .. targetName, Duration = 2 })
                end
            else
                if not DisableNotify then
                    WindUI:Notify({ Title = "Teleport Error", Content = "Could not determine position for " .. targetName, Duration = 3 })
                end
            end
        else
            if not DisableNotify then
                WindUI:Notify({ Title = "Teleport Error", Content = targetName .. " not found in workspace!", Duration = 3 })
            end
        end
    end
end

TeleportsTab:Button({
    Title = "TP to Bank",
    Description = "Teleports to the bank folder",
    Callback = function()
        teleportTo("Armchair")
    end,
})

TeleportsTab:Button({
    Title = "TP to Charging Station",
    Description = "Teleports to the charging station",
    Callback = function()
        teleportTo("Charger")
    end,
})

TeleportsTab:Button({
    Title = "TP to Gas Station",
    Description = "Teleports to the gas station",
    Callback = function()
        teleportTo("Bush1")
    end,
})

TeleportsTab:Button({
    Title = "TP to House",
    Description = "Teleports to House",
    Callback = function()
        teleportTo("House_04")
    end,
})

local InfiniteJumpEnabled = false
local WalkSpeedEnabled = false
local WalkSpeedVal = 16
local JumpPowerEnabled = false
local JumpPowerVal = 50
local NoClipEnabled = false
local AntiAFKEnabled = false
local FlyEnabled = false
local FlySpeed = 50
local IsFrozen = false
local AntiFallActive = false

local DamageEvent = ReplicatedStorage:WaitForChild("Events", 5) and ReplicatedStorage.Events:WaitForChild("Damage", 5)
if DamageEvent then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if AntiFallActive and self == DamageEvent and method == "FireServer" and args[1] == 12.082430590753969 then
            return 
        end
        return oldNamecall(self, ...)
    end)
end

PlayerTab:Toggle({
    Title = "Anti Fall Damage",
    Description = "Blocks the fall damage remote call automatically",
    Default = false,
    Callback = function(Value)
        AntiFallActive = Value
    end,
})

PlayerTab:Toggle({
    Title = "Infinite Jump",
    Description = "Lompat berkali-kali di udara",
    Default = false,
    Callback = function(Value)
        InfiniteJumpEnabled = Value
    end,
})

UIS.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

PlayerTab:Toggle({
    Title = "WalkSpeed Override",
    Description = "Mengubah kecepatan jalan",
    Default = false,
    Callback = function(Value)
        WalkSpeedEnabled = Value
    end,
})

PlayerTab:Slider({
    Title = "WalkSpeed Value",
    Description = "Atur kecepatan jalan",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(Value)
        WalkSpeedVal = Value
    end,
})

PlayerTab:Toggle({
    Title = "JumpPower Override",
    Description = "Mengubah tinggi lompatan",
    Default = false,
    Callback = function(Value)
        JumpPowerEnabled = Value
    end,
})

PlayerTab:Slider({
    Title = "JumpPower Value",
    Description = "Atur tinggi lompat",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(Value)
        JumpPowerVal = Value
    end,
})

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if WalkSpeedEnabled then hum.WalkSpeed = WalkSpeedVal end
            if JumpPowerEnabled then hum.JumpPower = JumpPowerVal end
        end
    end
end)

PlayerTab:Toggle({
    Title = "NoClip",
    Description = "Menembus tembok/objek",
    Default = false,
    Callback = function(Value)
        NoClipEnabled = Value
    end,
})

RunService.Stepped:Connect(function()
    if NoClipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

PlayerTab:Toggle({
    Title = "Anti AFK",
    Description = "Mencegah kick karena AFK",
    Default = false,
    Callback = function(Value)
        AntiAFKEnabled = Value
        if Value then
            local vu = game:GetService("VirtualUser")
            LocalPlayer.Idled:Connect(function()
                if AntiAFKEnabled then
                    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end,
})

PlayerTab:Toggle({
    Title = "Fly",
    Description = "Terbang dengan pengatur kecepatan",
    Default = false,
    Callback = function(Value)
        FlyEnabled = Value
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        if FlyEnabled then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "PrisonEscapeFlyVelocity"
            bv.Parent = hrp
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            
            task.spawn(function()
                while FlyEnabled and char.Parent do
                    local camCFrame = Camera.CFrame
                    local moveDir = Vector3.new(0, 0, 0)
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCFrame.RightVector end
                    
                    bv.Velocity = moveDir * FlySpeed
                    task.wait()
                end
                if bv then bv:Destroy() end
            end)
        else
            if hrp:FindFirstChild("PrisonEscapeFlyVelocity") then
                hrp.PrisonEscapeFlyVelocity:Destroy()
            end
        end
    end,
})

PlayerTab:Slider({
    Title = "Fly Speed",
    Description = "Kecepatan terbang",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(Value)
        FlySpeed = Value
    end,
})

PlayerTab:Toggle({
    Title = "Freeze Character",
    Description = "Menghentikan posisi karakter",
    Default = false,
    Callback = function(Value)
        IsFrozen = Value
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Anchored = Value
        end
    end,
})

local EspTeamActive = false
local EspAtmActive = false
local EspBoxActive = false
local EspHealthActive = false
local TracerActive = false
local FullbrightActive = false

local activeNameTags = {}
local activeAtmTags = {}

local oldLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

VisualTab:Toggle({
    Title = "Fullbright / Night Vision",
    Description = "Menerangi seluruh map yang gelap",
    Default = false,
    Callback = function(Value)
        FullbrightActive = Value
        if Value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            Lighting.Brightness = oldLighting.Brightness
            Lighting.ClockTime = oldLighting.ClockTime
            Lighting.FogEnd = oldLighting.FogEnd
            Lighting.GlobalShadows = oldLighting.GlobalShadows
            Lighting.OutdoorAmbient = oldLighting.OutdoorAmbient
        end
    end,
})

VisualTab:Toggle({
    Title = "ESP Team / Name",
    Description = "Displays player names colored by team with distance",
    Default = false,
    Callback = function(Value)
        EspTeamActive = Value
    end,
})

VisualTab:Toggle({
    Title = "ESP Box",
    Description = "Kotak di sekitar player",
    Default = false,
    Callback = function(Value)
        EspBoxActive = Value
    end,
})

VisualTab:Toggle({
    Title = "ESP Health",
    Description = "Menampilkan bar/angka HP",
    Default = false,
    Callback = function(Value)
        EspHealthActive = Value
    end,
})

VisualTab:Toggle({
    Title = "Tracer",
    Description = "Garis dari layar ke player",
    Default = false,
    Callback = function(Value)
        TracerActive = Value
    end,
})

VisualTab:Toggle({
    Title = "ESP ATM",
    Description = "ATM Distance ESP & highlights",
    Default = false,
    Callback = function(Value)
        EspAtmActive = Value
    end,
})

task.spawn(function()
    while true do
        task.wait(2)
        if EspAtmActive then
            for _, gui in pairs(activeAtmTags) do
                if gui.Gui then gui.Gui:Destroy() end
            end
            activeAtmTags = {}
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if EspTeamActive and head and root and myRoot then
                if not activeNameTags[player] then
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "PrisonEscapeESPName"
                    bb.Size = UDim2.new(0, 200, 0, 50)
                    bb.StudsOffset = Vector3.new(0, 2.5, 0)
                    bb.AlwaysOnTop = true
                    
                    local txt = Instance.new("TextLabel")
                    txt.Size = UDim2.new(1,0,1,0)
                    txt.BackgroundTransparency = 1
                    txt.TextSize = 14
                    txt.Font = Enum.Font.SourceSansBold
                    txt.TextStrokeTransparency = 0
                    txt.Parent = bb
                    bb.Parent = head
                    activeNameTags[player] = {Gui = bb, Text = txt}
                end
                local dist = math.floor((myRoot.Position - root.Position).Magnitude)
                activeNameTags[player].Text.Text = string.format("%s [%dm]", player.Name, dist)
                activeNameTags[player].Text.TextColor3 = player.Team and player.Team.TeamColor.Color or Color3.new(1,1,1)
                activeNameTags[player].Gui.Enabled = true
            else
                if activeNameTags[player] then activeNameTags[player].Gui.Enabled = false end
            end
        end
    end
    
    if EspAtmActive and myRoot then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == "ATM" then
                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    if not activeAtmTags[obj] then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 200, 0, 50)
                        bb.StudsOffset = Vector3.new(0, 2, 0)
                        bb.AlwaysOnTop = true
                        local txt = Instance.new("TextLabel")
                        txt.Size = UDim2.new(1,0,1,0)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = Color3.fromRGB(170, 0, 255)
                        txt.TextStrokeTransparency = 0
                        txt.Font = Enum.Font.GothamBold
                        txt.TextSize = 14
                        txt.Parent = bb
                        bb.Parent = part
                        activeAtmTags[obj] = {Gui = bb, Text = txt, Part = part}
                    end
                    local dist = math.floor((myRoot.Position - part.Position).Magnitude)
                    activeAtmTags[obj].Text.Text = string.format("ATM [%dm]", dist)
                    activeAtmTags[obj].Gui.Enabled = true
                end
            end
        end
    else
        for _, gui in pairs(activeAtmTags) do
            if gui.Gui then gui.Gui.Enabled = false end
        end
    end
end)

local InstantInteractActive = false
local AutoInteractActive = false
local AutoInteractRadius = 10

InteractTab:Toggle({
    Title = "Instant Interact",
    Description = "Sets ProximityPrompt hold duration to 0",
    Default = false,
    Callback = function(Value)
        InstantInteractActive = Value
        task.spawn(function()
            while InstantInteractActive do
                for _, prompt in ipairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                    end
                end
                task.wait(1)
            end
        end)
    end,
})

InteractTab:Toggle({
    Title = "Auto Interact",
    Description = "Automatically triggers proximity prompts in range",
    Default = false,
    Callback = function(Value)
        AutoInteractActive = Value
    end,
})

InteractTab:Slider({
    Title = "Radius Auto Interact",
    Description = "Set range for automatic prompt triggering",
    Min = 10,
    Max = 35,
    Default = 10,
    Callback = function(Value)
        AutoInteractRadius = Value
    end,
})

RunService.Heartbeat:Connect(function()
    if AutoInteractActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrpPos = LocalPlayer.Character.HumanoidRootPart.Position
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                local parentPart = prompt.Parent
                if parentPart and parentPart:IsA("BasePart") then
                    if (parentPart.Position - hrpPos).Magnitude <= AutoInteractRadius then
                        fireproximityprompt(prompt)
                    end
                end
            end
        end
    end
end)

local AimbotEnabled = false
local AntiTeam = true
local AntiWall = true
local UseFOV = true
local FOVRadius = 80
local Smoothness = 0.10
local TargetPart = "Head"
local PredictionActive = false
local TargetPriority = "closest" 
local TargetLockActive = false
local LockedTarget = nil

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Filled = false
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.NumSides = 64

local function IsTeam(plr)
    if LocalPlayer.Team ~= nil and plr.Team ~= nil then
        if LocalPlayer.Team == plr.Team then return true end
    end
    if LocalPlayer.TeamColor == plr.TeamColor then return true end
    return false
end

local function IsVisible(part)
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    local result = Workspace:Raycast(origin, direction, params)
    return result == nil
end

local function GetTargetPart(character)
    if TargetPart == "HumanoidRootPart" then
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    else
        return character:FindFirstChild("Head")
    end
end

local function GetBestTarget()
    if TargetLockActive and LockedTarget and LockedTarget.Character and LockedTarget.Character:FindFirstChild("Humanoid") and LockedTarget.Character.Humanoid.Health > 0 then
        local part = GetTargetPart(LockedTarget.Character)
        if part then return part end
    end

    local target = nil
    local bestScore = math.huge
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            local hum = plr.Character.Humanoid
            if hum.Health <= 0 then continue end
            if AntiTeam and IsTeam(plr) then continue end
            
            local partToAim = GetTargetPart(plr.Character)
            if not partToAim then continue end
            if AntiWall and not IsVisible(partToAim) then continue end

            local screenPos, onScreen = Camera:WorldToViewportPoint(partToAim.Position)
            if onScreen then
                local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                if not UseFOV or screenDist <= FOVRadius then
                    local score = screenDist
                    if TargetPriority == "lowest" then
                        score = hum.Health
                    elseif TargetPriority == "closest" and myHrp then
                        score = (myHrp.Position - partToAim.Position).Magnitude
                    end

                    if score < bestScore then
                        bestScore = score
                        target = partToAim
                        if TargetLockActive then LockedTarget = plr end
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = FOVRadius
    FOVCircle.Visible = UseFOV and AimbotEnabled

    local targetPart = GetBestTarget()
    if AimbotEnabled and targetPart then
        local finalPos = targetPart.Position
        if PredictionActive and targetPart.Parent:FindFirstChild("HumanoidRootPart") then
            local hrp = targetPart.Parent.HumanoidRootPart
            finalPos = finalPos + (hrp.AssemblyLinearVelocity * 0.1)
        end
        
        local currentCFrame = Camera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, finalPos)
        Camera.CFrame = currentCFrame:Lerp(targetCFrame, math.clamp(Smoothness * 10, 0.01, 1))
    else
        if TargetLockActive then LockedTarget = nil end
    end
end)

AimbotTab:Toggle({
    Title = "Aimbot Active",
    Description = "Enables core aimbot",
    Default = false,
    Callback = function(Value) AimbotEnabled = Value end,
})

AimbotTab:Toggle({
    Title = "Prediction",
    Description = "Prediksi pergerakan target",
    Default = false,
    Callback = function(Value) PredictionActive = Value end,
})

AimbotTab:Toggle({
    Title = "Target Lock",
    Description = "Mengunci target agar tidak mudah pindah",
    Default = false,
    Callback = function(Value) TargetLockActive = Value end,
})

AimbotTab:Toggle({
    Title = "Anti Team",
    Description = "Abaikan rekan satu tim",
    Default = true,
    Callback = function(Value) AntiTeam = Value end,
})

AimbotTab:Toggle({
    Title = "Wall Check",
    Description = "Cek tembok",
    Default = true,
    Callback = function(Value) AntiWall = Value end,
})

AimbotTab:Slider({
    Title = "FOV Size",
    Description = "Dynamic FOV radius",
    Min = 20,
    Max = 350,
    Default = 80,
    Callback = function(Value) FOVRadius = Value end,
})

UtilityTab:Button({
    Title = "Server Hop",
    Description = "Pindah ke server lain secara acak",
    Callback = function()
        WindUI:Notify({ Title = "Server", Content = "Searching for another server...", Duration = 2 })
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        local data = HttpService:JSONDecode(req)
        for _, s in ipairs(data.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                table.insert(servers, s.id)
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            WindUI:Notify({ Title = "Server Error", Content = "No available servers found!", Duration = 3 })
        end
    end,
})

UtilityTab:Button({
    Title = "Rejoin Server",
    Description = "Bergabung kembali ke server saat ini",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

UtilityTab:Button({
    Title = "Server Info / JobId",
    Description = "Menampilkan JobId & Player count",
    Callback = function()
        local info = string.format("JobId: %s\nPlayers: %d/%d", game.JobId, #Players:GetPlayers(), Players.MaxPlayers)
        print(info)
        WindUI:Notify({ Title = "Server Info", Content = "Printed to console/F9", Duration = 3 })
    end,
})

UtilityTab:Toggle({
    Title = "FPS Boost",
    Description = "Disable particles, lower effects & rendering details",
    Default = false,
    Callback = function(Value)
        if Value then
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then
                    v.Enabled = false
                end
            end
            Lighting.GlobalShadows = false
            WindUI:Notify({ Title = "FPS Boost", Content = "FPS Boost Enabled", Duration = 2 })
        else
            WindUI:Notify({ Title = "FPS Boost", Content = "FPS Boost Disabled", Duration = 2 })
        end
    end,
})

local AutoFarmEnabled = false

local AutoFarmGui = Instance.new("ScreenGui")
AutoFarmGui.Name = "PrisonEscapeAutoFarmScreen"
AutoFarmGui.IgnoreGuiInset = true
AutoFarmGui.ResetOnSpawn = false
AutoFarmGui.Enabled = false
pcall(function()
    AutoFarmGui.Parent = CoreGui
end)
if not AutoFarmGui.Parent then
    AutoFarmGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local BlackBackground = Instance.new("Frame")
BlackBackground.Size = UDim2.new(1, 0, 1, 0)
BlackBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackBackground.BorderSizePixel = 0
BlackBackground.Parent = AutoFarmGui

local TextContainer = Instance.new("UIListLayout")
TextContainer.Parent = BlackBackground
TextContainer.HorizontalAlignment = Enum.HorizontalAlignment.Center
TextContainer.VerticalAlignment = Enum.VerticalAlignment.Center
TextContainer.SortOrder = Enum.SortOrder.LayoutOrder
TextContainer.Padding = UDim.new(0, 10)

local FarmTextLabel = Instance.new("TextLabel")
FarmTextLabel.Size = UDim2.new(0, 500, 0, 50)
FarmTextLabel.BackgroundTransparency = 1
FarmTextLabel.Text = "Prison Escape Auto Farm"
FarmTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmTextLabel.TextSize = 36
FarmTextLabel.Font = Enum.Font.GothamBold
FarmTextLabel.Parent = BlackBackground

local RejoinTextLabel = Instance.new("TextLabel")
RejoinTextLabel.Size = UDim2.new(0, 500, 0, 30)
RejoinTextLabel.BackgroundTransparency = 1
RejoinTextLabel.Text = "Rejoin to check your money!"
RejoinTextLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
RejoinTextLabel.TextSize = 22
RejoinTextLabel.Font = Enum.Font.GothamBold
RejoinTextLabel.Parent = BlackBackground

AutoFarmTab:Toggle({
    Title = "Auto Farm",
    Description = "Automatically teleports to ATMs and interacts with prompts",
    Default = false,
    Callback = function(Value)
        AutoFarmEnabled = Value
        AutoFarmGui.Enabled = Value
    end,
})

task.spawn(function()
    while true do
        task.wait(0.2)
        if AutoFarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(Workspace:GetDescendants()) do
                if not AutoFarmEnabled then break end
                if v:IsA("Model") and v.Name == "ATM" then
                    local part = v:FindFirstChildWhichIsA("BasePart")
                    if part then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.15)
                        for _, obj in pairs(v:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") then
                                pcall(function()
                                    fireproximityprompt(obj, 0)
                                end)
                            end
                        end
                        task.wait(0.25)
                    end
                end
            end
        end
    end
end)

local function ProtectWindUi()
    pcall(function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            for _, gui in ipairs(playerGui:GetChildren()) do
                if gui:IsA("ScreenGui") and (gui.Name:find("WindUI") or gui.Name:find("Prison") or gui:FindFirstChildWhichIsA("Frame", true)) then
                    gui.ResetOnSpawn = false
                end
            end
        end
    end)
end

ProtectWindUi()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    ProtectWindUi()
end)

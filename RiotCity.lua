-- yang nyolong gabisa punya keturunan
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/aboutsibah113/Library/refs/heads/main/Sibah2xZcu_Library.lua?v=2"
))()

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
local MainSection   = MainTab:AddSection("Settings", true)

MainSection:AddToggle({
    Title    = "Disable Notify",
    Content  = "Disables all custom script notifications",
    Default  = false,
    Callback = function(Value)
        DisableNotify = Value
    end,
})

local TeleportsTab = Window:CreateTab({ "Teleports", "" })
local TeleportsSection = TeleportsTab:AddSection("Location Teleports", true)

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
                Window:Notify("Teleported to " .. targetName, 2)
            else
                Window:Notify("Could not determine position for " .. targetName, 3)
            end
        else
            Window:Notify(targetName .. " not found in workspace!", 3)
        end
    end
end

TeleportsSection:AddButton({
    Title    = "TP to Bank",
    Content  = "Teleports to the bank folder",
    Callback = function()
        teleportTo("Armchair")
    end,
})

TeleportsSection:AddButton({
    Title    = "TP to Charging Station",
    Content  = "Teleports to the charging station",
    Callback = function()
        teleportTo("Charger")
    end,
})

TeleportsSection:AddButton({
    Title    = "TP to Gas Station",
    Content  = "Teleports to the gas station",
    Callback = function()
        teleportTo("Bush1")
    end,
})

TeleportsSection:AddButton({
    Title    = "TP to House",
    Content  = "Teleports to House",
    Callback = function()
        teleportTo("House_04")
    end,
})

local PlayerTab = Window:CreateTab({ "Player", "" })
local PlayerSection = PlayerTab:AddSection("Player Modifications", true)

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

PlayerSection:AddToggle({
    Title    = "Anti Fall Damage",
    Content  = "Blocks the fall damage remote call automatically",
    Default  = false,
    Callback = function(Value)
        AntiFallActive = Value
    end,
})

PlayerSection:AddToggle({
    Title    = "Infinite Jump",
    Content  = "Lompat berkali-kali di udara",
    Default  = false,
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

PlayerSection:AddToggle({
    Title    = "WalkSpeed Override",
    Content  = "Mengubah kecepatan jalan",
    Default  = false,
    Callback = function(Value)
        WalkSpeedEnabled = Value
    end,
})

PlayerSection:AddSlider({
    Title    = "WalkSpeed Value",
    Content  = "Atur kecepatan jalan",
    Min      = 16,
    Max      = 200,
    Default  = 16,
    Increment= 1,
    Callback = function(Value)
        WalkSpeedVal = Value
    end,
})

PlayerSection:AddToggle({
    Title    = "JumpPower Override",
    Content  = "Mengubah tinggi lompatan",
    Default  = false,
    Callback = function(Value)
        JumpPowerEnabled = Value
    end,
})

PlayerSection:AddSlider({
    Title    = "JumpPower Value",
    Content  = "Atur tinggi lompat",
    Min      = 50,
    Max      = 300,
    Default  = 50,
    Increment= 5,
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

PlayerSection:AddToggle({
    Title    = "NoClip",
    Content  = "Menembus tembok/objek",
    Default  = false,
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

PlayerSection:AddToggle({
    Title    = "Anti AFK",
    Content  = "Mencegah kick karena AFK",
    Default  = false,
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
            Window:Notify("Anti AFK Enabled", 2)
        end
    end,
})

PlayerSection:AddToggle({
    Title    = "Fly",
    Content  = "Terbang dengan pengatur kecepatan (Support Mobile)",
    Default  = false,
    Callback = function(Value)
        FlyEnabled = Value
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        if FlyEnabled then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "BearHubFlyVelocity"
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
            if hrp:FindFirstChild("BearHubFlyVelocity") then
                hrp.BearHubFlyVelocity:Destroy()
            end
        end
    end,
})

PlayerSection:AddSlider({
    Title    = "Fly Speed",
    Content  = "Kecepatan terbang",
    Min      = 10,
    Max      = 200,
    Default  = 50,
    Increment = 5,
    Callback = function(Value)
        FlySpeed = Value
    end,
})

PlayerSection:AddToggle({
    Title    = "Freeze Character",
    Content  = "Menghentikan posisi karakter (Utility)",
    Default  = false,
    Callback = function(Value)
        IsFrozen = Value
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Anchored = Value
        end
    end,
})

local VisualTab = Window:CreateTab({ "Visual", "" })
local VisualSection = VisualTab:AddSection("ESP & Visual Options", true)

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

VisualSection:AddToggle({
    Title    = "Fullbright / Night Vision",
    Content  = "Menerangi seluruh map yang gelap",
    Default  = false,
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

VisualSection:AddToggle({
    Title    = "ESP Team / Name",
    Content  = "Displays player names colored by team with distance [32m]",
    Default  = false,
    Callback = function(Value)
        EspTeamActive = Value
    end,
})

VisualSection:AddToggle({
    Title    = "ESP Box",
    Content  = "Kotak di sekitar player",
    Default  = false,
    Callback = function(Value)
        EspBoxActive = Value
    end,
})

VisualSection:AddToggle({
    Title    = "ESP Health",
    Content  = "Menampilkan bar/angka HP",
    Default  = false,
    Callback = function(Value)
        EspHealthActive = Value
    end,
})

VisualSection:AddToggle({
    Title    = "Tracer",
    Content  = "Garis dari layar ke player",
    Default  = false,
    Callback = function(Value)
        TracerActive = Value
    end,
})

VisualSection:AddToggle({
    Title    = "ESP ATM",
    Content  = "ATM Distance ESP & highlights",
    Default  = false,
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
                    bb.Name = "BearHubESPName"
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

local InteractTab = Window:CreateTab({ "Interact", "" })
local InteractSection = InteractTab:AddSection("Interaction Settings", true)

local InstantInteractActive = false
local AutoInteractActive = false
local AutoInteractRadius = 10

InteractSection:AddToggle({
    Title    = "Instant Interact",
    Content  = "Sets ProximityPrompt hold duration to 0",
    Default  = false,
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

InteractSection:AddToggle({
    Title    = "Auto Interact",
    Content  = "Automatically triggers proximity prompts in range",
    Default  = false,
    Callback = function(Value)
        AutoInteractActive = Value
    end,
})

InteractSection:AddSlider({
    Title    = "Radius Auto Interact",
    Content  = "Set range for automatic prompt triggering",
    Min      = 10,
    Max      = 35,
    Default  = 10,
    Increment= 1,
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

local AimbotTab = Window:CreateTab({ "Aimbot", "" })
local AimbotSection = AimbotTab:AddSection("Aimbot Settings", true)

local AimbotEnabled = false
local AntiTeam = true
local AntiWall = true
local UseFOV = true
local TargetStun = true
local FOVRadius = 80
local Smoothness = 0.10
local TargetPart = "Head"
local MaxDistance = 10
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

AimbotSection:AddToggle({
    Title    = "Aimbot Active",
    Content  = "Enables core aimbot",
    Default  = false,
    Callback = function(Value) AimbotEnabled = Value end,
})

AimbotSection:AddToggle({
    Title    = "Prediction",
    Content  = "Prediksi pergerakan target",
    Default  = false,
    Callback = function(Value) PredictionActive = Value end,
})

AimbotSection:AddToggle({
    Title    = "Target Lock",
    Content  = "Mengunci target agar tidak mudah pindah",
    Default  = false,
    Callback = function(Value) TargetLockActive = Value end,
})

AimbotSection:AddToggle({
    Title    = "Anti Team",
    Content  = "Abaikan rekan satu tim",
    Default  = true,
    Callback = function(Value) AntiTeam = Value end,
})

AimbotSection:AddToggle({
    Title    = "Wall Check",
    Content  = "Cek tembok",
    Default  = true,
    Callback = function(Value) AntiWall = Value end,
})

AimbotSection:AddSlider({
    Title    = "FOV Size",
    Content  = "Dynamic FOV radius",
    Min      = 20,
    Max      = 350,
    Default  = 80,
    Increment= 1,
    Callback = function(Value) FOVRadius = Value end,
})

local UtilityTab = Window:CreateTab({ "Utility", "" })
local UtilitySection = UtilityTab:AddSection("Server & Performance", true)

UtilitySection:AddButton({
    Title    = "Server Hop",
    Content  = "Pindah ke server lain secara acak",
    Callback = function()
        Window:Notify("Searching for another server...", 2)
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
            Window:Notify("No available servers found!", 3)
        end
    end,
})

UtilitySection:AddButton({
    Title    = "Rejoin Server",
    Content  = "Bergabung kembali ke server saat ini",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

UtilitySection:AddButton({
    Title    = "Server Info / JobId",
    Content  = "Menampilkan JobId & Player count",
    Callback = function()
        local info = string.format("JobId: %s\nPlayers: %d/%d", game.JobId, #Players:GetPlayers(), Players.MaxPlayers)
        print(info)
        Window:Notify("Copied / Printed Server Info!", 3)
    end,
})

UtilitySection:AddToggle({
    Title    = "FPS Boost",
    Content  = "Disable particles, lower effects & rendering details",
    Default  = false,
    Callback = function(Value)
        if Value then
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then
                    v.Enabled = false
                end
            end
            Lighting.GlobalShadows = false
            Window:Notify("FPS Boost Enabled", 2)
        else
            Window:Notify("FPS Boost Disabled", 2)
        end
    end,
})

local AutoFarmTab = Window:CreateTab({ "Auto Farm", "" })
local AutoFarmSection = AutoFarmTab:AddSection("Automated Farming", true)

local AutoFarmEnabled = false

local AutoFarmGui = Instance.new("ScreenGui")
AutoFarmGui.Name = "BearHubAutoFarmScreen"
AutoFarmGui.IgnoreGuiInset = true
AutoFarmGui.ResetOnSpawn = false
AutoFarmGui.Enabled = false
AutoFarmGui.Parent = CoreGui

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
FarmTextLabel.Text = "Bear Hub Auto Farm"
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

AutoFarmSection:AddToggle({
    Title    = "Auto Farm",
    Content  = "Automatically teleports to ATMs and interacts with prompts",
    Default  = false,
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

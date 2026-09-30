--[[\n  Obfuscated with Bear Hub Protection\n  Original Script: Bear Hub v2.1 Pro Optimized\n]]--

local _U = string.char; local _B = table.concat; local _M = string.sub;
local _Env = (getgenv or function() return _G end)();

local _0x1a = {
    _P = game:GetService("Players"),
    _W = game:GetService("Workspace"),
    _R = game:GetService("RunService"),
    _RS = game:GetService("ReplicatedStorage"),
    _UIS = game:GetService("UserInputService"),
    _L = game:GetService("Lighting"),
    _TS = game:GetService("TeleportService"),
    _HS = game:GetService("HttpService"),
    _CG = game:GetService("CoreGui")
};

local _Cam = _0x1a._W.CurrentCamera;
local _LP = _0x1a._P.LocalPlayer;

local _LibUrl = _U(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,97,98,111,117,116,115,105,98,97,104,49,49,51,47,76,105,98,114,97,114,121,47,114,101,102,115,47,104,101,97,108,115,47,109,97,105,110,47,83,105,98,97,104,50,120,90,99,95,76,105,98,114,97,114,121,46,108,117,97,63,118,61,50);
local _Library = loadstring(game:HttpGet(_LibUrl))();

local _Window = _Library:CreateWindow({
    Title          = _U(66,101,97,114,32,72,117,98),
    Description    = _U(118,50,46,49,32,80,114,111,32,79,112,116,105,109,105,122,101,100),
    isVerified     = true,
    OpenCloseImage = _U(57,50,53,51,48,56,50,52,57,49,56,57,49,51),
    Icon           = _U(114,98,120,116,104,117,109,58,47,47,116,121,112,101,61,65,115,115,101,116,38,105,100,61,49,51,48,48,48,56,49,55,54,53,51,48,56,51,55,38,119,61,52,50,48,38,104,61,52,50,0),
    Keybind        = Enum.KeyCode.RightControl,
    SizeUi         = UDim2.fromOffset(500, 340),
    Tags           = { _U(66,101,116,97), _U(79,80) },
});

_Window:SetColor(Color3.fromRGB(88, 166, 255));

local _DN = false;
local _ON = _Window.Notify;
_Window.Notify = function(self, t, d)
    if not _DN then
        _ON(self, t, d);
    end
end;

_Window:Notify(_U(66,101,97,114,32,72,117,98,32,118,50,46,49,32,76,111,97,100,101,100,33), 4);

local _MainTab = _Window:CreateTab({ _U(77,97,105,110), "" });
local _MainSec = _MainTab:AddSection(_U(83,101,116,116,105,110,103,115), true);

_MainSec:AddToggle({
    Title    = _U(68,105,115,97,98,108,101,32,78,111,116,105,102,121),
    Content  = _U(68,105,115,97,98,108,101,115,32,97,108,108,32,99,117,115,116,111,109,32,115,99,114,105,112,116,32,110,111,116,105,102,105,99,97,116,105,111,110,115),
    Default  = false,
    Callback = function(v) _DN = v; end,
});

local _TPTab = _Window:CreateTab({ _U(84,101,108,101,112,111,114,116,115), "" });
local _TPSec = _TPTab:AddSection(_U(76,111,99,97,116,105,111,110,32,84,101,108,101,112,111,114,116,115), true);

local function _DoTP(n)
    local c = _LP.Character;
    if c and c:FindFirstChild(_U(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116)) then
        local o = _0x1a._W:FindFirstChild(n, true);
        if o then
            local p;
            if o:IsA(_U(77,111,100,101,108)) then p = o:GetPivot().Position;
            elseif o:IsA(_U(70,111,108,100,101,114)) and o.PrimaryPart then p = o.PrimaryPart.Position;
            elseif o:IsA(_U(66,97,115,101,80,97,114,116)) then p = o.Position; end
            if p then
                c:PivotTo(CFrame.new(p + Vector3.new(0, 3, 0)));
                _Window:Notify(_U(84,101,108,101,112,111,114,116,101,100,32,116,111,32) .. n, 2);
            end
        end
    end
end

_TPSec:AddButton({ Title = "TP to Bank", Content = "Teleports to the bank folder", Callback = function() _DoTP("Armchair") end });
_TPSec:AddButton({ Title = "TP to Charging Station", Content = "Teleports to the charging station", Callback = function() _DoTP("Charger") end });
_TPSec:AddButton({ Title = "TP to Gas Station", Content = "Teleports to the gas station", Callback = function() _DoTP("Bush1") end });
_TPSec:AddButton({ Title = "TP to House", Content = "Teleports to House", Callback = function() _DoTP("House_04") end });

local _PlrTab = _Window:CreateTab({ "Player", "" });
local _PlrSec = _PlrTab:AddSection("Player Modifications", true);

local _InfJump, _WSOn, _WSVal, _JPOn, _JPVal, _NoClip, _AntiAFK, _FlyOn, _FlySpd = false, false, 16, false, 50, false, false, false, 50;

_PlrSec:AddToggle({
    Title    = "Infinite Jump",
    Content  = "Lompat berkali-kali di udara",
    Default  = false,
    Callback = function(v) _InfJump = v; end,
});

_0x1a._UIS.JumpRequest:Connect(function()
    if _InfJump and _LP.Character then
        local h = _LP.Character:FindFirstChildOfClass("Humanoid");
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping); end
    end
end);

_PlrSec:AddToggle({ Title = "WalkSpeed Override", Default = false, Callback = function(v) _WSOn = v; end });
_PlrSec:AddSlider({ Title = "WalkSpeed Value", Min = 16, Max = 200, Default = 16, Increment = 1, Callback = function(v) _WSVal = v; end });

_PlrSec:AddToggle({ Title = "JumpPower Override", Default = false, Callback = function(v) _JPOn = v; end });
_PlrSec:AddSlider({ Title = "JumpPower Value", Min = 50, Max = 300, Default = 50, Increment = 5, Callback = function(v) _JPVal = v; end });

_0x1a._R.Heartbeat:Connect(function()
    local c = _LP.Character;
    if c then
        local h = c:FindFirstChildOfClass("Humanoid");
        if h then
            if _WSOn then h.WalkSpeed = _WSVal; end
            if _JPOn then h.JumpPower = _JPVal; end
        end
    end
end);

_PlrSec:AddToggle({
    Title = "NoClip",
    Default = false,
    Callback = function(v) _NoClip = v; end,
});

_0x1a._R.Stepped:Connect(function()
    if _NoClip and _LP.Character then
        for _, p in pairs(_LP.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false; end
        end
    end
end);

local _AutoFarmTab = _Window:CreateTab({ "Auto Farm", "" });
local _AutoFarmSec = _AutoFarmTab:AddSection("Automated Farming", true);
local _AFEnabled = false;

local _AFGui = Instance.new("ScreenGui", _0x1a._CG);
_AFGui.Name = "Protected_AF_Gui";
_AFGui.Enabled = false;

local _AFFbg = Instance.new("Frame", _AFGui);
_AFFbg.Size = UDim2.new(1,0,1,0);
_AFFbg.BackgroundColor3 = Color3.new(0,0,0);

local _AFTLbl = Instance.new("TextLabel", _AFFbg);
_AFTLbl.Size = UDim2.new(0, 500, 0, 50);
_AFTLbl.Position = UDim2.new(0.5, -250, 0.4, -25);
_AFTLbl.BackgroundTransparency = 1;
_AFTLbl.Text = "Bear Hub Auto Farm (Secured)";
_AFTLbl.TextColor3 = Color3.new(1,1,1);
_AFTLbl.TextSize = 32;

_AutoFarmSec:AddToggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(v)
        _AFEnabled = v;
        _AFGui.Enabled = v;
    end,
});

task.spawn(function()
    while true do
        task.wait(0.2);
        if _AFEnabled and _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(_0x1a._W:GetDescendants()) do
                if not _AFEnabled then break; end
                if v:IsA("Model") and v.Name == "ATM" then
                    local pt = v:FindFirstChildWhichIsA("BasePart");
                    if pt then
                        _LP.Character.HumanoidRootPart.CFrame = pt.CFrame + Vector3.new(0, 3, 0);
                        task.wait(0.15);
                        for _, obj in pairs(v:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") then
                                pcall(function() fireproximityprompt(obj, 0); end);
                            end
                        end
                        task.wait(0.25);
                    end
                end
            end
        end
    end
end)

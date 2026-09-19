if not game:IsLoaded() then game.Loaded:Wait() end

local BASE = 'https://raw.githubusercontent.com/BEARHUB-DEV/BEARHUB/main/'

local games = {
    [4789047554] = 'prisonescapev2.lua',
    [126016859830524] = 'StealAEggBrainrot.lua',
    [128168754563448] = 'SwatSimulator.lua',
}

if identifyexecutor then
    local execName = tostring(identifyexecutor()):lower()
    local UNSUPPORTED = { "Solara", "Xeno" }
    
    for _, name in ipairs(UNSUPPORTED) do
        if execName:find(name:lower(), 1, true) then
            local ok, Library = pcall(function() 
                return loadstring(game:HttpGet("https://raw.githubusercontent.com/joustingmatch/ObsidianUltra/main/Library.lua"))() 
            end)
            if ok and Library then
                Library:CreateUnsupportedScreen({
                    Title = "BEAR HUB",
                    Unsupported = UNSUPPORTED,
                    Footer = {
                        { Text = "Unsupported Executor Detected", Copyable = false }
                    },
                })
            end
            return
        end
    end
end

local file = games[game.CreatorId] or games[game.PlaceId]

if file then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "BEAR HUB",
        Text = "Supported games! loading...",
        Duration = 5
    })
    
    task.wait(math.random())
    
    local success, scriptContent = pcall(function()
        return game:HttpGet(BASE .. file)
    end)
    
    if success and scriptContent and not scriptContent:find("404: Not Found") then
        local loadedFunc, err = loadstring(scriptContent)
        if loadedFunc then
            task.spawn(loadedFunc)
            print("[BEAR HUB] Successfully executed: " .. file)
        else
            warn("[BEAR HUB] Syntax error in script: " .. tostring(err))
        end
    else
        warn("[BEAR HUB] Failed to fetch script from URL: " .. BASE .. file)
    end
else
    print("[BEAR HUB] Current game is not supported.")
end

local isOpen = false
local pendingSince = nil

-- Saved locally on the player's own FiveM client (survives reconnects and restarts)
local KVP_PINNED = 'pinned_jobs'
local KVP_MODE = 'display_mode'

local function getPinned()
    local raw = GetResourceKvpString(KVP_PINNED)
    if raw then
        local ok, decoded = pcall(json.decode, raw)
        if ok and type(decoded) == 'table' then return decoded end
    end
    return Config.DefaultPinnedJobs
end

local function getCompact()
    if Config.RememberMode then
        local saved = GetResourceKvpString(KVP_MODE)
        if saved then return saved == 'compact' end
    end
    return Config.DefaultMode == 'compact'
end

local function openScoreboard()
    if isOpen then return end
    -- ignore repeat presses while waiting for the server (times out after 3s)
    if pendingSince and (GetGameTimer() - pendingSince) < 3000 then return end
    pendingSince = GetGameTimer()
    TriggerServerEvent('ec_scoreboard:requestData')
end

local function closeScoreboard()
    if not isOpen then return end
    isOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

-- Server answers both the first request (open) and the refresh requests (update)
RegisterNetEvent('ec_scoreboard:receiveData', function(data)
    if type(data) ~= 'table' then return end

    if pendingSince then
        pendingSince = nil
        if isOpen then return end

        data.pinned = getPinned()
        data.compact = getCompact()

        isOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'open', data = data })
    elseif isOpen then
        SendNUIMessage({ action = 'update', data = data })
    end
end)

-- ─────────────────────────────────────────────────────────────
-- Input
-- ─────────────────────────────────────────────────────────────
RegisterCommand(Config.Command, function()
    if isOpen then closeScoreboard() else openScoreboard() end
end, false)

RegisterKeyMapping(Config.Command, Config.OpenKeyDescription, 'keyboard', Config.OpenKey)

if Config.BlockWeaponWheel then
    CreateThread(function()
        while true do
            Wait(0)
            DisableControlAction(0, 37, true) -- INPUT_SELECT_WEAPON (weapon wheel)
        end
    end)
end

-- ─────────────────────────────────────────────────────────────
-- Live refresh while open
-- ─────────────────────────────────────────────────────────────
CreateThread(function()
    while true do
        Wait(Config.RefreshInterval)
        if isOpen then
            TriggerServerEvent('ec_scoreboard:requestData')
        end
    end
end)

-- ─────────────────────────────────────────────────────────────
-- NUI callbacks
-- ─────────────────────────────────────────────────────────────
RegisterNUICallback('close', function(_, cb)
    if isOpen then
        isOpen = false
        SetNuiFocus(false, false)
    end
    cb('ok')
end)

RegisterNUICallback('savePinned', function(data, cb)
    local clean = {}
    if type(data) == 'table' and type(data.pinned) == 'table' then
        for _, jobName in ipairs(data.pinned) do
            if type(jobName) == 'string' and #jobName <= 64 and #clean < 200 then
                clean[#clean + 1] = jobName
            end
        end
    end
    SetResourceKvp(KVP_PINNED, json.encode(clean))
    cb('ok')
end)

RegisterNUICallback('saveMode', function(data, cb)
    if Config.RememberMode and type(data) == 'table' then
        SetResourceKvp(KVP_MODE, data.compact and 'compact' or 'full')
    end
    cb('ok')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() and isOpen then
        SetNuiFocus(false, false)
    end
end)

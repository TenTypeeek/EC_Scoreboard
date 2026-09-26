local ESX = exports['es_extended']:getSharedObject()

local jobsDb = {}
local cache = { data = nil, time = 0 }
local CACHE_MS = 1000

local function toSet(list)
    local set = {}
    for _, v in ipairs(list or {}) do set[v] = true end
    return set
end

local blacklist = toSet(Config.BlacklistedJobs)
local policeJobs = toSet(Config.PoliceJobs)

local categoryByJob = {}
local categoryByLabel = {}
for _, cat in ipairs(Config.JobCategories) do
    categoryByLabel[cat.label] = cat
    for _, jobName in ipairs(cat.jobs or {}) do
        categoryByJob[jobName] = cat
    end
end

local function loadJobs()
    if not Config.JobsTable:match('^[%w_]+$') then
        print('^1[ec_scoreboard] Config.JobsTable contains invalid characters.^0')
        return
    end

    local ok, rows = pcall(MySQL.query.await, ('SELECT `name`, `label` FROM `%s`'):format(Config.JobsTable))
    if not ok or type(rows) ~= 'table' then
        print(('^1[ec_scoreboard] Could not read jobs from table `%s`.^0'):format(Config.JobsTable))
        return
    end

    local loaded = {}
    for _, row in ipairs(rows) do
        loaded[row.name] = row.label or row.name
    end
    jobsDb = loaded
    cache.data = nil
end

MySQL.ready(function()
    loadJobs()

    if Config.JobRefreshMinutes and Config.JobRefreshMinutes > 0 then
        CreateThread(function()
            while true do
                Wait(Config.JobRefreshMinutes * 60000)
                loadJobs()
            end
        end)
    end
end)

local function getMaxPlayers()
    if Config.MaxPlayers and Config.MaxPlayers > 0 then return Config.MaxPlayers end
    return GetConvarInt('sv_maxclients', 48)
end

local function buildData()
    local players, counts, copCount = {}, {}, 0

    for _, xPlayer in pairs(ESX.GetExtendedPlayers()) do
        local src = xPlayer.source
        local job = xPlayer.job or {}
        local jobName = job.name

        local name = GetPlayerName(src) or ('ID ' .. src)
        if Config.UseCharacterNames then
            local ok, charName = pcall(function() return xPlayer.getName() end)
            if ok and charName and charName ~= '' then name = charName end
        end

        local tag
        local group = xPlayer.getGroup()
        local groupCfg = group and Config.AdminGroups[group]
        if groupCfg then
            tag = { label = groupCfg.label, color = groupCfg.color or '#ffffff' }
        end

        players[#players + 1] = {
            id = src,
            name = name,
            ping = Config.ShowPing and GetPlayerPing(src) or nil,
            tag = tag,
        }

        if jobName then
            local counted = true
            if Config.CountOnlyOnDuty and job.onDuty == false then counted = false end

            if counted then
                counts[jobName] = (counts[jobName] or 0) + 1
                if policeJobs[jobName] then copCount = copCount + 1 end
                if not jobsDb[jobName] and job.label then jobsDb[jobName] = job.label end
            end
        end
    end

    table.sort(players, function(a, b) return a.id < b.id end)

    local jobs = {}
    for jobName, dbLabel in pairs(jobsDb) do
        local count = counts[jobName] or 0
        if not blacklist[jobName] and (count > 0 or Config.ShowEmptyJobs) then
            local override = Config.JobOverrides[jobName] or {}
            local cat = (override.category and categoryByLabel[override.category])
                or categoryByJob[jobName]
                or Config.DefaultCategory

            jobs[#jobs + 1] = {
                id = jobName,
                label = override.label or dbLabel,
                icon = override.icon or cat.icon,
                color = override.color or cat.color,
                category = cat.label,
                count = count,
            }
        end
    end

    local heists = {}
    for _, heist in ipairs(Config.Heists) do
        heists[#heists + 1] = {
            id = heist.id,
            label = heist.label,
            icon = heist.icon,
            requiredCops = heist.requiredCops,
            enoughCops = copCount >= heist.requiredCops,
        }
    end

    return {
        serverName = Config.ServerName,
        maxPlayers = getMaxPlayers(),
        playerCount = #GetPlayers(),
        showPing = Config.ShowPing,
        locales = Config.Locale,
        players = players,
        jobs = jobs,
        heists = heists,
    }
end

local function getData()
    local now = GetGameTimer()
    if not cache.data or (now - cache.time) > CACHE_MS then
        cache.data = buildData()
        cache.time = now
    end
    return cache.data
end

local lastRequest = {}

RegisterNetEvent('ec_scoreboard:requestData', function()
    local src = source
    local now = GetGameTimer()
    if lastRequest[src] and (now - lastRequest[src]) < 250 then return end
    lastRequest[src] = now

    TriggerClientEvent('ec_scoreboard:receiveData', src, getData())
end)

AddEventHandler('playerDropped', function()
    lastRequest[source] = nil
end)
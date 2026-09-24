Config = {}

-- ─────────────────────────────────────────────────────────────
-- General
-- ─────────────────────────────────────────────────────────────
Config.ServerName = 'Eclipse Development'

-- Max players shown in the header (e.g. 12/100). Set to 0 to use your sv_maxclients convar.
Config.MaxPlayers = 64

-- Key + command used to open the scoreboard (players can rebind it in Settings > Key Bindings > FiveM)
Config.Command = 'scoreboard'
Config.OpenKey = 'TAB'
Config.OpenKeyDescription = 'Open scoreboard'

-- Blocks the GTA weapon wheel while TAB is the open key
Config.BlockWeaponWheel = false

-- 'full' or 'compact' (compact = small panel on the right side of the screen)
Config.DefaultMode = 'compact'

-- true  = remember the mode the player last used (saved on their own client)
-- false = always open in Config.DefaultMocompactde
Config.RememberMode = true

-- Show the ping of each player
Config.ShowPing = true

-- true  = show the ESX character name (firstname lastname)
-- false = show the player's Steam/FiveM name
Config.UseCharacterNames = false

-- How often (ms) the open scoreboard refreshes its data
Config.RefreshInterval = 3000

-- How often (minutes) the job list is re-read from the database. 0 = only on resource start.
Config.JobRefreshMinutes = 10

-- Database table that holds the jobs (ESX default: 'jobs', needs `name` and `label` columns)
Config.JobsTable = 'jobs'

-- ─────────────────────────────────────────────────────────────
-- Jobs
-- ─────────────────────────────────────────────────────────────

-- Jobs that will NOT appear in the scoreboard (use the job `name` from the database)
Config.BlacklistedJobs = {
    'unemployed',
}

-- Jobs pinned by default for players who never pinned/unpinned anything.
-- Once a player pins or unpins a job, their own list is saved on their client and used instead.
Config.DefaultPinnedJobs = {
    'police',
    'ambulance',
}

-- Show jobs that currently have 0 players online
Config.ShowEmptyJobs = true

-- Only count players that are on duty (needs an ESX version with job.onDuty; ignored if the field does not exist)
Config.CountOnlyOnDuty = false

-- Job names that count as police (used for the heist "cops required" check)
Config.PoliceJobs = {
    'police',
    'sheriff',
}

-- Categories shown as a small tag on each job. Icons are Font Awesome 6 (free) names.
-- Jobs that are not listed in any category use Config.DefaultCategory.
Config.JobCategories = {
    { label = 'Law Enforcement', icon = 'fa-shield-halved', color = '#60a5fa', jobs = { 'police', 'sheriff', 'state', 'fib' } },
    { label = 'Medical',         icon = 'fa-heart-pulse',   color = '#f87171', jobs = { 'ambulance', 'ems', 'doctor' } },
    { label = 'Mechanic',        icon = 'fa-wrench',        color = '#fb923c', jobs = { 'mechanic', 'bennys', 'tuner' } },
    { label = 'Restaurant',      icon = 'fa-burger',        color = '#facc15', jobs = { 'burgershot', 'pizzeria', 'cafe', 'bar', 'unicorn' } },
    { label = 'Services',        icon = 'fa-taxi',          color = '#e879f9', jobs = { 'taxi', 'tow', 'realestateagent' } },
}

Config.DefaultCategory = { label = 'Civilian', icon = 'fa-briefcase', color = '#9ca3af' }

-- Optional per-job overrides. Every field is optional.
-- Example: ['police'] = { label = 'LSPD', icon = 'fa-star', color = '#3b82f6', category = 'Law Enforcement' }
-- `category` must match the `label` of one of the categories above.
Config.JobOverrides = {
    -- ['police'] = { label = 'Los Santos Police Department' },
}

-- ─────────────────────────────────────────────────────────────
-- Heists
-- ─────────────────────────────────────────────────────────────
-- requiredCops = number of online police (Config.PoliceJobs) needed for the heist to show as available
Config.Heists = {
    { id = 'fleeca',   label = 'Fleeca Bank',   icon = 'fa-building-columns', requiredCops = 2 },
    { id = 'jewelry',  label = 'Jewelry Store', icon = 'fa-ring',             requiredCops = 3 },
    { id = 'pacific',  label = 'Pacific Bank',  icon = 'fa-vault',            requiredCops = 5 },
    { id = 'humane',   label = 'Humane Labs',   icon = 'fa-flask',            requiredCops = 6 },
}

-- ─────────────────────────────────────────────────────────────
-- Admin tags
-- ─────────────────────────────────────────────────────────────
-- Key = ESX group name (xPlayer.getGroup()). `label` is the text shown in the tag.
-- Groups that are not listed here get no tag.
Config.AdminGroups = {
    owner = { label = 'Owner',     color = '#f87171' },
    admin = { label = 'Admin',     color = '#fbbf24' },
    mod = { label = 'Moderator', color = '#60a5fa' },
}

-- ─────────────────────────────────────────────────────────────
-- Texts (translate here)
-- ─────────────────────────────────────────────────────────────
Config.Locale = {
    ui_players          = 'Players',
    ui_jobs             = 'Jobs',
    ui_heists           = 'Heists',
    ui_compact          = 'Compact',
    ui_full             = 'Full',
    ui_close            = 'Close',
    ui_toggle           = 'Toggle Mode',
    ui_search_players   = 'Search players...',
    ui_search_jobs      = 'Search jobs...',
    ui_search_heists    = 'Search heists...',
    ui_no_players       = 'No players found',
    ui_no_jobs          = 'No jobs found',
    ui_no_heists        = 'No heists found',
    ui_online           = 'online',
    ui_pin              = 'Pin Job',
    ui_unpin            = 'Unpin Job',
    ui_cops_enough      = 'Available',
    ui_cops_not_enough  = 'Not enough cops',
    ui_requires_cops    = 'Requires {n} police',
}

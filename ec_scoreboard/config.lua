Config = {}

Config.ServerName = 'Eclipse Development'

Config.MaxPlayers = 64

Config.Command = 'scoreboard'
Config.OpenKey = 'TAB'
Config.OpenKeyDescription = 'Open scoreboard'

Config.BlockWeaponWheel = false

Config.DefaultMode = 'compact'

Config.RememberMode = true

Config.ShowPing = true

Config.ShowLogo = false

Config.UseCharacterNames = false

Config.RefreshInterval = 3000

Config.JobRefreshMinutes = 10

Config.JobsTable = 'jobs'

Config.BlacklistedJobs = {
    'unemployed',
}

Config.DefaultPinnedJobs = {
    'police',
    'ambulance',
}

Config.ShowEmptyJobs = true

Config.CountOnlyOnDuty = false

Config.PoliceJobs = {
    'police',
    'sheriff',
}

Config.JobCategories = {
    { label = 'Law Enforcement', icon = 'fa-shield-halved', color = '#60a5fa', jobs = { 'police', 'sheriff', 'state', 'fib' } },
    { label = 'Medical',         icon = 'fa-heart-pulse',   color = '#f87171', jobs = { 'ambulance', 'ems', 'doctor' } },
    { label = 'Mechanic',        icon = 'fa-wrench',        color = '#fb923c', jobs = { 'mechanic', 'bennys', 'tuner' } },
    { label = 'Restaurant',      icon = 'fa-burger',        color = '#facc15', jobs = { 'burgershot', 'pizzeria', 'cafe', 'bar', 'unicorn' } },
    { label = 'Services',        icon = 'fa-taxi',          color = '#e879f9', jobs = { 'taxi', 'tow', 'realestateagent' } },
}

Config.DefaultCategory = { label = 'Civilian', icon = 'fa-briefcase', color = '#9ca3af' }

Config.JobOverrides = {
}

Config.Heists = {
    { id = 'fleeca',   label = 'Fleeca Bank',   icon = 'fa-building-columns', requiredCops = 2 },
    { id = 'jewelry',  label = 'Jewelry Store', icon = 'fa-ring',             requiredCops = 3 },
    { id = 'pacific',  label = 'Pacific Bank',  icon = 'fa-vault',            requiredCops = 5 },
    { id = 'humane',   label = 'Humane Labs',   icon = 'fa-flask',            requiredCops = 6 },
}

Config.AdminGroups = {
    owner = { label = 'Owner',     color = '#f87171' },
    admin = { label = 'Admin',     color = '#fbbf24' },
    mod = { label = 'Moderator', color = '#60a5fa' },
}

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
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'TenTypeeek & 100Kary'
description '[Eclipse Development] Scoreboard'
version '1.0.2'

dependencies {
    'es_extended',
    'oxmysql'
}

shared_scripts {
    'config.lua',
    'shared/locale.lua'
}

client_script 'client/client.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

ui_page 'html/index.html'

files {
    'locales/*.json',
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/logo.png'
}

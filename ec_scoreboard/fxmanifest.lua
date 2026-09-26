fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'TenTypeeek & 100Kary'
description '[Eclipse Development] Scoreboard'
version '1.0.1'

dependencies {
    'es_extended',
    'oxmysql'
}

shared_script 'config.lua'

client_script 'client/main.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/logo.png'
}

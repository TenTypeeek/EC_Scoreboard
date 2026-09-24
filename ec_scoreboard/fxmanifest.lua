fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'ec_scoreboard'
description 'ESX scoreboard with players, jobs and heists'
version '1.0.0'

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
    'html/script.js'
}

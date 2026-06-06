fx_version 'cerulean'
game 'gta5'

author "ScriptCore.dk"
description "ScriptCore.dk | Airdrop SystemV2"
version "2.0.0"

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

ui_page 'html/index.html'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

escrow_ignore{
    "config.lua",
}
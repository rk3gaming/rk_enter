fx_version 'cerulean'
game 'gta5'

shared_script {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
}

client_scripts {
    'src/client/*.lua',
}

server_scripts {
    'src/server/*.lua',
}

files {
    'config/*.lua',
}

escrow_ignore {
    'config/*.lua',
}

lua54 'yes'
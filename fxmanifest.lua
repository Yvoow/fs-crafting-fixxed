fx_version 'cerulean'
game { 'gta5' }

author 'Fusion Scripts'
description 'Fusion Scripts crafting system'
version '1.0.0'
lua54 'yes'

shared_scripts {
  'config.lua',
  'init.lua',
  'locales/*.lua',
}

client_scripts {
  'client/opensource.lua',
  'client/functions.lua',
  'client/main.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'sv_config.lua',
  'server/opensource.lua',
  'server/utils.lua',
  'server/functions.lua',
  'server/main.lua',
}

ui_page 'web/dist/index.html'

files {
  'web/dist/*.*',
  'web/dist/assets/*.*',
  'web/dist/img/*.*',
}

escrow_ignore {
  '[INSTALLATION]/*',
  'client/opensource.lua',
  'server/opensource.lua',
  'config.lua',
  'sv_config.lua',
  'locales/*.lua',
  'init.lua',
}
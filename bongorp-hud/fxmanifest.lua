fx_version 'ogmarc3l'

game 'gta5'

lua54 'yes'


client_scripts {
    'client/*.lua',
}

ui_page "ui/index.html"

files {
    'ui/index.html',
    'ui/style.css',
    'ui/*.js',
    'ui/img/**/*.png',
    'ui/img/**/*.svg',
}

export 'RadarShown'


client_script "api-ac_BbBeYZbGgzYr.lua"
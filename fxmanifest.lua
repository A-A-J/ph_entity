fx_version "adamant"
game "gta5"

description "Powerful entity info/copy tool"
author 'PH'
version '1.0.0'

shared_scripts {
	'@ox_lib/init.lua'
}

ox_lib 'locale'

ui_page "ui/index.html"

client_scripts {
	"client/*.lua"
}

server_scripts {
	"server.lua"
}

files {
	"ui/index.html",
	"locales/*.json",
	"shared/config.lua"
}

lua54 'yes'
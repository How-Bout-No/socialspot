resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/index.html'

client_scripts {
	'config.lua',
	'client.lua'
}
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

files {
    'html/index.html',
    'html/stylesheet.css',
    'html/reset.css',
    'config.css',
    'config.js',
    'config.lua',
    'html/listener.js',
    'html/img/user_blank.png'
}
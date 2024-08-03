fx_version "cerulean"
game "gta5"

author "iZeyy"
github "https://github.com/izEyy442";
version "1.0.0"
lua54 "yes"

-- RageUI
client_scripts {
    "Client/Lib/init.lua",
    "Client/Lib/menu/RageUI.lua",
    "Client/Lib/menu/Menu.lua",
    "Client/Lib/menu/MenuController.lua",
    "Client/Lib/components/*.lua",
    "Client/Lib/menu/elements/*.lua",
    "Client/Lib/menu/items/*.lua",
    "Client/Lib/menu/panels/*.lua",
    "Client/Lib/menu/windows/*.lua",
}

client_scripts {

    "Client/Files/client.lua"

}

server_scripts {

    "Server/Files/server.lua"

}

shared_scripts {

    "Shared/Classes/BaseObject.lua",
    "Shared/Classes/Class.lua",
    "Shared/Classes/Index.lua",
    "Shared/Config.lua",

}

files(

    "Server/Data/Blips.json"

)

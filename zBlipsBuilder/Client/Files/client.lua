ESX = exports["Framework"]:getSharedObject()

local BuilderMenu = RageUI.AddMenu("", "BlipsBuilder")

local BlipName = nil
local BlipsPos = nil

local BlipTypes = {
    BlipTypesList = {},
    BlipTypesListIndex = 1
}

local BlipColor = {
    BlipColorList = {},
    BlipColorListIndex = 1
}

local BlipSize = {
    BlipSizeList = {
        0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0
    },
    BlipSizeListIndex = 1
}

for i = 1, 883 do
    table.insert(BlipTypes.BlipTypesList, i)
end

for i = 1, 85 do
    table.insert(BlipColor.BlipColorList, i)
end

local NameIsValid = false
local PosIsValid = false
local TypeIsValid = false
local ColorIsValid = false
local SizeIsValid = false

-- Make sure you have a JSON library for Lua
local json = require("json")

-- Function for creating blips and saving them as JSON
function CreateBlips()
    local blipsData = {
        name = BlipName,
        position = BlipsPos,
        type = BlipTypes.BlipTypesList[BlipTypes.BlipTypesListIndex],
        color = BlipColor.BlipColorList[BlipColor.BlipColorListIndex],
        size = BlipSize.BlipSizeList[BlipSize.BlipSizeListIndex]
    }

    local jsonData = json.encode(blipsData)
    local file = io.open("blips.json", "w")
    if file then
        file:write(jsonData)
        file:close()
        ESX.ShowNotification("Blips créé et sauvegardé en JSON")
    else
        ESX.ShowNotification("Erreur lors de la sauvegarde des blips en JSON")
    end
end

-- Builder Menu
BuilderMenu:IsVisible(function(Items)

    Items:Button("Reset the current settings", nil, { RightLabel = "→→" }, true, {
        onSelected = function()
            NameIsValid = false
            PosIsValid = false
            TypeIsValid = false
            ColorIsValid = false
            SizeIsValid = false
            -- 
            BlipName = nil
            BlipsPos = nil
            BlipTypes.BlipTypesListIndex = 1
            BlipColor.BlipColorListIndex = 1
            BlipSize.BlipSizeListIndex = 1
            --
            ESX.ShowNotification("Settings reset")
        end
    })

    Items:Line()

    Items:Button("Blips name", nil, { RightLabel = BlipName or "→→" }, true, {
        onSelected = function()
            local name = KeyboardInput("Blips name (Max 20 characters)", "", 20)
            if name and name ~= "" then
                BlipName = name
                ESX.ShowNotification("Name: " .. name)
                NameIsValid = true
            else
                ESX.ShowNotification("Invalid name")
            end
        end
    })

    Items:Button("Blip position", nil, { RightLabel = BlipsPos or "→→" }, true, {
        onSelected = function()
            local coords = GetEntityCoords(PlayerPedId())
            ESX.ShowNotification("Position: " .. string.format("(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z))
            BlipsPos = string.format("(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z)
            PosIsValid = true
        end
    })

    Items:List("Blips type", BlipTypes.BlipTypesList, BlipTypes.BlipTypesListIndex, "Press ~h~ENTER~h~ to confirm (Use the FiveM documentation for more information.)", {}, true, {
        onListChange = function(index)
            BlipTypes.BlipTypesListIndex = index
        end,
        onSelected = function(index)
            ESX.ShowNotification("Type: " .. BlipTypes.BlipTypesList[index])
            TypeIsValid = true
        end
    })

    Items:List("Blips color", BlipColor.BlipColorList, BlipColor.BlipColorListIndex, "Press ~h~ENTER~h~ to confirm (Use the FiveM documentation for more information.)", {}, true, {
        onListChange = function(index)
            BlipColor.BlipColorListIndex = index
        end,
        onSelected = function(index)
            ESX.ShowNotification("Color: " .. BlipColor.BlipColorList[index])
            ColorIsValid = true
        end
    })

    Items:List("Blips size", BlipSize.BlipSizeList, BlipSize.BlipSizeListIndex, "Press ~h~ENTER~h~ to confirm (Recommended: 0.6)", {}, true, {
        onListChange = function(index)
            BlipSize.BlipSizeListIndex = index
        end,
        onSelected = function(index)
            ESX.ShowNotification("Size: " .. BlipSize.BlipSizeList[index])
            SizeIsValid = true
        end
    })

    if NameIsValid and TypeIsValid and ColorIsValid and SizeIsValid and PosIsValid then

        Items:Line()

        Items:Button("Create the Blips", nil, { RightLabel = "→→" }, true, {
            onSelected = function()
                NameIsValid = false
                PosIsValid = false
                TypeIsValid = false
                ColorIsValid = false
                SizeIsValid = false
                -- Send data to the server
                local blipData = {
                    {
                        name = BlipName,
                        position = BlipsPos,
                        type = BlipTypes.BlipTypesList[BlipTypes.BlipTypesListIndex],
                        color = BlipColor.BlipColorList[BlipColor.BlipColorListIndex],
                        size = BlipSize.BlipSizeList[BlipSize.BlipSizeListIndex]
                    }
                }
                TriggerServerEvent('zBlipsBuilder:saveBlips', blipData)
                -- Reset variables after sending data
                BlipName = nil
                BlipsPos = nil
                BlipTypes.BlipTypesListIndex = 1
                BlipColor.BlipColorListIndex = 1
                BlipSize.BlipSizeListIndex = 1
                -- Close the menu after sending data
                BuilderMenu:Close()
                Wait(100)
                RequestBlips()
                ESX.ShowNotification("Blips created successfully")
            end
        })
    end

end)

-- Command to open the builder menu
RegisterCommand("createBlips", function()
    local PlayerData = ESX.GetPlayerData()
    if PlayerData.group == "founder" then -- @todo Change this to your group name
        BuilderMenu:Open()
    else
        ESX.ShowNotification("You are not allowed to use this command")
    end
end)

-- Create Blips
RegisterNetEvent('zBlipsBuilder:receiveBlips')
AddEventHandler('zBlipsBuilder:receiveBlips', function(blipData)
    for _, blip in ipairs(blipData) do
        local newBlip = AddBlipForCoord(blip.position.x, blip.position.y, blip.position.z)
        if newBlip then
            SetBlipSprite(newBlip, blip.type)
            SetBlipDisplay(newBlip, 4)
            SetBlipScale(newBlip, blip.size)
            SetBlipColour(newBlip, blip.color)
            SetBlipAsShortRange(newBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blip.name)
            EndTextCommandSetBlipName(newBlip)
        end
    end
end)

-- Functions Display Keyboard Input
function KeyboardInput(title, defaultText, maxLength)

    AddTextEntry('FMMC_KEY_TIP1', title)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", defaultText, "", "", "", maxLength)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        return GetOnscreenKeyboardResult()
    end

    return nil
    
end

-- This function is used to parse the position string into a table
function RequestBlips()
    TriggerServerEvent('zBlipsBuilder:requestBlips')
end

-- This function is used when the resource starts in order to display the blips
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    RequestBlips()
end)
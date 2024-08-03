local json = require("json")

-- Function to load blip data from JSON file
function GetBlipData()
    local data = LoadResourceFile("BlipsBuilder", "Server/Data/Blips.json")
    return data and json.decode(data) or {}
end

-- Function to save blip data to JSON file
function SaveBlipData(blipData)
    if not blipData or next(blipData) == nil then
        return
    end
    local jsonData = json.encode(blipData)
    SaveResourceFile("BlipsBuilder", "Server/Data/Blips.json", jsonData)
end

RegisterServerEvent('zBlipsBuilder:saveBlips')
AddEventHandler('zBlipsBuilder:saveBlips', function(blipData)
    if not blipData or next(blipData) == nil then
        return
    end
    
    local existingBlipsData = GetBlipData()
    
    for _, blip in ipairs(blipData) do
        table.insert(existingBlipsData, blip)
    end
    
    SaveBlipData(existingBlipsData)
end)

-- Register the network event
RegisterNetEvent('zBlipsBuilder:requestBlips')
AddEventHandler('zBlipsBuilder:requestBlips', function()
    local src = source
    local blipData = GetBlipData()
    if blipData == nil or #blipData == 0 then
        return
    end
    TriggerClientEvent('zBlipsBuilder:receiveBlips', src, blipData)
end)

-- Function to parse position string
local function parsePosition(posString)
    if not posString then
        return nil
    end
    local x, y, z = posString:match("%(([^,]+), ([^,]+), ([^)]+)%)")
    if not x or not y or not z then
        return nil
    end
    return { x = tonumber(x), y = tonumber(y), z = tonumber(z) }
end

-- Function to Get Blip Data
function GetBlipData()
    local data = LoadResourceFile("BlipsBuilder", "Server/Data/Blips.json")
    if not data then
        return {}
    end

    local decodedData = json.decode(data)
    if not decodedData then
        return {}
    end

    for _, blip in ipairs(decodedData) do
        if type(blip.position) == "string" then
            local parsedPosition = parsePosition(blip.position)
            if parsedPosition then
                blip.position = parsedPosition
            end
        elseif type(blip.position) == "table" then
            if blip.position.x and blip.position.y and blip.position.z then
                blip.position = { x = blip.position.x, y = blip.position.y, z = blip.position.z }
            end
        end
    end

    return decodedData
end

-- Function to save blip data to JSON file
function SaveBlipData(blipData)
    if not blipData or next(blipData) == nil then
        return
    end
    local jsonData = json.encode(blipData)
    SaveResourceFile("BlipsBuilder", "Server/Data/Blips.json", jsonData)
    print("[^9zBlipsBuilder^7] The blips has been successfully created and saved in the folder (^9Server/Data/Blips.json^7)")
end

-- Resource Start
AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local blipData = GetBlipData()
        if blipData then
            print("[^9zBlipsBuilder^7] This script was created by ^9iZeyy^7 in open source. Please do not sell it.")
            print("[^9zBlipsBuilder^7] If you have any questions, please contact me on Discord: ^923h23^7")
            print("[^9zBlipsBuilder^7] The blips has been successfully loaded from the folder (^9Server/Data/Blips.json^7)")
        elseif blipData == nil or #blipData == 0 then
            print("[^9zBlipsBuilder^7] This script was created by ^9iZeyy^7 in open source. Please do not sell it.")
            print("[^9zBlipsBuilder^7] If you have any questions, please contact me on Discord: ^923h23^7")
            print("[^9zBlipsBuilder^7] The blips file is empty or does not exist")
        end
    end
end)
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('tg-realescort:server:getescort')
AddEventHandler('tg-realescort:server:getescort', function()
    local src = source
    TriggerClientEvent('tg-realescort:client:escortplayer', src)
end)

RegisterNetEvent('tg-realescort:server:escortplayer', function(playerId)
    local src = source
    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)
    local targetCoords = GetEntityCoords(targetPed)
    if #(playerCoords - targetCoords) > 2.5 then 
        return
    end
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if not Player or not EscortPlayer then 
        return 
    end
    if (Player.PlayerData.job.type == "leo" or Player.PlayerData.job.type == "ambulance") then
        TriggerClientEvent('tg-realescort:client:escortanimation', src)
        TriggerClientEvent("tg-realescort:client:getescorted", EscortPlayer.PlayerData.source, Player.PlayerData.source)
    else
        TriggerClientEvent('QBCore:Notify', src,"Your profession is not suitable for this", 'error')
    end
end)

RegisterNetEvent('tg-realescort:server:isescortingplayer', function(bool, playerId)
    TriggerClientEvent('tg-realescort:client:setescortstatus', playerId, bool)
end)
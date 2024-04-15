local QBCore = exports['qb-core']:GetCoreObject()
local isEscorting = false
local isBeingEscorted = false

RegisterNetEvent('tg-realescort:client:escortplayer', function()
    local player, distance = QBCore.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not isEscorted then
            TriggerServerEvent("tg-realescort:server:escortplayer", playerId)
        else
        end
    else
        QBCore.Functions.Notify("Player Not Found", "error")
    end
end)

RegisterNetEvent('tg-realescort:client:escortanimation', function()
    if isEscorting then
        ClearPedTasks(PlayerPedId())
        isEscorting = false
    else
        isEscorting = true
        QBCore.Functions.RequestAnimDict('amb@world_human_drinking@coffee@male@base')
        if IsEntityPlayingAnim(PlayerPedId(), 'amb@world_human_drinking@coffee@male@base', 'base', 3) ~= 1 then
            TaskPlayAnim(PlayerPedId(), 'amb@world_human_drinking@coffee@male@base', 'base', 8.0, -8, -1, 51, 0, false, false, false)
        end
    end
end)

RegisterNetEvent('tg-realescort:client:getescorted', function(playerId)
    local ped = PlayerPedId()
    if not isEscorted then
        isEscorted = true
        local dragger = GetPlayerPed(GetPlayerFromServerId(playerId))
        TriggerServerEvent('tg-realescort:server:isescortingplayer', true, playerId)
        SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(dragger, 0.0, 0.45, 0.0))
        AttachEntityToEntity(ped, dragger, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        if cuffType ~= 49 then
            TempcuffType = cuffType
            cuffType = 49
        end
        ToggleEscort(dragger)
    else
        isEscorted = false
        cuffType = TempcuffType
        DetachEntity(ped, true, false)
        TriggerServerEvent('tg-realescort:server:isescortingplayer', false, playerId)
        StopEscort()
    end
    TriggerEvent('hospital:client:isEscorted', isEscorted)
end)

RegisterNetEvent('tg-realescort:client:setescortstatus', function(bool)
    isEscorted = bool
end)

function ToggleEscort(dragger)
    isBeingEscorted = not isBeingEscorted
    if isBeingEscorted then
        SyncEscortWalking(dragger)
    end
end

function StopEscort()
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    isBeingEscorted = false
end

function SyncEscortWalking(dragger)
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        while isBeingEscorted do
            local speed = GetEntitySpeed(dragger)
            local shouldPlayAnim = speed > 0.2
            if shouldPlayAnim then
                local animDict = 'move_m@casual@d'
                local animName = 'walk'
                if not IsEntityPlayingAnim(ped, animDict, animName, 3) then
                    RequestAnimDict(animDict)
                    while not HasAnimDictLoaded(animDict) do
                        Wait(10)
                    end
                    TaskPlayAnim(ped, animDict, animName, 8.0, -8, -1, 1, 0, false, false, false)
                end
            else
                ClearPedTasks(ped)
            end
            Citizen.Wait(500)
            if not isBeingEscorted then
                StopEscort()
                break
            end
        end
    end)
end

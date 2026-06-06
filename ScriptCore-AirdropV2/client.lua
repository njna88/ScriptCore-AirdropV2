local ESX = exports["es_extended"]:getSharedObject()

-- Sikkerhedscheck og loop
CreateThread(function()
    if GetCurrentResourceName() ~= Config.ResourceName then
        while true do
            print("^1[FEJL] Mappenavnet skal være " .. Config.ResourceName .. "!^7")
            Wait(10000)
        end
    end
end)

-- UI Styring
function ToggleUI(display)
    SetNuiFocus(display, display)
    SendNUIMessage({ type = "ui", status = display })
end

RegisterNUICallback("closeMenu", function(data, cb)
    ToggleUI(false)
    cb('ok')
end)

RegisterNUICallback("confirmAirdrop", function(data, cb)
    local zone = Config.DropZones[data.location]
    if zone then
        TriggerServerEvent('airdrop:requestSync', zone.coords, data.package, zone.name)
    end
    ToggleUI(false)
    cb('ok')
end)

RegisterCommand("AirdropV2", function()
    ESX.TriggerServerCallback('airdrop:checkAdmin', function(hasPermission)
        if hasPermission then ToggleUI(true) else
            exports.ox_lib:notify({ title = 'Adgang Nægtet', type = 'error' })
        end
    end)
end)

-- Airdrop Logik
RegisterNetEvent('airdrop:spawnClient')
AddEventHandler('airdrop:spawnClient', function(coords, packageType)
    RequestModel(Config.PlaneModel)
    RequestModel(Config.BoxModel)
    while not HasModelLoaded(Config.PlaneModel) or not HasModelLoaded(Config.BoxModel) do Wait(0) end

    -- Blip Zone
    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, 128)

    -- Fly (Bombushka)
    local plane = CreateVehicle(Config.PlaneModel, coords.x, coords.y, coords.z + 250.0, 0.0, false, false)
    SetEntityVelocity(plane, 0.0, 45.0, 0.0)

    -- Drop Loop (3 kasser)
    for i = 1, Config.AmountOfBoxes do
        Wait(1500)
        local offsetX, offsetY = math.random(-30, 30), math.random(-30, 30)
        local drop = CreateObject(Config.BoxModel, coords.x + offsetX, coords.y + offsetY, coords.z + 220.0, true, true, true)
        
        -- Rotation og Fysik
        SetEntityRotation(drop, math.random(0,360)+0.0, math.random(0,360)+0.0, math.random(0,360)+0.0, 2, true)
        SetEntityHasGravity(drop, true)
        ActivatePhysics(drop)
        ApplyForceToEntity(drop, 1, math.random(-2, 2)+0.0, math.random(-2, 2)+0.0, 0.0, 0.0, 0.0, 0.0, 0, false, true, true, false, true)

        -- Røg
        RequestNamedPtfxAsset("core")
        while not HasNamedPtfxAssetLoaded("core") do Wait(0) end
        UseParticleFxAssetNextCall("core")
        StartNetworkedParticleFxLoopedOnEntity("exp_grd_flare", drop, 0.0, 0.0, 0.5, 0.0, 0.0, 0.0, 2.5, false, false, false)

        -- OX_TARGET FIX (Dette virker nu!)
        exports.ox_target:addLocalEntity(drop, {
            {
                name = 'open_airdrop_'..drop,
                icon = 'fa-solid fa-box-open',
                label = 'Åbn Airdroppet...',
                onSelect = function()
                    OpenAirdrop(drop, packageType)
                end,
                distance = 2.5
            }
        })
    end

    SetTimeout(300000, function() RemoveBlip(blip) end)
end)

-- ProgressBar Funktion (Fixet global 'lib')
function OpenAirdrop(entity, packageType)
    if exports.ox_lib:progressBar({
        duration = 5000,
        label = 'Tømmer Airdroppet...',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true },
        anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' }
    }) then 
        TriggerServerEvent('airdrop:giveRewards', packageType)
        DeleteEntity(entity)
    else
        exports.ox_lib:notify({ title = 'Annulleret', type = 'error' })
    end
end
local ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('airdrop:checkAdmin', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local group = xPlayer.getGroup()
        cb(group == 'admin' or group == 'mod' or group == 'superadmin')
    else
        cb(false)
    end
end)

RegisterServerEvent('airdrop:requestSync')
AddEventHandler('airdrop:requestSync', function(coords, packageType, zoneName)
    TriggerClientEvent('airdrop:spawnClient', -1, coords, packageType)
    
    TriggerClientEvent('ox_lib:notify', -1, {
        title = 'AIRDROP',
        description = 'En Bombushka smider Airdrop´s over ' .. zoneName,
        type = 'inform',
        duration = 10000
    })
end)

RegisterServerEvent('airdrop:giveRewards')
AddEventHandler('airdrop:giveRewards', function(packageType)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local rewards = Config.Rewards[packageType]

    if xPlayer and rewards then
        for _, data in pairs(rewards) do
            if data.item == "black_money" then
                xPlayer.addAccountMoney('black_money', data.amount)
            else
                local count = math.random(data.min, data.max)
                xPlayer.addInventoryItem(data.item, count)
            end
        end
    end
end)
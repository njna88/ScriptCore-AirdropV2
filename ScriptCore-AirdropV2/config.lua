Config = {}

Config.ResourceName = "ScriptCore-AirdropV2"
Config.PlaneModel = `bombushka`
Config.BoxModel = `prop_boxpile_07d`
Config.AmountOfBoxes = 1

Config.DropZones = {
    [1] = {coords = vector3(1741.0, 3269.0, 41.0), name = "Sandy Lufthavn"},
    [2] = {coords = vector3(2132.0, 4778.0, 41.0), name = "Grapeseed"},
    [3] = {coords = vector3(80.0, -2397.0, 6.0), name = "Havnen"},
    [4] = {coords = vector3(-1042.6813, -3517.9507, 14.1434), name = "Lufthavnen"},
    [5] = {coords = vector3(-2234.0, 263.0, 174.0), name = "Kortz"},
    [6] = {coords = vector3(-265.0149, 6564.8325, 2.6383), name = "Paleto Bay"}
}

Config.Rewards = {
    ["illegal_drugs"] = {
        {item = "coke_pooch", min = 100, max = 250},
        {item = "weed_pooch", min = 100, max = 250}
    },
    ["heavy_weapons"] = {
        {item = "ammo-50", min = 100, max = 400}
    },
    ["criminal_package"] = {
        {item = "black_money", amount = 50000}
    },
    ["supplies"] = {
        {item = "bread", min = 50, max = 50},
        {item = "water", min = 50, max = 50}
    }
}
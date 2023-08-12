local directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', } 

local Zones = {
    ['AIRP'] = 'Los Santos International Airport',
    ['ALAMO'] = 'Alamo Sea',
    ['ALTA'] = 'Alta',
    ['ARMYB'] = 'Fort Zancudo',
    ['BANHAMC'] = 'Banham Canyon Dr',
    ['BANNING'] = 'Banning',
    ['BEACH'] = 'Vespucci Beach',
    ['BHAMCA'] = 'Banham Canyon',
    ['BRADP'] = 'Braddock Pass',
    ['BRADT'] = 'Braddock Tunnel',
    ['BURTON'] = 'Burton',
    ['CALAFB'] = 'Calafia Bridge',
    ['CANNY'] = 'Raton Canyon',
    ['CCREAK'] = 'Cassidy Creek',
    ['CHAMH'] = 'Chamberlain Hills',
    ['CHIL'] = 'Vinewood Hills',
    ['CHU'] = 'Chumash',
    ['CMSW'] = 'Chiliad Mountain State Wilderness',
    ['CYPRE'] = 'Cypress Flats',
    ['DAVIS'] = 'Davis',
    ['DELBE'] = 'Del Perro Beach',
    ['DELPE'] = 'Del Perro',
    ['DELSOL'] = 'La Puerta',
    ['DESRT'] = 'Grand Senora Desert',
    ['DOWNT'] = 'Downtown',
    ['DTVINE'] = 'Downtown Vinewood',
    ['EAST_V'] = 'East Vinewood',
    ['EBURO'] = 'El Burro Heights',
    ['ELGORL'] = 'El Gordo Lighthouse',
    ['ELYSIAN'] = 'Elysian Island',
    ['GALFISH'] = 'Galilee',
    ['GOLF'] = 'GWC and Golfing Society',
    ['GRAPES'] = 'Grapeseed',
    ['GREATC'] = 'Great Chaparral',
    ['HARMO'] = 'Harmony',
    ['HAWICK'] = 'Hawick',
    ['HORS'] = 'Vinewood Racetrack',
    ['HUMLAB'] = 'Humane Labs and Research',
    ['JAIL'] = 'Bolingbroke Penitentiary',
    ['KOREAT'] = 'Little Seoul',
    ['LACT'] = 'Land Act Reservoir',
    ['LAGO'] = 'Lago Zancudo',
    ['LDAM'] = 'Land Act Dam',
    ['LEGSQU'] = 'Legion Square',
    ['LMESA'] = 'La Mesa',
    ['LOSPUER'] = 'La Puerta',
    ['MIRR'] = 'Mirror Park',
    ['MORN'] = 'Morningwood',
    ['MOVIE'] = 'Richards Majestic',
    ['MTCHIL'] = 'Mount Chiliad',
    ['MTGORDO'] = 'Mount Gordo',
    ['MTJOSE'] = 'Mount Josiah',
    ['MURRI'] = 'Murrieta Heights',
    ['NCHU'] = 'North Chumash',
    ['NOOSE'] = 'N.O.O.S.E',
    ['OCEANA'] = 'Pacific Ocean',
    ['PALCOV'] = 'Paleto Cove',
    ['PALETO'] = 'Paleto Bay',
    ['PALFOR'] = 'Paleto Forest',
    ['PALHIGH'] = 'Palomino Highlands',
    ['PALMPOW'] = 'Palmer-Taylor Power Station',
    ['PBLUFF'] = 'Pacific Bluffs',
    ['PBOX'] = 'Pillbox Hill',
    ['PROCOB'] = 'Procopio Beach',
    ['RANCHO'] = 'Rancho',
    ['RGLEN'] = 'Richman Glen',
    ['RICHM'] = 'Richman',
    ['ROCKF'] = 'Rockford Hills',
    ['RTRAK'] = 'Redwood Lights Track',
    ['SANAND'] = 'San Andreas',
    ['SANCHIA'] = 'San Chianski Mountain Range',
    ['SANDY'] = 'Sandy Shores',
    ['SKID'] = 'Mission Row',
    ['SLAB'] = 'Stab City',
    ['STAD'] = 'Maze Bank Arena',
    ['STRAW'] = 'Strawberry',
    ['TATAMO'] = 'Tataviam Mountains',
    ['TERMINA'] = 'Terminal',
    ['TEXTI'] = 'Textile City',
    ['TONGVAH'] = 'Tongva Hills',
    ['TONGVAV'] = 'Tongva Valley',
    ['VCANA'] = 'Vespucci Canals',
    ['VESP'] = 'Vespucci',
    ['VINE'] = 'Vinewood',
    ['WINDF'] = 'Ron Alternates Wind Farm',
    ['WVINE'] = 'West Vinewood',
    ['ZANCUDO'] = 'Zancudo River',
    ['ZP_ORT'] = 'Port of South Los Santos',
    ['ZQ_UAR'] = 'Davis Quartz'
}

RegisterCommand("hud", function(src, args, raw)
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "toggleSettings"
        })
end, false)

RegisterNUICallback("sendRequest", function(data,cb) 
    SetNuiFocus(false, false)
    cb({})
end)

CreateThread(function()
    while true do
            Citizen.Wait(250)

            TriggerEvent('esx_status:getStatus', 'hunger', function(status)
                hunger = status.getPercent()
            end)
            TriggerEvent('esx_status:getStatus', 'thirst', function(status)
                thirst = status.getPercent()
            end)
            local hp = GetEntityHealth(PlayerPedId()) - 100
            local armor = GetPedArmour(PlayerPedId())

            if NetworkGetTalkerProximity() == 1.5 then
                ile = 10
            elseif NetworkGetTalkerProximity() == 6.0 then
                ile = 30
            elseif NetworkGetTalkerProximity() == 15.0 then
                ile = 100
            end
    
            SendNUIMessage({
                action = 'updateStatus',
                hp = hp,
                armor = armor,
                hunger = hunger,
                thirst = thirst,
                inwater = IsPedSwimmingUnderWater(PlayerPedId()),
                oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId())*10,
                voiceProximity = ile
            })    
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300)
        local state = NetworkIsPlayerTalking(PlayerId())
        if state then
            value = true
        else
            value = false
        end

        SendNUIMessage({
            action = 'toggleSpeaking',
            toggle = value
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            DisplayRadar(true)
            Wait(70)
            SendNUIMessage({
                action = "toggleCarHud",
                toggle = true
            })

            local p = PlayerId()
            local sId = GetPlayerServerId(p)
            SendNUIMessage({action = 'setId', id = sId})

            local PedCar = GetVehiclePedIsUsing(PlayerPedId(), false)
            local speed = (GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1))))
            local finalSpeed = math.ceil(speed * 3.6)
            local x, y, z = table.unpack(GetEntityCoords(ped))
            local ul, ul2 = GetStreetNameAtCoord(x, y, z)
            local ulica = GetStreetNameFromHashKey(ul)
            local coords = GetEntityCoords(ped);
            local rpm = GetVehicleCurrentRpm(GetVehiclePedIsIn(GetPlayerPed(-1)))
            local finalRPM = rpm*100
            local zone = GetNameOfZone(coords.x, coords.y, coords.z);
            local ped, direction = PlayerPedId(), nil
            for k, v in pairs(directions) do
                direction = GetEntityHeading(ped)
                if math.abs(direction - k) < 22.5 then
                    direction = v
                    break
                end
            end
            zonekoncowy = (Zones[zone:upper()] or zone:upper())
            SendNUIMessage({
                action = "updateCarHud",
                speed = finalSpeed,
                gear = GetVehicleCurrentGear(PedCar),
                street = ulica.. ", " ..zonekoncowy,
                direction = direction,
                rpm = finalRPM
            })
        else
            DisplayRadar(false)
            SendNUIMessage({
                action = "toggleCarHud",
                toggle = false
            })
        end
    end
end)

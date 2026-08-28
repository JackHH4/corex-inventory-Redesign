--[[
    Portable vehicle persistence:
    ox_target pickup -> inventory item -> deploy in front of player.

    The filename is kept for upgrade compatibility; the implementation is no
    longer bicycle-specific.
]]

local Corex

local function EnsureCore()
    if Corex then return true end
    local ok, core = pcall(function()
        return exports['corex-core']:GetCoreObject()
    end)
    Corex = ok and core or nil
    return Corex ~= nil
end

CreateThread(function()
    repeat
        Wait(200)
        EnsureCore()
    until Corex
end)

local function Notify(msg, typ, duration)
    if EnsureCore() and Corex.Functions and Corex.Functions.Notify then
        Corex.Functions.Notify(msg, typ or 'inform', duration or 4500)
    end
end

RegisterNetEvent('corex-inventory:client:portableVehicleNotify', function(message, typ)
    Notify(message, typ)
end)

RegisterNetEvent('corex-inventory:client:rentalBikeNotify', function(message, typ)
    Notify(message, typ)
end)

-- Local cache of vehicles this client registered as portable (covers state-bag delay)
LocalPortableVehicles = LocalPortableVehicles or {}

local function MarkLocalPortable(vehicle)
    if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
        LocalPortableVehicles[vehicle] = true
    end
end

local function IsLocalPortable(vehicle)
    if not vehicle or vehicle == 0 then return false end
    if LocalPortableVehicles[vehicle] then return true end
    return false
end

RegisterNetEvent('corex-inventory:client:portableVehicleRegistered', function(netId)
    netId = tonumber(netId)
    if not netId or netId == 0 then return end
    local ent = NetworkGetEntityFromNetworkId(netId)
    if ent and ent ~= 0 then
        MarkLocalPortable(ent)
    end
end)

local function LoadVehicleModel(model)
    if Corex and Corex.Functions and Corex.Functions.LoadModel then
        return Corex.Functions.LoadModel(model, 5000)
    end

    local hash = GetHashKey(model)
    RequestModel(hash)

    local deadline = GetGameTimer() + 5000
    while not HasModelLoaded(hash) and GetGameTimer() < deadline do
        Wait(50)
    end

    return HasModelLoaded(hash)
end


---Capture full visual/performance state so pickup → deploy keeps mods.
local function CaptureVehicleProps(veh)
    if not veh or veh == 0 or not DoesEntityExist(veh) then return nil end
    SetVehicleModKit(veh, 0)

    local props = {
        model = GetEntityModel(veh),
        plate = GetVehicleNumberPlateText(veh),
        plateIndex = GetVehicleNumberPlateTextIndex(veh),
        wheelType = GetVehicleWheelType(veh),
        windowTint = GetVehicleWindowTint(veh),
        dirtLevel = GetVehicleDirtLevel(veh),
        mods = {},
        toggles = {},
        extras = {},
        neonEnabled = {
            IsVehicleNeonLightEnabled(veh, 0),
            IsVehicleNeonLightEnabled(veh, 1),
            IsVehicleNeonLightEnabled(veh, 2),
            IsVehicleNeonLightEnabled(veh, 3)
        }
    }

    local r, g, b = GetVehicleNeonLightsColour(veh)
    props.neonColour = { r, g, b }

    if GetVehicleXenonLightsColor then
        props.xenonColour = GetVehicleXenonLightsColor(veh)
    end

    local primary, secondary = GetVehicleColours(veh)
    local pearlescent, wheelCol = GetVehicleExtraColours(veh)
    props.colours = {
        primary = primary,
        secondary = secondary,
        pearlescent = pearlescent,
        wheel = wheelCol
    }

    local r1, g1, b1 = GetVehicleCustomPrimaryColour(veh)
    local r2, g2, b2 = GetVehicleCustomSecondaryColour(veh)
    props.customPrimary = { r1, g1, b1 }
    props.customSecondary = { r2, g2, b2 }

    for i = 0, 49 do
        props.mods[tostring(i)] = GetVehicleMod(veh, i)
        props.toggles[tostring(i)] = IsToggleModOn(veh, i)
    end

    for extraId = 0, 20 do
        if DoesExtraExist(veh, extraId) then
            props.extras[tostring(extraId)] = IsVehicleExtraTurnedOn(veh, extraId)
        end
    end

    props.livery = GetVehicleLivery(veh)
    props.roofLivery = GetVehicleRoofLivery and GetVehicleRoofLivery(veh) or nil

    return props
end

local function ApplyVehicleProps(veh, props)
    if not veh or veh == 0 or not DoesEntityExist(veh) or type(props) ~= 'table' then return end
    SetVehicleModKit(veh, 0)

    if props.wheelType ~= nil then
        SetVehicleWheelType(veh, tonumber(props.wheelType) or 0)
    end

    if type(props.colours) == 'table' then
        SetVehicleColours(veh, tonumber(props.colours.primary) or 0, tonumber(props.colours.secondary) or 0)
        SetVehicleExtraColours(veh, tonumber(props.colours.pearlescent) or 0, tonumber(props.colours.wheel) or 0)
    end

    if type(props.customPrimary) == 'table' then
        SetVehicleCustomPrimaryColour(veh, props.customPrimary[1] or 0, props.customPrimary[2] or 0, props.customPrimary[3] or 0)
    end
    if type(props.customSecondary) == 'table' then
        SetVehicleCustomSecondaryColour(veh, props.customSecondary[1] or 0, props.customSecondary[2] or 0, props.customSecondary[3] or 0)
    end

    if type(props.mods) == 'table' then
        for k, v in pairs(props.mods) do
            local modType = tonumber(k)
            local index = tonumber(v)
            if modType ~= nil and index ~= nil then
                if index < 0 then
                    RemoveVehicleMod(veh, modType)
                else
                    local custom = (modType == 23 or modType == 24)
                    SetVehicleMod(veh, modType, index, custom)
                end
            end
        end
    end

    if type(props.toggles) == 'table' then
        for k, v in pairs(props.toggles) do
            local modType = tonumber(k)
            if modType ~= nil then
                ToggleVehicleMod(veh, modType, v and true or false)
            end
        end
    end

    if type(props.extras) == 'table' then
        for k, on in pairs(props.extras) do
            local extraId = tonumber(k)
            if extraId ~= nil and DoesExtraExist(veh, extraId) then
                SetVehicleExtra(veh, extraId, not (on and true or false))
            end
        end
    end

    if props.windowTint ~= nil then
        SetVehicleWindowTint(veh, tonumber(props.windowTint) or 0)
    end
    if props.plateIndex ~= nil then
        SetVehicleNumberPlateTextIndex(veh, tonumber(props.plateIndex) or 0)
    end
    if props.livery ~= nil then
        SetVehicleLivery(veh, tonumber(props.livery) or -1)
    end
    if props.roofLivery ~= nil and SetVehicleRoofLivery then
        SetVehicleRoofLivery(veh, tonumber(props.roofLivery) or 0)
    end

    if type(props.neonEnabled) == 'table' then
        for i = 0, 3 do
            SetVehicleNeonLightEnabled(veh, i, props.neonEnabled[i + 1] and true or false)
        end
    end
    if type(props.neonColour) == 'table' then
        SetVehicleNeonLightsColour(veh, props.neonColour[1] or 0, props.neonColour[2] or 0, props.neonColour[3] or 0)
    end
    if props.xenonColour ~= nil and SetVehicleXenonLightsColor then
        SetVehicleXenonLightsColor(veh, tonumber(props.xenonColour) or -1)
    end
    if props.dirtLevel ~= nil then
        SetVehicleDirtLevel(veh, tonumber(props.dirtLevel) or 0.0)
    end
end


local function RegisterPortableVehicleNetworked(vehicle)
    CreateThread(function()
        local tries = 0
        local maxTries = 200 -- ~20s

        -- Ensure entity is networked before requesting net id
        if DoesEntityExist(vehicle) and not NetworkGetEntityIsNetworked(vehicle) then
            pcall(function()
                NetworkRegisterEntityAsNetworked(vehicle)
            end)
        end

        while tries < maxTries do
            if DoesEntityExist(vehicle) then
                if not NetworkGetEntityIsNetworked(vehicle) then
                    pcall(function()
                        NetworkRegisterEntityAsNetworked(vehicle)
                    end)
                end

                if NetworkGetEntityIsNetworked(vehicle) then
                    local netId = NetworkGetNetworkIdFromEntity(vehicle)
                    if netId and netId ~= 0 then
                        SetNetworkIdCanMigrate(netId, true)
                        SetNetworkIdExistsOnAllMachines(netId, true)
                        TriggerServerEvent('corex-inventory:server:finalizePortableVehicle', netId)
                        return
                    end
                end
            end

            tries = tries + 1
            Wait(100)
        end

        TriggerServerEvent('corex-inventory:server:portableVehicleDeployAborted')
    end)
end

AddEventHandler('corex-inventory:internal:markLocalPortable', function(vehicle)
    MarkLocalPortable(vehicle)
end)

AddEventHandler('corex-inventory:internal:registerPortableVehicleNet', function(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return end
    RegisterPortableVehicleNetworked(vehicle)
end)

AddEventHandler('corex-inventory:internal:registerRentalBikeNet', function(vehicle)
    TriggerEvent('corex-inventory:internal:registerPortableVehicleNet', vehicle)
end)

RegisterNetEvent('corex-inventory:client:deleteVehicleByNetId', function(netId)
    netId = tonumber(netId)
    if not netId then return end

    local veh = NetToVeh(netId)
    if veh and veh ~= 0 and DoesEntityExist(veh) then
        pcall(function()
            exports['corex-inventory']:ClearActiveRentalVehicleIfMatches(veh)
        end)
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
    end
end)

local function BuildSpawnPoint(distance)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local rad = math.rad(heading)
    local forwardX = -math.sin(rad)
    local forwardY = math.cos(rad)
    local dist = tonumber(distance) or (Config.PortableVehicles and Config.PortableVehicles.SpawnDistance) or 3.8

    return vector4(coords.x + forwardX * dist, coords.y + forwardY * dist, coords.z + 0.35, heading)
end

RegisterNetEvent('corex-inventory:client:spawnPortableVehicleFromItem', function(payload)
    if type(payload) ~= 'table' or type(payload.model) ~= 'string' then
        TriggerServerEvent('corex-inventory:server:portableVehicleDeployAborted')
        return
    end

    local deadline = GetGameTimer() + 10000
    while not EnsureCore() and GetGameTimer() < deadline do
        Wait(100)
    end

    if not Corex then
        TriggerServerEvent('corex-inventory:server:portableVehicleDeployAborted')
        return
    end

    local model = payload.model
    local plate = type(payload.plate) == 'string' and payload.plate or ''

    if not LoadVehicleModel(model) then
        TriggerServerEvent('corex-inventory:server:portableVehicleDeployAborted')
        SetModelAsNoLongerNeeded(GetHashKey(model))
        return
    end

    local spawnPoint = BuildSpawnPoint(payload.spawnDistance)
    local hash = GetHashKey(model)
    local vehicle = CreateVehicle(hash, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.w or 0.0, true, false)

    if not vehicle or vehicle == 0 then
        TriggerServerEvent('corex-inventory:server:portableVehicleDeployAborted')
        SetModelAsNoLongerNeeded(hash)
        return
    end

    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehRadioStation(vehicle, 'OFF')
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleEngineOn(vehicle, false, true, false)

    if plate ~= '' then
        -- GTA plate max 8 chars; strip extra spaces mid-plate only for game text
        local plateGame = plate
        if #plateGame > 8 then
            plateGame = plateGame:gsub('%s+', '')
            if #plateGame > 8 then
                plateGame = plateGame:sub(1, 8)
            end
        end
        SetVehicleNumberPlateText(vehicle, plateGame)
        Wait(100)
    end

    -- Restore saved mods from item metadata (after plate so finalize still matches)
    if type(payload.props) == 'table' then
        ApplyVehicleProps(vehicle, payload.props)
        Wait(50)
    end

    pcall(function()
        exports['corex-inventory']:SetActiveRentalVehicle(vehicle)
    end)

    if Config.PortableVehicles == nil or Config.PortableVehicles.AutoEnterOnDeploy ~= false then
        local ped = PlayerPedId()
        if ped and ped ~= 0 and DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) then
            TaskWarpPedIntoVehicle(ped, vehicle, -1)
        end
    end

    SetModelAsNoLongerNeeded(hash)
    Notify((payload.label or 'Vehicle') .. ' deployed.', 'success', 2500)

    TriggerEvent('corex-inventory:internal:registerPortableVehicleNet', vehicle)
end)

RegisterNetEvent('corex-inventory:client:spawnRentalBikeFromItem', function(payload)
    TriggerEvent('corex-inventory:client:spawnPortableVehicleFromItem', payload)
end)

CreateThread(function()
    while GetResourceState('ox_target') ~= 'started' do
        Wait(500)
    end

    local pickupDist = (Config.PortableVehicles and Config.PortableVehicles.PickupDistance) or 4.5

    exports.ox_target:addGlobalVehicle({
        {
            name = 'corex_pickup_portable_vehicle',
            icon = 'fa-solid fa-box-open',
            label = 'Pick up vehicle',
            distance = pickupDist,
            canInteract = function(entity)
                if not entity or entity == 0 or not DoesEntityExist(entity) then return false end
                if Config.PortableVehicles and Config.PortableVehicles.Enabled == false then return false end
                local ped = PlayerPedId()
                if GetVehiclePedIsIn(ped, false) ~= 0 then return false end

                local st = Entity(entity).state
                if st.corexPortableVehicleOwner ~= nil or st.corexRentalBikeOwner ~= nil then
                    return true
                end

                -- Fallback while state bags still replicating / race after shop spawn
                if IsLocalPortable(entity) then
                    return true
                end

                local active = nil
                pcall(function()
                    active = exports['corex-inventory']:GetActiveRentalVehicle()
                end)
                if active and active == entity then
                    return true
                end
                return false
            end,
            onSelect = function(data)
                local entity = data.entity
                if not entity or entity == 0 then return end
                local netId = NetworkGetNetworkIdFromEntity(entity)
                if not netId or netId == 0 then
                    Notify('Vehicle is not networked yet. Wait a moment.', 'error')
                    return
                end
                local props = CaptureVehicleProps(entity)
                TriggerServerEvent('corex-inventory:server:pickupPortableVehicle', netId, props)
            end,
        },
    })
end)

local config = require('config')

for i, location in pairs(config.locations) do
    local enterPoint = lib.points.new({
        coords = location.enter,
        distance = 2.0
    })
    
    function enterPoint:onEnter()
        TriggerEvent('chat:addMessage', {
            color = {255, 255, 0},
            multiline = true,
            args = {"^4[System] ^3You are near an interactable door.^4 Use ^3/enter^4 to use it."}
        })
    end
end

RegisterCommand('enter', function()
    local playerCoords = GetEntityCoords(cache.ped)
    local closestPoint = nil
    local closestDistance = math.huge

    for i, location in pairs(config.locations) do
        local distance = #(playerCoords - location.enter)
        if distance < closestDistance and distance <= 2.0 then
            closestDistance = distance
            closestPoint = i
        end
    end
    
    if closestPoint then
        local targetCoords = config.locations[closestPoint].tpcoords
        SetEntityCoords(cache.ped, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, true)
        TriggerServerEvent('enter:addToBucket', closestPoint)
    end
end, false)

RegisterCommand('exit', function()
    local playerCoords = GetEntityCoords(cache.ped)
    local closestExitPoint = nil
    local closestDistance = math.huge
    
    for i, location in pairs(config.locations) do
        if location.exit ~= vec3(0, 0, 0) then
            local distance = #(playerCoords - location.exit)
            if distance < closestDistance and distance <= 2.0 then
                closestDistance = distance
                closestExitPoint = i
            end
        end
    end
    
    if closestExitPoint then
        local enterCoords = config.locations[closestExitPoint].enter
        SetEntityCoords(cache.ped, enterCoords.x, enterCoords.y, enterCoords.z, false, false, false, true)
        TriggerServerEvent('enter:removeFromBucket', closestExitPoint)
    end
end, false)
local config = require('config')

local doorBuckets = {}

for i, location in pairs(config.locations) do
    doorBuckets[i] = {
        bucketId = i + 1000,
        players = {}
    }
end

local function addPlayerToDoorBucket(playerId, doorIndex)
    local bucket = doorBuckets[doorIndex]
    if bucket then
        SetPlayerRoutingBucket(playerId, bucket.bucketId)
        bucket.players[playerId] = true
    end
end

local function removePlayerFromDoorBucket(playerId, doorIndex)
    local bucket = doorBuckets[doorIndex]
    if bucket and bucket.players[playerId] then
        SetPlayerRoutingBucket(playerId, 0) 
        bucket.players[playerId] = nil
    end
end

RegisterNetEvent('enter:addToBucket', function(doorIndex)
    local playerId = source
    addPlayerToDoorBucket(playerId, doorIndex)
end)

RegisterNetEvent('enter:removeFromBucket', function(doorIndex)
    local playerId = source
    removePlayerFromDoorBucket(playerId, doorIndex)
end)

AddEventHandler('playerDropped', function()
    local playerId = source
    for doorIndex, bucket in pairs(doorBuckets) do
        if bucket.players[playerId] then
            removePlayerFromDoorBucket(playerId, doorIndex)
        end
    end
end)

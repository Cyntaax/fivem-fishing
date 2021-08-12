ClFishingPlayer = {
    EventHandlers = {},
    ---@type FishingLure
    CurrentLure = nil,
    FishingState = false,
    ---@param cb fun(hasItem: boolean): void
    CheckRodCallback = function(cb)
        cb(true)
    end,
    OnFishCaught = function(fish, cb)
        print("Caught", fish)

        cb()
    end,
    CatchPending = function()
        ClFishingPlayer:ShowHelpText("Press ~INPUT_CONTEXT~ to reel in")
    end,
    FishingLure = nil,
    LastFishingPosition = nil
}

function ClFishingPlayer:PlayerPed()
    return PlayerPedId()
end

---@param name string
function ClFishingPlayer:Emit(name, ...)
    TriggerServerEvent(GetCurrentResourceName() .. ":" .. name, ...)
end

---@param name string
---@param handler fun(...: any): void
function ClFishingPlayer:On(name, handler)
    for k,v in pairs(self.EventHandlers) do
        if v.type == name then
            return
        end
    end

    table.insert(self.EventHandlers, {
        handler = handler,
        name = name
    })
end

---@param name string
---@return fun(...: any): void
function ClFishingPlayer:GetHandler(name)
    for k,v in pairs(self.EventHandlers) do
        if v.name == name then return v.handler end
    end
end

---@param message string
---@param messageType string
function ClFishingPlayer:ShowMessage(message, messageType)
    ClFishing.ShowMessage(message, messageType)
end

---@param message string
function ClFishingPlayer:ShowHelpText(message)
    AddTextEntry('FISHINGHELP', message)
    BeginTextCommandDisplayHelp('FISHINGHELP')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

---@param cb fun(canFish: boolean, place: { x: number, y: number, z: number }): void
function ClFishingPlayer:TestFishingSpot(cb)
    if ClFishing.TestingProgressActive == true then return end
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, true)
    local coords = GetEntityCoords(playerPed)
    local forwar = GetEntityForwardVector(playerPed)
    local factor = 1
    local hit = false
    local place = nil
    ClFishing.TestingProgressActive = true
    ClFishing.TestingProgress(0)

    Citizen.CreateThread(function()
        while factor < 50 and hit == false do
            Citizen.Wait(0)
            factor = factor + 0.05
            local progress = (factor / 50) * 100
            progress = math.floor(progress + 0.5)
            ClFishing.TestingProgress(progress)
            local f2 = (coords + (forwar * factor))
            local tz = f2.z - factor
            local a1, a2 = TestProbeAgainstWater(coords.x, coords.y, coords.z, f2.x, f2.y, tz)
            hit = a1
            place = a2
        end
        ClFishing.TestingProgressActive = false
        ClFishing.TestingComplete(hit)
        FreezeEntityPosition(playerPed, false)
        cb(hit, place)
    end)
end

---@param cb fun(hasItem: boolean): void
function ClFishingPlayer:BeforeFish(cb)
    if self.FishingState == true then print('already fishing') cb(false) return end
    self.CheckRodCallback(function(hasItem)
        cb(hasItem)
    end)
end

---@param lure string
---@param coords { x: number, y: number, z: number }
function ClFishingPlayer:StartFishing(lure, coords)
    self.FishingLure = lure
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_FISHING", 0, true)
    ModifyWater(coords.x, coords.y, 50.0, 200.0)
    math.randomseed(GetGameTimer())
    local duration = math.random(20000, 30000)
    print('we fishing!')
    SetTimeout(duration, function()
        self:StartCatch()
    end)
end

function ClFishingPlayer:DeleteRod()
    local _coords = GetEntityCoords(PlayerPedId())
    local rod = GetClosestObjectOfType(_coords, 10.0, GetHashKey('prop_fishing_rod_01'), false, false, false)
    SetEntityAsMissionEntity(rod, true, true)
    DeleteEntity(rod)
end

---@return boolean
function ClFishingPlayer:CanCatch()
    local coords = GetEntityCoords()
    if self.LastFishingPosition == nil then
        return false
    end

    local dist = #(coords - self.LastFishingPosition)
    return dist <= 3.0
end

function ClFishingPlayer:StartCatch()
    local response = nil
    local timeout = false
    if not self:CanCatch() then

    end
    SetTimeout(2000, function()
        if response == nil then
            timeout = true
        end
    end)

    Citizen.CreateThread(function()
        while response == nil and timeout == false do
            Citizen.Wait(0)
            self.CatchPending()
            if IsControlJustReleased(0, 38) and IsInputDisabled(0) then
                response = true
            end
        end

        if response == true then
            self.FishingState = false
            self:DeleteRod()
            ClearPedTasks(PlayerPedId())
            local fish = ClFishing:GetCatch(self.FishingLure)
            self.OnFishCaught(fish, function()
                if fish == "nothing" then
                    -- caught nothing
                else
                    self:Emit("giveItem", fish, 1)
                end
            end)
            return
        end

        if timeout == true then
            self.FishingState = false
            self:DeleteRod()
            ClearPedTasks(PlayerPedId())
        end
    end)
end

local resourceName = GetCurrentResourceName()
RegisterNetEvent(resourceName .. ":cl")
---@param eventPacket { type: string, payload: table }
AddEventHandler(resourceName .. ":cl", function(eventPacket)
    if type(eventPacket.type) ~= "string" then
        return
    end

    local handler = ClFishingPlayer:GetHandler(eventPacket.type)
    if handler ~= nil then
        handler(eventPacket.payload)
    end
end)
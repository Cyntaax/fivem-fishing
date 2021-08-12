SvFishing = {
    Stats = {},
    GivePlayerItem = function(source, item, amount)
        local player = SvFishingPlayer.new(source)
        player:SendMessage("Congrats! You caught a" .. item)
    end,
    SetLureHandler = function(source, lure)
        local player = SvFishingPlayer.new(source)
        player:EquipLure(lure)
    end
}

---@param handler fun(source: number, item: string, amount: number): void
function SvFishing:SetGiveHandler(handler)
    self.GivePlayerItem = function(source, item, amount)
        handler(source, item, amount)
    end
end

---@param playerId number
---@param lure string
function SvFishing:SetPlayerLure(playerId, lure)
    local player = SvFishingPlayer.new(playerId)
    player:EquipLure(lure)
end

---@param playerId number
---@param item string
---@param amount number
function SvFishing:GiveItem(playerId, item, amount)
    if type(item) ~= "string" then
        return
    end

    amount = tonumber(amount)
    if type(amount) ~= "number" then return end

    local player = SvFishingPlayer.new(playerId)

    player:AddItem(item, amount)
end

local EventHandlers = {
    {
        Event = "setLure",
        Handler = "SetPlayerLure"
    },
    {
        Event = "giveItem",
        Handler = "GiveItem"
    }
}

local resourceName = GetCurrentResourceName()
for k,v in pairs(EventHandlers) do
    local eventName = resourceName .. ":" .. v.Event
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function(...)
        local source = source
        SvFishing[v.Handler](svFishing, source, ...)
    end)
end

RegisterCommand('setlure', function(source, args, raw)
    local source = source
    local player = SvFishingPlayer.new(source)
    player:EquipLure("lure_basic_01")
end)

exports('SetGivePlayerItem', function(handler)
    SvFishing.GivePlayerItem = handler
end)

exports('SetLureHandler', function(handler)
    SvFishing.SetLureHandler = handler
end)

exports('SetLureForPlayer', function(source, lure)
    SvFishing:SetPlayerLure(source, lure)
end)
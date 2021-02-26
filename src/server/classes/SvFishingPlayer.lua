SvFishingPlayer = setmetatable({}, SvFishingPlayer)

SvFishingPlayer.__call = function()
    return "SvFishingPlayer"
end

SvFishingPlayer.__index = SvFishingPlayer

---@param source number
function SvFishingPlayer.new(source)
    local _SvFishingPlayer = {
        Source = source
    }

    return setmetatable(_SvFishingPlayer, SvFishingPlayer)
end

---@param message string
---@param messageType string
function SvFishingPlayer:SendMessage(message, messageType)
    self:Emit(GetCurrentResourceName() .. ":cl", {
        type = "message",
        payload = {
            content = message,
            messageType = messageType
        }
    })
end

---@param lureName string
function SvFishingPlayer:EquipLure(lureName)
    local lure = FishingConfig:GetLureInfo(lureName)
    if lure == nil then
        self:Emit(GetCurrentResourceName() .. ":cl", {
            type = "message",
            payload = {
                content = "Failed to equip lure " .. lureName
            }
        })
        return
    end

    self:Emit(GetCurrentResourceName() .. ":cl", {
        type = "lure",
        payload = {
            state = true,
            lure = lure.name
        }
    })
end

---@param name string
function SvFishingPlayer:Emit(name, ...)
    TriggerClientEvent(name, self.Source, ...)
end

---@param name string
---@param amount number
function SvFishingPlayer:AddItem(name, amount)
    if type(SvFishing.GivePlayerItem) == "function" then
        SvFishing.GivePlayerItem(self.Source, name, amount)
    else
        print("^1[" .. GetCurrentResourceName() .. "]: no add item hook set. please refer to documentation^7")
    end
end
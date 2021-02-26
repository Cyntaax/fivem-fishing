---@class FishingLure
local FishingLure = {
    name = "",
    label = "",
    ---@type { name: string, label: string, prob: number }[]
    catches = {}
}

FishingConfig = {
    ---@type FishingLure[]
    lures = {},
    enableStats = false,
    _Loaded = false,
    key = ""
}

---@param name string
---@return FishingLure
function FishingConfig:GetLureInfo(name)
    for k,v in pairs(self.lures) do
        if v.name == name then
            return v
        end
    end
end

---@param location string
---@param name string
---@return number
function FishingConfig:GetFishPrice(location, name)
    for k,v in pairs(self.sellingZones) do
        if v.name == location then
            for b,z in pairs(v.prices) do
                if z.name == name then
                    return z.price
                end
            end
        end
    end
end

function FishingConfig:Load()
    if self._Loaded == true then return end
    self._Loaded = true
    local config = LoadResourceFile(GetCurrentResourceName(), "config.json")
    if config == nil or config == "" then
        print("^1[" .. GetCurrentResourceName() .. "]: failed to load configuration (config.json likely not present)^7")
        return
    end

    local parsedConfig = json.decode(config)
    if parsedConfig == nil then
        print("^1[" .. GetCurrentResourceName() .. "]: failed to load configuration. (invalid json format)^7")
        return
    end

    for k,v in pairs(parsedConfig) do
        self[k] = v
    end

    print("^2[" .. GetCurrentResourceName() .. "]^3: configuration loaded successfully^7")
end

FishingConfig:Load()
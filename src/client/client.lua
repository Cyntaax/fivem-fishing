RegisterKeyMapping('fish', 'Start Fishing', 'keyboard', FishingConfig.key)

local MessageColor = {
    success = 210,
    warning = 180,
    error = 160,
    info = 0
}

ClFishing = {
    TestingProgressActive = false,
    PromptActive = false,
    ShowMessage = function(message, messageType)
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(message)
        if type(messageType) == "string" then
            if MessageColor[messageType] ~= nil then
                ThefeedNextPostBackgroundColor(MessageColor[messageType])
            end
        end
        EndTextCommandThefeedPostTicker(false, false)
    end,
    TestingProgress = function(progress)
        if ClFishing.TestingProgressActive == false then return end
        SetLoadingPromptTextEntry("STRING")
        AddTextComponentSubstringPlayerName("Casting line... "  .. progress .. "%")
        ShowLoadingPrompt("PM_WAIT")
        ClFishing.PromptActive = true
    end,
    TestingComplete = function(result)
        RemoveLoadingPrompt()
    end
}

---@type fun(message: string, messageType: string)
function ClFishing:SetMessageHandler(handler)
    self.ShowMessage = handler
end

ClFishingPlayer:On("lure", function(data)
    print(json.encode(data))
    if data.state == true then
        if type(data.lure) == "string" then
            local lure = FishingConfig:GetLureInfo(data.lure)
            if lure ~= nil then
                ClFishingPlayer.CurrentLure = lure
                ClFishingPlayer:ShowMessage("~l~Lure equipped!", "success")
            end
        end
    end
end)

ClFishingPlayer:On("message", function(data)
    ClFishingPlayer:ShowMessage(data.content, data.messageType)
end)

---@param lure string
function ClFishing:GetCatch(lure)
    math.randomseed(GetGameTimer())
    local tmpicks = {}
    local lureInfo = FishingConfig:GetLureInfo(lure)
    if lureInfo == nil then return end
    for k,v in pairs(lureInfo.catches) do
        local amt = v.prob
        for i = 1, amt, 1 do
            table.insert(tmpicks, v.name)
        end
    end

    local pick = math.random(1, #tmpicks)

    return tmpicks[pick]
end

RegisterCommand('fish', function()
    if ClFishingPlayer.CurrentLure == nil then
        ClFishingPlayer:ShowMessage("No lure", "error")
        return
    end
    ClFishingPlayer:TestFishingSpot(function(canFish, place)
        if canFish then
            ClFishingPlayer:BeforeFish(function(hasItem)
                if hasItem == true then
                    ClFishingPlayer:StartFishing(ClFishingPlayer.CurrentLure.name, place)
                end
            end)
        end
    end)
end)

exports('SetShowMessage', function(handler)
    ClFishing.ShowMessage = handler
end)

exports('SetOnTestingProgress', function(handler)
    ClFishing.TestingProgress = handler
end)

exports('SetOnTestingComplete', function(handler)
    ClFishing.TestingComplete = handler
end)

exports('SetCheckRodCallback', function(handler)
    ClFishingPlayer.CheckRodCallback = handler
end)

exports('SetOnFishCaught', function(handler)
    ClFishingPlayer.OnFishCaught = handler
end)

exports('SetOnCatchPending', function(handler)
    ClFishingPlayer.CatchPending = handler
end)